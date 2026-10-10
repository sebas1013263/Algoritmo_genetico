clc;
clear;

% Configurar las carpetas del proyecto
configurarProyecto;

disp('PRUEBAS DEL CRUCE OX PARA EL VIAJERO');
disp('-------------------------------------');

% Semilla para repetir el ejemplo
rng(4);

%% Definir los padres

padre1 = 1:13;

padre2 = [ ...
    4 7 2 1 9 3 12 6 5 13 8 10 11 ...
];

%% Realizar el cruce

[hijo1, hijo2, puntosCorte] = ...
    cruceViajero(padre1, padre2);

%% Mostrar los resultados

disp('Padre 1:');
disp(padre1);

disp('Padre 2:');
disp(padre2);

fprintf('Puntos de corte: %d y %d\n', ...
    puntosCorte(1), puntosCorte(2));

disp('Hijo 1:');
disp(hijo1);

disp('Hijo 2:');
disp(hijo2);

%% Verificar los segmentos heredados

punto1 = puntosCorte(1);
punto2 = puntosCorte(2);

segmentoPadre1 = padre1(punto1:punto2);
segmentoPadre2 = padre2(punto1:punto2);

segmentoHijo1 = hijo1(punto1:punto2);
segmentoHijo2 = hijo2(punto1:punto2);

assert(isequal(segmentoHijo1, segmentoPadre1), ...
    'El hijo 1 no conservo el segmento del padre 1.');

assert(isequal(segmentoHijo2, segmentoPadre2), ...
    'El hijo 2 no conservo el segmento del padre 2.');

%% Verificar que los hijos sean permutaciones válidas

assert(isequal(sort(hijo1), 1:13), ...
    'El hijo 1 no es una ruta valida.');

assert(isequal(sort(hijo2), 1:13), ...
    'El hijo 2 no es una ruta valida.');

assert(length(unique(hijo1)) == 13, ...
    'El hijo 1 tiene elementos repetidos.');

assert(length(unique(hijo2)) == 13, ...
    'El hijo 2 tiene elementos repetidos.');

%% Evaluar los padres y los hijos

fitnessPadre1 = fitnessViajero(padre1, false);
fitnessPadre2 = fitnessViajero(padre2, false);
fitnessHijo1 = fitnessViajero(hijo1, false);
fitnessHijo2 = fitnessViajero(hijo2, false);

fprintf('Fitness del padre 1: %.0f\n', fitnessPadre1);
fprintf('Fitness del padre 2: %.0f\n', fitnessPadre2);
fprintf('Fitness del hijo 1: %.0f\n', fitnessHijo1);
fprintf('Fitness del hijo 2: %.0f\n', fitnessHijo2);

%% Realizar 100 cruces para comprobar la función

for prueba = 1:100

    padrePrueba1 = randperm(13);
    padrePrueba2 = randperm(13);

    [hijoPrueba1, hijoPrueba2] = ...
        cruceViajero(padrePrueba1, padrePrueba2);

    assert(isequal(sort(hijoPrueba1), 1:13), ...
        'Se genero un hijo 1 invalido.');

    assert(isequal(sort(hijoPrueba2), 1:13), ...
        'Se genero un hijo 2 invalido.');
end

disp(' ');
disp('Los 100 cruces generaron rutas validas.');
disp('Todas las pruebas del cruce OX fueron superadas.');