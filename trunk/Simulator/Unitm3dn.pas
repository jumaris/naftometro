{ЖИЗНЬ ПРЕКРАСНА!!!}

unit Unitm3dn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Math, ComCtrls, useful, dglOpenGL, OpenGL,
  MPlayer, Bomj, Buttons, Bass, MyKeyConsts;

const mu = 0.25;                  //трение об рельсы
      betamu = 0.003;             //Трение в осях
      g = 9.8;                      //сила тяжести
      mwag = 32500;                 //масса вагона
      amax = 1.2;                   //Максимальное ускорение, создаваемое движком
      amax1 = 1.2;                  // -//- в режиме торможения
      amax2 = 3;                    // -//- пневмотормозом
      pmax = 1;                     //
      pmin = 0.15;                  //
      kv = 0.05; //Velocity of kran pressuring
      kmv = 1; //Velocity of kran mooving
      tubr = 1;
      tubg = 0.8;
      tubb = 0.6;
      beta0 = 2;
      rmax = 5;
      r0 = 0.01;
      IMAX = 350;
      brakeconst = 100;
      bshamount = 17;
      dv = 0.00001; //Физически бесконечно малая скорость

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
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnStartClick(Sender: TObject);
    procedure btnKeysClick(Sender: TObject);
    procedure btnAutorsClick(Sender: TObject);
  private
    hz:array [0 .. 100] of THz;
    brakehz:array [0 .. bshamount - 1] of TBrakeHz;
    mytextures:array [0 .. 1048575, 0 .. 30] of Byte;
    texturesizes:array [0 .. 30] of TMy3dc;
    rup, polzunok, revers, nrevers, oldhz, itx, maxpolz, maxpolz2:integer;
    isrp, ismenu, nadoload, bbstarted:boolean;
    Textureamount, nquads, npoin, glaz, localidstat:integer;
    climit, v, prs, k, waiting, kran, rwaiting, polzunwait, delit, timeofplaying:real;
    wtf:TWtf;
    ueue:TShipLoader;
    blackbox:TBlackbox;
    MyKeys:TControlKeys;
    bwfirst:PBWp;
    queuestart:PBWp;
    poin:array [0 .. 10000] of TRe3dc;
    realpoin: array [0 .. 10000] of TRe3dc;
    qua:array [0 .. 10000] of TBwquads;
    procedure mkphys;
    procedure mkgoodscb;
    procedure Create_OpenGL;
    procedure Reset_OpenGL;
    procedure SetDCPixelFormat;
    procedure DrawScene;
    procedure PrepareImage (bmap:integer);
    procedure DrawSCB;
    procedure DrawCab;
    function givef (i:integer; v:real):real;
    function givebrakef (i:integer; v:real):real;
    function givei (i:integer; v:real):real;
    function givei2 (i:integer; v:real):real;
    function bwgc (p:PTp):real;
    procedure setSmotrelka;
    procedure strelochka;
    procedure LoadCab;
    procedure CalcRealPoints;
    procedure PaintTubing (p:Ptp);
    procedure PaintFloor (p:Ptp);
    procedure PaintRels (p:Ptp);
    procedure MovePoint (var a:TRe3dc; kurs, len:real);
    procedure zafigachtexturu (i:integer);
    procedure RecConstQue (p:PTp; dep:integer);
    procedure DrawGame;
    procedure DrawMenu;
    procedure validateonmenu;
    procedure SimpQue;
    function giveafter (pbw:PBWp; p:PTp):PBWp;
    procedure LoadGame;
    procedure SetChannels;
    procedure Zvuchi;
    procedure Painstation (localidstat:integer);
  public
  end;

var
  MainForm: TMainForm;
  DC:HDC;
  hrc:HGLRC;
  Start_Open_GL:boolean;
  Chan1: dword = 0;  //фоновый шум
  Chan2: dword = 1;  //Стук колёс
  Chan3: dword = 2;

implementation

{$R *.dfm}


procedure TMainForm.FormCreate(Sender: TObject);
var i:integer;
begin
  Left:=Screen.Width-Width;  Left:=Left div 2;
  Top:=Screen.Height-Height; Top:=Top div 2;

  Create_OpenGL;
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
  waiting := 0;
  isrp := false;
  ismenu := True;
  bbstarted := False;
  Vp.Height := MainForm.Height;

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


