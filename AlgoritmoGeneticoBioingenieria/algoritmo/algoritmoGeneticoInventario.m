function [mejorIndividuo, mejorFitness, historial, ...
    tiempoEjecucion] = ...
    algoritmoGeneticoInventario( ...
        tamanoPoblacion, ...
        numeroGeneraciones, ...
        metodoSeleccion, ...
        probabilidadCruce, ...
        probabilidadMutacion, ...
        proporcionSigma)
% ALGORITMOGENETICOINVENTARIO busca minimizar
% las ventas no realizadas por falta de inventario.
%
% tamanoPoblacion:
% Cantidad de individuos.
%
% numeroGeneraciones:
% Cantidad de iteraciones.
%
% metodoSeleccion:
% 'elitismo', 'torneo' o 'ruleta'.
%
% probabilidadCruce:
% Probabilidad de aplicar el cruce aritmético.
%
% probabilidadMutacion:
% Probabilidad de mutar cada hijo.
%
% proporcionSigma:
% Magnitud relativa de la mutación.

    %% Validaciones

    if ~isnumeric(tamanoPoblacion) || ...
       numel(tamanoPoblacion) ~= 1 || ...
       tamanoPoblacion < 4 || ...
       floor(tamanoPoblacion) ~= tamanoPoblacion || ...
       mod(tamanoPoblacion, 2) ~= 0

        error(['El tamaño de poblacion debe ser un ' ...
               'entero par mayor o igual a 4.']);
    end

    if ~isnumeric(numeroGeneraciones) || ...
       numel(numeroGeneraciones) ~= 1 || ...
       numeroGeneraciones <= 0 || ...
       floor(numeroGeneraciones) ~= numeroGeneraciones

        error('El numero de generaciones debe ser positivo.');
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

    if ~isnumeric(proporcionSigma) || ...
       numel(proporcionSigma) ~= 1 || ...
       proporcionSigma <= 0

        error('La proporcion de sigma debe ser positiva.');
    end

    metodoSeleccion = lower(char(metodoSeleccion));

    metodosValidos = {'elitismo', 'torneo', 'ruleta'};

    if ~ismember(metodoSeleccion, metodosValidos)
        error('El metodo debe ser elitismo, torneo o ruleta.');
    end

    %% Iniciar medición del tiempo

    inicioTiempo = tic;

    %% Generar la población inicial

    [poblacion, fitness] = ...
        poblacionInventario(tamanoPoblacion);

    %% Encontrar el mejor individuo inicial

    [mejorFitness, posicionMejor] = min(fitness);

    mejorIndividuo = poblacion(posicionMejor, :);

    historial = zeros(numeroGeneraciones + 1, 1);
    historial(1) = mejorFitness;

    %% Ejecutar generaciones

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

        cantidadHijos = ...
            tamanoPoblacion - cantidadPadres;

        hijos = zeros(cantidadHijos, 15);

        contadorHijos = 1;

        %% Cruce y mutación

        while contadorHijos <= cantidadHijos

            % Escoger dos padres diferentes
            indicesPadres = ...
                randperm(cantidadPadres, 2);

            padre1 = padres(indicesPadres(1), :);
            padre2 = padres(indicesPadres(2), :);

            % Aplicar o no el cruce
            if rand <= probabilidadCruce

                [hijo1, hijo2] = ...
                    cruceInventario(padre1, padre2);

            else

                hijo1 = padre1;
                hijo2 = padre2;
            end

            % Aplicar mutación
            hijo1 = mutacionInventario( ...
                hijo1, ...
                probabilidadMutacion, ...
                proporcionSigma ...
            );

            hijo2 = mutacionInventario( ...
                hijo2, ...
                probabilidadMutacion, ...
                proporcionSigma ...
            );

            % Reparar nuevamente por seguridad
            hijo1 = repararInventario(hijo1);
            hijo2 = repararInventario(hijo2);

            % Guardar el primer hijo
            hijos(contadorHijos, :) = hijo1;
            contadorHijos = contadorHijos + 1;

            % Guardar el segundo si hay espacio
            if contadorHijos <= cantidadHijos

                hijos(contadorHijos, :) = hijo2;
                contadorHijos = contadorHijos + 1;
            end
        end

        %% Formar nueva población

        poblacion = [padres; hijos];

        %% Evaluar población

        fitness = zeros(tamanoPoblacion, 1);

        for i = 1:tamanoPoblacion
            fitness(i) = ...
                fitnessInventario(poblacion(i, :));
        end

        %% Buscar el mejor de la generación

        [mejorGeneracion, posicionGeneracion] = ...
            min(fitness);

        if mejorGeneracion < mejorFitness

            mejorFitness = mejorGeneracion;

            mejorIndividuo = ...
                poblacion(posicionGeneracion, :);
        end

        historial(generacion + 1) = mejorFitness;
    end

    %% Finalizar medición

    tiempoEjecucion = toc(inicioTiempo);
end