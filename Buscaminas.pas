program buscaminas;

uses
  crt;
const
  FACIL = 1;
  MEDIO = 2;
  DIFICIL = 3;
var
  TAMANO: array[1..3, 1..2] of integer = ((8, 8), (16, 16), (16, 30));
  MINAS: array[1..3] of integer = (10, 40, 99);

begin
writeln('¡Bienvenido a Buscaminas!');
end.
