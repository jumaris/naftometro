unit tests;

interface

uses ObjectContainer1, MapUnit, math;

procedure testscb;
procedure testarctan;


implementation

procedure testscb();
var
  scb:PScb;
  str:PStrelka;
  arsw:array[0..2] of PSwitcher;
  arnil:array of PSwitcher;

begin
  New(arsw[0]);
  arsw[0]^ := TStrelka.create(false);
  SetLength(arnil,0);
  New(arsw[1]);
  arsw[1]^ := TScb.create(arnil);
  New(arsw[2]);
  arsw[2]^ := TScb.create(arnil);
  New(scb);
  scb^ := TScb.create(arsw);
  SetLength(scb.dependences,50);

  arsw[0].state:=1;
  arsw[1].state:=1;
  arsw[2].state:=1;



  scb.dependences[0].isNode:=True;
  scb.dependences[0].fromWhoOrState:=0;
  SetLength(scb.dependences[0].nodes,2);
  scb.dependences[0].nodes[0]:=1;
  scb.dependences[0].nodes[1]:=2;

  scb.dependences[1].isNode:=True;
  scb.dependences[1].fromWhoOrState:=1;
  SetLength(scb.dependences[1].nodes,2);
  scb.dependences[1].nodes[0]:=3;
  scb.dependences[1].nodes[1]:=4;

  scb.dependences[2].isNode:=True;
  scb.dependences[2].fromWhoOrState:=2;
  SetLength(scb.dependences[2].nodes,2);
  scb.dependences[2].nodes[0]:=5;
  scb.dependences[2].nodes[1]:=6;

  scb.dependences[3].isNode:=False;
  scb.dependences[3].fromWhoOrState:=3;

  scb.dependences[4].isNode:=False;
  scb.dependences[4].fromWhoOrState:=4;

  scb.dependences[5].isNode:=False;
  scb.dependences[5].fromWhoOrState:=5;

  scb.dependences[6].isNode:=False;
  scb.dependences[6].fromWhoOrState:=6;

  scb.updateState;
  Writeln(scb.getState);
  Readln;
end;

procedure dotestarctan(x1,y1,x2,y2:real);
begin
  Writeln('getAngle(',x1:0:3,',',y1:0:3,',',x2:0:3,',',y2:0:3,') == ',getAngle(x1,y1,x2,y2):0:3);
  Writeln(' ArcTan2(',x1:0:3,',',y1:0:3,',',x2:0:3,',',y2:0:3,') == ',arcTan2(y2-y1,x2-x1):0:3);
  writeln;
end;

procedure testarctan();
begin
  dotestarctan(0,0,0,1);
  dotestarctan(0,0,1,0);
  dotestarctan(0,0,0,-1);
  dotestarctan(0,0,-1,0);
  dotestarctan(0,0,1,1);
  readln;

end;

end.
 