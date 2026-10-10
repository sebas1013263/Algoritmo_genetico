clc;
clear;
close all;

% Obtener la ubicación de la carpeta principal
carpetaPrincipal = fileparts(mfilename('fullpath'));

% Agregar al path todas las carpetas del proyecto
addpath(genpath(carpetaPrincipal));

disp('Proyecto configurado correctamente.');
disp('Todas las carpetas fueron agregadas al path de MATLAB.');