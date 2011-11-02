unit Useful;

interface
                       
uses Graphics, Math, SysUtils, StdCtrls, Bomj, ReallyUseful, ObjectContainer,
  MapUnit;

type
  Twtf = class
  constructor sozdat;
  destructor destroy();
  function gc1(a: integer): TColor;
  function gc2(a:integer):TColor;
  function gnscbid(p:PTp; isleft:boolean):integer;
  function gpscbid(p:PTp; isleft:boolean):integer;
  function gntrscbid:integer;
  function giveldouble(a, b:PTp):real;
  procedure calccorners(var p:PTp);
  procedure die(s:string);
  procedure initialSCB;
  function isgoodtr:boolean;
  function constructmap(var mmo:TMemo):PBWp;
  function TimeToStr(time:real):string;
  procedure constructscb(first:PBWp);
  function givePTPbyid(id:integer; start:PBWp):PTp;
  procedure process(s:string);
  procedure wwp; //workwithparams
  procedure constructstat;
  procedure realizestat;
  procedure constructTrain(head: PTP; var cabloader: TShipLoader);
  procedure constructViewPoint;
  private
  public

    train: PSoftTrain;
    viewPoint: PViewPoint;

    isleft:boolean;
    scbfile, mapfile, stfile:string;
    amount, idtrain:integer;
    givelimbycond:array [0 .. maxpok - 1] of real;
    //Ptrain:array [0 .. maxnwag] of PTp;
    tr, camdopkurs, camdopalpha:real;
    nwag, wlength, nscb:integer;
    pheight, pwidth:real;
    nstat:integer;
    uuueee:TShipLoader;
    scb:array [0 .. maxscb - 1] of TScb;
    statinstruct:array [1 .. maxstatn] of TInst;
    statrealpoin: array [1 .. maxstatn, 0 .. 10000] of TRe3dc;
    statqua:array [1 .. maxstatn, 0 .. 10000] of TBwquads;
    nstatpoin: array [1 .. maxstatn] of Integer;
    nstatquad: array [1 .. maxstatn] of Integer;
  end;

implementation

function Twtf.gc1(a: integer): TColor;
begin
  result := $FFFFFF;
  if a <= 2 then
    result := $0000FF;
  if a = 3 then
    result := $00CCCC;
  if (a = 5) or (a = 4) then
    result := $00FF00;
end;

function Twtf.gc2(a: integer): TColor;
begin
  result := $FFFFFF;
  if a = 0 then
    result := $0000FF;
  if (a = 2) or (a = 4) then
    result := $00CCCC;
end;



function Twtf.gnscbid(p:PTp; isleft:boolean): integer;
begin
  //p^.scbid:=1;
  while ( (p^.scbid = -1) or (not scb [p^.scbid].isforward) )  and (p^.next1 <> nil) do
    if isleft then
      p := p^.next1
    else
      p := p^.next2;
  result := p^.scbid;
end;

function Twtf.gpscbid(p:PTp; isleft:boolean): integer;
begin
  while ( (p^.scbid = -1) or (scb [p^.scbid].isforward) )  and (p^.previous1 <> nil) do
    if isleft then
      p := p^.previous1
    else
      p := p^.previous2;
  result := p^.scbid;
end;

function Twtf.giveldouble(a, b: PTp): real;
begin
  result := sqrt(sqr(a^.cx - b^.cx) + sqr(a^.cy - b^.cy));
end;

constructor Twtf.sozdat;
begin
  isleft := true;

  
  ///cabfactor := 1;
  //camdopkurs := 0;
  //camdopalpha := 0;


end;

destructor Twtf.destroy();
begin
  train.ferrum.Free;
  train.Free;
  viewPoint.Free;
end;

procedure Twtf.constructTrain(head: PTP; var cabloader: TShipLoader);
var htrain:PHardTrain;
begin
  new(htrain);
  htrain^ := THardTrain.create(cabloader, nwag, wlength);
  new(train);
  train^ := TSoftTrain.create(head, htrain);
