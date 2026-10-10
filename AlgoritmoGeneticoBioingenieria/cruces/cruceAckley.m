function [hijo1, hijo2, alfa] = ...
    cruceAckley(padre1, padre2, alfa)
% CRUCEACKLEY realiza un cruce aritmetico
% entre dos individuos de Ackley.
%
% padre1 y padre2:
% Vectores reales con la misma cantidad de dimensiones.
%
% alfa:
% Valor entre 0 y 1 que controla la mezcla.
% Si no se envia, se genera aleatoriamente.
%
% hijo1 y hijo2:
% Individuos resultantes del cruce.

% Convertir los padres en vectores fila
padre1 = padre1(:)';
padre2 = padre2(:)';

% Comprobar el tamaño
if length(padre1) ~= length(padre2)
    error('Los padres deben tener el mismo tamaño.');
end

% Comprobar que no estén vacíos
if isempty(padre1)
    error('Los padres no pueden estar vacios.');
end

% Comprobar que sean numéricos
if ~isnumeric(padre1) || ~isnumeric(padre2)
    error('Los padres deben ser vectores numericos.');
end

% Comprobar que no contengan NaN o Inf
if any(~isfinite(padre1)) || ...
        any(~isfinite(padre2))

    error('Los padres no pueden contener NaN o Inf.');
end

% Generar alfa si no fue enviado
if nargin < 3
    alfa = rand;
end

% Comprobar alfa
if ~isnumeric(alfa) || numel(alfa) ~= 1 || ...
        alfa < 0 || alfa > 1

    error('Alfa debe ser un valor entre 0 y 1.');
end

% Crear el primer hijo
hijo1 = ...
    alfa .* padre1 + ...
    (1 - alfa) .* padre2;

% Crear el segundo hijo
hijo2 = ...
    (1 - alfa) .* padre1 + ...
    alfa .* padre2;
end