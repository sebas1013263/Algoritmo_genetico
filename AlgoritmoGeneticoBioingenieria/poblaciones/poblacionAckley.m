function [poblacion, fitness] = poblacionAckley(n, d, limites)
% POBLACIONACKLEY genera la poblacion inicial para Ackley.
%
% n:
% Cantidad de individuos.
%
% d:
% Cantidad de dimensiones de cada individuo.
%
% limites:
% Vector con el limite inferior y superior.
% Ejemplo: [-10 10]
%
% poblacion:
% Matriz de n filas y d columnas.
%
% fitness:
% Valor de Ackley para cada individuo.

% Comprobar el tamaño de la poblacion
if ~isnumeric(n) || numel(n) ~= 1 || ...
        n <= 0 || floor(n) ~= n

    error('n debe ser un entero positivo.');
end

% Comprobar la cantidad de dimensiones
if ~isnumeric(d) || numel(d) ~= 1 || ...
        d <= 0 || floor(d) ~= d

    error('d debe ser un entero positivo.');
end

% Comprobar que se hayan enviado dos limites
if ~isnumeric(limites) || numel(limites) ~= 2
    error('Los limites deben contener dos valores.');
end

% Convertir los limites en un vector fila
limites = limites(:)';

limiteInferior = limites(1);
limiteSuperior = limites(2);

% Comprobar el orden de los limites
if limiteInferior >= limiteSuperior
    error('El limite inferior debe ser menor al superior.');
end

% Generar numeros aleatorios entre los dos limites
poblacion = limiteInferior + ...
    (limiteSuperior - limiteInferior) .* rand(n, d);

% Crear el vector para guardar los fitness
fitness = zeros(n, 1);

% Evaluar cada individuo
for i = 1:n
    fitness(i) = fitnessAckley(poblacion(i, :));
end
end