unit Mapform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Math, Bomj, Spin;

type
  TTunnel = record
    length:Real;
    nakl:Real;
    rad:Real;
    ug:Real;
    beg:Integer;
    en:Integer;
    idst:Integer;
    pov:Boolean;
    id1:Integer;
    id2:Integer;
  end;
  Tpoint = record
    x:Real;
    y:Real;
    z:Real;
    n1:Integer;
    n2:Integer;
    p1:Integer;
    p2:Integer;
    idst:Integer;
    np1:integer;
    np2:integer;
    pp1:integer;
    pp2:integer;
    ncs:Integer;
    pcs:Integer;
    ug:Real;
  end;
  TForm1 = class(TForm)
    Panel1: TPanel;
    pbM: TPaintBox;
    btn1: TButton;
    edt1: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    btn2: TButton;
    edt3: TEdit;
    lbl3: TLabel;
    edt4: TEdit;
    lbl4: TLabel;
    btn3: TButton;
    btn4: TButton;
    se1: TSpinEdit;
    Edit1: TEdit;
    lbl5: TLabel;
    lbl6: TLabel;
    edt2: TEdit;
    btn5: TButton;
    se2: TSpinEdit;
    btn6: TButton;
    lbl7: TLabel;
    rb1: TRadioButton;
    rb2: TRadioButton;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure pbMPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure rb2Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure rb1Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure pbMMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  point: array [0..1000] of TPoint;
  Tunnel: array [0..1000] of TTunnel;
  now, allp, allt, x0, y0, mx, my: Integer;
  napr, isdown: Boolean;
  outputer:TBlackbox;
  //ugol: Real;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  point[0].x := 200;
  point[0].y := 300;
  point[0].z := 0;
  point[0].ug := 0;
  point[0].idst := 0;
  point[0].n1 := -1;
  point[0].n2 := -1;
  point[0].p1 := -1;
  point[0].p2 := -1;
  point[0].ncs := 0;
  point[0].pcs := 0;
  allp:=1;
  allt:=0;
  now:=0;
  x0 := 0;
  y0 := 0;
  isdown := False;
  napr:=true;
  //ugol:=0;
  outputer := TBlackbox.lego;
end;

procedure TForm1.btn1Click(Sender: TObject);
var ugol, l, n, x, y, z:Real;
    id, next, i:Integer;
