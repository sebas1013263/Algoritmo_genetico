function tiempoTotal = fitnessViajero(ruta, regresarInicio)
% FITNESSVIAJERO calcula el tiempo total de una ruta.
%
% ruta:
% Vector con una permutacion de los numeros del 1 al 13.
%
% regresarInicio:
% true  = regresa al lugar donde comenzo.
% false = termina en el ultimo lugar de la ruta.
%
% tiempoTotal:
% Tiempo total del recorrido en minutos.

% Si no se envia el segundo argumento, no se regresa al inicio
if nargin < 2
    regresarInicio = false;
end

% Matriz de tiempos entre los 13 lugares
matrizTiempos = [
    0  10  35  29  16  30  40  27  56  44  67  54  81;
    6   0  32  31  16  32  34  28  52  44  63  56  83;
    34  32   0  29  45  58  35  57  26  73  91  83 110;
    29  29  28   0  32  47  57  31  49  61  67  70  99;
    18  18  46  33   0  23  52  19  68  39  54  41  69;
    30  30  58  46  25   0  46  36  79  39  71  62  90;
    40  37  36  59  52  54   0  64  61  80 104  89 117;
    32  32  57  32  18  36  65   0  82  50  41  51  82;
    55  52  23  48  67  80  56  73   0  95 116 101 130;
    47  47  76  62  42  37  73  53  97   0 102  81 111;
    79  79 106  80  66  87 110  59 148 101   0  97 100;
    59  59  86  74  44  65  90  55 107  80  93   0  29;
    89  89 116 104  74  96 119  86 137 110 103  33   0
    ];

% Verificar que la ruta sea una permutacion del 1 al 13
rutaOrdenada = sort(ruta(:))';

if length(ruta) ~= 13 || ~isequal(rutaOrdenada, 1:13)
    tiempoTotal = 10000;
    return;
end

% Inicializar el tiempo del recorrido
tiempoTotal = 0;

% Sumar el tiempo entre lugares consecutivos
for i = 1:length(ruta) - 1
    origen = ruta(i);
    destino = ruta(i + 1);

    tiempoTotal = tiempoTotal + matrizTiempos(origen, destino);
end

% Agregar el tiempo de regreso al punto inicial
if regresarInicio
    ultimoLugar = ruta(end);
    primerLugar = ruta(1);

    tiempoTotal = tiempoTotal + ...
        matrizTiempos(ultimoLugar, primerLugar);
end
end