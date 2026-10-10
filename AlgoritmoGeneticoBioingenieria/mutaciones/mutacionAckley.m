function [individuoMutado, fueMutado, ...
    posicionMutada, cambioAplicado] = ...
    mutacionAckley(individuo, probabilidadMutacion, ...
    sigmaM, limites)
% MUTACIONACKLEY modifica aleatoriamente una variable
% utilizando una distribución normal.
%
% individuo:
% Vector real que representa una solución.
%
% probabilidadMutacion:
% Probabilidad de aplicar la mutación.
%
% sigmaM:
% Desviación estándar de la mutación.
%
% limites:
% Vector [limiteInferior limiteSuperior].
% Si no se envía, se utiliza [-10 10].
%
% individuoMutado:
% Individuo después de la mutación.
%
% fueMutado:
% Indica si se aplicó la mutación.
%
% posicionMutada:
% Posición modificada. Retorna 0 si no muta.
%
% cambioAplicado:
% Número aleatorio sumado antes de limitar el resultado.

    % Convertir el individuo en vector fila
    individuo = individuo(:)';

    % Comprobar el individuo
    if isempty(individuo) || ~isnumeric(individuo)
        error('El individuo debe ser un vector numerico.');
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

    % Comprobar sigma
    if ~isnumeric(sigmaM) || ...
       numel(sigmaM) ~= 1 || ...
       sigmaM <= 0

        error('SigmaM debe ser un valor positivo.');
    end

    % Utilizar los límites predeterminados
    if nargin < 4
        limites = [-10 10];
    end

    % Comprobar los límites
    if ~isnumeric(limites) || numel(limites) ~= 2
        error('Los limites deben contener dos valores.');
    end

    limites = limites(:)';

    limiteInferior = limites(1);
    limiteSuperior = limites(2);

    if limiteInferior >= limiteSuperior
        error('El limite inferior debe ser menor al superior.');
    end

    % Comprobar que el individuo inicial sea válido
    if any(individuo < limiteInferior) || ...
       any(individuo > limiteSuperior)

        error('El individuo se encuentra fuera de los limites.');
    end

    % Valores iniciales de salida
    individuoMutado = individuo;
    fueMutado = false;
    posicionMutada = 0;
    cambioAplicado = 0;

    %% Decidir si se realiza la mutación

    if rand <= probabilidadMutacion

        % Seleccionar una posición aleatoria
        posicionMutada = randi(length(individuo));

        % Generar el cambio con distribución normal
        cambioAplicado = sigmaM * randn;

        % Aplicar el cambio
        individuoMutado(posicionMutada) = ...
            individuoMutado(posicionMutada) + ...
            cambioAplicado;

        % Reparar el límite inferior
        if individuoMutado(posicionMutada) < limiteInferior
            individuoMutado(posicionMutada) = limiteInferior;
        end

        % Reparar el límite superior
        if individuoMutado(posicionMutada) > limiteSuperior
            individuoMutado(posicionMutada) = limiteSuperior;
        end

        fueMutado = true;
    end
end