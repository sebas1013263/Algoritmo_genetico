function [individuoMutado, fueMutado, posiciones] = ...
    mutacionViajero(individuo, probabilidadMutacion)
% MUTACIONVIAJERO intercambia dos posiciones aleatorias.
%
% individuo:
% Ruta válida representada mediante una permutación.
%
% probabilidadMutacion:
% Valor entre 0 y 1.
%
% individuoMutado:
% Ruta después de aplicar o no la mutación.
%
% fueMutado:
% true si se realizó el intercambio.
%
% posiciones:
% Posiciones intercambiadas.
% Si no hay mutación, retorna [0 0].

% Convertir el individuo en vector fila
individuo = individuo(:)';

cantidadGenes = length(individuo);

% Comprobar el tamaño
if cantidadGenes < 2
    error('El individuo debe tener al menos dos elementos.');
end

% Comprobar que sea una permutación
if length(unique(individuo)) ~= cantidadGenes
    error('El individuo contiene elementos repetidos.');
end

% Comprobar la probabilidad
if ~isnumeric(probabilidadMutacion) || ...
        numel(probabilidadMutacion) ~= 1 || ...
        probabilidadMutacion < 0 || ...
        probabilidadMutacion > 1

    error('La probabilidad debe estar entre 0 y 1.');
end

% Inicialmente, el individuo queda igual
individuoMutado = individuo;
fueMutado = false;
posiciones = [0 0];

% Decidir aleatoriamente si se aplica la mutación
if rand <= probabilidadMutacion

    % Seleccionar dos posiciones diferentes
    posiciones = sort(randperm(cantidadGenes, 2));

    posicion1 = posiciones(1);
    posicion2 = posiciones(2);

    % Guardar temporalmente el primer valor
    auxiliar = individuoMutado(posicion1);

    % Realizar el intercambio
    individuoMutado(posicion1) = ...
        individuoMutado(posicion2);

    individuoMutado(posicion2) = auxiliar;

    fueMutado = true;
end
end