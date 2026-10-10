function [poblacion, fitness] = poblacionInventario(n)
% POBLACIONINVENTARIO genera la poblacion inicial
% para el problema de inventarios.
%
% n:
% Cantidad de individuos.
%
% poblacion:
% Matriz de n filas y 15 columnas.
%
% Cada individuo tiene la estructura:
% [Q1 Q2 Q3 Q4 Q5 S1 S2 S3 S4 S5 K1 K2 K3 K4 K5]
%
% fitness:
% Resultado de evaluar cada individuo.

    % Comprobar el tamaño de la poblacion
    if ~isnumeric(n) || numel(n) ~= 1 || ...
       n <= 0 || floor(n) ~= n

        error('n debe ser un entero positivo.');
    end

    % Inversion total de la empresa
    inversionObjetivo = 8000;

    % Limites para las variables S
    limiteInferiorS = [0 0 0 0 0];
    limiteSuperiorS = [200 1200 2500 800 1500];

    % Limites para las variables K
    limiteInferiorK = [0 0 0 0 0];
    limiteSuperiorK = [500 2000 5000 1500 3000];

    % Crear la matriz de la poblacion
    poblacion = zeros(n, 15);

    % Crear el vector de fitness
    fitness = zeros(n, 1);

    % Generar cada individuo
    for i = 1:n

        %% Generar los cinco valores de S

        S = limiteInferiorS + ...
            (limiteSuperiorS - limiteInferiorS) .* ...
            rand(1, 5);

        %% Generar los cinco valores de K

        K = limiteInferiorK + ...
            (limiteSuperiorK - limiteInferiorK) .* ...
            rand(1, 5);

        %% Calcular cuánto dinero queda disponible para Q

        % De la ecuacion:
        % sum(Q/2 + S) = 8000
        %
        % Se obtiene:
        % sum(Q) = 2 * (8000 - sum(S))

        sumaTotalQ = 2 * ...
            (inversionObjetivo - sum(S));

        %% Dividir aleatoriamente el valor disponible entre Q

        % Se garantiza que cada Q sea mayor que cero
        valorMinimoQ = 1;

        % Dinero restante despues de asignar el minimo
        restanteQ = sumaTotalQ - 5 * valorMinimoQ;

        % Crear cuatro puntos aleatorios ordenados
        puntos = sort(rand(1, 4));

        % Convertir los puntos en cinco proporciones
        proporciones = diff([0 puntos 1]);

        % Inicializar los valores Q
        Q = zeros(1, 5);

        % Generar directamente Q1, Q2, Q3 y Q4
        for j = 1:4
            Q(j) = valorMinimoQ + ...
                restanteQ * proporciones(j);
        end

        % Calcular Q5 utilizando la restriccion de igualdad
        Q(5) = 2 * ( ...
            inversionObjetivo ...
            - sum(S) ...
            - sum(Q(1:4)) / 2 ...
        );

        %% Construir y evaluar el individuo

        individuo = [Q S K];

        poblacion(i, :) = individuo;

        fitness(i) = fitnessInventario(individuo);
    end
end