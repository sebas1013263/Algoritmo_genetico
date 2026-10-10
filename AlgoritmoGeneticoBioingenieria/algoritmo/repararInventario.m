function individuoReparado = repararInventario(individuo)
% REPARARINVENTARIO ajusta un individuo para que
% cumpla los limites y la inversion total de 8000.
%
% Estructura:
% [Q1 Q2 Q3 Q4 Q5 S1 S2 S3 S4 S5 K1 K2 K3 K4 K5]

% Comprobar el tamaño
if ~isnumeric(individuo) || numel(individuo) ~= 15
    error('El individuo debe contener 15 variables.');
end

% Convertir en vector fila
individuo = individuo(:)';

% Comprobar valores inválidos
if any(~isfinite(individuo))
    error('El individuo no puede contener NaN o Inf.');
end

% Separar las variables
Q = individuo(1:5);
S = individuo(6:10);
K = individuo(11:15);

% Límites
limiteSuperiorQ = 16000;

limiteInferiorS = [0 0 0 0 0];
limiteSuperiorS = [200 1200 2500 800 1500];

limiteInferiorK = [0 0 0 0 0];
limiteSuperiorK = [500 2000 5000 1500 3000];

inversionObjetivo = 8000;

%% Reparar las variables S

S = max(S, limiteInferiorS);
S = min(S, limiteSuperiorS);

%% Reparar las variables K

K = max(K, limiteInferiorK);
K = min(K, limiteSuperiorK);

%% Reparar Q1, Q2, Q3 y Q4

valorMinimoQ = 1;

Q(1:4) = max(Q(1:4), valorMinimoQ);
Q(1:4) = min(Q(1:4), limiteSuperiorQ);

% Suma total que deben tener todos los valores Q
sumaTotalQ = 2 * ...
    (inversionObjetivo - sum(S));

% Reservar como mínimo 1 para Q5
maximoParaPrimerosCuatro = ...
    sumaTotalQ - valorMinimoQ;

% Si los cuatro primeros Q utilizan demasiado dinero,
% reducirlos proporcionalmente
if sum(Q(1:4)) > maximoParaPrimerosCuatro

    factorReduccion = ...
        maximoParaPrimerosCuatro / sum(Q(1:4));

    Q(1:4) = Q(1:4) .* factorReduccion;
end

%% Calcular nuevamente Q5

Q(5) = 2 * ( ...
    inversionObjetivo ...
    - sum(S) ...
    - sum(Q(1:4)) / 2 ...
    );

% Construir el individuo reparado
individuoReparado = [Q S K];
end