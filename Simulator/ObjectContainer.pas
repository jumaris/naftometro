unit ObjectContainer;

interface

uses
  ReallyUseful, Bomj, Mapunit, ObjectContainer1;

type
PSoftTrain = ^TSoftTrain;
PHardTrain = ^THardTrain;
PViewPoint = ^TViewPoint;
THardTrain = class
  nwag: integer;
  wlength: integer; //вообще-то нужно real
  npoin: integer;
  poin:array of TRe3dc;
  glaz: Integer;

  nquads:Integer;
  qua:array[0 .. 10000] of TBwquads;

public
  constructor create(var cabloader: TShipLoader; nwag,wlength:integer);
  destructor destroy(); override;
end;

TSoftTrain = class
  ferrum: PHardTrain;
  realpoin:array of TRe3dc;
  coord: Real;
  PWag:array of PTp; // указатель на вагоны
  itx: real; //signed путь
  fullx:real; //abslolute путь

public
  constructor create(head: PTP; pHardTrain:PHardTrain);
  //destructor destroy();
  procedure move(length: Real; turnleft: boolean{этого не должно быть});
end;

TViewPoint = class
  cabfactor:Shortint;
  camdopkurs: real;
  camdopalpha: real;
  train: PSoftTrain;

  constructor create(cabfact:Shortint; psofttrain:PSoftTrain);
  function givelto(a: PTp): real;
  function givecamkurs: real;
  function givecamalpha: real;
  procedure CalcRealPoints();
end;

TStrelka = class
  left:boolean;
end;

implementation

constructor THardTrain.create(var cabloader: TShipLoader; nwag,wlength:integer);
var
  i:Integer;                                           
begin
  Self.nwag:=nwag;
  Self.wlength:=wlength;
  npoin := cabloader.giveinteger;
  SetLength(poin, npoin);
  for i := 0 to npoin - 1 do
  begin
    poin[i].x := cabloader.givereal;
    poin[i].y := cabloader.givereal;
    poin[i].z := cabloader.givereal;
    if cabloader.giveinteger = 1 then
      glaz := i;
  end;
    nquads := cabloader.giveinteger;
  for i := 0 to nquads - 1 do
  begin
    qua[i].tid := cabloader.giveinteger;
    qua[i].a.x := cabloader.giveinteger; //????? ?????
    qua[i].a.y := cabloader.giveinteger; //???????? ?
    qua[i].a.z := cabloader.giveinteger; //???????? ?

    qua[i].b.x := cabloader.giveinteger;
    qua[i].b.y := cabloader.giveinteger;
    qua[i].b.z := cabloader.giveinteger;

    qua[i].c.x := cabloader.giveinteger;
    qua[i].c.y := cabloader.giveinteger;
    qua[i].c.z := cabloader.giveinteger;

    qua[i].d.x := cabloader.giveinteger;
    qua[i].d.y := cabloader.giveinteger;
    qua[i].d.z := cabloader.giveinteger;
  end;

end;

destructor THardTrain.destroy();
begin
  finalize(poin);
  inherited;
end; 

constructor TSoftTrain.create(head: PTP; pHardTrain:PHardTrain);
var
  i,j: integer;
begin
  ferrum := pHardTrain;
  coord := 0;
  SetLength(realpoin, ferrum.npoin);

  SetLength(PWag, ferrum.nwag);
  PWag[0] := head;
  for i := 1 to ferrum.nwag do
  begin
    PWag[i] := PWag[i - 1];
    for j := 0 to ferrum.wlength - 1 do
      PWag[i] := PWag[i]^.previous1;
  end;
end;

constructor TViewPoint.create(cabfact:Shortint; psofttrain:PSoftTrain);
begin
  cabfactor := cabfact;
  train := psofttrain;
end;

function TViewPoint.givelto(a: PTp): real;
begin
  if cabfactor = 1 then
    result := sqrt(sqr(givebx(train.PWag[0], train.coord) - a^.cx) + sqr(giveby(train.PWag[0], train.coord) - a^.cy) + sqr(givebz(train.PWag[0], train.coord) - a^.cz))
  else
    result := sqrt(sqr(givebx(train.PWag[train.ferrum.nwag], train.coord) - a^.cx) + sqr(giveby(train.PWag[train.ferrum.nwag], train.coord) - a^.cy) + sqr(givebz(train.PWag[train.ferrum.nwag], train.coord) - a^.cz));
