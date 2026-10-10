clc;
clear;

% Configurar las carpetas
configurarProyecto;

disp('PRUEBAS DEL CRUCE ARITMETICO DE ACKLEY');
disp('---------------------------------------');

%% Definir los padres

padre1 = [2 -4 8];
padre2 = [-6 10 4];

% Usar un alfa conocido para comprobar los cálculos
alfaPrueba = 0.3;

%% Realizar el cruce

[hijo1, hijo2, alfa] = ...
    cruceAckley(padre1, padre2, alfaPrueba);

%% Mostrar resultados

disp('Padre 1:');
disp(padre1);

disp('Padre 2:');
disp(padre2);

fprintf('Valor de alfa: %.2f\n', alfa);

disp('Hijo 1:');
disp(hijo1);

disp('Hijo 2:');
disp(hijo2);

%% Calcular manualmente los resultados esperados

hijoEsperado1 = ...
    alfaPrueba .* padre1 + ...
    (1 - alfaPrueba) .* padre2;

hijoEsperado2 = ...
    (1 - alfaPrueba) .* padre1 + ...
    alfaPrueba .* padre2;

%% Verificaciones del cruce

assert(max(abs(hijo1 - hijoEsperado1)) < 1e-10, ...
    'El hijo 1 no se calculo correctamente.');

assert(max(abs(hijo2 - hijoEsperado2)) < 1e-10, ...
    'El hijo 2 no se calculo correctamente.');

assert(length(hijo1) == length(padre1), ...
    'El hijo 1 tiene dimensiones incorrectas.');

assert(length(hijo2) == length(padre2), ...
    'El hijo 2 tiene dimensiones incorrectas.');

%% Verificar los límites

assert(all(hijo1 >= -10) && all(hijo1 <= 10), ...
    'El hijo 1 salio de los limites.');

assert(all(hijo2 >= -10) && all(hijo2 <= 10), ...
    'El hijo 2 salio de los limites.');

%% Evaluar padres e hijos

fitnessPadre1 = fitnessAckley(padre1);
fitnessPadre2 = fitnessAckley(padre2);
fitnessHijo1 = fitnessAckley(hijo1);
fitnessHijo2 = fitnessAckley(hijo2);

fprintf('Fitness del padre 1: %.10f\n', fitnessPadre1);
fprintf('Fitness del padre 2: %.10f\n', fitnessPadre2);
fprintf('Fitness del hijo 1: %.10f\n', fitnessHijo1);
fprintf('Fitness del hijo 2: %.10f\n', fitnessHijo2);

%% Probar 100 cruces aleatorios

rng(5);

for prueba = 1:100

    % Generar padres aleatorios en tres dimensiones
    padrePrueba1 = -10 + 20 .* rand(1, 3);
    padrePrueba2 = -10 + 20 .* rand(1, 3);

    % No enviar alfa para que sea aleatorio
    [hijoPrueba1, hijoPrueba2, alfaAleatorio] = ...
        cruceAckley(padrePrueba1, padrePrueba2);

    % Comprobar alfa
    assert(alfaAleatorio >= 0 && alfaAleatorio <= 1, ...
        'Se genero un alfa invalido.');

    % Comprobar dimensiones
    assert(length(hijoPrueba1) == 3, ...
        'El hijo 1 tiene dimensiones incorrectas.');

    assert(length(hijoPrueba2) == 3, ...
        'El hijo 2 tiene dimensiones incorrectas.');

    % Comprobar límites
    assert(all(hijoPrueba1 >= -10) && ...
           all(hijoPrueba1 <= 10), ...
        'El hijo 1 salio de los limites.');

    assert(all(hijoPrueba2 >= -10) && ...
           all(hijoPrueba2 <= 10), ...
        'El hijo 2 salio de los limites.');
end

disp(' ');
disp('Los 100 cruces permanecieron dentro de los limites.');
disp('Todas las pruebas del cruce de Ackley fueron superadas.');