begin
  if ((napr and (point[now].n1 <> -1) and (point[now].n2 <> -1)) or ((not napr) and (point[now].p1 <> -1) and (point[now].p2 <> -1))) then
    ShowMessage('Не жадничай!')
  else
  if (StrToFloat(edt1.Text) = 0) then
    ShowMessage('Нулевой путь. Низя!')
  else
  begin
    ugol := point[now].ug;
    Tunnel[allt].pov := False;
    l := StrToFloat(edt1.Text);
    n := StrToFloat(se1.Text)*0.001;
    id := StrToInt(Edit1.Text);
    if napr then
    begin
      x := point[now].x + l*cos(ugol);
      y := point[now].y + l*sin(ugol);
      z := Point[now].z + l*n;
    end
    else
    begin
      x := point[now].x - l*cos(ugol);
      y := point[now].y - l*sin(ugol);
      z := Point[now].z - l*n;
    end;
    next := allp;
    for i:=0 to allp - 1 do
      if ((Abs(point[i].x - x) < 1) and (Abs(point[i].y - y) < 1) and(Abs(Point[i].z - z) < 1) and
         (Abs(sin(point[i].ug) - Sin(ugol)) < 0.01) and (Abs(cos(point[i].ug) - cos(ugol)) < 0.01)) then
        if (napr and (point[i].p1 <> -1) and (point[i].p2 <> -1)) or ((not napr) and (point[i].n1 <> -1) and (point[i].n2 <> -1)) then
        begin
          ShowMessage('Занято!');
          Exit;
        end
        else
          next := i;
    Edit1.Text := '0';
    if napr then
    begin
      Tunnel[allt].beg := now;
      Tunnel[allt].en := next;
      if (point[now].n1 = -1) then
        point[now].n1 := allt
      else
      if (Tunnel[point[now].n1].ug < 0) then
      begin
        point[now].n2 := Point[now].n1;
        point[now].n1 := allt;
      end
      else
        point[now].n2 := allt;
      if next = allp then
      begin
        point[allp].p1 := allt;
        point[allp].p2 := -1;
        point[allp].n1 := -1;
        point[allp].n2 := -1;
      end
      else
      if (point[next].p1 = -1) then
        point[next].p1 := allt
      else
      if (Tunnel[point[next].p1].ug < 0) then
      begin
        point[next].p2 := point[next].p1;
        point[next].p1 := allt;
      end
      else
        point[next].p2 := allt;
    end
    else
    begin
      Tunnel[allt].beg := next;
      Tunnel[allt].en := now;
      if (point[now].p1 = -1) then
        point[now].p1 := allt
      else
      if (Tunnel[point[now].p1].ug < 0) then
      begin
        point[now].p2 := point[now].p1;
        point[now].p1 := allt;
      end
      else
        point[now].p2 := allt;
      if next = allp then
      begin
        point[allp].n1 := allt;
        point[allp].n2 := -1;
        point[allp].p1 := -1;
        point[allp].p2 := -1;
      end
      else
      if (point[next].n1 = -1) then
        point[next].n1 := allt
      else
      if (Tunnel[point[next].n1].ug < 0) then
      begin
        point[next].n2 := Point[next].n1;
        point[next].n1 := allt;
      end
      else
        point[next].n2 := allt;
    end;
    point[now].idst := id;
    point[next].idst := id;
    Tunnel[allt].idst := id;
    if next = allp then
    begin
      point[allp].x := x;
      point[allp].y := y;
      point[allp].z := z;
      point[allp].ug := ugol;
      point[allp].ncs := 0;
      point[allp].pcs := 0;
      Inc(allp);
    end;
    Tunnel[allt].length := l;
    Tunnel[allt].nakl := n;
    Tunnel[allt].ug := 0;
    now:=next;
    Inc(allt);
    pbM.Repaint;
  end;
end;


procedure TForm1.btn2Click(Sender: TObject);
var ugol, r, n, x, y, z, ug:Real;
    id, i, next:Integer;
