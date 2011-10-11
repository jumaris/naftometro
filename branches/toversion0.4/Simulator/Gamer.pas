unit Gamer;



interface

uses Bomj, useful, dglOpenGL, OpenGL, Graphics,
  MPlayer, Buttons, Bass, StdCtrls, Windows, math, SysUtils;

procedure start();
procedure loadcab();
procedure LoadGame(var logMemo:Tmemo);
procedure mkgoodscb;
procedure SetChannels;
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
  queuestart:PBWp;
  ueue:TShipLoader;
  npoin:Integer;
  poin:array [0 .. 10000] of TRe3dc;
  realpoin: array [0 .. 10000] of TRe3dc;
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


var
  mytextures:array [0 .. 1048575, 0 .. 30] of Byte;
  texturesizes:array [0 .. 30] of TMy3dc;
  hz:array [0 .. 100] of THz;
  brakehz:array [0 .. bshamount - 1] of TBrakeHz;


procedure PrepareImage(bmap: integer);
var
Bitmap:Graphics.TBitmap;
Data:array of Byte;
BMInfo:TBitmapInfo;
Temp:Byte;
MemDC:HDC;
I, ImageSize:longint;
bitwid, bithei:Integer;
S:string;
begin
  s:= 'media/' + IntToStr (bmap) + '.bmp';
  Bitmap := Graphics.TBitmap.Create;
  Bitmap.LoadFromFile (s);
  with BMinfo.bmiHeader do
  begin
    FillChar (BMInfo, SizeOf (BMInfo), 0);
    biSize := sizeof (TBitmapInfoHeader);
    biBitCount := 24;
    biWidth := Bitmap.Width;
    biHeight := Bitmap.Height;
    ImageSize := biWidth * biHeight;
    bitwid := biWidth;
    bithei := biHeight;

    biPlanes := 1;
    biCompression := BI_RGB;
    MemDC := CreateCompatibleDC (0);
    SetLength (Data, (ImageSize + 2) * 3);
    try
      GetDIBits (MemDC, Bitmap.Handle, 0, biHeight, Data, BMInfo, DIB_RGB_COLORS);
      for I := 0 to ImageSize - 1 do begin
        Temp := Data [i*3];
        Data [i * 3] := Data [i*3 + 2];
        Data [i * 3 + 2] := Temp;
      end;
      for I := 0 to ImageSize - 1 do begin
        mytextures [i * 4, bmap] := Data [i*3];
        mytextures [i * 4 + 1, bmap] := Data [i*3 + 1];
        mytextures [i * 4 + 2, bmap] := Data [i*3 + 2];
        if (Data [i*3] = 254) then
          mytextures [i * 4 + 3, bmap] := 0
        else
          mytextures [i * 4 + 3, bmap] := 255;
      end;
    finally
      Finalize (Data);
      DeleteDC (MemDC);
      Bitmap.Free;
    end;
  end;
  texturesizes [bmap].x := bitWid;
  texturesizes [bmap].y := bitHei;
  texturesizes [bmap].z := ImageSize * 4;
end;


procedure Start();
var i:Integer;
begin
  v := 0;
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
  hz [0].kbeta := 0.28;
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
    PrepareImage(i);        
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
  logmemo.Lines.Add('Расчёт станций');
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

procedure MovePoint(var a: TRe3dc; kurs, len: real);
begin
  a.x := a.x + len * cos (kurs/180*pi);
  a.y := a.y + len * sin (kurs/180*pi);
end;


procedure CalcRealPoints;
var i:integer;
    x, y, kurs, z:Real;
begin
  if wtf.cabfactor=1 then
  begin
    x := wtf.givebx(wtf.ptrain [0]);
    y := wtf.giveby(wtf.ptrain [0]);
    z := wtf.givebz(wtf.ptrain [0]);
  end
  else
  begin
    x := wtf.givebx(wtf.ptrain [wtf.nwag]);
    y := wtf.giveby(wtf.ptrain [wtf.nwag]);
    z := wtf.givebz(wtf.ptrain [wtf.nwag]);
  end;
  kurs := wtf.givecamkurs - wtf.camdopkurs;
  for i := 0 to npoin - 1 do   //??????? ????? ? ???? ?? ?????? ??????
  begin
    realpoin [i].x := x;
    realpoin [i].y := y;

    MovePoint(realpoin [i], kurs, Poin [i].x);
    MovePoint(realpoin [i], kurs + 90, Poin [i].y);
    realpoin [i].z := poin [i].z + z;
  end;
end;

procedure zafigachtexturu(i: integer);
var DataA:array of Byte;
    j:integer;
