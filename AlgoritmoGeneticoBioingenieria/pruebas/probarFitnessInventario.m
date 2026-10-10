clc;
clear;

% Configurar las carpetas del proyecto
configurarProyecto;

disp('PRUEBAS DE LA FUNCION DE INVENTARIOS');
disp('-------------------------------------');

%% Prueba 1: individuo valido

Q = [500 1500 3000 1800 3200];
S = [100 600 1200 400 700];
K = [250 1000 2500 750 1500];

individuoValido = [Q S K];

% Verificar manualmente la inversion
inversion = sum(Q ./ 2 + S);

fprintf('Inversion del individuo: %.2f\n', inversion);

% Evaluar la funcion objetivo
resultadoValido = fitnessInventario(individuoValido);

fprintf('Resultado Z del individuo valido: %.10f\n', ...
    resultadoValido);

%% Prueba 2: individuo que no cumple la inversion

individuoInvalido = individuoValido;

% Modificar Q1 para romper la restriccion
individuoInvalido(1) = 600;

resultadoInvalido = fitnessInventario(individuoInvalido);

fprintf('Resultado del individuo invalido: %.0f\n', ...
    resultadoInvalido);

%% Prueba 3: individuo con una variable fuera del limite

individuoFueraLimite = individuoValido;

% S1 tiene un maximo de 200
individuoFueraLimite(6) = 300;

resultadoFueraLimite = ...
    fitnessInventario(individuoFueraLimite);

fprintf('Resultado fuera del limite: %.0f\n', ...
    resultadoFueraLimite);

%% Verificaciones automaticas

resultadoEsperado = 1239.8172189961;
tolerancia = 1e-4;
penalizacionEsperada = 1e12;

assert(abs(resultadoValido - resultadoEsperado) < tolerancia, ...
    'El resultado del individuo valido no es correcto.');

assert(resultadoInvalido == penalizacionEsperada, ...
    'No se penalizo la inversion incorrecta.');

assert(resultadoFueraLimite == penalizacionEsperada, ...
    'No se penalizo la variable fuera del limite.');

disp(' ');
disp('Todas las pruebas de inventarios fueron superadas.');