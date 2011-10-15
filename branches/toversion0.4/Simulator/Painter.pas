unit Painter;

interface

uses
  SysUtils, math, windows, Graphics,
  dglOpenGL, OpenGL,
  useful;

procedure init();
procedure PaintGame(Width, Height: integer; DC:HDC; wtf:TWtf);

implementation

var
  textureamount: integer;
  mytextures:array [0 .. 1048575, 0 .. 30] of Byte;
  texturesizes:array [0 .. 30] of TMy3dc;

const
  delit = 10; // что-то о ширине светофора

const         // цвет тюбинга
  tubr = 1;
  tubg = 0.8;
  tubb = 0.6;

const
  maxdep = 100;     // длина отрисовки

procedure zafigachtexturu(i: integer);
var DataA:array of Byte;
    j:integer;
begin
    SetLength (DataA, texturesizes[i].z);
    for j := 0 to texturesizes[i].z - 1 do
      DataA[j] := mytextures[j, i];
    glTexImage2d (GL_TEXTURE_2D, 0, 4, texturesizes[i].x, texturesizes[i].y, 0, GL_RGBA, GL_UNSIGNED_BYTE, DataA);
    gluBuild2DMipmaps (GL_TEXTURE_2D, 0, texturesizes[i].x, texturesizes[i].y, 4, GL_UNSIGNED_BYTE, DataA);
    Finalize (DataA);
end;

function bwgc(p: PTp; wtf: Twtf): real;
begin
  result := 1 / (1.5 + sqr (wtf.givelto(p) / delit));
end;

procedure PaintSCB(wtf: Twtf);
var i:integer;
    p2:PTp;
begin
  for i := 0 to wtf.nscb - 1 do
  if ((wtf.cabfactor = 1) and wtf.scb[i].isforward) or ((wtf.cabfactor = -1) and not wtf.scb[i].isforward) then
  begin
    p2 := wtf.scb[i].ntp;
    zafigachtexturu(wtf.scb[i].condition);
    glBegin (GL_QUADS);
      glTexCoord2f (0, 0);
      glVertex3f (p2^.table[0].x, p2^.table[0].y, p2^.table[0].z);
      glTexCoord2f (1, 0);
      glVertex3f (p2^.table[1].x, p2^.table[1].y, p2^.table[1].z);
      glTexCoord2f (1, 1);
      glVertex3f (p2^.table[2].x, p2^.table[2].y, p2^.table[2].z);
      glTexCoord2f (0, 1);
      glVertex3f (p2^.table[3].x, p2^.table[3].y, p2^.table[3].z);
    glEnd;
  end;
end;

procedure PaintTubing(p: Ptp; var localidstat: integer; var wtf: TWtf);
var i:integer;
    p2:PTp;
    c:Real;
begin
  if (p = nil) then Exit;
  p2 := p^.next1;
  if (p2 = nil) then exit;
  if (p2^.idstat <> 0) or (p^.idstat <> 0) then
  begin
    localidstat := max(p2^.idstat, p^.idstat);
    Exit;
  end;
  c := bwgc(p, wtf);
  glColor3f(C * tubr, c * tubg, c * tubb);
  if (p^.together = p) or (p^.isright) then
    for i := 0 to numboc div 2 - 1 do
    begin
      glBegin(GL_QUADS);
        glTexCoord2f (0, 0);
        glVertex3f(p^.corners[i].x, p^.corners[i].y, p^.corners[i].z);
        glTexCoord2f (0, 1);
        glVertex3f(p^.corners[i + 1].x, p^.corners[i + 1].y, p^.corners[i + 1].z);
        glTexCoord2f (1, 1);
        glVertex3f(p2^.corners[i + 1].x, p2^.corners[i + 1].y, p2^.corners[i + 1].z);
        glTexCoord2f (1, 0);
        glVertex3f(p2^.corners[i].x, p2^.corners[i].y, p2^.corners[i].z);
      glEnd;
    end;
  if (p^.together = p) or (not p^.isright) then
    for i := numboc div 2 to numboc - 2 do
    begin
      glBegin(GL_QUADS);
        glTexCoord2f (0, 0);
        glVertex3f(p^.corners[i].x, p^.corners[i].y, p^.corners[i].z);
        glTexCoord2f (0, 1);
        glVertex3f(p^.corners[i + 1].x, p^.corners[i + 1].y, p^.corners[i + 1].z);
        glTexCoord2f (1, 1);
        glVertex3f(p2^.corners[i + 1].x, p2^.corners[i + 1].y, p2^.corners[i + 1].z);
        glTexCoord2f (1, 0);
        glVertex3f(p2^.corners[i].x, p2^.corners[i].y, p2^.corners[i].z);
      glEnd;
    end;
