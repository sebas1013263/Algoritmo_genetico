function [mejorIndividuo, mejorFitness, historial, ...
    tiempoEjecucion] = ...
    algoritmoGeneticoAckley( ...
        tamanoPoblacion, ...
        numeroGeneraciones, ...
        dimensiones, ...
        limites, ...
        metodoSeleccion, ...
        probabilidadCruce, ...
        probabilidadMutacion, ...
        sigmaM)
% ALGORITMOGENETICOACKLEY busca el mínimo de Ackley.
%
% tamanoPoblacion:
% Cantidad de individuos.
%
% numeroGeneraciones:
% Cantidad de iteraciones.
%
% dimensiones:
% Cantidad de variables de cada individuo.
%
% limites:
% [limiteInferior limiteSuperior].
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
% sigmaM:
% Desviación estándar de la mutación.

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

    if ~isnumeric(dimensiones) || ...
       numel(dimensiones) ~= 1 || ...
       dimensiones <= 0 || ...
       floor(dimensiones) ~= dimensiones

        error('Las dimensiones deben ser un entero positivo.');
    end

    if ~isnumeric(limites) || numel(limites) ~= 2
        error('Los limites deben contener dos valores.');
    end

    limites = limites(:)';

    if limites(1) >= limites(2)
        error('El limite inferior debe ser menor al superior.');
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

    if ~isnumeric(sigmaM) || ...
       numel(sigmaM) ~= 1 || sigmaM <= 0

        error('SigmaM debe ser un valor positivo.');
    end

    metodoSeleccion = lower(char(metodoSeleccion));

    metodosValidos = {'elitismo', 'torneo', 'ruleta'};

    if ~ismember(metodoSeleccion, metodosValidos)
        error('El metodo debe ser elitismo, torneo o ruleta.');
    end

    %% Iniciar el tiempo

    inicioTiempo = tic;

    %% Generar la población inicial

    [poblacion, fitness] = ...
        poblacionAckley( ...
            tamanoPoblacion, ...
            dimensiones, ...
            limites ...
        );

    %% Mejor individuo inicial

    [mejorFitness, posicionMejor] = min(fitness);

    mejorIndividuo = poblacion(posicionMejor, :);

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

        cantidadHijos = ...
            tamanoPoblacion - cantidadPadres;

        hijos = zeros(cantidadHijos, dimensiones);

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
                    cruceAckley(padre1, padre2);

            else

                hijo1 = padre1;
                hijo2 = padre2;
            end

            % Mutar los hijos
            hijo1 = mutacionAckley( ...
                hijo1, ...
                probabilidadMutacion, ...
                sigmaM, ...
                limites ...
            );

            hijo2 = mutacionAckley( ...
                hijo2, ...
                probabilidadMutacion, ...
                sigmaM, ...
                limites ...
            );

            % Guardar el primer hijo
            hijos(contadorHijos, :) = hijo1;
            contadorHijos = contadorHijos + 1;

            % Guardar el segundo hijo si hay espacio
            if contadorHijos <= cantidadHijos

                hijos(contadorHijos, :) = hijo2;
                contadorHijos = contadorHijos + 1;
            end
        end

        %% Crear la nueva población

        poblacion = [padres; hijos];

        %% Evaluar la nueva población

        fitness = zeros(tamanoPoblacion, 1);

        for i = 1:tamanoPoblacion
            fitness(i) = ...
                fitnessAckley(poblacion(i, :));
        end

        %% Mejor individuo de la generación

        [mejorGeneracion, posicionGeneracion] = ...
            min(fitness);

        if mejorGeneracion < mejorFitness

            mejorFitness = mejorGeneracion;

            mejorIndividuo = ...
                poblacion(posicionGeneracion, :);
        end

        historial(generacion + 1) = mejorFitness;
    end

    %% Finalizar el tiempo

    tiempoEjecucion = toc(inicioTiempo);
end