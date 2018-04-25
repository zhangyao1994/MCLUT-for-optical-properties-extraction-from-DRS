% LUTcreate_1layer
% Created by Ricky Hennessy
% Please cite J. Biomed. Opt. 18(3), 037003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creates a LUT using the properties that you enter below. Overwrites 
% and LUT that is in current folder, so make sure to save the LUT in
% another folder if you want to keep it for future use. 1 layer
%

close all, clear all
%% Constants
d       = 0.035;    % Source Detector Separation [cm]
r       = 0.01;     % Detector Radius [cm]
s		= 0.01;     % Source Radius [cm]
g       = 0.9;      % scattering anisotropy

%% Parameters (musp muae muad th)
musp_v = linspace(0.01,50,20);  % reduced scattering
mua_v  = linspace(1,50,20);     % absorption

%% Make LUT
H = waitbar(0,'Please Wait...');
LUT = zeros([length(musp_v) length(mua_v)]);
tic
create_CONV_input_file(s)
for aa = 1:length(mua_v)
    for ss = 1:length(musp_v)
        waitbar((ss + length(musp_v)*(aa-1))/(length(musp_v)*length(mua_v)),H)
        LUT(aa,ss) = MCMLr(mua_v(aa),0,musp_v(ss)/(1-g),0,g,d,r);
    end
end
toc
close(H)

save LUT.mat LUT musp_v mua_v
