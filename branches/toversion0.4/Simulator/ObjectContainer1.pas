unit ObjectContainer1;

interface

uses Bomj, ReallyUseful;

type
PSwitcher = ^TSwitcher;
TSwitcher = class
public
  state:Integer;
  function getState(): integer; virtual;
  procedure updateState(); overload; virtual; abstract;
end;

PStrelka = ^TStrelka;
TStrelka = class(TSwitcher)
public
  constructor create(defState:Boolean);
  procedure updateState(newState:Boolean); overload;
end;

PScb = ^TScb;
TScb = class(TSwitcher)
public
  nStates:Integer;
  depends: array of PSwitcher;
  dependences: array of record
    isNode: Boolean; //разветвление, а не лист
    fromWhoOrState: Integer; //по кому разветвление, или номер состояния
    nodes: array of Integer; //номер следующего узла
  end;
  
  constructor create(dependsOn:array of PSwitcher);
  procedure updateState(); override;
end;

implementation

function TSwitcher.getState():Integer;
begin
  Result := state;
end;

constructor TStrelka.create(defstate:Boolean);
begin
  inherited create();
  updateState(defstate);
end;

procedure TStrelka.updateState(newState:Boolean);
begin
  if newState then begin
    state:=0
  end else begin
    state:=1;
  end;
end;

constructor TScb.create(dependsOn:array of PSwitcher);
var n,i:Integer;
begin
  n:=Length(dependsOn);
  SetLength(depends, n);
  for i:=0 to n-1 do begin
    depends[i]:=dependsOn[i];
  end;
  //scbloader.giveinteger()
end;

procedure TScb.updateState();
var i:Integer;
begin
  i := 0;
  while dependences[i].isNode do begin
    i := dependences[i].nodes[depends[dependences[i].fromWhoOrState].getState];
  end;
  state := dependences[i].fromWhoOrState;
end;

end.
