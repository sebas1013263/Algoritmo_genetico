clc;
clear;

% Configurar las carpetas del proyecto
configurarProyecto;

disp('PRUEBAS DE LA SELECCION POR ELITISMO');
disp('-------------------------------------');

% Semilla para repetir los valores aleatorios
rng(1);

%% PRUEBA 1: VIAJERO

disp(' ');
disp('1. PRUEBA CON EL VIAJERO');

[poblacionV, fitnessV] = poblacionViajero(10);

[seleccionadosV, fitnessSeleccionadosV, indicesV] = ...
    seleccionElitismo(poblacionV, fitnessV);

disp('Fitness originales:');
disp(fitnessV);

disp('Fitness seleccionados:');
disp(fitnessSeleccionadosV);

disp('Indices seleccionados:');
disp(indicesV);

%% PRUEBA 2: ACKLEY

disp(' ');
disp('2. PRUEBA CON ACKLEY');

[poblacionA, fitnessA] = ...
    poblacionAckley(10, 3, [-10 10]);

[seleccionadosA, fitnessSeleccionadosA, indicesA] = ...
    seleccionElitismo(poblacionA, fitnessA);

disp('Fitness originales:');
disp(fitnessA);

disp('Fitness seleccionados:');
disp(fitnessSeleccionadosA);

disp('Indices seleccionados:');
disp(indicesA);

%% PRUEBA 3: INVENTARIOS

disp(' ');
disp('3. PRUEBA CON INVENTARIOS');

[poblacionI, fitnessI] = poblacionInventario(10);

[seleccionadosI, fitnessSeleccionadosI, indicesI] = ...
    seleccionElitismo(poblacionI, fitnessI);

disp('Fitness originales:');
disp(fitnessI);

disp('Fitness seleccionados:');
disp(fitnessSeleccionadosI);

disp('Indices seleccionados:');
disp(indicesI);

%% VERIFICACIONES AUTOMATICAS

% Ordenar manualmente los fitness
fitnessVOrdenados = sort(fitnessV, 'ascend');
fitnessAOrdenados = sort(fitnessA, 'ascend');
fitnessIOrdenados = sort(fitnessI, 'ascend');

% Verificar cantidad de seleccionados
assert(size(seleccionadosV, 1) == 5, ...
    'El viajero no selecciono la mitad.');

assert(size(seleccionadosA, 1) == 5, ...
    'Ackley no selecciono la mitad.');

assert(size(seleccionadosI, 1) == 5, ...
    'Inventarios no selecciono la mitad.');

% Verificar cantidad de columnas
assert(size(seleccionadosV, 2) == 13, ...
    'Los individuos del viajero fueron modificados.');

assert(size(seleccionadosA, 2) == 3, ...
    'Los individuos de Ackley fueron modificados.');

assert(size(seleccionadosI, 2) == 15, ...
    'Los individuos de inventarios fueron modificados.');

% Verificar que escogio los menores fitness
assert(isequal( ...
    fitnessSeleccionadosV, fitnessVOrdenados(1:5)), ...
    'El elitismo del viajero es incorrecto.');

assert(max(abs( ...
    fitnessSeleccionadosA - fitnessAOrdenados(1:5))) < 1e-10, ...
    'El elitismo de Ackley es incorrecto.');

assert(max(abs( ...
    fitnessSeleccionadosI - fitnessIOrdenados(1:5))) < 1e-8, ...
    'El elitismo de inventarios es incorrecto.');

% Verificar que el mejor individuo no se perdio
assert(min(fitnessV) == min(fitnessSeleccionadosV), ...
    'Se perdio el mejor individuo del viajero.');

assert(abs(min(fitnessA) - min(fitnessSeleccionadosA)) < 1e-10, ...
    'Se perdio el mejor individuo de Ackley.');

assert(abs(min(fitnessI) - min(fitnessSeleccionadosI)) < 1e-8, ...
    'Se perdio el mejor individuo de inventarios.');

disp(' ');
disp('Todas las pruebas de elitismo fueron superadas.');