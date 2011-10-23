unit physer;

interface

uses
  useful,ReallyUseful,Classes,SysUtils,math,StdCtrls,ObjectContainer,MapUnit;


const
      //TiPhysInterval = 10;
      mu = 0.0015;
      acc = 1;
      g = 9.8;
      mwag = 32500;
      u = 825;
      amax = 1.2;
      amax2 = 2;
      vt1 = 90 / 3.6;
      vt2 = 60 / 3.6;
      vt3 = 30 / 3.6;
      pmax = 1;
      pmin = 0.2;
      kv = 5; //Velocity of kran pressuring
      kmv = 0.04; //Velocity of kran mooving
      rmax = 5;
      r0 = 0.01;
      IMAX = 300;
      beta0 = 2;
      valphacam = 100;




type
  TControlKeys = record
    fw:boolean;
    bw:boolean;
    up:boolean;
    down:boolean;
    ipr:boolean;
    dpr:boolean;
    mr:boolean;  //   ->
    ml:boolean;  //   <-
    mu:boolean;  //  /\
    md:boolean;  //  \/
  end;

  THz = record
    kbeta:real;
    r:real;
    ispp:boolean; //Параллельно-последовательно
  end;


var
    hz:array [0 .. 100] of THz;
    rup, polzunok, revers, nrevers, oldhz, itx, maxpolz, maxpolz2:integer;
    ispaused, isrp:boolean;
    climit, v, prs, k, waiting, kran, rwaiting, polzunwait, delit, timeofplaying, timeofmenu:real;
    //wtf:TWtf;
    MyKeys:TControlKeys;
    bwfirst:PBWp;
    AOSVisible,RPVisible,ALSVisible:boolean;
    gameover:boolean;
    laststeptime:real;

procedure init(var logmemo:TMemo; var wtf:Twtf);
procedure calcPanel(k:real; const wtf:Twtf);
procedure calcphys(const wtf: TWtf; train:PSoftTrain);
function givei(i: integer; v: real): real;
function givef(i: integer; v: real): real;
procedure mkgoodscb(var wtf:Twtf);

implementation

procedure calcPanel(k:real; const wtf:Twtf);
begin
    if waiting > 0 then
    waiting := waiting - k;

  if rwaiting >= 0 then
  begin
    rwaiting := rwaiting - k;
    if rwaiting <= 0 then
      revers := nrevers;
  end;


  if (revers <> 0) and (rwaiting <= 0) then
  begin
    if Mykeys.up then
      if (rup < 3) and (waiting <= 0) then
      begin
        inc (rup);
        waiting := 0.5;
      end;
    if Mykeys.down then
      if (rup > -3) and (waiting <= 0) then
      begin
        dec (rup);
        waiting := 0.5;
      end;
    MyKeys.up:=false;
    MyKeys.down:=false;
  end;

  if (rwaiting <= 0) and (rup = 0) then
  begin
    if ((Mykeys.fw and (wtf.viewPoint.cabfactor = 1)) or (Mykeys.bw and (wtf.viewPoint.cabfactor = -1))) and (revers < 1)  then
    begin
      nrevers:=revers+1;
      MyKeys.fw := false;
      MyKeys.bw := false;
      rwaiting := 1;
    end;
    if ((Mykeys.fw and (wtf.viewPoint.cabfactor = -1)) or (Mykeys.bw and (wtf.viewPoint.cabfactor = 1))) and (revers > -1) then
    begin
      nrevers:=revers-1;
      MyKeys.fw := false;
      MyKeys.bw := false;
      rwaiting := 1;
    end;
  end;
  if Mykeys.mr then
    wtf.camdopkurs := wtf.camdopkurs - k * valphacam;
  if Mykeys.ml then
    wtf.camdopkurs := wtf.camdopkurs + k * valphacam;
  if Mykeys.mu then
    wtf.camdopalpha := wtf.camdopalpha + k * valphacam;
  if Mykeys.md then
    wtf.camdopalpha := wtf.camdopalpha - k * valphacam;

end;

procedure calcphys(const wtf: TWtf; train:PSoftTrain);
var
  zhvost, zgolova, F, f2:real;
  k,nowtime:real;
  i:integer;
