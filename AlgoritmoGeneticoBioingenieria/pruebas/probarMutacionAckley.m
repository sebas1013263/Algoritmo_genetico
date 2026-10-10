clc;
clear;

% Configurar las carpetas
configurarProyecto;

disp('PRUEBAS DE LA MUTACION DE ACKLEY');
disp('---------------------------------');

% Semilla para repetir resultados
rng(8);

% Individuo de prueba
individuo = [0 0 0];

% Parámetros
probabilidadMutacion = 1;
sigmaM = 1;
limites = [-10 10];

%% PRUEBA 1: PROBABILIDAD DEL 100 %

disp(' ');
disp('1. MUTACION CON PROBABILIDAD DEL 100 %');

[individuoMutado, fueMutado, ...
 posicionMutada, cambioAplicado] = ...
    mutacionAckley( ...
        individuo, ...
        probabilidadMutacion, ...
        sigmaM, ...
        limites ...
    );

disp('Individuo original:');
disp(individuo);

disp('Individuo mutado:');
disp(individuoMutado);

fprintf('Posicion mutada: %d\n', posicionMutada);
fprintf('Cambio generado: %.10f\n', cambioAplicado);
fprintf('Fue mutado: %d\n', fueMutado);

% Comprobar que se aplicó
assert(fueMutado, ...
    'No se aplico la mutacion con probabilidad 1.');

% Comprobar la posición
assert(posicionMutada >= 1 && posicionMutada <= 3, ...
    'La posicion mutada es incorrecta.');

% Comprobar que solo cambió una posición
cantidadCambios = sum( ...
    abs(individuoMutado - individuo) > 1e-12 ...
);

assert(cantidadCambios == 1, ...
    'La mutacion cambio mas de una posicion.');

% Comprobar los límites
assert(all(individuoMutado >= -10) && ...
       all(individuoMutado <= 10), ...
    'El individuo mutado salio de los limites.');

%% PRUEBA 2: PROBABILIDAD DEL 0 %

disp(' ');
disp('2. MUTACION CON PROBABILIDAD DEL 0 %');

[individuoSinMutacion, fueMutadoCero, ...
 posicionCero, cambioCero] = ...
    mutacionAckley(individuo, 0, sigmaM, limites);

disp('Resultado:');
disp(individuoSinMutacion);

assert(~fueMutadoCero, ...
    'Se aplico una mutacion con probabilidad 0.');

assert(isequal(individuoSinMutacion, individuo), ...
    'El individuo cambio con probabilidad 0.');

assert(posicionCero == 0, ...
    'La posicion debería ser 0.');

assert(cambioCero == 0, ...
    'El cambio debería ser 0.');

%% PRUEBA 3: COMPARAR LOS FITNESS

fitnessOriginal = fitnessAckley(individuo);
fitnessMutado = fitnessAckley(individuoMutado);

fprintf('Fitness original: %.10f\n', ...
    fitnessOriginal);

fprintf('Fitness mutado: %.10f\n', ...
    fitnessMutado);

%% PRUEBA 4: REALIZAR 100 MUTACIONES

rng(9);

for prueba = 1:100

    % Individuo aleatorio de cinco dimensiones
    individuoPrueba = ...
        -10 + 20 .* rand(1, 5);

    [mutadoPrueba, fueMutadoPrueba] = ...
        mutacionAckley( ...
            individuoPrueba, ...
            1, ...
            2, ...
            [-10 10] ...
        );

    % Debe mutar
    assert(fueMutadoPrueba, ...
        'No se aplico una mutacion.');

    % Debe conservar las dimensiones
    assert(length(mutadoPrueba) == 5, ...
        'Se modifico la cantidad de dimensiones.');

    % Debe conservar los límites
    assert(all(mutadoPrueba >= -10) && ...
           all(mutadoPrueba <= 10), ...
        'Una mutacion salio de los limites.');

    % Solo puede cambiar una posición
    cantidadCambiosPrueba = sum( ...
        abs(mutadoPrueba - individuoPrueba) > 1e-12 ...
    );

    assert(cantidadCambiosPrueba <= 1, ...
        'Una mutacion modifico mas de una posicion.');
end

disp(' ');
disp('Las 100 mutaciones permanecieron dentro de los limites.');
disp('Todas las pruebas de mutacion de Ackley fueron superadas.');