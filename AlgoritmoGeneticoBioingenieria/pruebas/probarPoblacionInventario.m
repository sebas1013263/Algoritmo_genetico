clc;
clear;

% Configurar las carpetas del proyecto
configurarProyecto;

disp('PRUEBAS DE LA POBLACION DE INVENTARIOS');
disp('---------------------------------------');

% Semilla para repetir los valores aleatorios
rng(1);

% Tamaño de la poblacion
n = 10;

% Generar la poblacion
[poblacion, fitness] = poblacionInventario(n);

%% Mostrar el primer individuo de forma organizada

primerIndividuo = poblacion(1, :);

Q = primerIndividuo(1:5);
S = primerIndividuo(6:10);
K = primerIndividuo(11:15);

disp('Valores Q del primer individuo:');
disp(Q);

disp('Valores S del primer individuo:');
disp(S);

disp('Valores K del primer individuo:');
disp(K);

%% Mostrar los fitness

disp('Fitness de todos los individuos:');
disp(fitness);

%% Verificar tamaño

cantidadFilas = size(poblacion, 1);
cantidadColumnas = size(poblacion, 2);

fprintf('Cantidad de individuos: %d\n', cantidadFilas);
fprintf('Variables por individuo: %d\n', cantidadColumnas);

%% Preparar verificaciones

limiteSuperiorS = [200 1200 2500 800 1500];
limiteSuperiorK = [500 2000 5000 1500 3000];

inversiones = zeros(n, 1);
fitnessVerificados = zeros(n, 1);

todosValidos = true;

%% Comprobar todos los individuos

for i = 1:n

    individuo = poblacion(i, :);

    Q = individuo(1:5);
    S = individuo(6:10);
    K = individuo(11:15);

    % Calcular la inversion
    inversiones(i) = sum(Q ./ 2 + S);

    % Comprobar Q
    qValido = all(Q > 0) && all(Q < 16000);

    % Comprobar S
    sValido = ...
        all(S >= 0) && ...
        all(S <= limiteSuperiorS);

    % Comprobar K
    kValido = ...
        all(K >= 0) && ...
        all(K <= limiteSuperiorK);

    % Comprobar la inversion
    inversionValida = ...
        abs(inversiones(i) - 8000) < 1e-6;

    if ~qValido || ~sValido || ...
       ~kValido || ~inversionValida

        todosValidos = false;
    end

    % Volver a calcular el fitness
    fitnessVerificados(i) = ...
        fitnessInventario(individuo);
end

%% Mostrar las inversiones

disp('Inversion de cada individuo:');
disp(inversiones);

%% Encontrar el mejor individuo

[mejorFitness, posicionMejor] = min(fitness);

mejorIndividuo = poblacion(posicionMejor, :);

disp('Mejor individuo de la poblacion:');
disp(mejorIndividuo);

fprintf('Mejor fitness: %.10f\n', mejorFitness);

%% Pruebas automáticas

assert(cantidadFilas == n, ...
    'La poblacion no tiene la cantidad correcta de individuos.');

assert(cantidadColumnas == 15, ...
    'Los individuos no tienen 15 variables.');

assert(todosValidos, ...
    'La poblacion contiene individuos invalidos.');

assert(max(abs(fitness - fitnessVerificados)) < 1e-8, ...
    'Los fitness no corresponden con los individuos.');

assert(all(fitness < 1e12), ...
    'Algun individuo recibio una penalizacion.');

disp(' ');
disp('Todas las pruebas de inventarios fueron superadas.');