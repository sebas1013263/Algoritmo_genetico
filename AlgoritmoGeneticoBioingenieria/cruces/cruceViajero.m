function [hijo1, hijo2, puntosCorte] = ...
    cruceViajero(padre1, padre2)
% CRUCEVIAJERO realiza un cruce por orden OX.
%
% padre1 y padre2:
% Permutaciones validas con los mismos elementos.
%
% hijo1 y hijo2:
% Nuevas permutaciones generadas.
%
% puntosCorte:
% Posiciones utilizadas para realizar el cruce.

% Convertir los padres en vectores fila
padre1 = padre1(:)';
padre2 = padre2(:)';

% Verificar que tengan el mismo tamaño
if length(padre1) ~= length(padre2)
    error('Los padres deben tener el mismo tamaño.');
end

cantidadGenes = length(padre1);

% Se necesitan al menos dos genes
if cantidadGenes < 2
    error('Los padres deben tener al menos dos elementos.');
end

% Verificar que no existan elementos repetidos
if length(unique(padre1)) ~= cantidadGenes
    error('El padre 1 contiene elementos repetidos.');
end

if length(unique(padre2)) ~= cantidadGenes
    error('El padre 2 contiene elementos repetidos.');
end

% Verificar que ambos tengan los mismos elementos
if ~isequal(sort(padre1), sort(padre2))
    error('Los padres deben contener los mismos elementos.');
end

%% Seleccionar los puntos de corte

puntosCorte = sort(randperm(cantidadGenes, 2));

punto1 = puntosCorte(1);
punto2 = puntosCorte(2);

%% Crear los hijos vacíos

hijo1 = zeros(1, cantidadGenes);
hijo2 = zeros(1, cantidadGenes);

%% Copiar los segmentos centrales

hijo1(punto1:punto2) = ...
    padre1(punto1:punto2);

hijo2(punto1:punto2) = ...
    padre2(punto1:punto2);

%% Definir el orden de las posiciones libres

posicionesLibres = [ ...
    punto2 + 1:cantidadGenes, ...
    1:punto1 - 1 ...
    ];

%% Completar el primer hijo usando el padre 2

ordenPadre2 = [ ...
    padre2(punto2 + 1:cantidadGenes), ...
    padre2(1:punto2) ...
    ];

segmentoHijo1 = hijo1(punto1:punto2);

genesParaHijo1 = ordenPadre2( ...
    ~ismember(ordenPadre2, segmentoHijo1) ...
    );

hijo1(posicionesLibres) = genesParaHijo1;

%% Completar el segundo hijo usando el padre 1

ordenPadre1 = [ ...
    padre1(punto2 + 1:cantidadGenes), ...
    padre1(1:punto2) ...
    ];

segmentoHijo2 = hijo2(punto1:punto2);

genesParaHijo2 = ordenPadre1( ...
    ~ismember(ordenPadre1, segmentoHijo2) ...
    );

hijo2(posicionesLibres) = genesParaHijo2;
end