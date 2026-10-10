function [seleccionados, fitnessSeleccionados, indicesSeleccionados] = ...
    seleccionElitismo(poblacion, fitness)
% SELECCIONELITISMO selecciona la mejor mitad de la poblacion.
%
% poblacion:
% Matriz donde cada fila representa un individuo.
%
% fitness:
% Vector con el fitness de cada individuo.
%
% seleccionados:
% Individuos que tienen los menores valores de fitness.
%
% fitnessSeleccionados:
% Fitness de los individuos seleccionados.
%
% indicesSeleccionados:
% Posiciones originales de los individuos seleccionados.

% Convertir fitness en un vector columna
fitness = fitness(:);

% Cantidad de individuos
cantidadIndividuos = size(poblacion, 1);

% Comprobar que existan al menos dos individuos
if cantidadIndividuos < 2
    error('La poblacion debe tener al menos dos individuos.');
end

% Comprobar que exista un fitness por individuo
if length(fitness) ~= cantidadIndividuos
    error(['La cantidad de fitness debe coincidir con ' ...
        'la cantidad de individuos.']);
end

% Comprobar que los fitness sean valores validos
if any(~isfinite(fitness))
    error('Los fitness no pueden contener NaN o Inf.');
end

% Ordenar los fitness de menor a mayor
[fitnessOrdenados, indicesOrdenados] = ...
    sort(fitness, 'ascend');

% Seleccionar la mitad de la poblacion
cantidadSeleccionados = floor(cantidadIndividuos / 2);

% Guardar las posiciones de los mejores individuos
indicesSeleccionados = ...
    indicesOrdenados(1:cantidadSeleccionados);

% Extraer los mejores individuos
seleccionados = ...
    poblacion(indicesSeleccionados, :);

% Extraer sus fitness
fitnessSeleccionados = ...
    fitnessOrdenados(1:cantidadSeleccionados);
end