end;

procedure Twtf.constructViewPoint;
begin
  new(viewPoint);
  viewPoint^ := TViewPoint.create(1, train);
end;

procedure Twtf.calccorners(var p: PTp);
var zkurs, dkurs, rad:real;
    i:integer;
//zero kurs, deltakurs, radius
begin
  zkurs := -1 * arctan(pheight / pwidth);
  dkurs := (pi - 2 * zkurs) / (numboc - 1);
  rad := sqrt(sqr(pwidth) + sqr(pheight)) / 2;
  for i := 0 to numboc - 1 do
  begin
    p.corners [i].x := p.cx - sin(p.kurs) * rad * cos(zkurs + i * dkurs);
    p.corners [i].y := p.cy + cos(p.kurs) * rad * cos(zkurs + i * dkurs);
    p.corners [i].z := p.cz + rad * sin(zkurs + i * dkurs);
  end;
{ 01
  32
}
  p.table [0].x := p.cx - sin(p.kurs) * pwidth / 2;
  p.table [0].y := p.cy + cos(p.kurs) * pwidth / 2;
  p.table [0].z := p.cz + theight / 2;
  p.table [3].x := p.cx - sin(p.kurs) * pwidth / 2;
  p.table [3].y := p.cy + cos(p.kurs) * pwidth / 2;
  p.table [3].z := p.cz - theight / 2;
  p.table [1].x := p.cx - sin(p.kurs) * (pwidth / 2 + twidth);
  p.table [1].y := p.cy + cos(p.kurs) * (pwidth / 2 + twidth);
  p.table [1].z := p.cz + theight / 2;
  p.table [2].x := p.cx - sin(p.kurs) * (pwidth / 2 + twidth);
  p.table [2].y := p.cy + cos(p.kurs) * (pwidth / 2 + twidth);
  p.table [2].z := p.cz - theight / 2;

  //Ох, шпала...
  p.shpala [0].x := p.cx - sin(p.kurs) * shpalw / 2;
  p.shpala [0].y := p.cy + cos(p.kurs) * shpalw / 2;
  p.shpala [0].z := p.cz - pheight / 2 + 0.01;
  p.shpala [1].x := p.cx + sin(p.kurs) * shpalw / 2;
  p.shpala [1].y := p.cy - cos(p.kurs) * shpalw / 2;
  p.shpala [1].z := p.cz - pheight / 2 + 0.01;
  p.shpala [2].x := p.cx + sin(p.kurs) * shpalw / 2;
  p.shpala [2].y := p.cy - cos(p.kurs) * shpalw / 2;
  p.shpala [2].z := p.cz - pheight / 2 + 0.05;
  p.shpala [3].x := p.cx - sin(p.kurs) * shpalw / 2;
  p.shpala [3].y := p.cy + cos(p.kurs) * shpalw / 2;
  p.shpala [3].z := p.cz - pheight / 2 + 0.05;
end;

function Twtf.gntrscbid: integer;
var p:PTp;
begin
  if viewPoint.cabfactor = 1 then
  begin
    p := train.PWag [0];
    while ((p^.scbid = -1) or (not scb [p^.scbid].isforward)) and (p^.next1 <> nil) do
      if isleft then
        p := p^.next1
      else
        p := p^.next2;
    result := p^.scbid;
  end
  else
  begin
    p := train.PWag [nwag];
    while ((p^.scbid = -1) or (scb [p^.scbid].isforward)) and (p^.previous1 <> nil) do
      if isleft then
        p := p^.previous1
      else
        p := p^.previous2;
    result := p^.scbid;
  end;
end;

procedure Twtf.die(s: string);
var o:text;
begin
  assign(o, 'Die log.txt');
  rewrite(o);
  write(o, s);
  closefile(o);
end;

