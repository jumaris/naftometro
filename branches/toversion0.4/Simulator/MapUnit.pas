unit MapUnit;

interface

uses ReallyUseful;

function givebx(a: PTp; tr:real): real;
function giveby(a: PTp; tr:real): real;
function givebz(a: PTp; tr:real): real;
function giveAngle(x1, y1, x2, y2: real): real;  //from 11 to 22

implementation

const isleft = True; // нужно читать каждую стрелку

function givebx(a: PTp; tr:real): real;
begin
  if isleft then
    result := tr * a^.next1^.cx + (1 - tr) * a^.cx
  else
    result := tr * a^.next2^.cx + (1 - tr) * a^.cx;
end;

function giveby(a: PTp; tr:real): real;
begin
  if isleft then
    result := tr * a^.next1^.cy + (1 - tr) * a^.cy
  else
    result := tr * a^.next2^.cy + (1 - tr) * a^.cy;
end;

function givebz(a: PTp; tr:real): real;
begin
  if isleft then
    result := tr * a^.next1^.cz + (1 - tr) * a^.cz
  else
    result := tr * a^.next2^.cz + (1 - tr) * a^.cz;
end;

function giveAngle(x1, y1, x2, y2: real): real;  //from 11 to 22
begin
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

end.