//????? ?????-?? ????????

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
end;

procedure TMainForm.mkphys;
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
      polzunwait := 0.2;
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
    polzunwait := 0.2;
  end;

  if (rup = -3) then
    prs := max (prs, 0.5 - abs (v/7));

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
    wtf.camdopkurs := wtf.camdopkurs - k * wtf.valphacam;
  if Mykeys.ml then
    wtf.camdopkurs := wtf.camdopkurs + k * wtf.valphacam;
  if Mykeys.mu then
    wtf.camdopalpha := wtf.camdopalpha + k * wtf.valphacam;
  if Mykeys.md then
    wtf.camdopalpha := wtf.camdopalpha - k * wtf.valphacam;

  //Всякие звуки
  Zvuchi;
end;

procedure TMainForm.TiPaintTimer(Sender: TObject);
begin
  if ismenu then
  begin
    DrawMenu;
    if Vp.Height > 150 then
      Vp.Height := round (Vp.Height - (Vp.Height - 150) / 10);
    DrawMenu;
  end
  else
    DrawGame;
end;

procedure TMainForm.TiPhysTimer(Sender: TObject);
begin
  if not ismenu then
    Mkphys;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
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
            oldhz := wtf.gntrscbid; //Работает?
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
end;

procedure TMainForm.mkgoodscb;
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

procedure TMainForm.DrawScene;
var bwa:PBWp;
begin
  zafigachtexturu(16);
  new (queuestart);
  queuestart^.next := nil;
  if wtf.cabfactor = 1 then
  begin
    queuestart^.tp := wtf.ptrain [1]^.previous1;
    RecConstQue(wtf.ptrain [1], 0);
  end
  else
  begin
    queuestart^.tp := wtf.ptrain [wtf.nwag - 1]^.next1;
    RecConstQue(wtf.ptrain [wtf.nwag - 1], 0);
  end;
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

procedure TMainForm.PrepareImage(bmap: integer);
var
Bitmap:TBitmap;
Data:array of Byte;
BMInfo:TBitmapInfo;
Temp:Byte;
MemDC:HDC;
I, ImageSize:longint;
bitwid, bithei:Integer;
S:string;
begin
  s:= 'media/' + IntToStr (bmap) + '.bmp';
  Bitmap := Tbitmap.Create;
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

procedure TMainForm.DrawSCB;
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

procedure TMainForm.FormResize(Sender: TObject);
begin
  setSmotrelka;
end;

function TMainForm.givef(i: integer; v: real): real;
begin
  result := sqr (wtf.U / (hz [i].r + hz [i].kbeta * beta0 * abs (v)) ) * hz[i].kbeta * beta0; // I^2 * (R / v)
end;

function TMainForm.givei(i: integer; v: real): real;
begin
  if (i > 0) then
    if hz [i-1].ispp then
      result := wtf.U / (hz [i-1].r + hz [i-1].kbeta * beta0 * abs (v)) / 2
    else
      result := wtf.U / (hz [i-1].r + hz [i-1].kbeta * beta0 * abs (v))
  else
    if (i < 0) and (Abs (v) > brakehz [-i-1].vmin)then
      result := (abs (v) - brakehz [-i-1].vmin) * brakeconst * brakehz [-i-1].kbeta / brakehz [-i-1].R / 2 //U / R, ispp
    else
      result := 0;
end;

function TMainForm.bwgc(p: PTp): real;
begin
  if (p^.idstat <> 0) then
    result := 1 / (1.5 + sqr (Min(wtf.givelto(p), p^.ltostat) / delit))
  else
    result := 1 / (1.5 + sqr (wtf.givelto(p) / delit));
end;

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

procedure TMainForm.strelochka;
begin
  if (wtf.isleft and (wtf.cabfactor = 1)) or (not wtf.isleft and (wtf.cabfactor = -1)) then
    LabelStrelka.Caption := '<--'
  else
    LabelStrelka.Caption := '-->';
end;

