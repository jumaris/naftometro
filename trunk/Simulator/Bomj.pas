unit Bomj;

interface

type TShipLoader = class
       constructor lego (s:string);
       destructor Lesha;
       function givereal:Real;
       function giveinteger:Integer;
     private
       f:Text;
     end;
     TBlackbox = class
       constructor lego;
       destructor Lesha;
       procedure sri (s:string);
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

constructor TShipLoader.lego (s:string);
begin
  Assign (f, s);
  Reset (f);
end;

destructor TShipLoader.Lesha;
begin
  Close (f);
end;

{ TBlackbox }

constructor TBlackbox.lego;
begin
  Assign (f, 'Drivelog.txt');
  Rewrite (f);
end;

destructor TBlackbox.Lesha;
begin
  close (f);
end;

procedure TBlackbox.sri(s: string);
begin
  Writeln (f, s);
end;

end.