procedure Twtf.initialSCB;
var i:integer;
begin
  givelimbycond [0] := -100500 / 3.6;
  givelimbycond [1] := 0 / 3.6;
  givelimbycond [2] := 0 / 3.6;
  givelimbycond [3] := 0 / 3.6;
  givelimbycond [4] := 20 / 3.6;
  givelimbycond [5] := 40 / 3.6;
  givelimbycond [6] := 60 / 3.6;
  givelimbycond [7] := 80 / 3.6;
  givelimbycond [8] := 1000 / 3.6;
  givelimbycond [9] := 0 / 3.6;
  givelimbycond [10] := 35 / 3.6;
  givelimbycond [11] := 35 / 3.6;
  givelimbycond [12] := 35 / 3.6;
end;

function Twtf.constructmap(var mmo:TMemo): PBWp;
var first, a, b:PBWp;
    i, j:integer;
    f:text;
    s:string;
    tmpi, tmpi2:integer;
    tmpr:real;
begin
  amount := -1;
  i := 1;
  mmo.Lines.Add('Загрузка карты');

  assign(f, 'map/' + mapfile);
  reset(f);
  s := '';
  while not eof(f) do
  begin
    readln(f, s);
    if length(s)>0 then
    begin
      if s[1]='#' then continue;//comment
      if s[1]='!' then break;//end of head part
    end;
    process(s);
  end;
  new(first);
  a := first;
            //SOBAKA
  while i <= amount do       //Первый пробег - заполнение полей, которые можно сразу
  begin
    new(b);
    a^.next := b;
    new(a^.tp);

    read(f, a^.tp^.id);             //id
    read(f, a^.tp^.cx);             //x
    read(f, a^.tp^.cy);             //y
    read(f, a^.tp^.cz);            //z

    //Холостое считываение
    read(f, tmpi);  //n1
    read(f, tmpi);  //n2
    read(f, tmpi);  //p1
    read(f, tmpi);  //p2
    read(f, tmpi);  //t

    read(f, a^.tp^.idstat);
    readln(f, tmpi);  //bool

    a^.tp^.isright:=(tmpi and 1)<>0;
    a := b;
    inc(i);
  end;
  close (f);
  a^.next := nil;

  reset (f);
  s := '';
  i := 1;
  a := first;

  while not eof(f) do
  begin
    readln (f, s);
    if length(s)>0 then
    begin
      if s[1]='#' then continue;//comment
      if s[1]='!' then break;//end of head part
    end;
  end;

  mmo.Lines.Add('Связывание карты');
  j := 0;
  mmo.Lines.Add(INtTOStr (j) + '%');
  while i <= amount do       //Второй пробег - заполнение остальных полей
  begin

    //Холостое считывание того, что уже сделали
    read (f, tmpi);    //id
    read (f, tmpr);    //x
    read (f, tmpr);    //y
    read (f, tmpr);    //z

    read (f, tmpi);
    a^.tp^.next1 := givePTPbyid (tmpi, first);
    read (f, tmpi2);
    if tmpi = tmpi2 then
      a^.tp^.next2 := a^.tp^.next1
    else
      a^.tp^.next2 := givePTPbyid (tmpi2, first);

    read (f, tmpi);
    a^.tp^.previous1 := givePTPbyid (tmpi, first);
    read (f, tmpi2);
    if tmpi = tmpi2 then
      a^.tp^.previous2 := a^.tp^.previous1
    else
      a^.tp^.previous2 := givePTPbyid (tmpi2, first);

    read (f, tmpi);
    if tmpi = a^.tp^.id then
      a^.tp^.together := a^.tp
    else
      a^.tp^.together := givePTPbyid (tmpi, first);

    read (f, tmpi);
    readln (f, tmpi);    //bool

    a := a^.next;
    inc (i);
    if round (i / amount * 100) > j then
    begin
      j := round (i / amount * 100);
      mmo.Lines.Delete(mmo.Lines.Count - 1);
      mmo.Lines.Add(INtTOStr (j) + '%');
    end;
  end;
  close (f);

  mmo.Lines.Add('Расчёт карты');
  //Теперь после того, как считали всю жизненно важную информацию, начинаем подсчёт параметров карты
  a := first;
  while a^.next <> nil do
  begin
    if a^.tp^.next1 <> nil then
      a^.tp^.kurs := giveangle (a^.tp^.cx, a^.tp^.cy, a^.tp^.next1^.cx, a^.tp^.next1^.cy)
    else
      a^.tp^.kurs := giveangle (a^.tp^.previous1^.cx, a^.tp^.previous1^.cy, a^.tp^.cx, a^.tp^.cy);
    calccorners (a^.tp);
    a^.tp^.scbid := -1;
    a := a^.next;
  end;
  result := first;