begin
    SetLength (DataA, texturesizes [i].z);
    for j := 0 to texturesizes [i].z - 1 do
      DataA [j] := mytextures [j, i];
    glTexImage2d (GL_TEXTURE_2D, 0, 4, texturesizes [i].x, texturesizes [i].y, 0, GL_RGBA, GL_UNSIGNED_BYTE, DataA);
    gluBuild2DMipmaps (GL_TEXTURE_2D, 0, texturesizes [i].x, texturesizes [i].y, 4, GL_UNSIGNED_BYTE, DataA);
    Finalize (DataA);
end;

procedure DrawSCB;
var i:integer;
    p2:PTp;
begin
  for i := 0 to wtf.nscb - 1 do
  if ((wtf.cabfactor = 1) and wtf.scb [i].isforward) or ((wtf.cabfactor = -1) and not wtf.scb [i].isforward) then
  begin
    p2 := wtf.scb [i].ntp;
    zafigachtexturu(wtf.scb [i].condition);
    glBegin (GL_QUADS);
      glTexCoord2f (0, 0);
      glVertex3f (p2^.table [0].x, p2^.table [0].y, p2^.table [0].z);
      glTexCoord2f (1, 0);
      glVertex3f (p2^.table [1].x, p2^.table [1].y, p2^.table [1].z);
      glTexCoord2f (1, 1);
      glVertex3f (p2^.table [2].x, p2^.table [2].y, p2^.table [2].z);
      glTexCoord2f (0, 1);
      glVertex3f (p2^.table [3].x, p2^.table [3].y, p2^.table [3].z);
    glEnd;
  end;
end;


function bwgc(p: PTp): real;
begin
  result := 1 / (1.5 + sqr (wtf.givelto(p) / delit));
end;


procedure PaintTubing(p: Ptp);
var i:integer;
    p2:PTp;
    c:Real;
begin
  if (p = nil) then Exit;
  p2 := p^.next1;
  if (p2 = nil) then exit;
  if (p2^.idstat <> 0) or (p^.idstat <> 0) then
  begin
    localidstat := max (p2^.idstat, p^.idstat);
    Exit;
  end;
  c := bwgc (p);
  glColor3f(C * tubr, c * tubg, c * tubb);
  if (p^.together = p) or (p^.isright) then
    for i := 0 to numboc div 2 - 1 do
    begin
      glBegin(GL_QUADS);
        glTexCoord2f (0, 0);
        glVertex3f(p^.corners[i].x, p^.corners [i].y, p^.corners [i].z);
        glTexCoord2f (0, 1);
        glVertex3f(p^.corners [i + 1].x, p^.corners [i + 1].y, p^.corners [i + 1].z);
        glTexCoord2f (1, 1);
        glVertex3f(p2^.corners [i + 1].x, p2^.corners [i + 1].y, p2^.corners [i + 1].z);
        glTexCoord2f (1, 0);
        glVertex3f(p2^.corners [i].x, p2^.corners [i].y, p2^.corners [i].z);
      glEnd;
    end;
  if (p^.together = p) or (not p^.isright) then
    for i := numboc div 2 to numboc - 2 do
    begin
      glBegin(GL_QUADS);
        glTexCoord2f (0, 0);
        glVertex3f(p^.corners [i].x, p^.corners [i].y, p^.corners [i].z);
        glTexCoord2f (0, 1);
        glVertex3f(p^.corners [i + 1].x, p^.corners [i + 1].y, p^.corners [i + 1].z);
        glTexCoord2f (1, 1);
        glVertex3f(p2^.corners [i + 1].x, p2^.corners [i + 1].y, p2^.corners [i + 1].z);
        glTexCoord2f (1, 0);
        glVertex3f(p2^.corners [i].x, p2^.corners [i].y, p2^.corners [i].z);
      glEnd;
    end;
end;

procedure Painstation(localidstat:integer);
var i:Integer;
begin
  glColor3f(1, 1, 1);
  for i := 0 to wtf.nstatquad [localidstat] - 1 do
  begin
    zafigachtexturu(wtf.statqua [localidstat, i].tid);
    glBegin (GL_QUADS);
      glTexCoord2f (wtf.statqua[localidstat, i].a.y, wtf.statqua[localidstat,i].a.z);
      glVertex3f (wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].a.x].x, wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].a.x].y, wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].a.x].z);
      glTexCoord2f (wtf.statqua[localidstat, i].b.y, wtf.statqua[localidstat,i].b.z);
      glVertex3f (wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].b.x].x, wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].b.x].y, wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].b.x].z);
      glTexCoord2f (wtf.statqua[localidstat, i].c.y, wtf.statqua[localidstat,i].c.z);
      glVertex3f (wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].c.x].x, wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].c.x].y, wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].c.x].z);
      glTexCoord2f (wtf.statqua[localidstat, i].d.y, wtf.statqua[localidstat,i].d.z);
      glVertex3f (wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].d.x].x, wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].d.x].y, wtf.statrealpoin [localidstat, wtf.statqua [localidstat,i].d.x].z);
    glEnd;
  end;