end;

procedure PaintStation(localidstat:integer; var wtf:Twtf);
var i:Integer;
begin
  glColor3f(1, 1, 1);
  for i := 0 to wtf.nstatquad[localidstat] - 1 do
  begin
    zafigachtexturu(wtf.statqua[localidstat, i].tid);
    glBegin (GL_QUADS);
      glTexCoord2f (wtf.statqua[localidstat, i].a.y, wtf.statqua[localidstat,i].a.z);
      glVertex3f (wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].a.x].x, wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].a.x].y, wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].a.x].z);
      glTexCoord2f (wtf.statqua[localidstat, i].b.y, wtf.statqua[localidstat,i].b.z);
      glVertex3f (wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].b.x].x, wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].b.x].y, wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].b.x].z);
      glTexCoord2f (wtf.statqua[localidstat, i].c.y, wtf.statqua[localidstat,i].c.z);
      glVertex3f (wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].c.x].x, wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].c.x].y, wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].c.x].z);
      glTexCoord2f (wtf.statqua[localidstat, i].d.y, wtf.statqua[localidstat,i].d.z);
      glVertex3f (wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].d.x].x, wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].d.x].y, wtf.statrealpoin[localidstat, wtf.statqua[localidstat,i].d.x].z);
    glEnd;
  end;
end;

procedure PaintFloor(p: Ptp; var wtf: TWtf);
var p2, p3:PTp;
    c:Real;
    i:Integer;