procedure TMainForm.DrawCab;
var i:Integer;
begin
  glColor3f(1, 1, 1);
  for i := 0 to nquads - 1 do
  begin
    zafigachtexturu(qua [i].tid);
    glBegin (GL_QUADS);
      glTexCoord2f (qua[i].a.y, qua[i].a.z);
      glVertex3f (realpoin [qua [i].a.x].x, realpoin [qua [i].a.x].y, realpoin [qua [i].a.x].z);
      glTexCoord2f (qua[i].b.y, qua[i].b.z);
      glVertex3f (realpoin [qua [i].b.x].x, realpoin [qua [i].b.x].y, realpoin [qua [i].b.x].z);
      glTexCoord2f (qua[i].c.y, qua[i].c.z);
      glVertex3f (realpoin [qua [i].c.x].x, realpoin [qua [i].c.x].y, realpoin [qua [i].c.x].z);
      glTexCoord2f (qua[i].d.y, qua[i].d.z);
      glVertex3f (realpoin [qua [i].d.x].x, realpoin [qua [i].d.x].y, realpoin [qua [i].d.x].z);
    glEnd;
  end;
end;

procedure TMainForm.CalcRealPoints;
var i:integer;
    x, y, kurs, angle, z:Real;
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
  angle := (wtf.givecamalpha - wtf.camdopalpha) / 180 * pi;
  for i := 0 to npoin - 1 do
  begin
    realpoin [i].x := x;
    realpoin [i].y := y;

    MovePoint(realpoin [i], kurs, Poin [i].x * cos (angle) - poin [i].z * sin (angle));
    MovePoint(realpoin [i], kurs + 90, Poin [i].y);
    realpoin [i].z := poin [i].z * cos (angle) + z + poin [i].x * sin (angle);
  end;
end;

procedure TMainForm.MovePoint(var a: TRe3dc; kurs, len: real);
begin
  a.x := a.x + len * cos (kurs/180*pi);
  a.y := a.y + len * sin (kurs/180*pi);
end;

procedure TMainForm.LoadCab;
var i:integer;
begin
  ueue := TShipLoader.lego ('cab.txt');
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

  ueue.Lesha;
end;

procedure TMainForm.PaintTubing(p: Ptp);
var i:integer;
    p2:PTp;
    c:Real;
begin
  if (p = nil) then Exit;
  p2 := p^.next1;
  if (p2 = nil) then exit;
  if (p2^.idstat <> 0) or (p^.idstat <> 0) then
    localidstat := max (p2^.idstat, p^.idstat);
  if ((p2^.idstat <> 0) and (p2^.ltostat = 0)) or ((p^.idstat <> 0) and (p^.ltostat = 0)) then
    Exit;

  c := bwgc (p);
  glColor3f(C * tubr, c * tubg, c * tubb);
  if ((p2^.together = p2) and (p^.together = p)) or
  ((p^.isright) and (p^.together <> p)) or
  ((p2^.isright) and (p2^.together <> p2)) or
  (p^.next1 <> p^.next2) then
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
  if ((p2^.together = p2) and (p^.together = p)) or
  ((not p^.isright) and (p^.together <> p)) or
  ((not p2^.isright) and (p2^.together <> p2)) or
  (p^.next1 <> p^.next2) then
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

procedure TMainForm.zafigachtexturu(i: integer);
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

procedure TMainForm.RecConstQue(p:PTp; dep:integer);
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
    while (dep < wtf.maxdep) and (p <> nil) and (p^.next1 = p^.next2) do
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
    if hrue <> nil then              //Постановка на прорисовку соседнего тоннеля
      RecConstQue(hrue, togdadep);   //в камере съездов (перед расставанием тоннелей)
    if  (dep < wtf.maxdep) and (p <> nil) and (p^.next1 <> nil) and (p^.next2 <> nil) then  //На развилке - по левому и правому пути
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
    while (dep < wtf.maxdep) and (p <> nil) and (p^.previous1 = p^.previous2) do
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
    if  (dep < wtf.maxdep) and (p <> nil) and (p^.previous1 <> nil) and (p^.previous2 <> nil) then
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

