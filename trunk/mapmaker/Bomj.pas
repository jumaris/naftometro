unit Bomj;

interface

type TShipLoader = class
       constructor lego;
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
       procedure sri2 (s:string);
       procedure sreal (r:Real);
       procedure hurktfu;
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

constructor TShipLoader.lego;
begin
  Assign (f, 'cab.txt');
  Reset (f);
end;

destructor TShipLoader.Lesha;
begin
  Close (f);
end;

{ TBlackbox }

procedure TBlackbox.hurktfu;
begin
  Writeln (f, '');
end;

constructor TBlackbox.lego;
begin
  Assign (f, 'output.naftomap');
  Rewrite (f);
end;

destructor TBlackbox.Lesha;
begin
  close (f);
end;

procedure TBlackbox.sreal(r: Real);
begin
  write(f, r);
  write(f, ' ');
end;

procedure TBlackbox.sri(s: string);
begin
  Write (f, s + ' ');
end;

procedure TBlackbox.sri2(s: string);
begin
  Write (f, s);
end;

end.