end;

procedure PaintFloor(p: Ptp);
var p2, p3:PTp;
    c:Real;
    i:Integer;
begin
  if p = nil then Exit;

  p2 := p^.next2;
  c := bwgc(p);
  glColor3f(C * tubr, c * tubg, c * tubb);
  if (p^.previous1 = nil) or (p2 = nil) then            //Заплатка на конец тоннеля
    for i := 0 to numboc div 2 - 1 do
    begin
      glBegin(GL_QUADS);
        glTexCoord2f (0, 0);
        glVertex3f(p^.corners [i].x, p^.corners [i].y, p^.corners [i].z);
        glTexCoord2f (0, 1);
        glVertex3f(p^.corners [i + 1].x, p^.corners [i + 1].y, p^.corners [i + 1].z);
        glTexCoord2f (1, 1);
        glVertex3f(p^.corners [numboc - i - 2].x, p^.corners [numboc - i - 2].y, p^.corners [numboc - i - 2].z);
        glTexCoord2f (1, 0);
        glVertex3f(p^.corners [numboc - i - 1].x, p^.corners [numboc - i - 1].y, p^.corners [numboc - i - 1].z);
      glEnd;
    end;

  if (p^.idstat <> 0) or (p2 = nil) or (p2^.idstat <> 0) then Exit;// Собственно пол не нужен

  if (p^.together <> p) and (p2^.together = p2) and (not p^.isright) then
  begin
    glBegin(GL_QUADS);            //Неправильная щель
      glTexCoord2f (0, 0);
      glVertex3f(p2^.corners [numboc - 1].x, p2^.corners [numboc - 1].y, p2^.corners [numboc - 1].z);
      glTexCoord2f (1, 0);
      glVertex3f(p2^.corners [0].x, p2^.corners [0].y, p2^.corners [0].z);
      p3 := p^.together^.next1;
      glTexCoord2f (1, 1);
      glVertex3f(p3^.corners [numboc - 1].x, p3^.corners [numboc - 1].y, p3^.corners [numboc - 1].z);
      glTexCoord2f (0, 1);
      glVertex3f(p3^.corners [0].x, p3^.corners [0].y, p3^.corners [0].z);
    glEnd;

    glBegin(GL_QUADS);     //Пол
      glTexCoord2f (0, 1);
      glVertex3f(p3^.corners [0].x, p3^.corners [0].y, p3^.corners [0].z);
      glTexCoord2f (1, 1);
      glVertex3f(p^.together^.corners [0].x, p^.together^.corners [0].y, p^.together^.corners [0].z);
      glTexCoord2f (1, 0);
      glVertex3f(p^.corners [numboc - 1].x, p^.corners [numboc - 1].y, p^.corners [numboc - 1].z);
      glTexCoord2f (0, 0);
      glVertex3f(p2^.corners [numboc - 1].x, p2^.corners [numboc - 1].y, p2^.corners [numboc - 1].z);
    glEnd;
    glBegin(GL_QUADS);    //Потолок
      glTexCoord2f (0, 0);
      glVertex3f(p^.corners [numboc div 2].x, p^.corners [numboc div 2].y, p^.corners [numboc div 2].z);
      glTexCoord2f (0, 1);
      glVertex3f(p^.together^.corners [numboc div 2].x, p^.together^.corners [numboc div 2].y, p^.together^.corners [numboc div 2].z);
      glTexCoord2f (1, 1);
      glVertex3f(p3^.corners [numboc div 2].x, p3^.corners [numboc div 2].y, p3^.corners [numboc div 2].z);
      glTexCoord2f (1, 0);
      glVertex3f(p2^.corners [numboc div 2].x, p2^.corners [numboc div 2].y, p2^.corners [numboc div 2].z);
    glEnd;

    for i := 0 to numboc div 2 - 1 do  //Стенка в камере съездов
    begin
      glBegin(GL_QUADS);
        glTexCoord2f (0, 0);
        glVertex3f(p2^.corners [i].x, p2^.corners [i].y, p2^.corners [i].z);
        glTexCoord2f (0, 1);
        glVertex3f(p2^.corners [i + 1].x, p2^.corners [i + 1].y, p2^.corners [i + 1].z);
        glTexCoord2f (1, 1);
        glVertex3f(p3^.corners [numboc - i - 2].x, p3^.corners [numboc - i - 2].y, p3^.corners [numboc - i - 2].z);
        glTexCoord2f (1, 0);
        glVertex3f(p3^.corners [numboc - i - 1].x, p3^.corners [numboc - i - 1].y, p3^.corners [numboc - i - 1].z);
      glEnd;
    end;
  end;

  if ((p^.together = p) and (p2^.together = p2)) or
     (not p2^.isright and (p2^.together <> p2))
    then
  begin
    glBegin(GL_QUADS);
      glTexCoord2f (0, 1);
      glVertex3f(p2^.together^.corners [0].x, p2^.together^.corners [0].y, p2^.together^.corners [0].z);
      glTexCoord2f (1, 1);
      glVertex3f(p^.together^.corners [0].x, p^.together^.corners [0].y, p^.together^.corners [0].z);
      glTexCoord2f (1, 0);
      glVertex3f(p^.corners [numboc - 1].x, p^.corners [numboc - 1].y, p^.corners [numboc - 1].z);
      glTexCoord2f (0, 0);
      glVertex3f(p2^.corners [numboc - 1].x, p2^.corners [numboc - 1].y, p2^.corners [numboc - 1].z);
    glEnd;
    glBegin(GL_QUADS);
      glTexCoord2f (0, 0);
      glVertex3f(p^.corners [numboc div 2].x, p^.corners [numboc div 2].y, p^.corners [numboc div 2].z);
      glTexCoord2f (0, 1);
      glVertex3f(p^.together^.corners [numboc div 2].x, p^.together^.corners [numboc div 2].y, p^.together^.corners [numboc div 2].z);
      glTexCoord2f (1, 1);
      glVertex3f(p2^.together^.corners [numboc div 2].x, p2^.together^.corners [numboc div 2].y, p2^.together^.corners [numboc div 2].z);
      glTexCoord2f (1, 0);
      glVertex3f(p2^.corners [numboc div 2].x, p2^.corners [numboc div 2].y, p2^.corners [numboc div 2].z);
    glEnd;
  end;
