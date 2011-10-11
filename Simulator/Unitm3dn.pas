{ЖИЗНЬ ПРЕКРАСНА!!!}

unit Unitm3dn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Qt, Math, ComCtrls, useful, dglOpenGL, OpenGL,
  MPlayer, Bomj, Buttons, Bass, StdCtrls, Gamer;


{
  }
type
  TMainForm = class(TForm)
    Vp: TPanel;
    Bp: TPanel;
    TiPhys: TTimer;
    TiPaint: TTimer;
    Vl: TLabel;
    Cl: TLabel;
    RL: TLabel;
    PL: TLabel;
    LK: TLabel;
    AOS: TLabel;
    RevL: TLabel;
    LimL: TLabel;
    LFlim: TLabel;
    ALS: TLabel;
    LabelStrelka: TLabel;
    LT: TLabel;
    LabelPause: TLabel;
    LabelI: TLabel;
    RP: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MPODZ: TMediaPlayer;
    Mp: TPanel;
    btnStart: TBitBtn;
    mmoKeys: TMemo;
    btnKeys: TButton;
    btnAutors: TButton;
    mmoAutors: TMemo;
    mmoLoadProg: TMemo;
    procedure TiPaintTimer(Sender: TObject);
    procedure TiPhysTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    //procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnStartClick(Sender: TObject);
    procedure btnKeysClick(Sender: TObject);
    procedure btnAutorsClick(Sender: TObject);
  private
    ismenu: Boolean;
    bbstarted:Boolean;
    nadoload: Boolean;
 {   
    wtf:TWtf;
    ueue:TShipLoader;
    blackbox:TBlackbox;
    MyKeys:TControlKeys;


    poin:array [0 .. 10000] of TRe3dc;
    realpoin: array [0 .. 10000] of TRe3dc;
    qua:array [0 .. 10000] of TBwquads;
    procedure mkphys;
    procedure mkgoodscb;}
    procedure Create_OpenGL;
    procedure Reset_OpenGL;
    procedure SetDCPixelFormat;
    //procedure DrawScene;
  {  procedure PrepareImage (bmap:integer);
    procedure DrawSCB;
    procedure DrawCab;
    function givef (i:integer; v:real):real;
    function givebrakef (i:integer; v:real):real;
    function givei (i:integer; v:real):real;
    function givei2 (i:integer; v:real):real;
    function bwgc (p:PTp):real;}
    procedure setSmotrelka;
{    procedure strelochka;
    procedure LoadCab;
    procedure CalcRealPoints;
    procedure PaintTubing (p:Ptp);
    procedure PaintFloor (p:Ptp);
    procedure PaintRels (p:Ptp);
    procedure MovePoint (var a:TRe3dc; kurs, len:real);
    procedure zafigachtexturu (i:integer);
    procedure RecConstQue (p:PTp; dep:integer);}
    //procedure DrawGame;
    procedure DrawMenu;
    procedure validateonmenu;
   { procedure SimpQue;
    function giveafter (pbw:PBWp; p:PTp):PBWp;}
    //procedure LoadGame;
   { procedure SetChannels;
    procedure Zvuchi;
    procedure Painstation (localidstat:integer);
  public      }
  end;

{var
  MainForm: TMainForm;}
var
  DC:HDC;
  hrc:HGLRC;
  Start_Open_GL:boolean;
implementation

{$R *.dfm}


procedure TMainForm.FormCreate(Sender: TObject);
var i:integer;
begin
  Left:=Screen.Width-Width;  Left:=Left div 2;
  Top:=Screen.Height-Height; Top:=Top div 2;
  Vp.Height := Height;
  ismenu := True;
  bbstarted := False;
  nadoload:=true;
  Create_OpenGL;

  // check the correct BASS was loaded
	if (HIWORD(BASS_GetVersion) <> BASSVERSION) then
	begin
		MessageBox(0,'An incorrect version of BASS.DLL was loaded', nil,MB_ICONERROR);
		Halt;
	end;
	if not BASS_Init(-1, 44100, 0, Handle, nil) then
	begin
		BASS_Free();
		MessageDlg('Cannot start device (audio)!', mtError, [mbOk], 0);
		Halt;
	end;


  Gamer.start();
end;

