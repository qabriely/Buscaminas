program buscaminas;

uses
  crt;

const
  // Constantes de niveles de dificultad
  FACIL = 1;
  MEDIO = 2;
  DIFICIL = 3;

var
  // Constantes de tamaño de tablero y cantidad de minas para cada nivel de dificultad
  TAMANO: array[1..3, 1..2] of integer = ((8, 8), (16, 16), (16, 30));
  MINAS: array[1..3] of integer = (10, 40, 99);

type
  Tablero = array of array of char;
  Coordenada = record
    fila, columna: integer;
  end;

var
  tableroVisible: Tablero;
  tableroReal: Tablero;
  coordenadaActual: Coordenada;

procedure inicializarTablero(var tableroVisible, tableroReal: Tablero; nivelDificultad: integer);
var
  i, j: integer;
begin
  // Inicializar tablero visible
  SetLength(tableroVisible, TAMANO[nivelDificultad][1], TAMANO[nivelDificultad][2]);
  for i := 0 to TAMANO[nivelDificultad][1] - 1 do
    for j := 0 to TAMANO[nivelDificultad][2] - 1 do
      tableroVisible[i, j] := '-';

  // Inicializar tablero real
  SetLength(tableroReal, TAMANO[nivelDificultad][1], TAMANO[nivelDificultad][2]);
  for i := 0 to TAMANO[nivelDificultad][1] - 1 do
    for j := 0 to TAMANO[nivelDificultad][2] - 1 do
      tableroReal[i, j] := ' ';
end;

procedure colocarMinas(var tableroReal: Tablero; nivelDificultad: integer);
var
  minasColocadas, fila, columna: integer;
begin
  minasColocadas := 0;
  while minasColocadas < MINAS[nivelDificultad] do
  begin
    fila := random(TAMANO[nivelDificultad][1]);
    columna := random(TAMANO[nivelDificultad][2]);
    if tableroReal[fila, columna] <> '*' then
    begin
      tableroReal[fila, columna] := '*';
      Inc(minasColocadas);
    end;
  end;
end;

procedure dibujarTablero(tablero: Tablero; nivelDificultad: integer);
var
  i, j: integer;
begin
  clrscr;
  writeln('  | 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30');
  writeln('----------------------------------------------------------------------------------');
  for i := 0 to TAMANO[nivelDificultad][1] - 1 do
  begin
    write(i + 1, ' | ');
    for j := 0 to TAMANO[nivelDificultad][2] - 1 do
      write(tablero[i, j], ' ');
    writeln;
  end;
end;

function contarMinasAlrededor(tablero: Tablero; coordenada: Coordenada; nivelDificultad: integer): integer;
var
  i, j, minas: integer;
begin
  minas := 0;
  for i := coordenada.fila - 1 to coordenada.fila + 1 do
    for j := coordenada.columna - 1 to coordenada.columna + 1 do
      if (i >= 0) and (i < TAMANO[nivelDificultad][1]) and (j >= 0) and (j < TAMANO[nivelDificultad][2]) and (tablero[i, j] = '*') then
        Inc(minas);
  contarMinasAlrededor := minas;
end;

procedure descubrirCeldas(var tableroVisible, tableroReal: Tablero; coordenada: Coordenada; nivelDificultad: integer);
var
  minasAlrededor: integer;
  i, j: integer;
begin
  minasAlrededor := contarMinasAlrededor(tableroReal, coordenada, nivelDificultad);
  if minasAlrededor = 0 then
  begin
    for i := coordenada.fila - 1 to coordenada.fila + 1 do
      for j := coordenada.columna - 1 to coordenada.columna + 1 do
        if (i >= 0) and (i < TAMANO[nivelDificultad][1]) and (j >= 0) and (j < TAMANO[nivelDificultad][2]) and (tableroVisible[i, j] = '-') then
        begin
          coordenadaActual.fila := i;
          coordenadaActual.columna := j;
          tableroVisible[i, j] := Chr(48 + contarMinasAlrededor(tableroReal, coordenadaActual, nivelDificultad));

          if tableroReal[i, j] = ' ' then
          begin
            coordenadaActual.fila := i;
            coordenadaActual.columna := j;
            descubrirCeldas(tableroVisible, tableroReal, coordenadaActual, nivelDificultad);
          end;
        end;
  end
  else
    tableroVisible[coordenada.fila, coordenada.columna] := Chr(48 + minasAlrededor);
end;

procedure jugar(nivelDificultad: integer);
var
  fila, columna: integer;
  jugando, jugarOtraVez: boolean;
  respuesta: char;
begin
  repeat
    inicializarTablero(tableroVisible, tableroReal, nivelDificultad);
    colocarMinas(tableroReal, nivelDificultad);
    jugando := true;
    while jugando do
    begin
      dibujarTablero(tableroVisible, nivelDificultad);
      write('Selecciona la fila: ');
      readln(fila);
      write('Selecciona la columna: ');
      readln(columna);
      if (fila >= 1) and (fila <= TAMANO[nivelDificultad][1]) and (columna >= 1) and (columna <= TAMANO[nivelDificultad][2]) then
      begin
        if tableroReal[fila - 1, columna - 1] = '*' then
        begin
          writeln('¡Perdiste! Has encontrado una mina.');
          writeln('Game Over');
          tableroVisible[fila - 1, columna - 1] := '*';
          dibujarTablero(tableroVisible, nivelDificultad);
          jugando := false;
        end
        else
        begin
          coordenadaActual.fila := fila - 1;
          coordenadaActual.columna := columna - 1;
          descubrirCeldas(tableroVisible, tableroReal, coordenadaActual, nivelDificultad);
          jugando := true;
        end;
      end
      else
        writeln('Coordenadas inválidas. Por favor, ingresa números entre 1 y ', TAMANO[nivelDificultad][1], ' para la fila y 1 y ', TAMANO[nivelDificultad][2], ' para la columna.');
    end;
    write('¿Deseas jugar otra vez? (S/N): ');
    readln(respuesta);
    jugarOtraVez := (respuesta = 'S') or (respuesta = 's');
  until not jugarOtraVez;
end;

var
  nivelDificultad: integer;
begin
  randomize;
  writeln('¡Bienvenido a Buscaminas!');
  writeln('Selecciona el nivel de dificultad:');
  writeln('1. Fácil (8x8 con 10 minas)');
  writeln('2. Medio (16x16 con 40 minas)');
  writeln('3. Difícil (16x30 con 99 minas)');
  repeat
    write('Ingresa el número correspondiente al nivel de dificultad: ');
    readln(nivelDificultad);
    if (nivelDificultad < FACIL) or (nivelDificultad > DIFICIL) then
      writeln('Error: Debes ingresar 1, 2 o 3 para seleccionar el nivel de dificultad.');
  until (nivelDificultad >= FACIL) and (nivelDificultad <= DIFICIL);
  jugar(nivelDificultad);
end.
