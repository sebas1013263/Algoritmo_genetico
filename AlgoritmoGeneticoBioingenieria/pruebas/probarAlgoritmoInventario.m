clc;
clear;
close all;

% Configurar las carpetas
configurarProyecto;

disp('PRUEBA DEL ALGORITMO GENETICO DE INVENTARIOS');
disp('---------------------------------------------');

format long g;

%% Parámetros

tamanoPoblacion = 20;

% Inicialmente usamos 30 para que la prueba no tarde demasiado
numeroGeneraciones = 30;

probabilidadCruce = 0.90;
probabilidadMutacion = 0.10;
proporcionSigma = 0.05;

%% ELITISMO

disp(' ');
disp('EJECUCION CON ELITISMO');

rng(13);

[individuoElitismo, fitnessElitismo, ...
 historialElitismo, tiempoElitismo] = ...
    algoritmoGeneticoInventario( ...
        tamanoPoblacion, ...
        numeroGeneraciones, ...
        'elitismo', ...
        probabilidadCruce, ...
        probabilidadMutacion, ...
        proporcionSigma ...
    );

fprintf('Mejor fitness: %.10f\n', fitnessElitismo);
fprintf('Tiempo: %.6f segundos\n', tiempoElitismo);

%% TORNEO

disp(' ');
disp('EJECUCION CON TORNEO');

rng(13);

[individuoTorneo, fitnessTorneo, ...
 historialTorneo, tiempoTorneo] = ...
    algoritmoGeneticoInventario( ...
        tamanoPoblacion, ...
        numeroGeneraciones, ...
        'torneo', ...
        probabilidadCruce, ...
        probabilidadMutacion, ...
        proporcionSigma ...
    );

fprintf('Mejor fitness: %.10f\n', fitnessTorneo);
fprintf('Tiempo: %.6f segundos\n', tiempoTorneo);

%% RULETA

disp(' ');
disp('EJECUCION CON RULETA');

rng(13);

[individuoRuleta, fitnessRuleta, ...
 historialRuleta, tiempoRuleta] = ...
    algoritmoGeneticoInventario( ...
        tamanoPoblacion, ...
        numeroGeneraciones, ...
        'ruleta', ...
        probabilidadCruce, ...
        probabilidadMutacion, ...
        proporcionSigma ...
    );

fprintf('Mejor fitness: %.10f\n', fitnessRuleta);
fprintf('Tiempo: %.6f segundos\n', tiempoRuleta);

%% Mostrar el mejor de los tres métodos

fitnessMetodos = [
    fitnessElitismo
    fitnessTorneo
    fitnessRuleta
];

[mejorFitnessGeneral, mejorMetodo] = ...
    min(fitnessMetodos);

switch mejorMetodo

    case 1
        nombreMejorMetodo = 'Elitismo';
        mejorIndividuoGeneral = individuoElitismo;

    case 2
        nombreMejorMetodo = 'Torneo';
        mejorIndividuoGeneral = individuoTorneo;

    case 3
        nombreMejorMetodo = 'Ruleta';
        mejorIndividuoGeneral = individuoRuleta;
end

disp(' ');
fprintf('Mejor metodo en esta prueba: %s\n', ...
    nombreMejorMetodo);

fprintf('Mejor fitness general: %.10f\n', ...
    mejorFitnessGeneral);

disp('Mejor individuo general:');
disp(mejorIndividuoGeneral);

%% Verificar cada individuo

individuos = [
    individuoElitismo
    individuoTorneo
    individuoRuleta
];

fitnessObtenidos = [
    fitnessElitismo
    fitnessTorneo
    fitnessRuleta
];

limiteSuperiorS = [200 1200 2500 800 1500];
limiteSuperiorK = [500 2000 5000 1500 3000];

for i = 1:3

    individuo = individuos(i, :);

    Q = individuo(1:5);
    S = individuo(6:10);
    K = individuo(11:15);

    inversion = sum(Q ./ 2 + S);

    assert(all(Q > 0) && all(Q < 16000), ...
        'El individuo tiene valores Q invalidos.');

    assert(all(S >= 0) && all(S <= limiteSuperiorS), ...
        'El individuo tiene valores S invalidos.');

    assert(all(K >= 0) && all(K <= limiteSuperiorK), ...
        'El individuo tiene valores K invalidos.');

    assert(abs(inversion - 8000) < 1e-6, ...
        'El individuo no cumple la inversion.');

    fitnessVerificado = fitnessInventario(individuo);

    assert(abs( ...
        fitnessVerificado - fitnessObtenidos(i)) < 1e-8, ...
        'El fitness no corresponde con el individuo.');

    assert(fitnessObtenidos(i) < 1e12, ...
        'Un metodo produjo una penalizacion.');
end

%% Verificar historiales

assert(length(historialElitismo) == ...
       numeroGeneraciones + 1, ...
    'El historial de elitismo tiene tamaño incorrecto.');

assert(length(historialTorneo) == ...
       numeroGeneraciones + 1, ...
    'El historial de torneo tiene tamaño incorrecto.');

assert(length(historialRuleta) == ...
       numeroGeneraciones + 1, ...
    'El historial de ruleta tiene tamaño incorrecto.');

assert(all(diff(historialElitismo) <= 1e-12), ...
    'El historial de elitismo empeoro.');

assert(all(diff(historialTorneo) <= 1e-12), ...
    'El historial de torneo empeoro.');

assert(all(diff(historialRuleta) <= 1e-12), ...
    'El historial de ruleta empeoro.');

%% Gráfica

generaciones = 0:numeroGeneraciones;

figure;

plot(generaciones, historialElitismo, ...
    'LineWidth', 1.5);

hold on;

plot(generaciones, historialTorneo, ...
    'LineWidth', 1.5);

plot(generaciones, historialRuleta, ...
    'LineWidth', 1.5);

hold off;

grid on;

xlabel('Generación');
ylabel('Mejor valor de Z');
title('Convergencia del algoritmo genético de inventarios');

legend( ...
    'Elitismo', ...
    'Torneo', ...
    'Ruleta', ...
    'Location', 'best' ...
);

disp(' ');
disp('Todas las pruebas del algoritmo de inventarios fueron superadas.');

format short;