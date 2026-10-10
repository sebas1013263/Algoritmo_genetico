clc;
clear;

% Configurar las carpetas
configurarProyecto;

disp('PRUEBAS DEL CRUCE DE INVENTARIOS');
disp('---------------------------------');

% Mostrar los números con suficiente precisión
format long g;

% Semilla para repetir la prueba
rng(6);

%% Generar dos padres válidos

[poblacion, fitnessPadres] = poblacionInventario(2);

padre1 = poblacion(1, :);
padre2 = poblacion(2, :);

% Alfa conocido
alfaPrueba = 0.35;

%% Realizar el cruce

[hijo1, hijo2, alfa] = ...
    cruceInventario(padre1, padre2, alfaPrueba);

%% Mostrar resultados

disp('Padre 1:');
disp(padre1);

disp('Padre 2:');
disp(padre2);

fprintf('Alfa utilizado: %.2f\n', alfa);

disp('Hijo 1:');
disp(hijo1);

disp('Hijo 2:');
disp(hijo2);

%% Separar las variables de los hijos

Q1 = hijo1(1:5);
S1 = hijo1(6:10);
K1 = hijo1(11:15);

Q2 = hijo2(1:5);
S2 = hijo2(6:10);
K2 = hijo2(11:15);

%% Calcular las inversiones

inversionHijo1 = sum(Q1 ./ 2 + S1);
inversionHijo2 = sum(Q2 ./ 2 + S2);

fprintf('Inversion del hijo 1: %.10f\n', inversionHijo1);
fprintf('Inversion del hijo 2: %.10f\n', inversionHijo2);

%% Calcular los fitness

fitnessHijo1 = fitnessInventario(hijo1);
fitnessHijo2 = fitnessInventario(hijo2);

fprintf('Fitness del padre 1: %.10f\n', fitnessPadres(1));
fprintf('Fitness del padre 2: %.10f\n', fitnessPadres(2));
fprintf('Fitness del hijo 1: %.10f\n', fitnessHijo1);
fprintf('Fitness del hijo 2: %.10f\n', fitnessHijo2);

%% Límites

limiteSuperiorS = [200 1200 2500 800 1500];
limiteSuperiorK = [500 2000 5000 1500 3000];

%% Verificaciones de los hijos

assert(all(Q1 > 0) && all(Q1 < 16000), ...
    'El hijo 1 tiene valores Q inválidos.');

assert(all(Q2 > 0) && all(Q2 < 16000), ...
    'El hijo 2 tiene valores Q inválidos.');

assert(all(S1 >= 0) && all(S1 <= limiteSuperiorS), ...
    'El hijo 1 tiene valores S inválidos.');

assert(all(S2 >= 0) && all(S2 <= limiteSuperiorS), ...
    'El hijo 2 tiene valores S inválidos.');

assert(all(K1 >= 0) && all(K1 <= limiteSuperiorK), ...
    'El hijo 1 tiene valores K inválidos.');

assert(all(K2 >= 0) && all(K2 <= limiteSuperiorK), ...
    'El hijo 2 tiene valores K inválidos.');

assert(abs(inversionHijo1 - 8000) < 1e-6, ...
    'El hijo 1 no cumple la inversion.');

assert(abs(inversionHijo2 - 8000) < 1e-6, ...
    'El hijo 2 no cumple la inversion.');

assert(fitnessHijo1 < 1e12, ...
    'El hijo 1 recibio una penalizacion.');

assert(fitnessHijo2 < 1e12, ...
    'El hijo 2 recibio una penalizacion.');

%% Realizar 100 cruces aleatorios

for prueba = 1:100

    [poblacionPrueba, ~] = poblacionInventario(2);

    padrePrueba1 = poblacionPrueba(1, :);
    padrePrueba2 = poblacionPrueba(2, :);

    [hijoPrueba1, hijoPrueba2] = ...
        cruceInventario(padrePrueba1, padrePrueba2);

    QPrueba1 = hijoPrueba1(1:5);
    SPrueba1 = hijoPrueba1(6:10);

    QPrueba2 = hijoPrueba2(1:5);
    SPrueba2 = hijoPrueba2(6:10);

    inversionPrueba1 = ...
        sum(QPrueba1 ./ 2 + SPrueba1);

    inversionPrueba2 = ...
        sum(QPrueba2 ./ 2 + SPrueba2);

    assert(abs(inversionPrueba1 - 8000) < 1e-6, ...
        'Un hijo 1 no cumplio la inversion.');

    assert(abs(inversionPrueba2 - 8000) < 1e-6, ...
        'Un hijo 2 no cumplio la inversion.');

    assert(fitnessInventario(hijoPrueba1) < 1e12, ...
        'Se genero un hijo 1 inválido.');

    assert(fitnessInventario(hijoPrueba2) < 1e12, ...
        'Se genero un hijo 2 inválido.');
end

disp(' ');
disp('Los 100 cruces generaron individuos validos.');
disp('Todas las pruebas del cruce de inventarios fueron superadas.');

% Volver al formato numérico normal
format short;