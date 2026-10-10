clc;
clear;

% Configurar las carpetas
configurarProyecto;

disp('PRUEBAS DE LA MUTACION DE INVENTARIOS');
disp('--------------------------------------');

format long g;

% Semilla
rng(10);

% Generar un individuo válido
[poblacion, fitnessInicial] = poblacionInventario(1);

individuo = poblacion(1, :);

% Parámetros
probabilidadMutacion = 1;
proporcionSigma = 0.05;

%% PRUEBA 1: PROBABILIDAD DEL 100 %

[individuoMutado, fueMutado, posicionMutada, ...
 cambioAplicado, sigmaUtilizado] = ...
    mutacionInventario( ...
        individuo, ...
        probabilidadMutacion, ...
        proporcionSigma ...
    );

disp('Individuo original:');
disp(individuo);

disp('Individuo mutado y reparado:');
disp(individuoMutado);

fprintf('Posicion seleccionada: %d\n', posicionMutada);
fprintf('Sigma utilizado: %.10f\n', sigmaUtilizado);
fprintf('Cambio generado: %.10f\n', cambioAplicado);
fprintf('Fue mutado: %d\n', fueMutado);

%% Separar las variables

Q = individuoMutado(1:5);
S = individuoMutado(6:10);
K = individuoMutado(11:15);

inversion = sum(Q ./ 2 + S);

fitnessMutado = fitnessInventario(individuoMutado);

fprintf('Inversion después de mutar: %.10f\n', inversion);
fprintf('Fitness original: %.10f\n', fitnessInicial);
fprintf('Fitness mutado: %.10f\n', fitnessMutado);

%% Límites

limiteSuperiorS = [200 1200 2500 800 1500];
limiteSuperiorK = [500 2000 5000 1500 3000];

%% Verificaciones

assert(fueMutado, ...
    'No se aplico la mutacion con probabilidad 1.');

assert(posicionMutada ~= 5, ...
    'La mutacion modifico directamente Q5.');

assert(ismember(posicionMutada, [1:4 6:15]), ...
    'Se selecciono una posicion dependiente.');

assert(all(Q > 0) && all(Q < 16000), ...
    'Existen valores Q invalidos.');

assert(all(S >= 0) && all(S <= limiteSuperiorS), ...
    'Existen valores S invalidos.');

assert(all(K >= 0) && all(K <= limiteSuperiorK), ...
    'Existen valores K invalidos.');

assert(abs(inversion - 8000) < 1e-6, ...
    'El individuo no cumple la inversion.');

assert(fitnessMutado < 1e12, ...
    'El individuo mutado recibio una penalizacion.');

%% PRUEBA 2: PROBABILIDAD DEL 0 %

[individuoSinMutacion, fueMutadoCero, ...
 posicionCero, cambioCero, sigmaCero] = ...
    mutacionInventario( ...
        individuo, ...
        0, ...
        proporcionSigma ...
    );

assert(~fueMutadoCero, ...
    'Se aplico una mutacion con probabilidad 0.');

assert(isequal(individuoSinMutacion, individuo), ...
    'El individuo cambio con probabilidad 0.');

assert(posicionCero == 0, ...
    'La posicion debería ser 0.');

assert(cambioCero == 0, ...
    'El cambio debería ser 0.');

assert(sigmaCero == 0, ...
    'Sigma debería ser 0.');

%% PRUEBA 3: REALIZAR 100 MUTACIONES

individuoPrueba = individuo;

for prueba = 1:100

    [individuoPrueba, mutacionAplicada, posicionPrueba] = ...
        mutacionInventario( ...
            individuoPrueba, ...
            1, ...
            0.05 ...
        );

    QPrueba = individuoPrueba(1:5);
    SPrueba = individuoPrueba(6:10);
    KPrueba = individuoPrueba(11:15);

    inversionPrueba = ...
        sum(QPrueba ./ 2 + SPrueba);

    assert(mutacionAplicada, ...
        'Una mutacion no fue aplicada.');

    assert(posicionPrueba ~= 5, ...
        'Una mutacion modifico directamente Q5.');

    assert(all(QPrueba > 0) && ...
           all(QPrueba < 16000), ...
        'Una mutacion genero Q invalidos.');

    assert(all(SPrueba >= 0) && ...
           all(SPrueba <= limiteSuperiorS), ...
        'Una mutacion genero S invalidos.');

    assert(all(KPrueba >= 0) && ...
           all(KPrueba <= limiteSuperiorK), ...
        'Una mutacion genero K invalidos.');

    assert(abs(inversionPrueba - 8000) < 1e-6, ...
        'Una mutacion incumplio la inversion.');

    assert(fitnessInventario(individuoPrueba) < 1e12, ...
        'Una mutacion genero un individuo invalido.');
end

disp(' ');
disp('Las 100 mutaciones conservaron individuos validos.');
disp('Todas las pruebas de mutacion de inventarios fueron superadas.');

format short;