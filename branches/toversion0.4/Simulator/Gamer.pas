unit Gamer;



interface

uses Bomj, useful, dglOpenGL, OpenGL,
  MPlayer, Buttons, Bass, StdCtrls, Windows;

procedure loadcab();
procedure LoadGame(var logMemo:Tmemo);
procedure mkgoodscb;
procedure SetChannels;

implementation

const mu = 0.25;                  //трение об рельсы
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
      tubr = 1;
      tubg = 0.8;
      tubb = 0.6;
      beta0 = 2;
      rmax = 5;
      r0 = 0.01;
      IMAX = 350;
      maxdep = 100;
      brakeconst = 100;
      bshamount = 17;
      dv = 0.00001; //Физически бесконечно малая скорость
      tiphysinterval = 20;


var
  ueue:TShipLoader;
  npoin:Integer;
  poin:array [0 .. 10000] of TRe3dc;
  glaz:Integer;
  nquads:Integer;
  qua:array [0 .. 10000] of TBwquads;
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
    Textureamount, localidstat:integer;
    climit, v, prs, k, waiting, kran, rwaiting, polzunwait, delit, timeofplaying:real;


procedure Start();
begin
  {v := 0;
  rup := 0;
  polzunok := 0;
  rwaiting := 0;
  polzunwait := 0;
  timeofplaying := 0;
  prs := pmax;
  kran := 1;
  revers := 0;
  nrevers := 0;
  delit := 10;
  itx := 0;
  climit := 80 / 3.6;
  k := TiPhysInterval / 1000 * acc;
  waiting := 0;
  isrp := false;


  // Задание газовых характеристик
  {hz [0].kbeta := 0.28;
  hz [0].r := rmax + r0;
  hz [0].ispp := false;
  hz [1].kbeta := 0.7;
  hz [1].r := rmax + r0;
  hz [1].ispp := false;
  i := 2;
  while hz [i - 1].r > r0 + 0.3 * sqrt (i) do
  begin
    hz [i].r := hz [i - 1].r - 0.3 * sqrt (i);
    hz [i].kbeta := 1;
    hz [i].ispp := false;
    inc (i);
  end;

  maxpolz := i + 1;

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
  maxpolz2 := i + 1;

  //Задание тормозных характеристик
  for i := 0 to bshamount - 1 do
    brakehz [i].vmin := 3 - 2.5 * i / (bshamount - 1);
  brakehz [0].R := 5;
  brakehz [0].kbeta := 0.5;
  brakehz [1].R := 5;
  brakehz [1].kbeta := 0.7;
  brakehz [2].R := 5;
  brakehz [2].kbeta := 1;
  for i := 3 to bshamount - 1 do
  begin
   brakehz [i].R := brakehz [i - 1].R  / (1.3);
   brakehz [i].kbeta := 1;
  end;


  TextureAmount := 0;
  while FileExists('media/' + IntToStr(TextureAmount) + '.bmp') do
    inc (TextureAmount);
  for i := 0 to TextureAmount - 1 do
    PrepareImage(i);        }
  nadoload := True;
{

//????? ?????-?? ????????             }

end;

procedure LoadGame(var logmemo:TMemo);
var i:integer;
begin
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
  logmemo.Lines.Add('Рассчёт станций');
  wtf.realizestat;

  for i := 0 to wtf.nscb do
  begin
    mkgoodscb;
  end;
  oldhz := wtf.gnscbid(wtf.ptrain [0], wtf.isleft);
  logmemo.Lines.Add('Создание звуков');
  SetChannels;
  Sleep(1000);
end;

procedure LoadCab;
var i:integer;
begin
  ueue := TShipLoader.create('cab.txt');
  npoin := ueue.giveinteger;
  for i := 0 to npoin - 1 do
  begin
    poin [i].x := ueue.givereal;
    poin [i].y := ueue.givereal;
    poin [i].z := ueue.givereal;
    if ueue.giveinteger = 1 then
      glaz := i;
  end;

  nquads := ueue.giveinteger;
  for i := 0 to nquads - 1 do
  begin
    qua [i].tid := ueue.giveinteger;
    qua [i].a.x := ueue.giveinteger; //????? ?????
    qua [i].a.y := ueue.giveinteger; //???????? ?
    qua [i].a.z := ueue.giveinteger; //???????? ?

    qua [i].b.x := ueue.giveinteger;
    qua [i].b.y := ueue.giveinteger;
    qua [i].b.z := ueue.giveinteger;

    qua [i].c.x := ueue.giveinteger;
    qua [i].c.y := ueue.giveinteger;
    qua [i].c.z := ueue.giveinteger;

    qua [i].d.x := ueue.giveinteger;
    qua [i].d.y := ueue.giveinteger;
    qua [i].d.z := ueue.giveinteger;
  end;

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


end.