begin
  nowtime:=time()*24*3600;
  k:=nowtime-laststeptime;
  laststeptime:=nowtime;
  calcPanel(k,wtf);
  if wtf.gntrscbid <> oldhz then
  begin
    climit := wtf.givelimbycond [wtf.scb [oldhz].condition];
    oldhz := wtf.gntrscbid;
  end;

  if v * revers < 0 then
  begin
    kran := 1;
    AOSVisible := true;
  end
  else
    AOSVisible := false;

  if givei (polzunok - 1, v) > IMAX then
  begin
    isrp := true;
    RPVisible := true;
  end;
  if revers = 0 then
  begin
    isrp := false;
    RPVisible := false;
  end;

  if abs (v) > climit then
  begin
    kran := 1;
    ALSVisible := true;
    rup := 0;
  end
  else
    ALSVisible := false;

  if kran <= 0.25 then
    prs := max(0,prs - (0.25 - kran) * kv * k * prs);
  if kran >= (0.45) then
    prs := min(pmax,prs - (0.45 - kran) * kv * k * (pmax - prs));

  train.move(v*k, wtf.isleft);
  
  timeofplaying := timeofplaying + k;
  v := v - v * mu * k;

  zgolova := givebz(wtf.train.PWag[0], wtf.train.coord);
  zhvost := givebz (wtf.train.PWag[wtf.train.ferrum.nwag], wtf.train.coord);
  v := v + g * (zhvost - zgolova) / (wtf.nwag * wtf.wlength) * k;

  //F без к !!!!!!!!!!!!!!

  if (rup = 0) or (rup = 1) then
    polzunok := rup;
  if (rup = 2) and (polzunok > maxpolz) then
    polzunok := maxpolz;
  if ((rup = 2) and (polzunok < maxpolz - 1)) or ((rup = 3) and (polzunok < maxpolz2)) then
  begin
    f2 := givef (polzunok, v);
    if (f2 / mwag < amax) then
      inc (polzunok);
  end;

  if isrp then
    polzunok := 0;

  if polzunok > 0 then
    F := givef (polzunok - 1, v)
  else
    F := 0;

  if (rup = -1) and not isrp then
    F := -1 * amax * mwag * v / vt1;
  if (rup = -2) and not isrp then
    F := -1 * amax * mwag * v / vt2;
  if (rup = -3) and not isrp then
    F := -1 * amax * mwag * v / vt3;

  v := v + F * k / mwag * revers;


  if prs > pmin then
  begin
    F := amax2 * mwag * (prs - pmin) / (pmax - pmin);
    if (abs (v) >  F * k / mwag) then
      if v > 0 then
        v := v - F * k / mwag
      else
        v := v + F * k / mwag
    else
      v := 0;
  end;

end;


procedure init(var logmemo:TMemo; var wtf:Twtf);
var i:integer;
begin
  gameover:=false;
  laststeptime:=Time()*24*3600;
  v := 20;
  rup := 0;
  polzunok := 0;
  rwaiting := 0;
  timeofplaying := 0;
  prs := pmax;
  kran := 1;
  revers := 0;
  nrevers := 0;
  delit := 10;
  itx := 0;
  climit := 80 / 3.6;
  //k := TiPhysInterval / 1000 * acc;
  waiting := 0;
  isrp := false;
{  for i := 0 to maxscb - 1 do
  begin
    wtf.scb [i].condition := 7;
    wtf.scb [i].right := true;
    wtf.scb [i].zhelezno := false;
  end;
}  hz [0].kbeta := 0.28;
  hz [0].r := rmax + r0;
  hz [0].ispp := false;
  hz [1].kbeta := 1;
  hz [1].r := rmax + r0;
  hz [1].ispp := false;
  i := 2;
  while hz [i - 1].r > r0 + 0.3 do
  begin
    hz [i].r := hz [i - 1].r - 0.3;
    hz [i].kbeta := 1;
    hz [i].ispp := false;
    inc (i);
  end;

  maxpolz := i;
  hz [i].r := r0;
  hz [i].kbeta := 1;
  hz [i].ispp := false;
  inc (i);
  hz [i].r := r0;
  hz [i].kbeta := 0.7;
  hz [i].ispp := false;
  inc (i);
  hz [i].r := r0;
  hz [i].kbeta := 0.5;
  hz [i].ispp := false;
  inc (i);
  hz [i].r := r0;
  hz [i].kbeta := 0.37;
  hz [i].ispp := false;
  inc (i);
  hz [i].r := r0;
  hz [i].kbeta := 1 / 4;
  hz [i].ispp := true;
  inc (i);
  hz [i].r := r0;
  hz [i].kbeta := 0.7 / 4;
  hz [i].ispp := true;
  inc (i);
  hz [i].r := r0;
  hz [i].kbeta := 0.5 / 4;
  hz [i].ispp := true;
  inc (i);
  hz [i].r := r0;
  hz [i].kbeta := 0.37 / 4;
  hz [i].ispp := true;
  inc (i);
  hz [i].r := r0;
  hz [i].kbeta := 0.28 / 4;
  hz [i].ispp := true;
  maxpolz2 := i;
end;

procedure mkgoodscb(var wtf:Twtf);
var i:integer;
begin
  if wtf.isleft then
  begin
    for i := 0 to wtf.nscb - 1 do
      if (not wtf.scb[i].zhelezno) then
        wtf.scb [i].condition := wtf.scb [i].table1 [wtf.scb [wtf.scb [i].next1].condition];
  end
  else
  begin
    for i := 0 to wtf.nscb - 1 do
      if (not wtf.scb[i].zhelezno) then
        wtf.scb [i].condition := wtf.scb [i].table2 [wtf.scb [wtf.scb [i].next2].condition];
  end;
end;

function givei(i: integer; v: real): real;
begin
  if (rup >= 0) then
    if (i >= 0) then
      if hz [i].ispp then
        result := U / (hz [i].r + hz [i].kbeta * beta0 * abs (v)) / 2
      else
        result := U / (hz [i].r + hz [i].kbeta * beta0 * abs (v))
    else
      result := 0
  else
  begin
    if rup = -1 then
      result := 70 * abs (v) / vt1;
    if rup = -2 then
      result := 70 * abs (v) / vt2;
    if rup = -3 then
      result := 70 * abs (v) / vt3;
  end;
end;

function givef(i: integer; v: real): real;
begin
  result := sqr (U / (hz [i].r + hz [i].kbeta * beta0 * abs (v)) ) * hz[i].kbeta * beta0; // I^2 * (R / v)
end;



end.