end;

procedure PaintRels(p: Ptp);
var p2:PTp;
    c:Real;
begin
  if p = nil then Exit;
  p2 := p^.next2;
  if p2 = nil then Exit;
  c := bwgc(p);
  glColor3f(c * tubr, c * tubg, c * tubb);
  glBegin(GL_QUADS);
    glTexCoord2f (0, 0);
    glVertex3f(p^.shpala [0].x, p^.shpala [0].y, p^.shpala [0].z);
    glTexCoord2f (1, 0);
    glVertex3f(p^.shpala [1].x, p^.shpala [1].y, p^.shpala [1].z);
    glTexCoord2f (1, 1);
    glVertex3f(p2^.shpala [1].x, p2^.shpala [1].y, p2^.shpala [1].z);
    glTexCoord2f (0, 1);
    glVertex3f(p2^.shpala [0].x, p2^.shpala [0].y, p2^.shpala [0].z);
  glEnd;
end;

procedure RecConstQue(p:PTp; dep:integer);
var pp:PBWp;
    hrue:PTp;
    togdadep:integer;
begin
  if (wtf.cabfactor=1) then
  begin
    pp:=queuestart;
    hrue := nil;
    while (pp^.next <> nil) do
      pp := pp^.next;
    while (dep < maxdep) and (p <> nil) and (p^.next1 = p^.next2) do
    begin
      new (pp^.next);
      pp := pp^.next;
      pp^.next := nil;
      pp^.tp := p;
      if p^.together <> p then
      begin
        new (pp^.next);
        pp := pp^.next;
        pp^.next := nil;
        pp^.tp := p^.together;
        if (p^.next1^.together = p^.next1) then
        begin
          hrue := p^.together^.next1;
          togdadep := dep;
        end;
      end;
      p := p^.next1;
      inc (dep);
    end;
    if hrue <> nil then
      RecConstQue(hrue, togdadep);
    if  (dep < maxdep) and (p <> nil) and (p^.next1 <> nil) and (p^.next2 <> nil) then
    begin
      new (pp^.next);
      pp := pp^.next;
      pp^.next := nil;
      pp^.tp := p;
      RecConstQue(p^.next1, dep);
      RecConstQue(p^.next2, dep);
    end;
  end
  else
  begin
    pp:=queuestart;
    hrue := nil;
    while (pp^.next <> nil) do
      pp := pp^.next;
    while (dep < maxdep) and (p <> nil) and (p^.previous1 = p^.previous2) do
    begin
      new (pp^.next);
      pp := pp^.next;
      pp^.next := nil;
      pp^.tp := p;
      if p^.together <> p then
      begin
        new (pp^.next);
        pp := pp^.next;
        pp^.next := nil;
        pp^.tp := p^.together;
        if (p^.previous1^.together = p^.previous1) then
        begin
          hrue := p^.together^.previous1;
          togdadep := dep;
        end;
      end;
      p := p^.previous1;
      inc (dep);
    end;
    if hrue <> nil then
      RecConstQue(hrue, togdadep);
    if  (dep < maxdep) and (p <> nil) and (p^.previous1 <> nil) and (p^.previous2 <> nil) then
    begin
      new (pp^.next);
      pp := pp^.next;
      pp^.next := nil;
      pp^.tp := p;
      RecConstQue(p^.previous1, dep);
      RecConstQue(p^.previous2, dep);
    end;
  end;
