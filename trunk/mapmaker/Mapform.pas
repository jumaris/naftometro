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
  private

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  point: array [0..1000] of TPoint;
  Tunnel: array [0..1000] of TTunnel;
  now, allp, allt: Integer;
  napr: Boolean;
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
  napr:=true;
  //ugol:=0;
  outputer := TBlackbox.lego;
end;

procedure TForm1.btn1Click(Sender: TObject);
var ugol, l, n:Real;
    id:Integer;
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
    Edit1.Text := '0';
    if napr then
    begin
      Tunnel[allt].beg := now;
      Tunnel[allt].en := allp;
      if (point[now].n1 = -1) then
        point[now].n1 := allt
      else
        point[now].n2 := allt;
      point[allp].p1 := allt;
      point[allp].p2 := -1;
      point[allp].n1 := -1;
      point[allp].n2 := -1;
      point[allp].x := point[now].x + l*cos(ugol);
      point[allp].y := point[now].y + l*sin(ugol);
      point[allp].z := Point[now].z + l*n;
    end
    else
    begin
      Tunnel[allt].beg := allp;
      Tunnel[allt].en := now;
      if (point[now].p1 = -1) then
        point[now].p1 := allt
      else
        point[now].p2 := allt;
      point[allp].n1 := allt;
      point[allp].n2 := -1;
      point[allp].p1 := -1;
      point[allp].p2 := -1;
      point[allp].x := point[now].x - l*cos(ugol);
      point[allp].y := point[now].y - l*sin(ugol);
      point[allp].z := Point[now].z - l*n;
    end;
    point[now].idst := id;
    point[allp].idst := id;
    Tunnel[allt].idst := id;
    point[allp].ug := ugol;
    point[allp].ncs := 0;
    point[allp].pcs := 0;
    Tunnel[allt].length := l;
    Tunnel[allt].nakl := n;
    Tunnel[allt].ug := 0;
    now:=allp;
    Inc(allp);
    Inc(allt);
    pbM.Repaint;
  end;
end;