begin
  if p = nil then Exit;

  p2 := p^.next2;
  c := bwgc(p, wtf);
  glColor3f(C * tubr, c * tubg, c * tubb);
  if (p^.previous1 = nil) or (p2 = nil) then            //Заплатка на конец тоннеля
    for i := 0 to numboc div 2 - 1 do
    begin
      glBegin(GL_QUADS);
        glTexCoord2f (0, 0);
        glVertex3f(p^.corners[i].x, p^.corners[i].y, p^.corners[i].z);
        glTexCoord2f (0, 1);
        glVertex3f(p^.corners[i + 1].x, p^.corners[i + 1].y, p^.corners[i + 1].z);
        glTexCoord2f (1, 1);
        glVertex3f(p^.corners[numboc - i - 2].x, p^.corners[numboc - i - 2].y, p^.corners[numboc - i - 2].z);
        glTexCoord2f (1, 0);
        glVertex3f(p^.corners[numboc - i - 1].x, p^.corners[numboc - i - 1].y, p^.corners[numboc - i - 1].z);
      glEnd;
    end;

  if (p^.idstat <> 0) or (p2 = nil) or (p2^.idstat <> 0) then Exit;// Собственно пол не нужен

  if (p^.together <> p) and (p2^.together = p2) and (not p^.isright) then
  begin
    glBegin(GL_QUADS);            //Неправильная щель
      glTexCoord2f (0, 0);
      glVertex3f(p2^.corners[numboc - 1].x, p2^.corners[numboc - 1].y, p2^.corners[numboc - 1].z);
      glTexCoord2f (1, 0);
      glVertex3f(p2^.corners[0].x, p2^.corners[0].y, p2^.corners[0].z);
      p3 := p^.together^.next1;
      glTexCoord2f (1, 1);
      glVertex3f(p3^.corners[numboc - 1].x, p3^.corners[numboc - 1].y, p3^.corners[numboc - 1].z);
      glTexCoord2f (0, 1);
      glVertex3f(p3^.corners[0].x, p3^.corners[0].y, p3^.corners[0].z);
    glEnd;

    glBegin(GL_QUADS);     //Пол
      glTexCoord2f (0, 1);
      glVertex3f(p3^.corners[0].x, p3^.corners[0].y, p3^.corners[0].z);
      glTexCoord2f (1, 1);
      glVertex3f(p^.together^.corners[0].x, p^.together^.corners[0].y, p^.together^.corners[0].z);
      glTexCoord2f (1, 0);
      glVertex3f(p^.corners[numboc - 1].x, p^.corners[numboc - 1].y, p^.corners[numboc - 1].z);
      glTexCoord2f (0, 0);
      glVertex3f(p2^.corners[numboc - 1].x, p2^.corners[numboc - 1].y, p2^.corners[numboc - 1].z);
    glEnd;
    glBegin(GL_QUADS);    //Потолок
      glTexCoord2f (0, 0);
      glVertex3f(p^.corners[numboc div 2].x, p^.corners[numboc div 2].y, p^.corners[numboc div 2].z);
      glTexCoord2f (0, 1);
      glVertex3f(p^.together^.corners[numboc div 2].x, p^.together^.corners[numboc div 2].y, p^.together^.corners[numboc div 2].z);
      glTexCoord2f (1, 1);
      glVertex3f(p3^.corners[numboc div 2].x, p3^.corners[numboc div 2].y, p3^.corners[numboc div 2].z);
      glTexCoord2f (1, 0);
      glVertex3f(p2^.corners[numboc div 2].x, p2^.corners[numboc div 2].y, p2^.corners[numboc div 2].z);
    glEnd;

    for i := 0 to numboc div 2 - 1 do  //Стенка в камере съездов
    begin
      glBegin(GL_QUADS);
        glTexCoord2f (0, 0);
        glVertex3f(p2^.corners[i].x, p2^.corners[i].y, p2^.corners[i].z);
        glTexCoord2f (0, 1);
        glVertex3f(p2^.corners[i + 1].x, p2^.corners[i + 1].y, p2^.corners[i + 1].z);
        glTexCoord2f (1, 1);
        glVertex3f(p3^.corners[numboc - i - 2].x, p3^.corners[numboc - i - 2].y, p3^.corners[numboc - i - 2].z);
        glTexCoord2f (1, 0);
        glVertex3f(p3^.corners[numboc - i - 1].x, p3^.corners[numboc - i - 1].y, p3^.corners[numboc - i - 1].z);
      glEnd;
    end;
  end;

  if ((p^.together = p) and (p2^.together = p2)) or
     (not p2^.isright and (p2^.together <> p2))
    then
  begin
    glBegin(GL_QUADS);
      glTexCoord2f (0, 1);
      glVertex3f(p2^.together^.corners[0].x, p2^.together^.corners[0].y, p2^.together^.corners[0].z);
      glTexCoord2f (1, 1);
      glVertex3f(p^.together^.corners[0].x, p^.together^.corners[0].y, p^.together^.corners[0].z);
      glTexCoord2f (1, 0);
      glVertex3f(p^.corners[numboc - 1].x, p^.corners[numboc - 1].y, p^.corners[numboc - 1].z);
      glTexCoord2f (0, 0);
      glVertex3f(p2^.corners[numboc - 1].x, p2^.corners[numboc - 1].y, p2^.corners[numboc - 1].z);
    glEnd;
    glBegin(GL_QUADS);
      glTexCoord2f (0, 0);
      glVertex3f(p^.corners[numboc div 2].x, p^.corners[numboc div 2].y, p^.corners[numboc div 2].z);
      glTexCoord2f (0, 1);
      glVertex3f(p^.together^.corners[numboc div 2].x, p^.together^.corners[numboc div 2].y, p^.together^.corners[numboc div 2].z);
      glTexCoord2f (1, 1);
      glVertex3f(p2^.together^.corners[numboc div 2].x, p2^.together^.corners[numboc div 2].y, p2^.together^.corners[numboc div 2].z);
      glTexCoord2f (1, 0);
      glVertex3f(p2^.corners[numboc div 2].x, p2^.corners[numboc div 2].y, p2^.corners[numboc div 2].z);
    glEnd;
  end;
end;

procedure PaintRails(p: Ptp; var wtf: TWtf);
var p2:PTp;
    c:Real;
begin
  if p = nil then Exit;
  p2 := p^.next2;
  if p2 = nil then Exit;
  c := bwgc(p, wtf);
  glColor3f(c * tubr, c * tubg, c * tubb);
  glBegin(GL_QUADS);
    glTexCoord2f (0, 0);
    glVertex3f(p^.shpala[0].x, p^.shpala[0].y, p^.shpala[0].z);
    glTexCoord2f (1, 0);
    glVertex3f(p^.shpala[1].x, p^.shpala[1].y, p^.shpala[1].z);
    glTexCoord2f (1, 1);
    glVertex3f(p2^.shpala[1].x, p2^.shpala[1].y, p2^.shpala[1].z);
    glTexCoord2f (0, 1);
    glVertex3f(p2^.shpala[0].x, p2^.shpala[0].y, p2^.shpala[0].z);
  glEnd;
end;

