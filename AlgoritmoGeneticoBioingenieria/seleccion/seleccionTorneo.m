function [seleccionados, fitnessSeleccionados, indicesSeleccionados] = ...
    seleccionTorneo(poblacion, fitness, tamanoTorneo)
% SELECCIONTORNEO selecciona individuos mediante torneos.
%
% poblacion:
% Matriz donde cada fila representa un individuo.
%
% fitness:
% Vector con el fitness de cada individuo.
%
% tamanoTorneo:
% Cantidad de participantes en cada torneo.
% Si no se envia, se utiliza un tamaño de 4.
%
% seleccionados:
% Individuos ganadores.
%
% fitnessSeleccionados:
% Fitness de los ganadores.
%
% indicesSeleccionados:
% Posiciones originales de los ganadores.

    % Si no se envia el tamaño, utilizar grupos de 4
    if nargin < 3
        tamanoTorneo = 4;
    end

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

    % Comprobar los valores de fitness
    if any(~isfinite(fitness))
        error('Los fitness no pueden contener NaN o Inf.');
    end

    % Comprobar el tamaño del torneo
    if ~isnumeric(tamanoTorneo) || ...
       numel(tamanoTorneo) ~= 1 || ...
       tamanoTorneo < 2 || ...
       floor(tamanoTorneo) ~= tamanoTorneo

        error('El tamaño del torneo debe ser un entero mayor o igual a 2.');
    end

    % El torneo no puede superar la poblacion
    if tamanoTorneo > cantidadIndividuos
        error('El tamaño del torneo no puede superar la poblacion.');
    end

    % Seleccionar la mitad de la poblacion
    cantidadSeleccionados = floor(cantidadIndividuos / 2);

    % Preparar los resultados
    indicesSeleccionados = zeros(cantidadSeleccionados, 1);
    fitnessSeleccionados = zeros(cantidadSeleccionados, 1);

    % Realizar cada torneo
    for i = 1:cantidadSeleccionados

        % Indices que todavía pueden ser seleccionados
        todosLosIndices = 1:cantidadIndividuos;

        disponibles = setdiff( ...
            todosLosIndices, ...
            indicesSeleccionados(1:i-1) ...
        );

        % En caso de que queden menos participantes disponibles
        tamanoActual = min(tamanoTorneo, length(disponibles));

        % Escoger posiciones aleatorias dentro de disponibles
        posicionesAleatorias = ...
            randperm(length(disponibles), tamanoActual);

        % Obtener los indices reales de los participantes
        participantes = ...
            disponibles(posicionesAleatorias);

        % Fitness de los participantes
        fitnessParticipantes = fitness(participantes);

        % Encontrar al ganador del torneo
        [mejorFitness, posicionGanador] = ...
            min(fitnessParticipantes);

        % Obtener el indice original del ganador
        indiceGanador = participantes(posicionGanador);

        % Guardar el resultado
        indicesSeleccionados(i) = indiceGanador;
        fitnessSeleccionados(i) = mejorFitness;
    end

    % Extraer los individuos seleccionados
    seleccionados = poblacion(indicesSeleccionados, :);
end