{procedure TMainForm.mkphys;
var zhvost, zgolova, F, f2:real;
    i:integer;
begin
  timeofplaying := timeofplaying + k;

  Vl.Caption := 'Скорость:' + IntToStr (round (abs (v) * 3.6)) + ' км/ч';
  CL.Caption := 'Проехано:' + IntToStr (itx) + ' м';
  LT.Caption := 'Время игры:' + wtf.TimeToStr(timeofplaying);
  Pl.Caption := 'Давление:' + FloatToStr (round (prs * 100) / 100) + ' атм.';
  LK.Caption := 'Пневмо:' + IntToStr (round (kran * 100)) + '%';
  LimL.Caption := 'Ограничение:' + IntToStr (round (climit * 3.6)) + ' км/ч';
  if wtf.gntrscbid >= 0 then
    LFlim.Caption := 'Будущ огранич:' + IntToStr (round (wtf.givelimbycond [wtf.scb [wtf.gntrscbid].condition] * 3.6)) + ' км/ч'
  else
    LFlim.Caption := 'Далее нет светофоров';
  LabelI.Caption := 'Ток через все дв.:' + IntToStr (round (givei2 (polzunok, v))) + ' А';
  label2.Caption := 'Номер схемы:' + IntToStr (polzunok);

  if polzunok > 0 then
  begin
    label3.Caption := 'Сопротивление:' + FloatToStr (round (hz [polzunok - 1].r * 100) / 100);
    if hz [polzunok - 1].ispp then
      label4.Caption := 'Поле:' + IntToStr (round (hz [polzunok - 1].kbeta * 400)) + '% п/п'
    else
      label4.Caption := 'Поле:' + IntToStr (round (hz [polzunok - 1].kbeta * 100)) + '%';
  end;
  if polzunok < 0 then
  begin
    label3.Caption := 'Сопротивление:' + FloatToStr (round (brakehz [-polzunok - 1].r * 100) / 100);
    label4.Caption := 'Поле:' + IntToStr (round (brakehz [-polzunok - 1].kbeta * 100)) + '%';
  end;
  if polzunok = 0 then
  begin
    label3.Caption := 'Собери';
    label4.Caption := 'схему';
  end;

  if revers = 0 then
    revl.Caption := 'нейтраль.';
  if revers * wtf.cabfactor = 1 then
    revl.Caption := 'вперёд.';
  if revers * wtf.cabfactor = -1 then
    revl.Caption := 'назад.';
  revl.Caption := 'Реверс:' + revl.Caption;
  if rwaiting >= 0 then
    revl.Caption := revl.Caption + ' пркл';

  if rup = 0 then
    Rl.Caption := '0';
  if rup = 1 then
    Rl.Caption := 'Ход 1';
  if rup = 2 then
    Rl.Caption := 'Ход 2';
  if rup = 3 then
    Rl.Caption := 'Ход 3';
  if rup = -1 then
    Rl.Caption := 'Тормоз 1';
  if rup = -2 then
    Rl.Caption := 'Тормоз 1А';
  if rup = -3 then
    Rl.Caption := 'Тормоз 2';

  if wtf.gntrscbid <> oldhz then           //Детект проезда светофора, чтоб его
  begin
    climit := wtf.givelimbycond [wtf.scb [oldhz].condition];
    oldhz := wtf.gntrscbid;
  end;

  if v * revers < -10*dv then             //АОС
  begin
    kran := 1;
    blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Сработка АОС');
    AOS.Visible := true;
  end
  else
    AOS.Visible := false;

  if givei (polzunok, v) > IMAX then      //РП
  begin
    isrp := true;
    blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Сработка РП');
    RP.Visible := true;
  end;
  if revers = 0 then
  begin
    if isrp then
      blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Возврат РП');
    isrp := false;
    RP.Visible := false;
  end;

  if abs (v) > climit then                   //АЛС
  begin
    kran := 1;
    blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Сработка АЛС-АРС');
    ALS.Visible := true;
    rup := 0;
  end
  else
    ALS.Visible := false;

  if kran <= 0.25 then
    prs := prs - (0.25 - kran) * kv * prs;             //Спуск
  if kran >= (0.45) then
    prs := prs - (0.45 - kran) * kv * (pmax - prs);    //Накачка

  if mykeys.ipr then                             //Вращение крана
    kran := kran + kmv * k;
  if mykeys.dpr then
    kran := kran - kmv * k;
  if kran > 1 then kran := 1;
  if kran < 0 then kran := 0;


// Передвижение поезда
  wtf.tr := wtf.tr + v * k;
  while wtf.tr > 1 do
  begin
    wtf.tr := wtf.tr - 1;
    if wtf.isleft then
      for i := 0 to wtf.nwag do
        wtf.Ptrain [i] := wtf.ptrain [i]^.next1
    else
      for i := 0 to wtf.nwag do
        wtf.Ptrain [i] := wtf.ptrain [i]^.next2;
    inc (itx);

    if (((wtf.Ptrain [0]^.next1 = nil) and wtf.isleft) or
       ((wtf.Ptrain [0]^.next2 = nil) and not wtf.isleft)) then
    begin
      wtf.die('Выезд за пределы тоннеля');
      close;
    end;
  end;
  while wtf.tr < 0 do
  begin
    wtf.tr := wtf.tr + 1;
    if wtf.isleft then
      for i := 0 to wtf.nwag do
        wtf.Ptrain [i] := wtf.ptrain [i]^.previous1
    else
      for i := 0 to wtf.nwag do
        wtf.Ptrain [i] := wtf.ptrain [i]^.previous2;
    dec (itx);

    if (((wtf.Ptrain [wtf.nwag]^.previous1 = nil) and wtf.isleft) or
       ((wtf.Ptrain [wtf.nwag]^.previous2 = nil) and not wtf.isleft)) then
    begin
      wtf.die('Выезд за пределы тоннеля');
      close;
    end;
  end;

// Математическая физика поезда

  if waiting >= 0 then
    waiting := waiting - k;
  if polzunwait >= 0 then
    polzunwait := polzunwait - k;

  if (rup = 0) or (rup = 1) then                //Поведение ползунка в зависимости от РУП
    polzunok := rup;
  if (rup = 2) and (polzunok > maxpolz) then
    polzunok := maxpolz;
  if (((rup = 2) and (polzunok < maxpolz)) or ((rup = 3) and (polzunok < maxpolz2))) and (polzunwait < 0) then
  begin
    f2 := givef (polzunok, v);
    if (f2 / mwag < amax) then
    begin
      polzunwait := 0.3;
      inc (polzunok);
    end;
  end;

  if (revers <> 0) and (rwaiting <= 0) then         //Передвижение ручки управления поездом
  begin
    if Mykeys.up then
      if (rup < 3) and (waiting <= 0) then
      begin
        inc (rup);
        blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Перевод РУП в ' + IntToStr(rup));
        waiting := 0.2;
      end;
    if Mykeys.down then
      if (rup > -3) and (waiting <= 0) then
      begin
        dec (rup);
        blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Перевод РУП в ' + IntToStr(rup));
        waiting := 0.2;
        if rup = -1 then
          polzunok := rup;
        if ((rup = -2) and (polzunok > -bshamount)) then
          dec (polzunok);
      end;
  end;

  if ((rup = -3) and (polzunok > -bshamount) and (givebrakef(-polzunok, v) / mwag < amax1)) and (polzunwait < 0) then
  begin
    dec (polzunok);
    polzunwait := 0.3;
  end;

  if (rup = -3) then
    prs := max (prs, 0.5 - v/7);

  if isrp then
    polzunok := 0;

  if rwaiting >= 0 then
  begin
    rwaiting := rwaiting - k;
    if rwaiting < 0 then
      revers := nrevers;
  end;


  if (rwaiting <= 0) and (rup = 0) then            //Передвижение реверса
  begin
    if ((Mykeys.fw and (wtf.cabfactor = 1)) or (Mykeys.bw and (wtf.cabfactor = -1))) and (revers < 1)  then
    begin
      inc (nrevers);
      blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Перевод реверса в ' + IntToStr(nrevers));
      rwaiting := 1;
    end;
    if ((Mykeys.fw and (wtf.cabfactor = -1)) or (Mykeys.bw and (wtf.cabfactor = 1))) and (revers > -1) then
    begin
      dec (nrevers);
      blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Перевод реверса в ' + IntToStr(nrevers));
      rwaiting := 1;
    end;
  end;

  //Собственно, та самая физическа физика.
  //Сила вперёд, без k
  //Все вагоны одинаковы - рассчёт для среднестатистического вагона

  F := -1 * v * betamu * mwag;  //Трение в осях

  if polzunok > 0 then               //Разгон двигателем
    F := F + givef (polzunok - 1, v) * revers;

  if polzunok < 0 then               //Динамический тормоз
    F := F - givebrakef (-polzunok - 1, v) * revers;

  //Сила тяжести
  F := f + g * mwag * (wtf.givebz (wtf.ptrain [wtf.nwag]) - wtf.givebz (wtf.ptrain [0])) / (wtf.nwag * wtf.wlength);

  //Колёса не могут вращаться в обратную сторону - аксиома
  //Действие пневмотормоза
  if prs > pmin then
  begin
    if abs (v) > dv then
      if v > 0 then
        F := F - amax2 * mwag * (prs - pmin) / (pmax - pmin)
      else
        F := F + amax2 * mwag * (prs - pmin) / (pmax - pmin)
    else
      If F > 0 then
        F := Max (0, F - amax2 * mwag * (prs - pmin) / (pmax - pmin))
      else
        F := Min (0, F + amax2 * mwag * (prs - pmin) / (pmax - pmin));
  end;

  //Сила не может быть больше, чем сила трения о рельсы
  if F > mwag * g * mu then
    F := mwag * g * mu;
  if F < -mwag * g * mu then
    F := -mwag * g * mu;

  //После того, как мы учли все факторы, подействуем этой силой.

  if (abs (v) > abs (F / mwag * k)) then   //v > a*dt - всё отлично, не налажаем
    v := v + F / mwag * k
  else
    if v * F >= 0 then     //Сонаправлены
      v := v + F / mwag * k
    else                  //Противонаправлены
      v := 0;

  if Mykeys.mr then                                             //Поворот камеры
    wtf.camdopkurs := wtf.camdopkurs - k * valphacam;
  if Mykeys.ml then
    wtf.camdopkurs := wtf.camdopkurs + k * valphacam;
  if Mykeys.mu then
    wtf.camdopalpha := wtf.camdopalpha + k * valphacam;
  if Mykeys.md then
    wtf.camdopalpha := wtf.camdopalpha - k * valphacam;

  //Всякие звуки
  Zvuchi;
end;}

