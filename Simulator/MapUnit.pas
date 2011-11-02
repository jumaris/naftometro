unit MapUnit;

interface

uses ReallyUseful, Math;

function getAngle(x1, y1, x2, y2: real): real;  //from 11 to 22

type

PAbstractPosition = ^TAbstractPosition;
TAbstractPosition = class
protected
  function givebx():real;
  function giveby():real;
  function givebz():real;
public
  //gettype procedures
  function getPoint:PTp; virtual; abstract;
  function getExtra:Real; virtual; abstract; //contract: minimal > 0
  function getdir:Boolean; virtual; abstract;
  function getRe3dc(): TRe3dc;
  //settype procedures
  procedure move(x: real); virtual; abstract;
end;

PMajorPosition = ^TMajorPosition;
TMajorPosition = class(TAbstractPosition)
public
  point: PTp;
  extra: Real;
  dir: Boolean; //по ходу едем?
  procedure reverse();
  //todo: implement getters  and move
end;

PMinorPosition = ^TMinorPosition;
TMinorPosition = class(TAbstractPosition)  //следует за major
  major: PAbstractPosition;
  distance: Real;
  function getPoint:PTp; override;
  function getExtra:Real; override;
  function cloneToMajorPosition:PMajorPosition;
end;

PStick = ^TStick;
TStick = class
public
  major: PMajorPosition;
  minor: PMinorPosition;

  procedure reverse();
end;

implementation

const isleft = True; // нужно читать каждую стрелку

procedure TMajorPosition.reverse();
begin
  dir := not dir;
end;

function TAbstractPosition.getRe3dc():TRe3dc;
begin
  Result.x:=givebx;
end;

function TAbstractPosition.givebx(): real;
begin
  if isleft then
    result := getExtra * getPoint^.next1^.cx + (1 - getExtra) * getPoint^.cx
  else
    result := getExtra * getPoint^.next2^.cx + (1 - getExtra) * getPoint^.cx;
end;

function TAbstractPosition.giveby(): real;
begin
  if isleft then
    result := getExtra * getPoint^.next1^.cy + (1 - getExtra) * getPoint^.cy
  else
    result := getExtra * getPoint^.next2^.cy + (1 - getExtra) * getPoint^.cy;
end;

function TAbstractPosition.givebz(): real;
begin
  if isleft then
    result := getExtra * getPoint^.next1^.cz + (1 - getExtra) * getPoint^.cz
  else
    result := getExtra * getPoint^.next2^.cz + (1 - getExtra) * getPoint^.cz;
end;

function TMinorPosition.getPoint():PTp;
begin
  Writeln('Error at TMinorPosition.getPoint');
  //todo
end;

function TMinorPosition.getExtra():Real;
begin
  Writeln('Error at TMinorPosition.getExtra');
  //todo
end;

function TMinorPosition.cloneToMajorPosition():PMajorPosition;

function getAngle(x1, y1, x2, y2: real): real;  //from 11 to 22
begin
  //todo: results := ArcTan2(y2-y1,x2-x1);
  if x1 = x2 then
    if y1 > y2 then
      result := pi / -2
    else
      result := pi / 2
  else
    result := arctan((y2 - y1) / (x2 - x1));
  if x1 > x2 then
    result := result + pi;
end;

procedure TStick.reverse();
begin
  
end;

end.
