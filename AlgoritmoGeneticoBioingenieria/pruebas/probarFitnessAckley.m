clc;
clear;

% Configurar las carpetas del proyecto
configurarProyecto;

disp('PRUEBAS DE LA FUNCION DE ACKLEY');
disp('--------------------------------');

% Valor optimo conocido de la funcion modificada
valorOptimo = 3 - exp(1);

%% Prueba 1: vector de tres dimensiones en cero

X1 = [0 0 0];

resultado1 = fitnessAckley(X1);

fprintf('Ackley en [0 0 0]: %.10f\n', resultado1);
fprintf('Valor optimo esperado: %.10f\n', valorOptimo);

%% Prueba 2: vector de dos dimensiones

X2 = [1 1];

resultado2 = fitnessAckley(X2);

fprintf('Ackley en [1 1]: %.10f\n', resultado2);

%% Prueba 3: vector de cinco dimensiones en cero

X3 = zeros(1, 5);

resultado3 = fitnessAckley(X3);

fprintf('Ackley en 5 dimensiones en cero: %.10f\n', ...
    resultado3);

%% Prueba 4: vector de 100 dimensiones en cero

X4 = zeros(1, 100);

resultado4 = fitnessAckley(X4);

fprintf('Ackley en 100 dimensiones en cero: %.10f\n', ...
    resultado4);

%% Verificaciones automaticas

tolerancia = 1e-10;

assert(abs(resultado1 - valorOptimo) < tolerancia, ...
    'El resultado para tres dimensiones no es correcto.');

assert(abs(resultado3 - valorOptimo) < tolerancia, ...
    'El resultado para cinco dimensiones no es correcto.');

assert(abs(resultado4 - valorOptimo) < tolerancia, ...
    'El resultado para 100 dimensiones no es correcto.');

assert(resultado2 > valorOptimo, ...
    'El vector [1 1] no deberia superar al punto optimo.');

disp(' ');
disp('Todas las pruebas de Ackley fueron superadas.');