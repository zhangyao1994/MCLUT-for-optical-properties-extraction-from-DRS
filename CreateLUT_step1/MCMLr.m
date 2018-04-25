% MCMLr.m
% Ricky Hennessy
% 3/19/2012

function R = MCMLr(mua_e, mua_d, mus, thi, g, d, r)

% INPUTS
%   mua_e   - absorption coefficient for 1 layer, epi abs for 2 layer (cm^-1)
%   mua_d   - dermal absorption coefficient for two layer only (cm^-1)
%   thi     - epidermal thickness (cm) (=0 for 1 layer)
%   mus     - scattering coefficient (cm^-1)
%   g       - scattering anisotropy
%   d       - vector of collection fiber distances from source (cm)
%   r       - collection fiber radius (cm)
%
% OUTPUTS
%   R   - Light collected by fiber

%% Create Input File for MCML
%             n         mua     mus     g       d
if thi == 0
    layers = [1.33      mua_e   mus     g       1E9];
else
    layers = [1.44      mua_e   mus     g       thi;
              1.44      mua_d   mus     g       1E9];
end

photons     = 1E6;   % Number of photon packets to simulate
n_above     = 1.452; % Refractive index of the medium above
n_below     = 1.33;  % Refractive index of the medium below
dz          = 0.001; % Spatial resolution of detection grid, z-direction [cm]
dr          = 0.001; % Spatial resolution of detection grid, r-direction [cm]
Ndz         = 100;   % Number of grid elements, z-direction
Ndr         = 100;  % Number of grid elements, r-direction
Nda         = 30;    % Number of grid elements, angular-direction

create_MCML_input_file('mcml',photons,layers,n_above,n_below,dz,dr,Ndz,Ndr,Nda);

%% Run GPUMCML
system('GPUMCML mcml.mci') %% Random Seed

%% Run Conv (Edit conv_input.txt file to change Conv parameters)
system('Conv.exe<conv_input.txt')

%% Compute Results
dataRr = dlmread('out.Rrc','\t',1,0);
distance = dataRr(:,1);
refl = dataRr(:,2);

for i = 1:length(d)
    [~, loc] = min(abs(distance - d(i)));
    range = (loc-round(r/dr)):(loc+round(r/dr));
    range(range<1) = [];
    R(i) = mean(refl(range));
end
