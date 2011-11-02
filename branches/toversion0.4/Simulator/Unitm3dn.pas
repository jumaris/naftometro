{

ЖИЗНЬ ПРЕКРАСНА!!!
Метро - это жизнь.
Значит, NaftoMetro - попытка смоделировать прекрасное! 

type TOurSmallVirtualWorld = class(TWorld);

function NothingToWorld(nothing:TNothing):TWorld;
var
  ourSmallVirtualWorld: TOurSmallVirtualWorld;
begin
  ourSmallVirtualWorld := TOurSmallVirtualWorld.create();
  result := ourSmallVirtualWorld;
end;

}

unit Unitm3dn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Math, ComCtrls, useful, dglOpenGL, OpenGL,
  MPlayer, Bomj, Buttons, Bass, StdCtrls,  Gamer, Painter;


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
begin
  Left:=Screen.Width-Width;  Left:=Left div 2;
  Top:=Screen.Height-Height; Top:=Top div 2;
  //Vp.Height := Height;
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
    Gamer.Mkphys;
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
  halt;
  if bbstarted then
  begin
    Gamer.Stop();
  end;
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