begin
  if ((napr and (point[now].n1 <> -1) and (point[now].n2 <> -1)) or ((not napr) and (point[now].p1 <> -1) and (point[now].p2 <> -1))) then
    ShowMessage('Не жадничай!')
  else
  if (StrToFloat(edt4.text) * StrToFloat(edt3.text) = 0) then
    ShowMessage('Нулевой путь. Низя!')
  else
  begin
    Tunnel[allt].pov := True;
    ugol := StrToFloat(edt4.text)*3.141592654/180;
    r := StrToFloat(edt3.text);
    n := StrToFloat(se1.Text)*0.001;
    id := StrToInt(Edit1.Text);
    if napr then
    begin
      ug := Point[now].ug + ugol;
      z := point[now].z + r*abs(ugol)*n;
    end
    else
    begin
      ug := Point[now].ug - ugol;
      z := point[now].z - r*abs(ugol)*n;
    end;
    x := Point[now].x - Sign(ugol)*r*sin(Point[now].ug) + Sign(ugol)*r*sin(ug);
    y := Point[now].y + Sign(ugol)*r*cos(Point[now].ug) - Sign(ugol)*r*cos(ug);

    next := allp;
    for i:=0 to allp - 1 do
      if ((Abs(point[i].x - x) < 1) and (Abs(point[i].y - y) < 1) and(Abs(Point[i].z - z) < 1) and
         (Abs(sin(point[i].ug) - Sin(ug)) < 0.01) and (Abs(cos(point[i].ug) - cos(ug)) < 0.01)) then
        if (napr and (point[i].p1 <> -1) and (point[i].p2 <> -1)) or ((not napr) and (point[i].n1 <> -1) and (point[i].n2 <> -1)) then
        begin
          ShowMessage('Занято!');
          Exit;
        end
        else
          next := i;
    Edit1.Text := '0';
    if napr then
    begin
      Tunnel[allt].beg := now;
      Tunnel[allt].en := next;
      if (point[now].n1 = -1) then
        point[now].n1 := allt
      else
      if (Tunnel[point[now].n1].ug < ugol) then
      begin
        point[now].n2 := Point[now].n1;
        point[now].n1 := allt;
      end
      else
        point[now].n2 := allt;

      if next = allp then
      begin
        point[allp].p1 := allt;
        point[allp].p2 := -1;
        point[allp].n1 := -1;
        point[allp].n2 := -1;
      end
      else
      if (point[next].p1 = -1) then
        point[next].p1 := allt
      else
      if (Tunnel[point[next].p1].ug < 0) then
      begin
        point[next].p2 := point[next].p1;
        point[next].p1 := allt;
      end
      else
        point[next].p2 := allt;
    end
    else
    begin
      Tunnel[allt].en := now;
      Tunnel[allt].beg := next;
      if (point[now].p1 = -1) then
        point[now].p1 := allt
      else
      if (Tunnel[point[now].p1].ug < ugol) then
      begin
        point[now].p2 := point[now].p1;
        point[now].p1 := allt;
      end
      else
        point[now].p2 := allt;
      if next = allp then
      begin
        point[allp].n1 := allt;
        point[allp].n2 := -1;
        point[allp].p1 := -1;
        point[allp].p2 := -1;
      end
      else
      if (point[next].n1 = -1) then
        point[next].n1 := allt
      else
      if (Tunnel[point[next].n1].ug < 0) then
      begin
        point[next].n2 := Point[next].n1;
        point[next].n1 := allt;
      end
      else
        point[next].n2 := allt;
    end;
    if next = allp then
    begin
      point[allp].x := x;
      point[allp].y := y;
      point[allp].z := z;
      point[allp].ug := ug;
      point[allp].ncs := 0;
      point[allp].pcs := 0;
      Inc(allp);
    end;
    
    point[next].idst := id;
    Tunnel[allt].idst := id;
    Tunnel[allt].rad := r;
    Tunnel[allt].ug := ugol;
    Tunnel[allt].length := r*abs(ugol);
    Tunnel[allt].nakl := n;
    now:=next;
    Inc(allt);
    pbM.Repaint;
  end;
end;

