clc;
clear;

% Configurar las carpetas del proyecto
configurarProyecto;

disp('PRUEBAS DE LA POBLACION DEL VIAJERO');
disp('------------------------------------');

% Utilizar una semilla para que la prueba sea repetible
rng(1);

% Tamaño de la población
n = 10;

% Generar la población
[poblacion, fitness] = poblacionViajero(n);

% Mostrar la población completa
disp('Poblacion generada:');
disp(poblacion);

% Mostrar el fitness de cada individuo
disp('Fitness de cada individuo:');
disp(fitness);

%% Comprobar el tamaño de la población

cantidadFilas = size(poblacion, 1);
cantidadColumnas = size(poblacion, 2);

fprintf('Cantidad de individuos: %d\n', cantidadFilas);
fprintf('Cantidad de elementos por individuo: %d\n', ...
    cantidadColumnas);

%% Verificar que todas las rutas sean válidas

todasLasRutasSonValidas = true;

for i = 1:n

    rutaOrdenada = sort(poblacion(i, :));

    if ~isequal(rutaOrdenada, 1:13)
        todasLasRutasSonValidas = false;
    end
end

%% Verificar nuevamente los fitness

fitnessVerificados = zeros(n, 1);

for i = 1:n
    fitnessVerificados(i) = ...
        fitnessViajero(poblacion(i, :), false);
end

%% Encontrar al mejor individuo

[mejorFitness, posicionMejor] = min(fitness);

mejorRuta = poblacion(posicionMejor, :);

disp('Mejor ruta de la poblacion:');
disp(mejorRuta);

fprintf('Mejor fitness: %.0f minutos\n', mejorFitness);

%% Pruebas automáticas

assert(cantidadFilas == n, ...
    'La poblacion no tiene la cantidad correcta de individuos.');

assert(cantidadColumnas == 13, ...
    'Los individuos no tienen 13 elementos.');

assert(todasLasRutasSonValidas, ...
    'La poblacion contiene alguna ruta invalida.');

assert(isequal(fitness, fitnessVerificados), ...
    'Los fitness no corresponden con las rutas.');

disp(' ');
disp('Todas las pruebas de la poblacion fueron superadas.');