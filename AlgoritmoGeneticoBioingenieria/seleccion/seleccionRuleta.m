function [seleccionados, fitnessSeleccionados, ...
    indicesSeleccionados, probabilidades] = ...
    seleccionRuleta(poblacion, fitness)
% SELECCIONRULETA selecciona individuos mediante
% probabilidades inversamente proporcionales al fitness.
%
% poblacion:
% Matriz donde cada fila representa un individuo.
%
% fitness:
% Vector con el fitness de cada individuo.
%
% seleccionados:
% Individuos elegidos por la ruleta.
%
% fitnessSeleccionados:
% Fitness de los individuos seleccionados.
%
% indicesSeleccionados:
% Posiciones originales de los seleccionados.
%
% probabilidades:
% Probabilidad inicial de cada individuo.

    % Convertir fitness en un vector columna
    fitness = fitness(:);

    % Cantidad de individuos
    cantidadIndividuos = size(poblacion, 1);

    % Comprobar la población
    if cantidadIndividuos < 2
        error('La poblacion debe tener al menos dos individuos.');
    end

    % Comprobar la cantidad de fitness
    if length(fitness) ~= cantidadIndividuos
        error(['La cantidad de fitness debe coincidir con ' ...
               'la cantidad de individuos.']);
    end

    % Comprobar valores inválidos
    if any(~isfinite(fitness))
        error('Los fitness no pueden contener NaN o Inf.');
    end

    % Para calcular el inverso, todos deben ser positivos
    if any(fitness <= 0)
        error('Los fitness deben ser mayores que cero.');
    end

    %% Calcular las probabilidades iniciales

    fitnessInverso = 1 ./ fitness;

    probabilidades = ...
        fitnessInverso ./ sum(fitnessInverso);

    %% Preparar la selección

    cantidadSeleccionados = floor(cantidadIndividuos / 2);

    indicesSeleccionados = ...
        zeros(cantidadSeleccionados, 1);

    fitnessSeleccionados = ...
        zeros(cantidadSeleccionados, 1);

    % Inicialmente todos están disponibles
    disponibles = 1:cantidadIndividuos;

    %% Girar la ruleta

    for i = 1:cantidadSeleccionados

        % Obtener probabilidades de los disponibles
        probabilidadesDisponibles = ...
            probabilidades(disponibles);

        % Volver a normalizar para que sumen 1
        probabilidadesDisponibles = ...
            probabilidadesDisponibles ./ ...
            sum(probabilidadesDisponibles);

        % Construir la probabilidad acumulada
        probabilidadAcumulada = ...
            cumsum(probabilidadesDisponibles);

        % Generar un valor aleatorio entre 0 y 1
        numeroAleatorio = rand;

        % Encontrar la primera posición que supera
        % el número aleatorio
        posicionElegida = find( ...
            numeroAleatorio <= probabilidadAcumulada, ...
            1, ...
            'first' ...
        );

        % Obtener el índice original
        indiceElegido = disponibles(posicionElegida);

        % Guardar el ganador
        indicesSeleccionados(i) = indiceElegido;

        fitnessSeleccionados(i) = ...
            fitness(indiceElegido);

        % Eliminarlo para evitar que vuelva a ganar
        disponibles(posicionElegida) = [];
    end

    % Extraer los individuos seleccionados
    seleccionados = ...
        poblacion(indicesSeleccionados, :);
end