end;

function TViewPoint.givecamkurs: real;
begin
  if cabfactor = 1 then
    result := giveangle(givebx(train.PWag[1], train.coord), giveby(train.PWag[1], train.coord), givebx(train.PWag[0], train.coord), giveby(train.PWag[0], train.coord)) * 180 / Pi + camdopkurs
  else
    result := giveangle(givebx(train.PWag[train.ferrum.nwag - 1], train.coord), giveby(train.PWag[train.ferrum.nwag - 1], train.coord), givebx(train.PWag[train.ferrum.nwag], train.coord), giveby(train.PWag[train.ferrum.nwag], train.coord)) * 180 / Pi + camdopkurs;
end;

function TViewPoint.givecamalpha: real;
begin
  if cabfactor = 1 then
    result := giveangle (0,
                         givebz(train.PWag[1], train.coord),
                         sqrt(sqr(givebx(train.PWag[0], train.coord) - givebx(train.PWag[1], train.coord))
                             + sqr(giveby(train.PWag[0], train.coord) - giveby(train.PWag[1], train.coord))),
                         givebz(train.PWag[0], train.coord)) * 180 / Pi +
                         camdopalpha
  else
    result := giveangle (0,
                         givebz(train.PWag[train.ferrum.nwag - 1], train.coord),
                         sqrt(sqr(givebx(train.PWag[train.ferrum.nwag], train.coord) - givebx(train.PWag[train.ferrum.nwag - 1], train.coord))
                             + sqr(giveby(train.PWag[train.ferrum.nwag], train.coord) - giveby(train.PWag[train.ferrum.nwag - 1], train.coord))),
                         givebz(train.PWag[train.ferrum.nwag], train.coord)) * 180 / Pi +
                         camdopalpha;
end;

procedure TViewPoint.calcRealPoints();
var i:integer;
    x, y, kurs, z:Real;
begin
  if cabfactor=1 then
  begin
    x := givebx(train.PWag[0], train.coord);
    y := giveby(train.PWag[0], train.coord);
    z := givebz(train.PWag[0], train.coord);
  end
  else
  begin
    x := givebx(train.PWag[train.ferrum.nwag], train.coord);
    y := giveby(train.PWag[train.ferrum.nwag], train.coord);
    z := givebz(train.PWag[train.ferrum.nwag], train.coord);
  end;
  kurs := givecamkurs - camdopkurs;

  //кабина
  for i := 0 to train.ferrum.npoin - 1 do   //??????? ????? ? ???? ?? ?????? ??????
  begin
    train.realpoin[i].x := x;
    train.realpoin[i].y := y;

    MovePoint(train.realpoin[i], kurs, train.ferrum.Poin[i].x);
    MovePoint(train.realpoin[i], kurs + 90, train.ferrum.Poin[i].y);
    train.realpoin[i].z := train.ferrum.poin[i].z + z;
  end;
end;

procedure TSoftTrain.move(length: Real; turnleft: boolean{этого не должно быть});
var
  i: integer;
begin
  coord := coord + length;
  while coord > 1 do
  begin
    coord := coord - 1;
    if turnleft then
      for i := 0 to ferrum.nwag do
        Pwag[i] := PWag[i]^.next1
    else
      for i := 0 to ferrum.nwag do
        PWag[i] := PWag[i]^.next2;
    itx := itx + 1;

    if (((PWag[0]^.next1 = nil) and turnleft) or
       ((PWag[0]^.next2 = nil) and not turnleft)) then
    begin
      //wtf.die('Выезд за пределы тоннеля');
      //gameover:=true;
      halt;
    end;
  end;
  while coord < 0 do
  begin
    coord := coord + 1;
    if turnleft then
      for i := 0 to ferrum.nwag do
        PWag[i] := PWag[i]^.previous1
    else
      for i := 0 to ferrum.nwag do
        PWag[i] := PWag[i]^.previous2;
    itx := itx - 1;

    if (((PWag[ferrum.nwag]^.previous1 = nil) and turnleft) or
       ((PWag[ferrum.nwag]^.previous2 = nil) and not turnleft)) then
    begin
      //wtf.die('Выезд за пределы тоннеля');
      //gameover:=true;
      Halt;
    end;
  end;
end;

end.