procedure TForm1.btn2Click(Sender: TObject);
var ugol, r, n:Real;
    id:Integer;
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
    Edit1.Text := '0';
    if napr then
    begin
      Tunnel[allt].beg := now;
      Tunnel[allt].en := allp;
      if (point[now].n1 = -1) then
        point[now].n1 := allt
      else
        point[now].n2 := allt;
      point[allp].p1 := allt;
      point[allp].p2 := -1;
      point[allp].n1 := -1;
      point[allp].n2 := -1;
      point[allp].ug := Point[now].ug + ugol;
      point[allp].z := point[now].z + r*abs(ugol)*n;
    end
    else
    begin
      Tunnel[allt].en := now;
      Tunnel[allt].beg := allp;
      if (point[now].p1 = -1) then
        point[now].p1 := allt
      else
        point[now].p2 := allt;
      point[allp].n1 := allt;
      point[allp].n2 := -1;
      point[allp].p1 := -1;
      point[allp].p2 := -1;
      point[allp].ug := Point[now].ug - ugol;
      point[allp].z := point[now].z - r*abs(ugol)*n;
    end;
    point[allp].x := Point[now].x - Sign(ugol)*r*sin(Point[now].ug) + Sign(ugol)*r*sin(Point[allp].ug);
    point[allp].y := Point[now].y + Sign(ugol)*r*cos(Point[now].ug) - Sign(ugol)*r*cos(Point[allp].ug);
    point[now].idst := id;
    point[allp].idst := id;
    point[allp].ncs := 0;
    point[allp].pcs := 0;
    Tunnel[allt].idst := id;
    Tunnel[allt].rad := r;
    Tunnel[allt].ug := ugol;
    Tunnel[allt].length := r*abs(ugol);
    Tunnel[allt].nakl := n;
    now:=allp;
    Inc(allp);
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
      cx := Point[b].x - Sign(tunnel[i].ug)*r*sin(Point[b].ug);
      cy := pbM.Height - Point[b].y - Sign(tunnel[i].ug)*r*cos(Point[b].ug);
      if (tunnel[i].ug > 0) then
        pbM.Canvas.Arc(Round(cx-r),Round(cy-r),Round(cx+r),Round(cy+r),Round(Point[b].x),pbM.Height - Round(Point[b].y),Round(Point[e].x), pbM.Height - Round(Point[e].y))
      else
        pbM.Canvas.Arc(Round(cx-r),Round(cy-r),Round(cx+r),Round(cy+r),Round(Point[e].x),pbM.Height - Round(Point[e].y),Round(Point[b].x), pbM.Height - Round(Point[b].y));
    end
    else
    begin
      pbM.Canvas.MoveTo(Round(point[tunnel[i].beg].x), pbM.Height - Round(point[tunnel[i].beg].y));
      pbM.Canvas.LineTo(Round(point[tunnel[i].en].x), pbM.Height - Round(point[tunnel[i].en].y));
    end;
  end;
  pbM.Canvas.Pen.Width := 5;
  pbM.Canvas.Pen.Color := $0066ff;
  for i:= 0 to allp - 1 do
  begin
    pbM.Canvas.TextOut(Round(point[i].x), pbM.Height - Round(Point[i].y) + 1, IntToStr(i));
    pbM.Canvas.MoveTo(Round(point[i].x), pbM.Height - Round(Point[i].y));
    pbM.Canvas.LineTo(Round(point[i].x), pbM.Height - Round(Point[i].y));
  end;
  pbM.Canvas.Pen.Width := 5;
  if napr then
    pbM.Canvas.Pen.Color := $ffff00
  else
    pbM.Canvas.Pen.Color := $0000ff;
  pbM.Canvas.MoveTo(Round(point[now].x), pbM.Height - Round(Point[now].y));
  pbM.Canvas.LineTo(Round(point[now].x), pbM.Height - Round(Point[now].y));
  pbM.Canvas.Pen.Width := 3;
  if napr then
    pbM.Canvas.LineTo(Round(point[now].x) + Round(15*cos(point[now].ug)), pbM.Height - Round(Point[now].y) - Round(15*sin(point[now].ug)))
  else
    pbM.Canvas.LineTo(Round(point[now].x) - Round(15*cos(point[now].ug)), pbM.Height - Round(Point[now].y) + Round(15*sin(point[now].ug)));
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
          outputer.sri(IntToStr(point[Tunnel[i].beg].pp2 - (round (tunnel [i].length) - j) + 1));
          Outputer.sri(IntToStr(tunnel[i].idst));
          if (Tunnel[i].ug > Tunnel[point[Tunnel[i].en].p2].ug) then
            outputer.sri('1')
          else
            outputer.sri('0');
        end
        else
        begin
          outputer.sri(IntToStr(point[Tunnel[i].beg].pp1 - (round (tunnel [i].length) - j) + 1));
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
          outputer.sri(IntToStr(point[Tunnel[i].beg].pp2 - (round (tunnel [i].length) - j) + 1));
          Outputer.sri(IntToStr(tunnel[i].idst));
          if (Tunnel[i].ug > Tunnel[point[Tunnel[i].en].p2].ug) then
            outputer.sri('1')
          else
            outputer.sri('0');
        end
        else
        begin
          outputer.sri(IntToStr(point[Tunnel[i].beg].pp1 - (round (tunnel [i].length) - j) + 1));
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
begin
  if (Tunnel[allt].en = allp) then
  begin
    now:= tunnel[allt].beg;
    if (point[now].n2 <> allt) then
      point[now].n1 := Point[now].n2;
    point[now].n2 := -1;
    point[now].ncs := 0;
  end
  else
  begin
    now:= tunnel[allt].en;
    if (point[now].p2 <> allt) then
      point[now].p1 := Point[now].p2;
    point[now].p2 := -1;
    point[now].pcs := 0;
  end;
    
  Dec(allt);
  Dec(allp);
  
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

end.