procedure TForm1.pbMPaint(Sender: TObject);
var i, b, e:Integer;
var cx, cy, r:Real;
begin
  for i:= 0 to allt - 1 do
  begin
    if Tunnel[i].idst = 0 then
    begin
      pbM.Canvas.Pen.Width := 1;
      pbM.Canvas.Pen.Color := $000000;
    end
    else
    begin
      pbM.Canvas.Pen.Width := 3;
      pbM.Canvas.Pen.Color := $ff0000;
    end;
    if Tunnel[i].pov then
    begin
      r := tunnel[i].rad;
      b := tunnel[i].beg;
      e := tunnel[i].en;
      cx := x0 + Point[b].x - Sign(tunnel[i].ug)*r*sin(Point[b].ug);
      cy := y0 + pbM.Height - Point[b].y - Sign(tunnel[i].ug)*r*cos(Point[b].ug);
      if (tunnel[i].ug > 0) then
        pbM.Canvas.Arc(Round(cx-r),Round(cy-r),Round(cx+r),Round(cy+r), x0 + Round(Point[b].x), y0 + pbM.Height - Round(Point[b].y), x0 + Round(Point[e].x), y0 + pbM.Height - Round(Point[e].y))
      else
        pbM.Canvas.Arc(Round(cx-r),Round(cy-r),Round(cx+r),Round(cy+r), x0 + Round(Point[e].x), y0 + pbM.Height - Round(Point[e].y),x0 + Round(Point[b].x), y0 + pbM.Height - Round(Point[b].y));
    end
    else
    begin
      pbM.Canvas.MoveTo(x0 + Round(point[tunnel[i].beg].x), y0 + pbM.Height - Round(point[tunnel[i].beg].y));
      pbM.Canvas.LineTo(x0 + Round(point[tunnel[i].en].x), y0 + pbM.Height - Round(point[tunnel[i].en].y));
    end;
  end;
  pbM.Canvas.Pen.Width := 5;
  pbM.Canvas.Pen.Color := $0066ff;
  for i:= 0 to allp - 1 do
  begin
    pbM.Canvas.TextOut(x0 + Round(point[i].x), y0 + pbM.Height - Round(Point[i].y) + 1, IntToStr(i));
    pbM.Canvas.MoveTo(x0 + Round(point[i].x), y0 + pbM.Height - Round(Point[i].y));
    if (point[i].ncs > 0) then
    begin
      pbM.Canvas.Pen.Width := 3;
      pbM.Canvas.Pen.Color := $555555;
      pbM.Canvas.LineTo(x0 + Round(Point[i].x + 15*cos(point[i].ug + 0.2617993)), y0 + pbM.Height - Round(point[i].y + 15*sin(point[i].ug + 0.2617993)));
      pbM.Canvas.LineTo(x0 + Round(Point[i].x + 15*cos(point[i].ug - 0.2617993)), y0 + pbM.Height - Round(point[i].y + 15*sin(point[i].ug - 0.2617993)));
      pbM.Canvas.LineTo(x0 + Round(point[i].x), y0 + pbM.Height - Round(Point[i].y));
      pbM.Canvas.Pen.Width := 5;
      pbM.Canvas.Pen.Color := $0066ff;
    end;
    if (point[i].pcs > 0) then
    begin
      pbM.Canvas.Pen.Width := 3;
      pbM.Canvas.Pen.Color := $555555;
      pbM.Canvas.LineTo(x0 + Round(Point[i].x - 15*cos(point[i].ug + 0.2617993)), y0 + pbM.Height - Round(point[i].y - 15*sin(point[i].ug + 0.2617993)));
      pbM.Canvas.LineTo(x0 + Round(Point[i].x - 15*cos(point[i].ug - 0.2617993)), y0 + pbM.Height - Round(point[i].y - 15*sin(point[i].ug - 0.2617993)));
      pbM.Canvas.LineTo(x0 + Round(point[i].x), y0 + pbM.Height - Round(Point[i].y));
      pbM.Canvas.Pen.Width := 5;
      pbM.Canvas.Pen.Color := $0066ff;
    end;
    pbM.Canvas.LineTo(x0 + Round(point[i].x), y0 + pbM.Height - Round(Point[i].y));
  end;
  pbM.Canvas.Pen.Width := 5;
  if napr then
    pbM.Canvas.Pen.Color := $ffff00
  else
    pbM.Canvas.Pen.Color := $0000ff;
  pbM.Canvas.MoveTo(x0 + Round(point[now].x), y0 + pbM.Height - Round(Point[now].y));
  pbM.Canvas.LineTo(x0 + Round(point[now].x), y0 + pbM.Height - Round(Point[now].y));
  pbM.Canvas.Pen.Width := 3;
  if napr then
    pbM.Canvas.LineTo(x0 + Round(point[now].x) + Round(15*cos(point[now].ug)), y0 + pbM.Height - Round(Point[now].y) - Round(15*sin(point[now].ug)))
  else
    pbM.Canvas.LineTo(x0 + Round(point[now].x) - Round(15*cos(point[now].ug)), y0 + pbM.Height - Round(Point[now].y) + Round(15*sin(point[now].ug)));
  lbl8.Caption := 'Текущая точка: ' + IntToStr(now);
  lbl9.Caption := 'x: ' + FloatToStr(point[now].x);
  lbl10.Caption := 'y: ' + FloatToStr(point[now].y);
  lbl11.Caption := 'z: ' + FloatToStr(point[now].z);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  outputer.Lesha;
