clc;
clear;

% Configurar las carpetas
configurarProyecto;

disp('PRUEBAS DE LA MUTACION DEL VIAJERO');
disp('-----------------------------------');

% Semilla para repetir resultados
rng(7);

% Individuo de prueba
individuo = 1:13;

%% PRUEBA 1: PROBABILIDAD DEL 100 %

disp(' ');
disp('1. MUTACION CON PROBABILIDAD DEL 100 %');

[individuoMutado, fueMutado, posiciones] = ...
    mutacionViajero(individuo, 1);

disp('Individuo original:');
disp(individuo);

disp('Individuo mutado:');
disp(individuoMutado);

fprintf('Posiciones intercambiadas: %d y %d\n', ...
    posiciones(1), posiciones(2));

fprintf('Fue mutado: %d\n', fueMutado);

% Debe haber mutación
assert(fueMutado, ...
    'No se aplico la mutacion con probabilidad 1.');

% Debe cambiar la ruta
assert(~isequal(individuoMutado, individuo), ...
    'El individuo no cambio.');

% Debe seguir siendo una permutación
assert(isequal(sort(individuoMutado), 1:13), ...
    'El individuo mutado no es una ruta valida.');

%% PRUEBA 2: PROBABILIDAD DEL 0 %

disp(' ');
disp('2. MUTACION CON PROBABILIDAD DEL 0 %');

[individuoSinMutacion, fueMutadoCero, posicionesCero] = ...
    mutacionViajero(individuo, 0);

disp('Resultado:');
disp(individuoSinMutacion);

fprintf('Fue mutado: %d\n', fueMutadoCero);

% No debe existir mutación
assert(~fueMutadoCero, ...
    'Se aplico una mutacion con probabilidad 0.');

assert(isequal(individuoSinMutacion, individuo), ...
    'El individuo cambio con probabilidad 0.');

assert(isequal(posicionesCero, [0 0]), ...
    'Las posiciones deberían ser [0 0].');

%% PRUEBA 3: COMPARAR LOS FITNESS

fitnessOriginal = fitnessViajero(individuo, false);

fitnessMutado = ...
    fitnessViajero(individuoMutado, false);

fprintf('Fitness original: %.0f minutos\n', ...
    fitnessOriginal);

fprintf('Fitness mutado: %.0f minutos\n', ...
    fitnessMutado);

%% PRUEBA 4: REALIZAR 100 MUTACIONES

for prueba = 1:100

    rutaPrueba = randperm(13);

    [rutaMutada, mutacionAplicada] = ...
        mutacionViajero(rutaPrueba, 1);

    assert(mutacionAplicada, ...
        'Una mutacion no fue aplicada.');

    assert(isequal(sort(rutaMutada), 1:13), ...
        'Una mutacion genero una ruta invalida.');

    assert(length(unique(rutaMutada)) == 13, ...
        'Una ruta mutada tiene elementos repetidos.');

    assert(~isequal(rutaPrueba, rutaMutada), ...
        'Una ruta no cambio despues de mutar.');
end

disp(' ');
disp('Las 100 mutaciones conservaron rutas validas.');
disp('Todas las pruebas de mutacion del viajero fueron superadas.');