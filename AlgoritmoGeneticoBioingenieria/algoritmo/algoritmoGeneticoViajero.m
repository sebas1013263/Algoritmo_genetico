function [mejorRuta, mejorFitness, historial, ...
    tiempoEjecucion] = ...
    algoritmoGeneticoViajero( ...
        tamanoPoblacion, ...
        numeroGeneraciones, ...
        metodoSeleccion, ...
        probabilidadCruce, ...
        probabilidadMutacion)
% ALGORITMOGENETICOVIAJERO ejecuta el algoritmo
% genético para buscar una ruta de menor tiempo.
%
% tamanoPoblacion:
% Cantidad total de individuos.
%
% numeroGeneraciones:
% Cantidad de iteraciones del algoritmo.
%
% metodoSeleccion:
% 'elitismo', 'torneo' o 'ruleta'.
%
% probabilidadCruce:
% Probabilidad de aplicar el cruce OX.
%
% probabilidadMutacion:
% Probabilidad de mutar cada hijo.
%
% mejorRuta:
% Mejor ruta encontrada.
%
% mejorFitness:
% Tiempo de la mejor ruta.
%
% historial:
% Mejor fitness encontrado en cada generación.
%
% tiempoEjecucion:
% Tiempo total de ejecución.

    %% Validaciones

    if ~isnumeric(tamanoPoblacion) || ...
       numel(tamanoPoblacion) ~= 1 || ...
       tamanoPoblacion < 4 || ...
       floor(tamanoPoblacion) ~= tamanoPoblacion || ...
       mod(tamanoPoblacion, 2) ~= 0

        error(['El tamaño de la poblacion debe ser un ' ...
               'entero par mayor o igual a 4.']);
    end

    if ~isnumeric(numeroGeneraciones) || ...
       numel(numeroGeneraciones) ~= 1 || ...
       numeroGeneraciones <= 0 || ...
       floor(numeroGeneraciones) ~= numeroGeneraciones

        error('El numero de generaciones debe ser un entero positivo.');
    end

    if ~isnumeric(probabilidadCruce) || ...
       numel(probabilidadCruce) ~= 1 || ...
       probabilidadCruce < 0 || ...
       probabilidadCruce > 1

        error('La probabilidad de cruce debe estar entre 0 y 1.');
    end

    if ~isnumeric(probabilidadMutacion) || ...
       numel(probabilidadMutacion) ~= 1 || ...
       probabilidadMutacion < 0 || ...
       probabilidadMutacion > 1

        error('La probabilidad de mutacion debe estar entre 0 y 1.');
    end

    % Convertir el nombre del método
    metodoSeleccion = lower(char(metodoSeleccion));

    metodosValidos = {'elitismo', 'torneo', 'ruleta'};

    if ~ismember(metodoSeleccion, metodosValidos)
        error('El metodo debe ser elitismo, torneo o ruleta.');
    end

    %% Iniciar medición del tiempo

    inicioTiempo = tic;

    %% Crear la población inicial

    [poblacion, fitness] = ...
        poblacionViajero(tamanoPoblacion);

    %% Encontrar el mejor individuo inicial

    [mejorFitness, posicionMejor] = min(fitness);

    mejorRuta = poblacion(posicionMejor, :);

    % Se incluye la generación cero
    historial = zeros(numeroGeneraciones + 1, 1);
    historial(1) = mejorFitness;

    %% Ejecutar las generaciones

    for generacion = 1:numeroGeneraciones

        %% Selección

        switch metodoSeleccion

            case 'elitismo'

                [padres, ~] = ...
                    seleccionElitismo(poblacion, fitness);

            case 'torneo'

                [padres, ~] = ...
                    seleccionTorneo(poblacion, fitness, 4);

            case 'ruleta'

                [padres, ~] = ...
                    seleccionRuleta(poblacion, fitness);
        end

        cantidadPadres = size(padres, 1);

        % Se generará la misma cantidad de hijos
        cantidadHijos = ...
            tamanoPoblacion - cantidadPadres;

        hijos = zeros(cantidadHijos, 13);

        contadorHijos = 1;

        %% Cruce y mutación

        while contadorHijos <= cantidadHijos

            % Escoger dos padres diferentes
            indicesPadres = ...
                randperm(cantidadPadres, 2);

            padre1 = padres(indicesPadres(1), :);
            padre2 = padres(indicesPadres(2), :);

            % Decidir si se aplica el cruce
            if rand <= probabilidadCruce

                [hijo1, hijo2] = ...
                    cruceViajero(padre1, padre2);

            else

                % Si no hay cruce, los hijos son copias
                hijo1 = padre1;
                hijo2 = padre2;
            end

            % Aplicar mutación
            hijo1 = mutacionViajero( ...
                hijo1, probabilidadMutacion);

            hijo2 = mutacionViajero( ...
                hijo2, probabilidadMutacion);

            % Guardar el primer hijo
            hijos(contadorHijos, :) = hijo1;
            contadorHijos = contadorHijos + 1;

            % Guardar el segundo si todavía hay espacio
            if contadorHijos <= cantidadHijos

                hijos(contadorHijos, :) = hijo2;
                contadorHijos = contadorHijos + 1;
            end
        end

        %% Formar la nueva población

        poblacion = [padres; hijos];

        %% Evaluar la población

        fitness = zeros(tamanoPoblacion, 1);

        for i = 1:tamanoPoblacion
            fitness(i) = ...
                fitnessViajero(poblacion(i, :), false);
        end

        %% Buscar el mejor de la generación

        [mejorGeneracion, posicionGeneracion] = ...
            min(fitness);

        % Actualizar el mejor global
        if mejorGeneracion < mejorFitness

            mejorFitness = mejorGeneracion;

            mejorRuta = ...
                poblacion(posicionGeneracion, :);
        end

        % Guardar el mejor global
        historial(generacion + 1) = mejorFitness;
    end

    %% Finalizar medición

    tiempoEjecucion = toc(inicioTiempo);
end