procedure TMainForm.PaintFloor(p: Ptp);
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

  if ((p^.idstat <> 0) and (p^.ltostat = 0))or (p2 = nil) or ((p2^.idstat <> 0) and (p^.ltostat = 0))then Exit;// Собственно пол не нужен

  if (p2^.together <> p2) and (p^.together = p) and (p^.next1 = p^.next2) and (not p2^.isright) then
  begin
    p3 := p2^.together^.previous1;

    for i := 0 to numboc div 2 - 1 do  //Стенка в камере съездов
    begin
      glBegin(GL_QUADS);
        glTexCoord2f (0, 0);
        glVertex3f(p^.corners [i].x, p^.corners [i].y, p^.corners [i].z);
        glTexCoord2f (0, 1);
        glVertex3f(p^.corners [i + 1].x, p^.corners [i + 1].y, p^.corners [i + 1].z);
        glTexCoord2f (1, 1);
        glVertex3f(p3^.corners [numboc - i - 2].x, p3^.corners [numboc - i - 2].y, p3^.corners [numboc - i - 2].z);
        glTexCoord2f (1, 0);
        glVertex3f(p3^.corners [numboc - i - 1].x, p3^.corners [numboc - i - 1].y, p3^.corners [numboc - i - 1].z);
      glEnd;
    end;

    glBegin(GL_QUADS);            //Неправильная щель
      glTexCoord2f (0, 0);
      glVertex3f(p^.corners [numboc - 1].x, p^.corners [numboc - 1].y, p^.corners [numboc - 1].z);
      glTexCoord2f (1, 0);
      glVertex3f(p^.corners [0].x, p^.corners [0].y, p^.corners [0].z);
      glTexCoord2f (1, 1);
      glVertex3f(p3^.corners [numboc - 1].x, p3^.corners [numboc - 1].y, p3^.corners [numboc - 1].z);
      glTexCoord2f (0, 1);
      glVertex3f(p3^.corners [0].x, p3^.corners [0].y, p3^.corners [0].z);
    glEnd;
  end;

  if (p^.together <> p) and (p2^.together = p2) and (p2^.previous1 = p2^.previous2) and (not p^.isright) then
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
     (not p2^.isright and (p2^.together <> p2)) or
     (not p2^.isright and (p^.next1 <> p2)) or
     (not p^.isright and (p <> p2^.previous1)) then
  begin
    glBegin(GL_QUADS);
      glTexCoord2f (0, 1);
      glVertex3f(p2^.together^.corners [0].x, p2^.together^.corners [0].y, p2^.together^.corners [0].z);
      glTexCoord2f (1, 1);
      glVertex3f(p2^.together^.Previous1^.corners [0].x, p2^.together^.Previous1^.corners [0].y, p2^.together^.Previous1^.corners [0].z);
      glTexCoord2f (1, 0);
      glVertex3f(p^.corners [numboc - 1].x, p^.corners [numboc - 1].y, p^.corners [numboc - 1].z);
      glTexCoord2f (0, 0);
      glVertex3f(p2^.corners [numboc - 1].x, p2^.corners [numboc - 1].y, p2^.corners [numboc - 1].z);
    glEnd;
    glBegin(GL_QUADS);
      glTexCoord2f (0, 0);
      glVertex3f(p^.corners [numboc div 2].x, p^.corners [numboc div 2].y, p^.corners [numboc div 2].z);
      glTexCoord2f (0, 1);
      glVertex3f(p2^.together^.Previous1^.corners [numboc div 2].x, p2^.together^.Previous1^.corners [numboc div 2].y, p2^.together^.Previous1^.corners [numboc div 2].z);
      glTexCoord2f (1, 1);
      glVertex3f(p2^.together^.corners [numboc div 2].x, p2^.together^.corners [numboc div 2].y, p2^.together^.corners [numboc div 2].z);
      glTexCoord2f (1, 0);
      glVertex3f(p2^.corners [numboc div 2].x, p2^.corners [numboc div 2].y, p2^.corners [numboc div 2].z);
    glEnd;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if bbstarted then
  begin
    blackbox.sri(wtf.TimeToStr(timeofplaying) + ' Игра завершена');
    blackbox.Lesha;
  end;
end;

procedure TMainForm.DrawGame;
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
end;

procedure TMainForm.DrawMenu;
begin
  setSmotrelka;
  glViewPort (0, 0, VP.ClientWidth, Vp.ClientHeight);
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  zafigachtexturu(21);
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
  if nadoload then
  begin
    LoadGame;
    k := TiPhys.Interval / 1000 * wtf.acc;
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

