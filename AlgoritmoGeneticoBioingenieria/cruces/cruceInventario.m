function [hijo1, hijo2, alfa] = ...
    cruceInventario(padre1, padre2, alfa)
% CRUCEINVENTARIO realiza un cruce aritmetico
% y repara los hijos.
%
% Los individuos utilizan la estructura:
% [Q1 Q2 Q3 Q4 Q5 S1 S2 S3 S4 S5 K1 K2 K3 K4 K5]

% Convertir los padres en vectores fila
padre1 = padre1(:)';
padre2 = padre2(:)';

% Comprobar el tamaño
if numel(padre1) ~= 15 || numel(padre2) ~= 15
    error('Cada padre debe contener 15 variables.');
end

% Comprobar valores inválidos
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

    error('Alfa debe estar entre 0 y 1.');
end

%% Realizar el cruce aritmético

hijo1Temporal = ...
    alfa .* padre1 + ...
    (1 - alfa) .* padre2;

hijo2Temporal = ...
    (1 - alfa) .* padre1 + ...
    alfa .* padre2;

%% Reparar los hijos

hijo1 = repararInventario(hijo1Temporal);
hijo2 = repararInventario(hijo2Temporal);
end