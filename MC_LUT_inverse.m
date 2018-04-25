function [R params] = MC_LUT_inverse(S)
% function E = MC_LUT_inverse(S)
% 
% MC_LUT_INVERSE extracts the parameters from the spectrum S using
%	a LUT based inverse model
%
% INPUT
%	S	- Measured spectra. S(:,1) = wavelengths in nanometers. 
%							S(:,2) = reflectance values.
%
% OUTPUT 
%   R		- Modeled Spectra (fit)
%	params  - Extracted parameters:
%		1) [Hb]							(mg/ml)
%		2) Reduced Scattering at 630nm	(cm^-1)
%		3) Reduced Scattering Exponent  (unitless)
% Written by Ricky Hennessy
% Please cite J. Biomed. Opt. 18(3), 037003 

%% Global Variables
global spectra Fig2 F
spectra = S;

%% Initialize
	%[Hb]	mus630	 B		
X0 = [1.5	10		-1];
lb = [0		5		-1.2];
ub = [3.1	28	    -.8];

%% Optimization
options = optimset('MaxFunEvals',5000,'MaxIter',5000,'TolX',5E-8, ...
	'TOlFun',5E-8,'display','off','algorithm','interior-point');
params = fmincon(@MC_LUT_fitness,X0,[],[],[],[],lb,ub,[],options);


%% get parameters
R = MC_LUT_forward(spectra(:,1),params);
if Fig2
	figure(200)
	plot(R(:,1),R(:,2).*F,'r','linewidth',2)
	hold on
	plot(R(:,1),spectra(:,2),'k--','linewidth',4)
	set(gca,'fontsize',16)
	xlabel('wavelength (nm)','fontsize',16)
	ylabel('R','fontsize',16)
    drawnow
end
