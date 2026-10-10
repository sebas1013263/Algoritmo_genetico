function Z = fitnessInventario(individuo)
% FITNESSINVENTARIO calcula la estimacion de ventas no
% realizadas o pedidos pendientes por falta de inventario.
%
% El individuo tiene 15 posiciones:
%
% [Q1 Q2 Q3 Q4 Q5 S1 S2 S3 S4 S5 K1 K2 K3 K4 K5]
%
% Z:
% Valor que se desea minimizar.

    % Penalizacion para individuos que no cumplen restricciones
    penalizacion = 1e12;

    % Verificar que el individuo tenga 15 variables
    if ~isnumeric(individuo) || numel(individuo) ~= 15
        Z = penalizacion;
        return;
    end

    % Convertir el individuo en un vector fila
    individuo = individuo(:)';

    % Verificar que no contenga NaN o valores infinitos
    if any(~isfinite(individuo))
        Z = penalizacion;
        return;
    end

    % Separar las variables
    Q = individuo(1:5);
    S = individuo(6:10);
    K = individuo(11:15);

    % Datos fijos de la Tabla II
    D = [12000 80000 150000 50000 100000];
    m = [20 220 900 120 180];
    mu = [300 4000 7000 2000 3500];
    sigma = [100 1200 2500 700 1100];

    % Limites de las variables S
    limiteInferiorS = [0 0 0 0 0];
    limiteSuperiorS = [200 1200 2500 800 1500];

    % Limites de las variables K
    limiteInferiorK = [0 0 0 0 0];
    limiteSuperiorK = [500 2000 5000 1500 3000];

    % La inversion total indicada en la guia
    inversionObjetivo = 8000;

    % Todos los valores Q deben ser mayores que cero
    if any(Q <= 0)
        Z = penalizacion;
        return;
    end

    % Comprobar los limites de S
    if any(S < limiteInferiorS) || ...
       any(S > limiteSuperiorS)

        Z = penalizacion;
        return;
    end

    % Comprobar los limites de K
    if any(K < limiteInferiorK) || ...
       any(K > limiteSuperiorK)

        Z = penalizacion;
        return;
    end

    % Calcular la inversion del individuo
    inversionCalculada = sum(Q ./ 2 + S);

    % Tolerancia para comparar valores decimales
    tolerancia = 1e-6;

    % Comprobar la restriccion de igualdad
    if abs(inversionCalculada - inversionObjetivo) > tolerancia
        Z = penalizacion;
        return;
    end

    % Inicializar el valor total
    Z = 0;

    % Calcular el aporte de cada uno de los cinco productos
    for i = 1:5

        % Punto a partir del cual comienza la integral
        limiteIntegral = S(i) + K(i);

        % Densidad de una distribucion normal
        densidadNormal = @(x) ...
            (1 ./ (sqrt(2 * pi) * sigma(i))) .* ...
            exp(-0.5 .* ((x - mu(i)) ./ sigma(i)) .^ 2);

        % Funcion que se debe integrar
        integrando = @(x) ...
            ((x - S(i) - K(i)) ./ m(i)) .* ...
            densidadNormal(x);

        % Integral desde S(i) + K(i) hasta infinito
        resultadoIntegral = integral( ...
            integrando, limiteIntegral, Inf ...
        );

        % Aporte de este producto al resultado total
        aporteProducto = ...
            (D(i) / Q(i)) * resultadoIntegral;

        Z = Z + aporteProducto;
    end
end