end;

function giveafter(pbw: PBWp; p: PTp): PBWp;
begin
  Result := nil;
  if (pbw = nil) then Exit;
  while pbw.next <> nil do
  begin
    pbw := pbw^.next;
    if pbw^.tp = p then
      Result := pbw;
  end;
end;


procedure SimpQue;
var i, j:PBWp;
begin
  while giveafter(queuestart, queuestart^.tp) <> nil do
  begin
    i := queuestart^.next;
    Dispose (queuestart);
    queuestart := i;
  end;
  i := queuestart;
  while i^.next <> nil do
  begin
    while giveafter(i^.next, i^.next^.tp) <> nil do
    begin
      j := i^.next;
      i^.next := i^.next^.next;
      Dispose (j);
    end;
    i := i^.next;
  end;
end;


procedure DrawScene;
var bwa:PBWp;
begin
  zafigachtexturu(16);
  new (queuestart);
  queuestart^.tp := wtf.ptrain [1]^.previous1;
  queuestart^.next := nil;
  RecConstQue(wtf.ptrain [1], 0);
  SimpQue;

  bwa := queuestart;
  localidstat := 0;
  while bwa <> nil do
  begin
    PaintTubing(bwa^.tp);
    bwa := bwa^.next;
  end;

  if localidstat > 0 then
    Painstation (localidstat);

  zafigachtexturu(17);
  bwa := queuestart;
  while bwa <> nil do
  begin
    PaintFloor(bwa^.tp);
    bwa := bwa^.next;
  end;

  zafigachtexturu(22);
  while (queuestart <> nil) do
  begin
    PaintRels (queuestart^.tp);
    bwa := queuestart;
    queuestart := queuestart ^.next;
    Dispose (bwa);
  end;
end;

procedure DrawCab;
var i:Integer;
begin
  glColor3f(1, 1, 1);
  for i := 0 to nquads - 1 do
  begin
    zafigachtexturu(qua [i].tid);
    glBegin (GL_QUADS);
      glTexCoord2f (qua[i].a.y, qua[i].a.z);
      glVertex3f (realpoin[qua[i].a.x].x, realpoin [qua [i].a.x].y, realpoin [qua [i].a.x].z);
      glTexCoord2f (qua[i].b.y, qua[i].b.z);
      glVertex3f (realpoin [qua [i].b.x].x, realpoin [qua [i].b.x].y, realpoin [qua [i].b.x].z);
      glTexCoord2f (qua[i].c.y, qua[i].c.z);
      glVertex3f (realpoin [qua [i].c.x].x, realpoin [qua [i].c.x].y, realpoin [qua [i].c.x].z);
      glTexCoord2f (qua[i].d.y, qua[i].d.z);
      glVertex3f (realpoin [qua [i].d.x].x, realpoin [qua [i].d.x].y, realpoin [qua [i].d.x].z);
    glEnd;
  end;
end;

procedure DrawGame(Width, Height: integer; DC:HDC);
begin
  calcRealPoints;
  glViewPort (0, 0, Width, Height);
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glPushMatrix;

  //Поворот камеры, т.е. системы координат
  glRotatef (wtf.givecamalpha, -1, 0, 0);
  glRotatef (wtf.givecamkurs, 0, -1, 0);

  glRotatef (90, -1, 0, 0);
  glRotatef (90, 0, 0, 1);
  glTranslatef(-realpoin[glaz].x, -realpoin [glaz].y, -realpoin [glaz].z);

  //Writeln(wtf.ptrain[0].next1.next1.cx);

  DrawSCB;
  DrawScene;

  //PaintTubing(wtf.ptrain[0]);

  DrawCab;


  glPopMatrix;
  SwapBuffers (DC);

end;

end.