end;

procedure TForm1.btn3Click(Sender: TObject);
var freeid, i, j, amount:integer;
    cx, cy:Real;
begin
  amount := allp;

  for i := 0 to allt - 1 do
  begin
    Tunnel[i].id1 := amount;
    amount := amount + Round (tunnel [i].length - 1);
    Tunnel[i].id2 := amount - 1;
  end;

  for i := 0 to allp - 1 do
  begin
    if (point[i].n1 <> -1) then
      point [i].np1 := tunnel[point[i].n1].id1
    else
      point [i].np1 := -1;
    if (point[i].n2 <> -1) then
      point [i].np2 := tunnel[point[i].n2].id1
    else
      point [i].np2 := point [i].np1;
    if (point[i].p1 <> -1) then
      point [i].pp1 := tunnel[point[i].p1].id2
    else
      point [i].pp1 := -1;
    if (point[i].p2 <> -1) then
      point [i].pp2 := tunnel[point[i].p2].id2
    else
      point [i].pp2 := point [i].pp1;
  end;
  outputer.sri2('amount=' + IntToStr(amount));
  outputer.hurktfu;
  outputer.sri2('idtrain=1');
  outputer.hurktfu;
  outputer.sri2('scb=newtest.naftoscb');
  outputer.hurktfu;
  outputer.sri2('stations=mystat.naftostations');
  outputer.hurktfu;
  outputer.sri2('!');
  outputer.hurktfu;

  for i := 0 to allt - 1 do
  if Tunnel [i].pov then
  begin
    cx:=Point[tunnel[i].beg].x - Sign(tunnel[i].ug)*tunnel[i].rad*sin(Point[tunnel[i].beg].ug);
    cy:=Point[tunnel[i].beg].y + Sign(tunnel[i].ug)*tunnel[i].rad*cos(Point[tunnel[i].beg].ug);
    {point [Tunnel [i].beg].np1 := freeid;
    point [Tunnel [i].beg].np2 := freeid;}
    for j := 1 to round (tunnel [i].length - 1) do
    begin
      outputer.sri(IntToStr(tunnel[i].id1 + j - 1));
      outputer.sreal(
      cx + Sign(tunnel[i].ug)*tunnel[i].rad*sin(Point[tunnel[i].beg].ug + tunnel[i].ug*j/Round(tunnel[i].length))
      );
      outputer.sreal(
      cy - Sign(tunnel[i].ug)*tunnel[i].rad*cos(Point[tunnel[i].beg].ug + tunnel[i].ug*j/Round(tunnel[i].length))
      );
      Outputer.sreal(Point [tunnel [i].beg].z + j * tunnel[i].nakl);
      if (j = round (abs (tunnel [i].length) - 1)) then
      begin
        outputer.sri(IntToStr(tunnel [i].en));
        outputer.sri(IntToStr(tunnel [i].en));
      end
      else
      begin
        outputer.sri(IntToStr(tunnel[i].id1 + j));
        outputer.sri(IntToStr(tunnel[i].id1 + j));
      end;
      if (j = 1) then
      begin
        outputer.sri(IntToStr(tunnel [i].beg));
        outputer.sri(IntToStr(tunnel [i].beg));
      end
      else
      begin
        outputer.sri(IntToStr(tunnel[i].id1 + j - 2));
        outputer.sri(IntToStr(tunnel[i].id1 + j - 2));
      end;

      if (j <= point[Tunnel[i].beg].ncs) then
      begin
        if (point[Tunnel[i].beg].n1 = i) then
        begin
          outputer.sri(IntToStr(point[Tunnel[i].beg].np2 + j - 1));
          Outputer.sri(IntToStr(tunnel[i].idst));
          if (Tunnel[i].ug > Tunnel[point[Tunnel[i].beg].n2].ug) then
            outputer.sri('1')
          else
            outputer.sri('0');
        end
        else
        begin
          outputer.sri(IntToStr(point[Tunnel[i].beg].np1 + j - 1));
          Outputer.sri(IntToStr(tunnel[i].idst));
          if (Tunnel[i].ug > Tunnel[point[Tunnel[i].beg].n1].ug) then
            outputer.sri('1')
          else
            outputer.sri('0');
        end;
      end
      else
      if (j >= round (tunnel [i].length) - point[Tunnel[i].en].pcs) then
      begin
        if (point[Tunnel[i].en].p1 = i) then
        begin
          outputer.sri(IntToStr(point[Tunnel[i].en].pp2 - (round (tunnel [i].length) - j) + 1));
          Outputer.sri(IntToStr(tunnel[i].idst));
          if (Tunnel[i].ug > Tunnel[point[Tunnel[i].en].p2].ug) then
            outputer.sri('1')
          else
            outputer.sri('0');
        end
        else
        begin
          outputer.sri(IntToStr(point[Tunnel[i].en].pp1 - (round (tunnel [i].length) - j) + 1));
          Outputer.sri(IntToStr(tunnel[i].idst));
          if (Tunnel[i].ug > Tunnel[point[Tunnel[i].en].p1].ug) then
            outputer.sri('1')
          else
            outputer.sri('0');
        end
      end
      else
      begin
        Outputer.sri(IntToStr(tunnel[i].id1 + j - 1));
        Outputer.sri(IntToStr(tunnel[i].idst));
        Outputer.sri('0');
      end;
      outputer.hurktfu;
    end;
    {point [Tunnel [i].en].pp1 := freeid - 1;
    point [Tunnel [i].en].pp2 := freeid - 1;}
  end
  else
  begin
    {point [Tunnel [i].beg].np1 := freeid;
    point [Tunnel [i].beg].np2 := freeid;}
    for j := 1 to round (tunnel [i].length - 1) do
    begin
      outputer.sri(IntToStr(tunnel[i].id1 + j - 1));
      outputer.sreal(
      (Point [tunnel [i].beg].x * (round (tunnel [i].length) - j) + Point [tunnel [i].en].x * j) / round (tunnel [i].length)
      );
      outputer.sreal(
      (Point [tunnel [i].beg].y * (round (tunnel [i].length) - j) + Point [tunnel [i].en].y * j) / round (tunnel [i].length)
      );
      Outputer.sreal(Point [tunnel [i].beg].z + j * tunnel[i].nakl);
      if (j = round (tunnel [i].length - 1)) then
      begin
        outputer.sri(IntToStr(tunnel [i].en));
        outputer.sri(IntToStr(tunnel [i].en));
      end
      else
      begin
        outputer.sri(IntToStr(tunnel[i].id1 + j));
        outputer.sri(IntToStr(tunnel[i].id1 + j));
      end;
      if (j = 1) then
      begin
        outputer.sri(IntToStr(tunnel [i].beg));
        outputer.sri(IntToStr(tunnel [i].beg));
      end
      else
      begin
        outputer.sri(IntToStr(tunnel[i].id1 + j - 2));
        outputer.sri(IntToStr(tunnel[i].id1 + j - 2));
      end;

      if (j <= point[Tunnel[i].beg].ncs) then
      begin
        if (point[Tunnel[i].beg].n1 = i) then
        begin
          outputer.sri(IntToStr(point[Tunnel[i].beg].np2 + j - 1));
          Outputer.sri(IntToStr(tunnel[i].idst));
          if (Tunnel[i].ug > Tunnel[point[Tunnel[i].beg].n2].ug) then
            outputer.sri('1')
          else
            outputer.sri('0');
        end
        else
        begin
          outputer.sri(IntToStr(point[Tunnel[i].beg].np1 + j - 1));
          Outputer.sri(IntToStr(tunnel[i].idst));
          if (Tunnel[i].ug > Tunnel[point[Tunnel[i].beg].n1].ug) then
            outputer.sri('1')
          else
            outputer.sri('0');
        end;
      end
      else
      if (j >= round (tunnel [i].length) - point[Tunnel[i].en].pcs) then
      begin
        if (point[Tunnel[i].en].p1 = i) then
        begin
          outputer.sri(IntToStr(point[Tunnel[i].en].pp2 - (round (tunnel [i].length) - j) + 1));
          Outputer.sri(IntToStr(tunnel[i].idst));
          if (Tunnel[i].ug > Tunnel[point[Tunnel[i].en].p2].ug) then
            outputer.sri('1')
          else
            outputer.sri('0');
        end
        else
        begin
          outputer.sri(IntToStr(point[Tunnel[i].en].pp1 - (round (tunnel [i].length) - j) + 1));
          Outputer.sri(IntToStr(tunnel[i].idst));
          if (Tunnel[i].ug > Tunnel[point[Tunnel[i].en].p1].ug) then
            outputer.sri('1')
          else
            outputer.sri('0');
        end;
      end
      else
      begin
        outputer.sri(IntToStr(tunnel[i].id1 + j - 1));
        Outputer.sri(IntToStr(tunnel[i].idst));
        Outputer.sri('0');
      end;
      outputer.hurktfu;
    end;
    {point [Tunnel [i].en].pp1 := freeid - 1;
    point [Tunnel [i].en].pp2 := freeid - 1;}
  end;

  for i := 0 to allp - 1 do
  begin
      outputer.sri(IntToStr(i));
      outputer.sreal(Point [i].x);
      outputer.sreal(Point [i].y);
      Outputer.sreal(Point [i].z);
      outputer.sri(IntToStr(point [i].np1));
      outputer.sri(IntToStr(point [i].np2));
      outputer.sri(IntToStr(point [i].pp1));
      outputer.sri(IntToStr(point [i].pp2));
      outputer.sri(IntToStr(i));
      Outputer.sri(IntToStr(point[i].idst));
      Outputer.sri('0');
      outputer.hurktfu;
  end;
