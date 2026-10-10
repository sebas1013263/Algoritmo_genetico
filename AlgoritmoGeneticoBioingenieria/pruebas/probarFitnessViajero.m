clc;
clear;

% Ejecutar la configuracion general del proyecto
configurarProyecto;

disp('PRUEBAS DE LA FUNCION DEL VIAJERO');
disp('--------------------------------');

% Ruta presentada como ejemplo en la guia
rutaEjemplo = 1:13;

% Prueba 1: recorrido sin regresar al inicio
tiempoSinRegreso = fitnessViajero(rutaEjemplo, false);

fprintf('Tiempo sin regresar: %.0f minutos\n', tiempoSinRegreso);

% Prueba 2: recorrido regresando al inicio
tiempoConRegreso = fitnessViajero(rutaEjemplo, true);

fprintf('Tiempo regresando al inicio: %.0f minutos\n', ...
    tiempoConRegreso);

% Prueba 3: ruta invalida porque se repite el numero 12
rutaInvalida = [1 2 3 4 5 6 7 8 9 10 11 12 12];

resultadoInvalido = fitnessViajero(rutaInvalida, false);

fprintf('Resultado de la ruta invalida: %.0f\n', ...
    resultadoInvalido);

% Verificaciones automaticas
assert(tiempoSinRegreso == 641, ...
    'La prueba sin regreso no produjo 641 minutos.');

assert(tiempoConRegreso == 730, ...
    'La prueba con regreso no produjo 730 minutos.');

assert(resultadoInvalido == 10000, ...
    'La ruta invalida no fue penalizada correctamente.');

disp(' ');
disp('Todas las pruebas fueron superadas correctamente.');