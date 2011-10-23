unit ReallyUseful;

interface


const maxnwag = 100;
      numboc = 9;  //Number of corners
      theight = 1;
      twidth = 0.25;
      maxpok = 20;
      maxscb = 10000;
      shpalw = 2.2;
      msl = 0; //minscblight
      maxstatn = 100;

type
  T3dc = record   //3d coords
    x:real;
    y:real;
    z:real;
  end;
  PTp = ^TTp;
  PBWp = ^TBWp;
  TTp = record
    cx:real;
    cy:real;
    cz:real;
    kurs:real;
    scbid:integer;
    next1:PTp;
    next2:PTp;
    previous1:PTp;
    previous2:PTp;
    together:PTp;
    isright:boolean;
    id:integer;
    idstat:integer;
    corners:array [0 .. numboc - 1] of T3dc;
    table:array [0 .. 3] of T3dc;
    shpala:array [0 .. 7] of T3dc;
  end;
  TBWP = record
    tp:PTp;
    next:PBWp;
  end;
  TMy3dc = record
    x:integer;
    y:integer;
    z:integer;
  end;
  Tinst = record
    x:real;
    y:Real;
    z:Real;
    alpha:Real;
    id:integer;
  end;
  TRe3dc = record
    x:real;
    y:real;
    z:real;
  end;
  TBwquads = record
    a:TMy3dc;
    b:TMy3dc;
    c:TMy3dc;
    d:TMy3dc;
    tid:Integer;
  end;
  TScb = record
    condition:integer;
    ntp:PTp;
    right:boolean;
    zhelezno:boolean;
    isforward:boolean;
    next1, next2:integer;
    table1:array [0 .. maxpok - 1] of integer; //Своё показание в зависимости от показания next1
    table2:array [0 .. maxpok - 1] of integer; // -//- next2
  end;

procedure MovePoint(var a: TRe3dc; kurs, len: real);

implementation

procedure MovePoint(var a: TRe3dc; kurs, len: real);
begin
  a.x := a.x + len * cos (kurs/180*pi);
  a.y := a.y + len * sin (kurs/180*pi);
end;


end.