end;

procedure TForm1.btn4Click(Sender: TObject);
var b, e:Integer;
begin
  b := Tunnel[allt].beg;
  e := Tunnel[allt].en;
  if (point[b].n2 <> allt) then
    point[b].n1 := Point[b].n2;
  point[b].n2 := -1;
  point[b].ncs := 0;
  if (point[e].p2 <> allt) then
    point[e].p1 := Point[e].p2;
  point[e].p2 := -1;
  point[e].pcs := 0;
  if (b = allp-1) and (point[b].n1 = -1) and (point[b].p1 = -1) and (point[b].p2 = -1) then
    Dec(allp);
  if (e = allp-1) and (point[e].p1 = -1) and (point[e].n1 = -1) and (point[e].n2 = -1) then
    Dec(allp);
  Dec(allt);
  pbM.Repaint;
end;

procedure TForm1.rb2Click(Sender: TObject);
begin
  napr := False;
  pbM.Repaint;
end;

procedure TForm1.btn6Click(Sender: TObject);
begin
  now := se2.Value;
  pbM.Repaint;
end;

procedure TForm1.rb1Click(Sender: TObject);
begin
  napr := True;
  pbM.Repaint;
end;

procedure TForm1.btn5Click(Sender: TObject);
begin
  if napr then
    point[now].ncs := StrToInt(edt2.Text)
  else
    point[now].pcs := StrToInt(edt2.Text);
  pbM.Repaint;
end;

procedure TForm1.pbMMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isdown := True;
  mx := X;
  my := Y;
end;

procedure TForm1.pbMMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if isdown then
  begin
    x0 := x0 + X - mx;
    y0 := y0 + Y - my;
    mx := X;
    my := Y;
    pbM.Repaint;
  end;
end;

procedure TForm1.pbMMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isdown := False;
  pbM.Repaint;
end;

end.