procedure TMainForm.TiPaintTimer(Sender: TObject);
begin
  if ismenu then
  begin
    DrawMenu;   // draw correctly
    if Vp.Height > 150 then
      Vp.Height := round (Vp.Height - (Vp.Height - 150) / 10);
    DrawMenu;
  end
  else
    Gamer.DrawGame(Vp.ClientWidth,Vp.ClientHeight, DC);
end;

procedure TMainForm.TiPhysTimer(Sender: TObject);
begin
  if not ismenu then
    //Mkphys;
end;

{procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i:integer;
const hereTruthIs=true;
begin
  case Key of

    Key_W:  mykeys.fw := hereTruthIs;
    Key_S:  mykeys.bw := hereTruthIs;
    Key_D:  mykeys.up := hereTruthIs;
    Key_A:  mykeys.down := hereTruthIs;

    Key_K: begin mykeys.ipr := hereTruthIs; blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Усиление тормозов начато'); end;
    Key_L: begin mykeys.dpr := hereTruthIs; blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Ослабление тормозов начато'); end;

    Key_O: MPODZ.Play;

    37: mykeys.ml := hereTruthIs;  //клоны
    38: mykeys.mu := hereTruthIs;  //клоны
    39: mykeys.mr := hereTruthIs;  //клоны
    40: mykeys.md := hereTruthIs;  //клоны

    Key_M:
          if wtf.isgoodtr then
          begin
            wtf.isleft := not wtf.isleft;
            strelochka;
            for i := 0 to wtf.nscb do
              mkgoodscb;
            oldhz := wtf.gnscbid(wtf.ptrain [0], wtf.isleft);    //Исправить!!!
          end;
    Key_B: if delit >  3 then delit := delit - 5;
    Key_N: if delit < 10 then delit := delit + 5;
    186:
          begin
            kran := 1;
            rup := 0;
            blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Экстренное торможение');
          end;
    Key_C:
          begin
            wtf.cabfactor := wtf.cabfactor * -1;
            strelochka();
            oldhz := wtf.gntrscbid;
            blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Смена кабины');
          end;
    Key_P: if not ismenu then         //Пауза в меню не пашет
    begin
      LabelPause.Visible := TiPhys.Enabled;
      TiPhys.Enabled := not TiPhys.Enabled;
    end;
    27:
    begin
      ismenu := not ismenu;
      validateonmenu;
    end;
  end;
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const hereTruthIs=false;
begin
  case Key of
    Key_W: mykeys.fw := hereTruthIs;
    Key_S: mykeys.bw := hereTruthIs;
    Key_D: mykeys.up := hereTruthIs;
    Key_A: mykeys.down := hereTruthIs;

    Key_K: begin mykeys.ipr := hereTruthIs; blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Усиление тормозов закончено'); end;
    Key_L: begin mykeys.dpr := hereTruthIs; blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Ослабление тормозов закончено'); end;

    37: mykeys.ml := hereTruthIs;  //клоны
    38: mykeys.mu := hereTruthIs;  //клоны
    39: mykeys.mr := hereTruthIs;  //клоны
    40: mykeys.md := hereTruthIs;  //клоны
  end;
end;}



