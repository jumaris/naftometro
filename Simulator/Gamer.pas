unit Gamer;



interface

uses Bomj, useful, Graphics,
  MPlayer, Buttons, Bass, StdCtrls, Windows, math, SysUtils, Painter, physer, ObjectContainer;

procedure start();
procedure loadcab();
procedure LoadGame(var logMemo:Tmemo);
procedure mkgoodscb;
procedure SetChannels;
procedure mkphys();
procedure DrawGame(Width, Height: integer; DC:HDC);

implementation

type
  THz = record
    kbeta:real;
    r:real;
    ispp:boolean; //Параллельно-последовательно
  end;
  TBrakeHz = record
    vmin:real;
    R:real;
    kbeta:real;
  end;
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


const {mu = 0.25;                  //трение об рельсы
      betamu = 0.003 ;            //Трение в осях
      acc = 1.5;
      g = 9.8;                      //сила тяжести
      mwag = 32500;                 //масса вагона
      u = 825;                      //Напруга
      amax = 1.2;                   //Максимальное ускорение, создаваемое движком
      amax1 = 1.2;                  // -//- в режиме торможения
      amax2 = 3;                    // -//- пневмотормозом
      pmax = 1;                     //
      pmin = 0.15;                  //
      kv = 0.05; //Velocity of kran pressuring
      kmv = 1; //Velocity of kran mooving
      valphacam = 100;
      beta0 = 2;
      rmax = 5;
      r0 = 0.01;
      IMAX = 350;
      brakeconst = 100;}
      bshamount = 17;
      {
      tiphysinterval = 20;}


var
  queuestart:PBWp;
  realpoin: array [0 .. 10000] of TRe3dc;
  glaz:Integer;
  wtf:TWtf;
  bwfirst:PBWp;
  blackbox:TBlackbox;
  oldhz:Integer;
  Chan1: dword = 0;  //фоновый шум
  Chan2: dword = 1;  //Стук колёс
  Chan3: dword = 2;

var
  rup, polzunok, revers, nrevers, itx, maxpolz, maxpolz2:integer;
    isrp, ismenu, nadoload, bbstarted:boolean;
    localidstat:integer;
//    climit, v, prs, k, waiting, kran, rwaiting, polzunwait, delit, timeofplaying:real;


var
  
  hz:array [0 .. 100] of THz;
  brakehz:array [0 .. bshamount - 1] of TBrakeHz;

var
  train:TSoftTrain;


procedure Start();
var i:Integer;
begin
  nadoload := True;
{

//????? ?????-?? ????????             }

end;

procedure LoadGame(var logmemo:TMemo);
var i:integer;
begin
  Painter.init();
  logmemo.Visible := True;
  logmemo.Lines.Clear;
  logmemo.Lines.Add('Загрузка кабины');
  LoadCab;
  logmemo.Lines.Add('Создание вспомогательного класса');
  wtf := TWTf.sozdat;
  logmemo.Lines.Add('Запуск чёрного ящика');
  blackbox := TBlackbox.create;
  logmemo.Lines.Add('Обработка параметров игры');
  wtf.wwp;
  bwfirst := wtf.constructmap (logmemo);
  logmemo.Lines.Add('Построение светофоров');
  wtf.constructscb (bwfirst);
  logmemo.Lines.Add('Зажжение светофоров');
  wtf.initialSCB;
  logmemo.Lines.Add('Загрузка станций');
  wtf.constructstat;
  logmemo.Lines.Add('Расчёт станций');
  wtf.realizestat;

  for i := 0 to wtf.nscb do
  begin
    mkgoodscb;
  end;
  physer.init(logMemo, wtf);
  oldhz := wtf.gnscbid(wtf.ptrain [0], wtf.isleft);
  logmemo.Lines.Add('Создание звуков');
  SetChannels;
end;

procedure LoadCab;
var ueue: TShipLoader;
begin
  ueue := TShipLoader.create('cab.txt');
  train := TSoftTrain.create(ueue);
  ueue.destroy;
end;

procedure mkgoodscb;
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

procedure SetChannels;
begin
  bass_streamfree(chan1);
  chan1:=bass_streamcreatefile(false, pchar('media\shum.mp3'), 0,0, {$ifdef unicode} bass_unicode {$else} 0 {$endif} or bass_sample_loop );
  bass_channelplay(chan1, false);
  BASS_ChannelSetAttribute (chan1, BASS_ATTRIB_VOL, 20);

  bass_streamfree(chan2);
  chan2:=bass_streamcreatefile(false, pchar('media\stuk.mp3'), 0,0, {$ifdef unicode} bass_unicode {$else} 0 {$endif} or bass_sample_loop {???? ???? ???????? ??? ???? ????? ?????? ?????});
end;

procedure mkphys();
begin
  physer.calcphys(wtf, train);
end;

procedure DrawGame(Width, Height: integer; DC:HDC);
begin
  Painter.PaintGame(Width, Height, DC, wtf, train.ferrum);
end;

end.
