function [poblacion, fitness] = poblacionViajero(n)
% POBLACIONVIAJERO genera la poblacion inicial del
% problema del viajero.
%
% n:
% Cantidad de individuos que tendra la poblacion.
%
% poblacion:
% Matriz de n filas y 13 columnas.
% Cada fila representa una ruta valida.
%
% fitness:
% Vector que contiene el tiempo de cada ruta.

    % Comprobar que n sea un entero positivo
    if ~isnumeric(n) || numel(n) ~= 1 || ...
       n <= 0 || floor(n) ~= n

        error('El tamaño de la poblacion debe ser un entero positivo.');
    end

    % Crear la matriz donde se guardaran los individuos
    poblacion = zeros(n, 13);

    % Crear el vector para guardar los fitness
    fitness = zeros(n, 1);

    % Generar cada individuo
    for i = 1:n

        % randperm genera una permutacion aleatoria
        % de los numeros del 1 al 13
        ruta = randperm(13);

        % Guardar la ruta en la poblacion
        poblacion(i, :) = ruta;

        % Evaluar el tiempo de la ruta
        % false significa que no regresa al punto inicial
        fitness(i) = fitnessViajero(ruta, false);
    end
end