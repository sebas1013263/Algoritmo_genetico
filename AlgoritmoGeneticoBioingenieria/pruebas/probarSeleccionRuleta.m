clc;
clear;

% Configurar las carpetas
configurarProyecto;

disp('PRUEBAS DE LA SELECCION POR RULETA');
disp('-----------------------------------');

% Semilla para repetir los resultados
rng(3);

%% PRUEBA 1: VIAJERO

disp(' ');
disp('1. PRUEBA CON EL VIAJERO');

[poblacionV, fitnessV] = poblacionViajero(10);

[seleccionadosV, fitnessSeleccionadosV, ...
 indicesV, probabilidadesV] = ...
    seleccionRuleta(poblacionV, fitnessV);

disp('Fitness y probabilidades:');
disp([fitnessV probabilidadesV]);

disp('Indices seleccionados:');
disp(indicesV);

disp('Fitness seleccionados:');
disp(fitnessSeleccionadosV);

%% PRUEBA 2: ACKLEY

disp(' ');
disp('2. PRUEBA CON ACKLEY');

[poblacionA, fitnessA] = ...
    poblacionAckley(10, 3, [-10 10]);

[seleccionadosA, fitnessSeleccionadosA, ...
 indicesA, probabilidadesA] = ...
    seleccionRuleta(poblacionA, fitnessA);

disp('Fitness y probabilidades:');
disp([fitnessA probabilidadesA]);

disp('Indices seleccionados:');
disp(indicesA);

disp('Fitness seleccionados:');
disp(fitnessSeleccionadosA);

%% PRUEBA 3: INVENTARIOS

disp(' ');
disp('3. PRUEBA CON INVENTARIOS');

[poblacionI, fitnessI] = poblacionInventario(10);

[seleccionadosI, fitnessSeleccionadosI, ...
 indicesI, probabilidadesI] = ...
    seleccionRuleta(poblacionI, fitnessI);

disp('Fitness y probabilidades:');
disp([fitnessI probabilidadesI]);

disp('Indices seleccionados:');
disp(indicesI);

disp('Fitness seleccionados:');
disp(fitnessSeleccionadosI);

%% VERIFICAR QUE LAS PROBABILIDADES SUMEN 1

assert(abs(sum(probabilidadesV) - 1) < 1e-10, ...
    'Las probabilidades del viajero no suman 1.');

assert(abs(sum(probabilidadesA) - 1) < 1e-10, ...
    'Las probabilidades de Ackley no suman 1.');

assert(abs(sum(probabilidadesI) - 1) < 1e-10, ...
    'Las probabilidades de inventarios no suman 1.');

%% VERIFICAR QUE EL MEJOR TENGA LA MAYOR PROBABILIDAD

[~, mejorV] = min(fitnessV);
[~, mejorA] = min(fitnessA);
[~, mejorI] = min(fitnessI);

assert(abs( ...
    probabilidadesV(mejorV) - max(probabilidadesV)) < 1e-10, ...
    'El mejor viajero no tiene la mayor probabilidad.');

assert(abs( ...
    probabilidadesA(mejorA) - max(probabilidadesA)) < 1e-10, ...
    'El mejor Ackley no tiene la mayor probabilidad.');

assert(abs( ...
    probabilidadesI(mejorI) - max(probabilidadesI)) < 1e-10, ...
    'El mejor inventario no tiene la mayor probabilidad.');

%% VERIFICAR LA CANTIDAD SELECCIONADA

assert(size(seleccionadosV, 1) == 5, ...
    'La ruleta del viajero no selecciono la mitad.');

assert(size(seleccionadosA, 1) == 5, ...
    'La ruleta de Ackley no selecciono la mitad.');

assert(size(seleccionadosI, 1) == 5, ...
    'La ruleta de inventarios no selecciono la mitad.');

%% VERIFICAR QUE NO HAYA REPETIDOS

assert(length(unique(indicesV)) == 5, ...
    'La ruleta del viajero repitio individuos.');

assert(length(unique(indicesA)) == 5, ...
    'La ruleta de Ackley repitio individuos.');

assert(length(unique(indicesI)) == 5, ...
    'La ruleta de inventarios repitio individuos.');

%% VERIFICAR LOS FITNESS SELECCIONADOS

assert(isequal( ...
    fitnessSeleccionadosV, fitnessV(indicesV)), ...
    'Los fitness seleccionados del viajero son incorrectos.');

assert(max(abs( ...
    fitnessSeleccionadosA - fitnessA(indicesA))) < 1e-10, ...
    'Los fitness seleccionados de Ackley son incorrectos.');

assert(max(abs( ...
    fitnessSeleccionadosI - fitnessI(indicesI))) < 1e-8, ...
    'Los fitness seleccionados de inventarios son incorrectos.');

%% VERIFICAR LOS INDIVIDUOS SELECCIONADOS

assert(isequal( ...
    seleccionadosV, poblacionV(indicesV, :)), ...
    'Los individuos seleccionados del viajero son incorrectos.');

assert(isequal( ...
    seleccionadosA, poblacionA(indicesA, :)), ...
    'Los individuos seleccionados de Ackley son incorrectos.');

assert(isequal( ...
    seleccionadosI, poblacionI(indicesI, :)), ...
    'Los individuos seleccionados de inventarios son incorrectos.');

disp(' ');
disp('Todas las pruebas de ruleta fueron superadas.');