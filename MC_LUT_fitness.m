function E = MC_LUT_fitness(params)
% function E = MC_LUT_fitness(X)
% 
% MC_LUT_FITNESS calculate the sum of squares error between the modeled
%	spectra and the measured spectra with X as the vector of parameters
%	used to create the modeled spectra
%
% INPUT
%	params	= vector of input parameters, given below:
%		1) [Hb]							(mg/ml)
%		2) Reduced Scattering at 630nm	(cm^-1)
%		3) Reduced Scattering Exponent  (unitless)
%
% OUTPUT 
%   E	= value of merit function - % Error (0 - 100)
% 
% Written by Ricky Hennessy
% Please cite J. Biomed. Opt. 18(3), 037003

%% Globals
global spectra Fig1 F
warning off 

%% Create Model
R = MC_LUT_forward(spectra(:,1),params);
S = spectra(:,2);
R(:,2) = R(:,2) .* F;

%% Find Error
dif = abs(S-R(:,2))./S;
E = mean(dif) * 100;

%% Plot
if Fig1
	figure(1)
	plot(R(:,1),R(:,2),'r','linewidth',2)
	hold on
	plot(R(:,1),S,'k--','linewidth',4)
	set(gca,'fontsize',16)
	xlabel('wavelength (nm)','fontsize',16)
	ylabel('R','fontsize',16)
	axis([min(R(:,1)) max(R(:,1)) min(S)-.01 max(S)+.01])
	hold off
    drawnow
end