end;

procedure Twtf.process(s: string);
var b, c:string;
    i:integer;
begin
  if s = '!' then exit;

  i := 1;
  b := '';
  c := '';
  while (s [i] <> '=') do
  begin
    b := b + s[i];
    inc (i);
  end;
  inc (i);
  while (i <= length (s)) do
  begin
    c := c + s[i];
    inc (i);
  end;

  if (b = 'amount') then
    amount := StrToInt (c);
  if (b = 'amountscb') then
    nscb := StrToInt (c);
  if (b = 'amountstat') then
    nstat := StrToInt (c);
  if (b = 'idtrain') then
    idtrain := StrToInt (c);
  if (b = 'nwag') then
    nwag := StrToInt (c);
  if (b = 'wlength') then
    wlength := StrToInt (c);
  if (b = 'pheight') then
    pheight := StrToFloat (c);
  if (b = 'pwidth') then
    pwidth := StrToFloat (c);
  if (b = 'scb') then
    scbfile := c;
  if (b = 'map') then
    mapfile := c;
  if (b = 'stations') then
    stfile := c;
end;

function Twtf.givePTPbyid(id: integer; start: PBWp): PTp;
var a:PBWp;
begin
  a := start;
  while ((a^.next <> nil) and (a^.tp^.id <> id)) do
    a := a^.next;
  if a^.next = nil then
    result := nil
  else
    result := a^.tp;
end;

procedure Twtf.wwp;
var f:text;
    s:string;
begin
  assignfile (f, 'params.naftometro');
  if (not fileexists ('params.naftometro')) then
  begin
    rewrite (f);
    close (f);
  end;

  nwag := 1;
  wlength := 19;
  pheight := 4.4;
  pwidth := 4.16;
  mapfile := 'input.naftomap';

  reset (f);
  while (not eof (f)) do
  begin
    readln (f, s);
    process (s);
  end;
  close (f);
end;

function TWtf.isgoodtr:boolean;  //Двойное назначение (?)
var t:Ptp;
    i:integer;
    g:boolean; //goood?
begin
  t := train.PWag [nwag];
  g := true;
  for i := 1 to nwag * wlength do
  begin
    g := g and (t^.next1 = t^.next2) and (t^.previous1 = t^.previous2);
    if isleft then
      t := t^.next1
    else
      t := t^.next2;
  end;
  g := g and (t^.next1 = t^.next2) and (t^.previous1 = t^.previous2);
  if not (t = train.PWag [0]) then
    die ('invalid train - head and ass are not friends!');
  result := g;
end;

procedure Twtf.constructscb (first:PBWp);
var i, j:integer;
    f:text;
    s:string;
begin
  i := 0;
  assign (f, 'scb/' + scbfile);
  reset (f);
  s := '';
  while not (s = '!') do
  begin
    readln (f, s);
    process (s);
  end;

  while i < nscb do
  begin
    readln (f, s);             //PTP
    scb [i].ntp := givePTPbyid (StrToInt (s), first);
    scb [i].ntp^.scbid := i;
    readln (f, s);             //Condition
    scb [i].condition := StrToInt (s);
    readln (f, s);             //Next1
    scb [i].next1 := StrToInt (s);
    readln (f, s);             //Next2
    scb [i].next2 := StrToInt (s);

    readln (f, s);             //Boolean
    scb [i].zhelezno := (StrToInt (s) mod 2 = 1);
    scb [i].isforward := ((StrToInt (s) div 2) mod 2 = 1);

    for j := 0 to maxpok - 1 do //Table1
    begin
      readln (f, s);
      scb [i].table1 [j] := StrToInt (s);
    end;
    for j := 0 to maxpok - 1 do //Table2
    begin
      readln (f, s);
      scb [i].table2 [j] := StrToInt (s);
    end;

    inc (i);
  end;
  close (f);
