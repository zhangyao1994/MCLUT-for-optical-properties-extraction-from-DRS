function [musp mua] = optprop(lambda, params)
% function [lambda mus g mua] = getMieScatter(lambda, CHb, scatsize, scatdensity)
% 
% OPTPROP gives musp(lambda) and mua(lambda) for given parameters.
%
% INPUT
%	lambda = vector of wavelengths to evaluate (nm)
%	params = vector of input parameters, given below:
%		1) Concentration Hb				(mg/ml)
%		2) Reduced Scattering at 630nm	(cm^-1)
%		3) Reduced Scattering Exponent  (unitless)
%
% OUTPUT 
%   musp			= vector of musp(lambda)
%   mua				= vector of mua_d(lambda)
% Written by Ricky Hennessy
% Please cite J. Biomed. Opt. 18(3), 037003

%% Load Hemoglobin Data
cd Chromophores
Hb = importdata('Hb.mat');  % http://omlc.ogi.edu/spectra/hemoglobin/summary.html
Hbw = Hb(:,1);				% Wavelengths
Hbe_o = Hb(:,2);			% Oxy
cd ..

%% Get oxy & deoxy mua
mua    = params(1)*interp1(Hbw,Hbe_o,lambda);			% Oxy Extinction Coeff

%% Get musp
musp		= params(2)*(lambda/630).^(params(3));