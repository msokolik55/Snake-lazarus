program project1;
uses crt;

var zivoty, smer, skore, dlzka,
      x_jedlo, y_jedlo: integer;
    telo: array[1..20, 1..2] of integer;
    ch: char;

procedure vygenerujJedlo(var x, y: integer);
var konflikt: boolean;
    i: integer;
begin
  repeat
    konflikt := False;

    x := random(39) + 1;
    y := random(19) + 1;

    for i := 1 to dlzka do
      if(telo[i, 1] = x) and
        (telo[i, 2] = y) then konflikt := True;
  until not konflikt;
end;

procedure posunSuradnice();
var i: integer;
begin 
  for i := dlzka + 1 downto 2 do
  begin
    telo[i, 1] := telo[i - 1, 1];
    telo[i, 2] := telo[i - 1, 2];
  end;
end;

function kusnutieHada(): boolean;
var i: integer;
begin
  kusnutieHada := False;

  for i := 2 to dlzka do
    if(telo[1, 1] = telo[i, 1]) and
      (telo[1, 2] = telo[i, 2]) then kusnutieHada := True;
end;

procedure vypisSkore();
begin
  gotoxy(50, 1);
  write('Skore: ', skore);
end;

procedure animPohyb();
begin
  gotoxy(telo[dlzka + 1, 1], telo[dlzka + 1, 2]);
  write(' ');

  gotoxy(telo[1, 1], telo[1, 2]);
  write('*');
end;

begin
  telo[1, 1] := 5;
  telo[1, 2] := 5; 
  telo[2, 1] := 4;
  telo[2, 2] := 5;
  dlzka := 1;

  zivoty := 1;                            
  smer := 2; // 1 - hore, 2 - vpravo, ...

  skore := 0;
  vypisSkore();

  vygenerujJedlo(x_jedlo, y_jedlo);
  gotoxy(x_jedlo, y_jedlo);
  write('#');

  repeat
    animPohyb();
    delay(50);

    // kusnutie
    if(kusnutieHada) then
    begin
      zivoty := zivoty - 1;
    end;

    // zjedenie jedla
    if(telo[1, 1] = x_jedlo) and (telo[1, 2] = y_jedlo) then
    begin
      skore := skore + 1;
      vypisSkore();

      dlzka := dlzka + 1;

      vygenerujJedlo(x_jedlo, y_jedlo);
      gotoxy(x_jedlo, y_jedlo);
      write('#');
    end;

    // zmena smeru pri kliknuti
    if(keypressed) then
    begin
      ch := readkey;

      if(dlzka > 1) then
      begin
        if(ch = 'w') and (smer <> 3) then smer := 1;
        if(ch = 'd') and (smer <> 4) then smer := 2;
        if(ch = 's') and (smer <> 1) then smer := 3;
        if(ch = 'a') and (smer <> 2) then smer := 4;
      end
      else

      case ch of
        'w': smer := 1;
        'd': smer := 2;
        's': smer := 3;
        'a': smer := 4;
      end;
    end;

    // zmena suradnic podla smeru
    posunSuradnice();
    case smer of
      1: telo[1, 2] := telo[1, 2] - 1;
      2: telo[1, 1] := telo[1, 1] + 1;
      3: telo[1, 2] := telo[1, 2] + 1;
      4: telo[1, 1] := telo[1, 1] - 1;
    end;

    // hranice
    if(telo[1, 1] < 1) then telo[1, 1] := 40;
    if(telo[1, 1] > 40) then telo[1, 1] := 1;
    if(telo[1, 2] < 1) then telo[1, 2] := 20;
    if(telo[1, 2] > 20) then telo[1, 2] := 1;
  until zivoty <= 0;

  write('KONIEC');
  readln();
end.

