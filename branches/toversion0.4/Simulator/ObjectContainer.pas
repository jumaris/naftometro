unit ObjectContainer;

interface

uses
  Useful, Bomj;

type
THardTrain = class
  npoin: integer;
  poin:array of TRe3dc;
  glaz: Integer;

  nquads:Integer;
  qua:array [0 .. 10000] of TBwquads;

public
  constructor create(var cabloader: TShipLoader);
  //destructor destroy();
end;

TSoftTrain = class
  ferrum: THardTrain;
  realpoin:array of TRe3dc;
  coord: Real;

public
  constructor create(var cabloader: TShipLoader);
end;

implementation

constructor THardTrain.create(var cabloader: TShipLoader);
var
  i:Integer;                                           
begin
  cabloader := TShipLoader.create('cab.txt');
  npoin := cabloader.giveinteger;
  SetLength(poin, npoin);
  for i := 0 to npoin - 1 do
  begin
    poin [i].x := cabloader.givereal;
    poin [i].y := cabloader.givereal;
    poin [i].z := cabloader.givereal;
    if cabloader.giveinteger = 1 then
      glaz := i;
  end;
    nquads := cabloader.giveinteger;
  for i := 0 to nquads - 1 do
  begin
    qua [i].tid := cabloader.giveinteger;
    qua [i].a.x := cabloader.giveinteger; //????? ?????
    qua [i].a.y := cabloader.giveinteger; //???????? ?
    qua [i].a.z := cabloader.giveinteger; //???????? ?

    qua [i].b.x := cabloader.giveinteger;
    qua [i].b.y := cabloader.giveinteger;
    qua [i].b.z := cabloader.giveinteger;

    qua [i].c.x := cabloader.giveinteger;
    qua [i].c.y := cabloader.giveinteger;
    qua [i].c.z := cabloader.giveinteger;

    qua [i].d.x := cabloader.giveinteger;
    qua [i].d.y := cabloader.giveinteger;
    qua [i].d.z := cabloader.giveinteger;
  end;

end;

constructor TSoftTrain.create(var cabloader: TShipLoader);
begin
  ferrum := THardTrain.create(cabloader);
  coord := 0;
end;

end.