end;

function Twtf.TimeToStr(time: real): string;
begin
  Result := IntToStr (round (time) div 3600)
                + ':' + IntToStr ((round (time) mod 3600) div 60)
                + ':' + IntToStr (round (time) mod 60);
end;

procedure Twtf.constructstat;
var i, j:integer;
    f:text;
    s:string;
begin
  i := 1;
  assign (f, 'stations/' + stfile);
  reset (f);
  s := '';
  while not (s = '!') do
  begin
    readln (f, s);
    process (s);
  end;

  while i <= nstat do
  begin
    readln (f, s);
    statinstruct [i].id := StrToInt (s);
    Readln (f, statinstruct [i].x);
    Readln (f, statinstruct [i].y);
    Readln (f, statinstruct [i].z);
    Readln (f, statinstruct [i].alpha);

    uuueee := TSHipLoader.create ('stations/models/' + s + '.txt');
    nstatpoin [statinstruct [i].id] := uuueee.giveinteger;
    for j := 0 to nstatpoin [statinstruct [i].id] - 1 do
    begin
      uuueee.givereal;
      statrealpoin [statinstruct [i].id, j].x := uuueee.givereal;
      statrealpoin [statinstruct [i].id, j].y := uuueee.givereal;
      statrealpoin [statinstruct [i].id, j].z := uuueee.givereal;
    end;
    nstatquad [statinstruct[i].id]:=uuueee.giveinteger;

    for j := 0 to nstatquad [statinstruct[i].id] - 1 do
    begin
      statqua [statinstruct [i].id, j].tid := uuueee.giveinteger;
      statqua [statinstruct [i].id, j].a.x := uuueee.giveinteger; //????? ?????
      statqua [statinstruct [i].id, j].a.y := uuueee.giveinteger; //???????? ?
      statqua [statinstruct [i].id, j].a.z := uuueee.giveinteger; //???????? ?

      statqua [statinstruct [i].id, j].b.x := uuueee.giveinteger;
      statqua [statinstruct [i].id, j].b.y := uuueee.giveinteger;
      statqua [statinstruct [i].id, j].b.z := uuueee.giveinteger;

      statqua [statinstruct [i].id, j].c.x := uuueee.giveinteger;
      statqua [statinstruct [i].id, j].c.y := uuueee.giveinteger;
      statqua [statinstruct [i].id, j].c.z := uuueee.giveinteger;

      statqua [statinstruct [i].id, j].d.x := uuueee.giveinteger;
      statqua [statinstruct [i].id, j].d.y := uuueee.giveinteger;
      statqua [statinstruct [i].id, j].d.z := uuueee.giveinteger;
    end;

    uuueee.destroy;
    inc (i);
  end;
  close (f);

end;

procedure Twtf.realizestat;
var i, j, k:Integer;
    tempx, tempy:Real;
begin
  for i := 1 to maxstatn do
    for j := 0 to nstatpoin [i] - 1 do
    begin
      tempx := statrealpoin [i, j].x;
      tempy := statrealpoin [i, j].y;
      k:=0;
      while (statinstruct[k].id<>i)do
        Inc(k);

      statrealpoin [i, j].x := statinstruct[k].x+tempx*cos(statinstruct[k].alpha)-tempy*sin(statinstruct[k].alpha);
      statrealpoin [i, j].y := statinstruct[k].y+tempx*sin(statinstruct[k].alpha)+tempy*cos(statinstruct[k].alpha);
      statrealpoin [i, j].z := statrealpoin [i, j].z + statinstruct [k].z;
    end;
end;

end.
