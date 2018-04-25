function R = MC_LUT_forward(lambda, params)
% function E = MC_LUT_inverse(S)
% 
% MC_LUT_FORWARD is the LUT based forward model that generates a spectrum
%	at the wavelength specified in LAMBDA with the parameters specified 
%	in PARAMS
%
% INPUT
%	lambda	- wavelength (nm)
%	params	- parameters:
%		1) Concentration Hb              (mg/ml)
%		2) Reduced Scattering at 630nm	 (cm^-1)
%		3) Reduced Scattering Exponent B (unitless)
%
% OUTPUT 
%   R		- Modeled Spectrum
% Written by Ricky Hennessy
% Please cite J. Biomed. Opt. 18(3), 037003

%% Globals
global LUT mua_v musp_v

%% Find musp & mua
[musp mua] = optprop(lambda, params);

%% Prevent Values Outside LUT
musp(musp < min(musp_v))	= min(musp_v);
musp(musp > max(musp_v))	= max(musp_v);

mua(mua < min(mua_v))		= min(mua_v);
mua(mua > max(mua_v))		= max(mua_v);

%% Create Spectra
R = zeros(length(lambda),2);
R(:,1) = lambda;
R(:,2) = interp2(mua_v, musp_v, LUT', mua, musp);