procedure RecConstQue(p:PTp; dep:integer; var wtf:Twtf; var queuestart:PBwp);
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
      RecConstQue(hrue, togdadep, wtf, queuestart);
    if  (dep < maxdep) and (p <> nil) and (p^.next1 <> nil) and (p^.next2 <> nil) then
    begin
      new (pp^.next);
      pp := pp^.next;
      pp^.next := nil;
      pp^.tp := p;
      RecConstQue(p^.next1, dep, wtf, queuestart);
      RecConstQue(p^.next2, dep, wtf, queuestart);
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
      RecConstQue(hrue, togdadep, wtf, queuestart);
    if  (dep < maxdep) and (p <> nil) and (p^.previous1 <> nil) and (p^.previous2 <> nil) then
    begin
      new (pp^.next);
      pp := pp^.next;
      pp^.next := nil;
      pp^.tp := p;
      RecConstQue(p^.previous1, dep, wtf, queuestart);
      RecConstQue(p^.previous2, dep, wtf, queuestart);
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


procedure SimpQue(var queuestart:PBWp);
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

procedure PaintScene(wtf:TWtf);
var
  bwa:PBWp;
  queuestart: PBWp;
  localidstat: integer;
begin
  zafigachtexturu(16);
  new (queuestart);
  queuestart^.tp := wtf.ptrain[1]^.previous1;
  queuestart^.next := nil;
  RecConstQue(wtf.ptrain[1], 0, wtf, queuestart);
  SimpQue(queuestart);

  bwa := queuestart;
  localidstat := 0;
  while bwa <> nil do
  begin
    PaintTubing(bwa^.tp, localidstat, wtf);
    bwa := bwa^.next;
  end;

  if localidstat > 0 then
    PaintStation(localidstat, wtf);

  zafigachtexturu(17);
  bwa := queuestart;
  while bwa <> nil do
  begin
    PaintFloor(bwa^.tp, wtf);
    bwa := bwa^.next;
  end;

  zafigachtexturu(22);
  while (queuestart <> nil) do
  begin
    PaintRails(queuestart^.tp, wtf);
    bwa := queuestart;
    queuestart := queuestart ^.next;
    Dispose (bwa);
  end;
end;

procedure PaintCab;
var i:Integer;
begin
  {glColor3f(1, 1, 1);
  for i := 0 to nquads - 1 do
  begin
    zafigachtexturu(qua[i].tid);
    glBegin (GL_QUADS);
      glTexCoord2f (qua[i].a.y, qua[i].a.z);
      glVertex3f (realpoin[qua[i].a.x].x, realpoin[qua[i].a.x].y, realpoin[qua[i].a.x].z);
      glTexCoord2f (qua[i].b.y, qua[i].b.z);
      glVertex3f (realpoin[qua[i].b.x].x, realpoin[qua[i].b.x].y, realpoin[qua[i].b.x].z);
      glTexCoord2f (qua[i].c.y, qua[i].c.z);
      glVertex3f (realpoin[qua[i].c.x].x, realpoin[qua[i].c.x].y, realpoin[qua[i].c.x].z);
      glTexCoord2f (qua[i].d.y, qua[i].d.z);
      glVertex3f (realpoin[qua[i].d.x].x, realpoin[qua[i].d.x].y, realpoin[qua[i].d.x].z);
    glEnd;
  end;}
end;

procedure CalcRealPoints(var wtf:TWtf);
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

  //кабина
  {for i := 0 to npoin - 1 do   //??????? ????? ? ???? ?? ?????? ??????
  begin
    realpoin [i].x := x;
    realpoin [i].y := y;

    MovePoint(realpoin [i], kurs, Poin [i].x);
    MovePoint(realpoin [i], kurs + 90, Poin [i].y);
    realpoin [i].z := poin [i].z + z;
  end;  }
end;

procedure PaintGame(Width, Height: integer; DC:HDC; wtf:TWtf);
begin
  calcRealPoints(wtf);
  glViewPort (0, 0, Width, Height);
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glPushMatrix;

  //Поворот камеры, т.е. системы координат
  glRotatef (wtf.givecamalpha, -1, 0, 0);
  glRotatef (wtf.givecamkurs, 0, -1, 0);

  glRotatef (90, -1, 0, 0);
  glRotatef (90, 0, 0, 1);
  //glTranslatef(-realpoin[glaz].x, -realpoin[glaz].y, -realpoin[glaz].z);

  //Writeln(wtf.ptrain[0].next1.next1.cx);

  PaintSCB(wtf);
  PaintScene(wtf);

  //PaintTubing(wtf.ptrain[0]);

  PaintCab;


  glPopMatrix;
  SwapBuffers (DC);

end;

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

procedure init();
var i:integer;
begin
  TextureAmount := 0;
  while FileExists('media/' + IntToStr(TextureAmount) + '.bmp') do begin
    inc (TextureAmount);
  end;
  for i := 0 to TextureAmount - 1 do begin
    PrepareImage(i);
  end;
end;

end.