procedure TMainForm.PaintRels(p: Ptp);
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

procedure TMainForm.SimpQue;
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

function TMainForm.giveafter(pbw: PBWp; p: PTp): PBWp;
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

procedure TMainForm.LoadGame;
var i:integer;
begin
  mmoLoadProg.Visible := True;
  mmoLoadProg.Lines.Clear;
  mmoLoadProg.Height := Vp.ClientHeight - 2 * mmoLoadProg.Top;
  mmoLoadProg.Width := Vp.ClientWidth - 2 * mmoLoadProg.Left;
  mmoLoadProg.Lines.Add('Загрузка кабины');
  LoadCab;
  mmoLoadProg.Lines.Add('Создание вспомогательного класса');
  wtf := TWTf.sozdat;
  mmoLoadProg.Lines.Add('Запуск чёрного ящика');
  blackbox := TBlackbox.lego;
  bbstarted := true;
  mmoLoadProg.Lines.Add('Обработка параметров игры');
  wtf.wwp;
  bwfirst := wtf.constructmap (mmoLoadProg);
  mmoLoadProg.Lines.Add('Построение светофоров');
  wtf.constructscb (bwfirst);
  mmoLoadProg.Lines.Add('Зажжение светофоров');
  wtf.initialSCB;
  mmoLoadProg.Lines.Add('Загрузка станций');
  wtf.constructstat;
  mmoLoadProg.Lines.Add('Рассчёт станций');
  wtf.realizestat;
  mmoLoadProg.Lines.Add('Освещение тоннелей');
  wtf.calclight (bwfirst);

  for i := 0 to wtf.nscb do
    mkgoodscb;
  oldhz := wtf.gnscbid(wtf.ptrain [0], wtf.isleft);
  mmoLoadProg.Lines.Add('Создание звуков');
  SetChannels;
  mmoLoadProg.Visible := false;
  nadoLoad := false;
end;

function TMainForm.givei2(i: integer; v: real): real;
begin
  if (i > 0) then
    result := wtf.U / (hz [i-1].r + hz [i-1].kbeta * beta0 * abs (v))
  else
    if (i < 0) and (Abs (v) > brakehz [-i-1].vmin)then
      result := (abs (v) - brakehz [-i-1].vmin) * brakeconst * brakehz [-i-1].kbeta / brakehz [-i-1].R //U / R
    else
      result := 0;
end;

procedure TMainForm.SetChannels;
begin
  bass_streamfree(chan1);
  chan1:=bass_streamcreatefile(false, pchar('media\shum.mp3'), 0,0, {$ifdef unicode} bass_unicode {$else} 0 {$endif} or bass_sample_loop {???? ???? ???????? ??? ???? ????? ?????? ?????});
  bass_channelplay(chan1, false);
  BASS_ChannelSetAttribute (chan1, BASS_ATTRIB_VOL, 20);

  bass_streamfree(chan2);
  chan2:=bass_streamcreatefile(false, pchar('media\stuk.mp3'), 0,0, {$ifdef unicode} bass_unicode {$else} 0 {$endif} or bass_sample_loop {???? ???? ???????? ??? ???? ????? ?????? ?????});
end;

procedure TMainForm.Zvuchi;
begin
  {if (abs (v) > 1) and ((itx mod 25 = 10) or (itx mod 25 = 14)) and (wtf.tr < 0.5) then
    bass_channelplay(chan2, false);
  if ((itx mod 25 = 12) or (itx mod 25 = 17)) and (wtf.tr > 0.5) or (Abs (v) <= 1) then
    bass_channelstop(chan2);   }
end;

procedure TMainForm.Painstation(localidstat:integer);
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

function TMainForm.givebrakef(i: integer; v: real): real;
begin
  if Abs (v) > brakehz [i].vmin then
    result := sqr ((abs (v) - brakehz [i].vmin) * brakeconst * brakehz [i].kbeta) / brakehz [i].R / Abs (v) //U^2 / R / v
  else
    Result := 0;
end;

end.

//function WorldToNothing (world:Tworld):TNothing;
