unit Bomj;

interface

type
PShipLoader = ^TShipLoader;
TShipLoader = class
public
  constructor create (s:string);
  destructor destroy; override;
  function givereal:Real;
  function giveinteger:Integer;
private
  f:Text;
end;


type TBlackbox = class
       constructor create;
       destructor destroy; override;
       procedure writestring (s:string);
     private
       f:Text;
     end;

implementation

{ TShipLoader }

function TShipLoader.giveinteger: Integer;
var a:Integer;
begin
  read (f, a);
  Result := a;
end;

function TShipLoader.givereal: Real;
var a:Real;
begin
  read (f, a);
  Result := a;
end;

constructor TShipLoader.create (s:string);
begin
  Assign (f, s);
  Reset (f);
end;

destructor TShipLoader.destroy;
begin
  Close (f);
end;

{ TBlackbox }

constructor TBlackbox.create;
begin
  Assign (f, 'Drivelog.txt');
  Rewrite (f);
end;

destructor TBlackbox.destroy;
begin
  close (f);
end;

procedure TBlackbox.writestring(s: string);
begin
  Writeln (f, s);
end;

end.