procedure TMainForm.Create_OpenGL;
begin
  DC := GetDC (VP.Handle);
  SetDCPixelFormat;
  HRC := CreateRenderingContext (Dc, [opDoubleBuffered], 32, 16, 0, 0, 0, 0);
  wglMakeCurrent (DC, hrc);

  setSmotrelka;
  glEnable (GL_DEPTH_TEST);
  glEnable (GL_TEXTURE_2D);
  glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexEnvi (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

  glEnable (GL_ALPHA_TEST);
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

  Start_Open_GL := true;
end;

procedure TMainForm.Reset_OpenGL;
begin
  if not Start_Open_GL then exit;
  wglMakeCurrent (0, 0);
  DestroyRenderingContext (hRC);
  ReleaseDC (Vp.Handle, DC);
  DeleteDC (DC);
end;

procedure TMainForm.SetDCPixelFormat;
var nPixelFormat:integer;
    pfd:TPixelFormatDescriptor;
begin
  FillChar (pfd, SizeOf (pfd), 0);
  pfd.dwFlags := PFD_DRAW_TO_WINDOW or
                 PFD_SUPPORT_OPENGL or
                 PFD_DOUBLEBUFFER;
  nPixelFormat := ChoosePixelFormat (DC, @pfd);
  SetPixelFormat (DC, nPixelFormat, @pfd);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Reset_OpenGL;
	BASS_Free;
	BASS_Stop;
end;



procedure TMainForm.FormResize(Sender: TObject);
begin
  setSmotrelka;
end;

{function TMainForm.givef(i: integer; v: real): real;
begin
  result := sqr (U / (hz [i].r + hz [i].kbeta * beta0 * abs (v)) ) * hz[i].kbeta * beta0; // I^2 * (R / v)
end;

function TMainForm.givei(i: integer; v: real): real;
begin
  if (i > 0) then
    if hz [i-1].ispp then
      result := U / (hz [i-1].r + hz [i-1].kbeta * beta0 * abs (v)) / 2
    else
      result := U / (hz [i-1].r + hz [i-1].kbeta * beta0 * abs (v))
  else
    if (i < 0) and (Abs (v) > brakehz [-i-1].vmin)then
      result := (abs (v) - brakehz [-i-1].vmin) * brakeconst * brakehz [-i-1].kbeta / brakehz [-i-1].R / 2 //U / R, ispp
    else
      result := 0;
end;

}
procedure TMainForm.setSmotrelka;
begin
  glViewPort (0, 0, VP.ClientWidth, VP.ClientHeight);
  glClearColor (0, 0, 0, 1.0);
  glMatrixMode (GL_Projection);
  glLoadIdentity;
  if ismenu then
    gluPerspective (120, VP.ClientWidth/VP.ClientHeight, 0.1, 3)
  else
    gluPerspective (70, VP.ClientWidth/VP.ClientHeight, 0.1, 3000);
  glMatrixMode (GL_MODELVIEW);
  glLoadIdentity;
end;

{procedure TMainForm.strelochka;
begin
  if (wtf.isleft and (wtf.cabfactor = 1)) or (not wtf.isleft and (wtf.cabfactor = -1)) then
    LabelStrelka.Caption := '<--'
  else
    LabelStrelka.Caption := '-->';
end; }

{




procedure TMainForm.PaintTubing(p: Ptp);
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
        glVertex3f(p^.corners [i].x, p^.corners [i].y, p^.corners [i].z);
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



}
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {if bbstarted then
  begin
    blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Игра завершена');
    blackbox.Lesha;
  end;}
end;

{procedure TMainForm.DrawGame;
begin
  calcRealPoints;
  glViewPort (0, 0, VP.ClientWidth, Vp.ClientHeight);
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glPushMatrix;

  //Поворот камеры, т.е. системы координат
  glRotatef (wtf.givecamalpha, -1, 0, 0);
  glRotatef (wtf.givecamkurs, 0, -1, 0);

  glRotatef (90, -1, 0, 0);
  glRotatef (90, 0, 0, 1);
  glTranslatef(-realpoin [glaz].x, -realpoin [glaz].y, -realpoin [glaz].z);

  DrawSCB;
  DrawScene;
  DrawCab;

  glPopMatrix;
  SwapBuffers (DC);
end;}

procedure TMainForm.DrawMenu;
begin
  setSmotrelka;
  glViewPort (0, 0, VP.ClientWidth, Vp.ClientHeight);
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  //zafigachtexturu(21);
  glBegin(GL_QUADS);
    glTexCoord2f (0, 0);
    glVertex3f(-0.8, -0.2, -0.15);
    glTexCoord2f (0, 1);
    glVertex3f(-0.8, 0.2, -0.15);
    glTexCoord2f (1, 1);
    glVertex3f(0.8, 0.2, -0.15);
    glTexCoord2f (1, 0);
    glVertex3f(0.8, -0.2, -0.15);
  glEnd;
  SwapBuffers (DC);
end;

procedure TMainForm.validateonmenu;
begin
  Bp.Visible := not ismenu;
  Mp.Visible := ismenu;
  if ismenu then
  begin
    Vp.Align := alTop;
    Vp.Height := 150;
    setSmotrelka;
  end
  else
  begin
    btnStart.Caption := 'Продолжить игру';
    Vp.Align := alClient;
    setSmotrelka;
  end;
end;

procedure TMainForm.btnStartClick(Sender: TObject);
begin
  ismenu := false;
  validateonmenu;
  if nadoload then begin
    mmoLoadProg.Height := Vp.ClientHeight - 2 * mmoLoadProg.Top;
    mmoLoadProg.Width := Vp.ClientWidth - 2 * mmoLoadProg.Left;
    Gamer.LoadGame(mmoLoadProg);
    mmoLoadProg.Visible := false;
    nadoLoad := false;
    bbstarted := true;
  end;
end;

procedure TMainForm.btnKeysClick(Sender: TObject);
begin
  mmoKeys.Visible := true;
  mmoAutors.Visible := False;
end;

procedure TMainForm.btnAutorsClick(Sender: TObject);
begin
  mmoKeys.Visible := false;
  mmoAutors.Visible := true;
end;

{



function TMainForm.givei2(i: integer; v: real): real;
begin
  if (i > 0) then
    result := U / (hz [i-1].r + hz [i-1].kbeta * beta0 * abs (v))
  else
    if (i < 0) and (Abs (v) > brakehz [-i-1].vmin)then
      result := (abs (v) - brakehz [-i-1].vmin) * brakeconst * brakehz [-i-1].kbeta / brakehz [-i-1].R //U / R
    else
      result := 0;
end;}

{

procedure TMainForm.Zvuchi;
begin
  {if (abs (v) > 1) and ((itx mod 25 = 10) or (itx mod 25 = 14)) and (wtf.tr < 0.5) then
    bass_channelplay(chan2, false);
  if ((itx mod 25 = 12) or (itx mod 25 = 17)) and (wtf.tr > 0.5) or (Abs (v) <= 1) then
    bass_channelstop(chan2);   }
{end;


function TMainForm.givebrakef(i: integer; v: real): real;
begin
  if Abs (v) > brakehz [i].vmin then
    result := sqr ((abs (v) - brakehz [i].vmin) * brakeconst * brakehz [i].kbeta) / brakehz [i].R / Abs (v) //U^2 / R / v
  else
    Result := 0;
end;}

end.

//function WorldToNothing (world:Tworld):TNothing;
