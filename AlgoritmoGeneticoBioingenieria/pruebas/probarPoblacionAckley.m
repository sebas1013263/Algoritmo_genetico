clc;
clear;

% Configurar las carpetas del proyecto
configurarProyecto;

disp('PRUEBAS DE LA POBLACION DE ACKLEY');
disp('----------------------------------');

% Semilla para repetir los mismos valores aleatorios
rng(1);

% Parametros de la poblacion
n = 10;
d = 3;
limites = [-10 10];

% Generar la poblacion
[poblacion, fitness] = ...
    poblacionAckley(n, d, limites);

% Mostrar la poblacion
disp('Poblacion generada:');
disp(poblacion);

% Mostrar los fitness
disp('Fitness de cada individuo:');
disp(fitness);

%% Comprobar el tamaño

cantidadFilas = size(poblacion, 1);
cantidadColumnas = size(poblacion, 2);

fprintf('Cantidad de individuos: %d\n', cantidadFilas);
fprintf('Cantidad de dimensiones: %d\n', cantidadColumnas);

%% Verificar los limites

menorValor = min(poblacion(:));
mayorValor = max(poblacion(:));

fprintf('Menor valor generado: %.6f\n', menorValor);
fprintf('Mayor valor generado: %.6f\n', mayorValor);

valoresDentroDeLimites = ...
    all(poblacion(:) >= limites(1)) && ...
    all(poblacion(:) <= limites(2));

%% Verificar nuevamente los fitness

fitnessVerificados = zeros(n, 1);

for i = 1:n
    fitnessVerificados(i) = ...
        fitnessAckley(poblacion(i, :));
end

%% Encontrar el mejor individuo

[mejorFitness, posicionMejor] = min(fitness);

mejorIndividuo = poblacion(posicionMejor, :);

disp('Mejor individuo de la poblacion:');
disp(mejorIndividuo);

fprintf('Mejor fitness: %.10f\n', mejorFitness);

%% Pruebas automáticas

assert(cantidadFilas == n, ...
    'La poblacion no tiene la cantidad correcta de filas.');

assert(cantidadColumnas == d, ...
    'Los individuos no tienen las dimensiones correctas.');

assert(valoresDentroDeLimites, ...
    'La poblacion contiene valores fuera de los limites.');

assert(max(abs(fitness - fitnessVerificados)) < 1e-10, ...
    'Los fitness no corresponden con los individuos.');

disp(' ');
disp('Todas las pruebas de Ackley fueron superadas.');