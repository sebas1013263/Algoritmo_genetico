function [individuoMutado, fueMutado, ...
    posicionMutada, cambioAplicado, sigmaUtilizado] = ...
    mutacionInventario(individuo, ...
    probabilidadMutacion, proporcionSigma)
% MUTACIONINVENTARIO modifica una de las 14 variables
% independientes y después repara el individuo.
%
% Estructura:
% [Q1 Q2 Q3 Q4 Q5 S1 S2 S3 S4 S5 K1 K2 K3 K4 K5]
%
% Q5 no se muta directamente porque se calcula
% utilizando la restricción de inversión.

    % Convertir en vector fila
    individuo = individuo(:)';

    % Comprobar el individuo
    if ~isnumeric(individuo) || numel(individuo) ~= 15
        error('El individuo debe contener 15 variables.');
    end

    if any(~isfinite(individuo))
        error('El individuo no puede contener NaN o Inf.');
    end

    % Comprobar la probabilidad
    if ~isnumeric(probabilidadMutacion) || ...
       numel(probabilidadMutacion) ~= 1 || ...
       probabilidadMutacion < 0 || ...
       probabilidadMutacion > 1

        error('La probabilidad debe estar entre 0 y 1.');
    end

    % Comprobar la proporción de sigma
    if ~isnumeric(proporcionSigma) || ...
       numel(proporcionSigma) ~= 1 || ...
       proporcionSigma <= 0

        error('La proporcion de sigma debe ser positiva.');
    end

    %% Posiciones que pueden mutar

    % Posiciones 1 a 4: Q1 a Q4
    % Posiciones 6 a 10: S1 a S5
    % Posiciones 11 a 15: K1 a K5
    posicionesIndependientes = [1:4 6:15];

    %% Límites de las 15 variables

    limiteInferior = [ ...
        1 1 1 1 1 ...
        0 0 0 0 0 ...
        0 0 0 0 0 ...
    ];

    limiteSuperior = [ ...
        16000 16000 16000 16000 16000 ...
        200 1200 2500 800 1500 ...
        500 2000 5000 1500 3000 ...
    ];

    %% Valores iniciales

    individuoMutado = individuo;
    fueMutado = false;
    posicionMutada = 0;
    cambioAplicado = 0;
    sigmaUtilizado = 0;

    %% Decidir si se realiza la mutación

    if rand <= probabilidadMutacion

        % Escoger una de las 14 variables independientes
        posicionAleatoria = ...
            randi(length(posicionesIndependientes));

        posicionMutada = ...
            posicionesIndependientes(posicionAleatoria);

        % Calcular el rango de la variable
        rangoVariable = ...
            limiteSuperior(posicionMutada) - ...
            limiteInferior(posicionMutada);

        % Calcular sigma según el rango
        sigmaUtilizado = ...
            proporcionSigma * rangoVariable;

        % Generar el cambio normal
        cambioAplicado = sigmaUtilizado * randn;

        % Aplicar la modificación
        individuoMutado(posicionMutada) = ...
            individuoMutado(posicionMutada) + ...
            cambioAplicado;

        % Aplicar límite inferior
        if individuoMutado(posicionMutada) < ...
                limiteInferior(posicionMutada)

            individuoMutado(posicionMutada) = ...
                limiteInferior(posicionMutada);
        end

        % Aplicar límite superior
        if individuoMutado(posicionMutada) > ...
                limiteSuperior(posicionMutada)

            individuoMutado(posicionMutada) = ...
                limiteSuperior(posicionMutada);
        end

        % Reparar la restricción y recalcular Q5
        individuoMutado = ...
            repararInventario(individuoMutado);

        fueMutado = true;
    end
end