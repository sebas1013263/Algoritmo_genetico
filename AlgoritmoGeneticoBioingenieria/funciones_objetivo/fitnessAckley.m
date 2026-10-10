function valorFitness = fitnessAckley(X)
% FITNESSACKLEY calcula el valor de la funcion de Ackley.
%
% X:
% Vector que representa un individuo.
% Puede tener cualquier cantidad de dimensiones.
%
% valorFitness:
% Resultado de evaluar el vector X.
%
% En esta version se utiliza +3 en lugar de +e,
% como se indica en la guia de la practica.

% Comprobar que X sea un vector numerico con datos
if isempty(X) || ~isnumeric(X)
    error('X debe ser un vector numerico no vacio.');
end

% Comprobar que no existan valores infinitos o NaN
if any(~isfinite(X))
    error('X no puede contener valores infinitos o NaN.');
end

% Constantes de la funcion de Ackley
a = 20;
b = 0.2;
c = 2 * pi;

% Numero de dimensiones del individuo
d = numel(X);

% Primera parte de la funcion
sumaCuadrados = sum(X .^ 2);

termino1 = -a * exp( ...
    -b * sqrt(sumaCuadrados / d) ...
    );

% Segunda parte de la funcion
sumaCosenos = sum(cos(c * X));

termino2 = -exp(sumaCosenos / d);

% Resultado de la funcion modificada
valorFitness = termino1 + termino2 + a + 3;
end