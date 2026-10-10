clc;
clear;

% Configurar las carpetas
configurarProyecto;

disp('PRUEBAS DE LA SELECCION POR TORNEO');
disp('-----------------------------------');

% Semilla para repetir los resultados
rng(2);

% Tamaño del torneo
tamanoTorneo = 4;

%% PRUEBA 1: VIAJERO

disp(' ');
disp('1. PRUEBA CON EL VIAJERO');

[poblacionV, fitnessV] = poblacionViajero(10);

[seleccionadosV, fitnessSeleccionadosV, indicesV] = ...
    seleccionTorneo( ...
        poblacionV, fitnessV, tamanoTorneo ...
    );

disp('Fitness originales:');
disp(fitnessV);

disp('Indices ganadores:');
disp(indicesV);

disp('Fitness seleccionados:');
disp(fitnessSeleccionadosV);

%% PRUEBA 2: ACKLEY

disp(' ');
disp('2. PRUEBA CON ACKLEY');

[poblacionA, fitnessA] = ...
    poblacionAckley(10, 3, [-10 10]);

[seleccionadosA, fitnessSeleccionadosA, indicesA] = ...
    seleccionTorneo( ...
        poblacionA, fitnessA, tamanoTorneo ...
    );

disp('Fitness originales:');
disp(fitnessA);

disp('Indices ganadores:');
disp(indicesA);

disp('Fitness seleccionados:');
disp(fitnessSeleccionadosA);

%% PRUEBA 3: INVENTARIOS

disp(' ');
disp('3. PRUEBA CON INVENTARIOS');

[poblacionI, fitnessI] = poblacionInventario(10);

[seleccionadosI, fitnessSeleccionadosI, indicesI] = ...
    seleccionTorneo( ...
        poblacionI, fitnessI, tamanoTorneo ...
    );

disp('Fitness originales:');
disp(fitnessI);

disp('Indices ganadores:');
disp(indicesI);

disp('Fitness seleccionados:');
disp(fitnessSeleccionadosI);

%% VERIFICAR LA CANTIDAD SELECCIONADA

assert(size(seleccionadosV, 1) == 5, ...
    'El torneo del viajero no selecciono la mitad.');

assert(size(seleccionadosA, 1) == 5, ...
    'El torneo de Ackley no selecciono la mitad.');

assert(size(seleccionadosI, 1) == 5, ...
    'El torneo de inventarios no selecciono la mitad.');

%% VERIFICAR QUE NO EXISTAN GANADORES REPETIDOS

assert(length(unique(indicesV)) == 5, ...
    'El viajero tiene ganadores repetidos.');

assert(length(unique(indicesA)) == 5, ...
    'Ackley tiene ganadores repetidos.');

assert(length(unique(indicesI)) == 5, ...
    'Inventarios tiene ganadores repetidos.');

%% VERIFICAR LOS FITNESS

assert(isequal( ...
    fitnessSeleccionadosV, fitnessV(indicesV)), ...
    'Los fitness seleccionados del viajero son incorrectos.');

assert(max(abs( ...
    fitnessSeleccionadosA - fitnessA(indicesA))) < 1e-10, ...
    'Los fitness seleccionados de Ackley son incorrectos.');

assert(max(abs( ...
    fitnessSeleccionadosI - fitnessI(indicesI))) < 1e-8, ...
    'Los fitness seleccionados de inventarios son incorrectos.');

%% VERIFICAR LOS INDIVIDUOS

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
disp('Todas las pruebas de torneo fueron superadas.');