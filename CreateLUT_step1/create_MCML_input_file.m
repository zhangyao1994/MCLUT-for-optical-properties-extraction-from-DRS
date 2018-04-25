% -------------------------------------------------------------------------
%
% create_MCML_input_file - Creates an input file (.mci) used by MCML to
%                          initiate a Monte Carlo simulation in layered
%                          media. Details on the created input file and the
%                          exact definitions of the input parameters can be
%                          found in the MCML manual.
%
% Modified: 2008-03-27 /Erik Alerstam
% 
% Useage: 
%   h=create_MCML_input_file(filename, number_of_photons, layers, n_above, n_below, dz, dr, number_of_dz, number_of_dr, number_of_da);
%
% Arguments:
%   filename,                     - Name of the created input (.mci) and output (.mco) files used to communicate with MCML. 
%                                   If the filename is already taken a number is added after the specified filename to create a
%                                   unique name and avioding overwriting
%                                   existing simulation results.
% 	number_of_photons,...         - Number of photon packets to simulate
%	layers,...                    - Layers matrix (in units of centimeters). Each row constitutes a layer in the Monte Carlo model and
%                                   specifies the refractive index, absorption and reduced scattering coefficients, g-factor and
%                                   thickness of the layer (in this particular order). The layers are added in decending order, i.e.
%                                   the first row in the matrix corresponds to the topmost layer in the model.
%	n_above,....                  - (optional, default value 1) Refractive index of the medium above.
% 	n_below,...                   - (optional, default value 1) Refractive index of the medium below.
%	dz,...                        - (optional, default value 0.01 [cm]) Spatial resolution of detection grid, z-direction [cm].
%	dr,...                        - (optional, default value 0.01 [cm]) Spatial resolution of detection grid, r-direction [cm].
%	number_of_dz,...              - (optional, default value 200) Number of grid elements, z-direction.
%	number_of_dr,...              - (optional, default value 500) Number of grid elements, r-direction.
%	number_of_da);                - (optional, default value 1) Number of grid elements, angular-direction. 
%
% Output:
%   h           - A structure echoing all the used parameters, including the optional values. Also the exact names of the input file 
%                 and the output file used are specified in the fields "input_filename" and "output_filename".
%
% Example
%
% >> h=create_MCML_input_file('simulation',50000, [1.4 0.1 10 0.8 2]);
%       This creates the file "simulation.mci" which can be used to start
%       an MCML simlation of 50000 photon packets in a single layer medium
%       of thickness 2 cm (i.e. a slab). The slab has a refractive index of
%       1.4, a reduced scattering coefficient of 10 [1/cm] an absorption
%       coefficient of 0.1 [1/cm] and a g-factor or 0.8. The result file
%       will be in ASCII.
%
%
% >> h=create_MCML_input_file('simulation2',50000, [1.4 0.1 10 0.8 2],1,2,0.1);
%       This creates the file "simulation2.mci", similar to the one above
%       with the exception that the medium under the slab has a refractive
%       index of 2 (instead of the default 1) and a coarser z-grid (dz=0.1
%       instead of 0.01 cm)
%
%
% >> h=create_MCML_input_file('simulation_two_layers',50000, [1.4 0.1 10 0.8 2;1.4 0.2 10 0.8 100]);
%       This creates the file "simulation_two_layers.mci" which can be used to start
%       an MCML simlation of 50000 photon packets in a double layer medium
%       of thickness 2 and 100 cm (i.e. effectively a semi-infinite
%       medium).  Both layers feature the same optical properties apart
%       from the absorption coefficient which is 0.2 in the lower layer.
% -------------------------------------------------------------------------

function h=create_MCML_input_file( filename,...            % Name of the created input (.mci) and output (.mco) files used to communicate with MCML
                                   number_of_photons,...   % Number of photon packets to simulate
                                   layers,...              % Layers matrix (in units of centimeters)
                                   varargin);
                                



if nargin>10
    error('To many input arguments.');%Error:To many input arguments
end

if nargin<3
    error('To few input arguments.');%Error:To few input arguments
end

%Check validity of filename
if ~isvarname(filename)
    error('Invalid filename. Filename must be a valid MATLAB variable name');
end

input_filename=[filename '.mci'];
output_filename=[filename '.mco'];

%Check validity of layers
X=size(layers);
if X(2)~=5|~isnumeric(layers)
    error('Invalid layers matrix. Must be an Xx5 numerical matrix');
end

number_of_layers=X(1);%extract the number of layers


%number of runs is limited to 1 as MATLAB can call MCML several times instead.
number_of_runs=1;

%Limit the output file to ASCII format, change AorB to B for binary output!
AorB='A';


% Check if the user has specified the optional parameters
if nargin <= 3, n_above=1; else n_above=varargin{1}; end;
if nargin <= 4, n_below=1; else n_below=varargin{2}; end;

if nargin <= 5, dz=0.01; else dz=varargin{3}; end;
if nargin <= 6, dr=0.01; else dr=varargin{4}; end;

if nargin <= 7, number_of_dz=200; else number_of_dz=varargin{5}; end;
if nargin <= 8, number_of_dr=500; else number_of_dr=varargin{6}; end;
if nargin <= 9, number_of_da=1;  else number_of_da=varargin{7}; end;




%Create the input file named filename.mci and write all the necessary data.
[fid,message] = fopen(input_filename, 'wt');

fprintf(fid, '#File created automatically by create_MCML_input_file...\n\n');%comment

fprintf(fid, '1.0\t\t\t# file version');                 % file version
fprintf(fid, '\n%d\t\t\t# Number of runs',number_of_runs); % number of runs

fprintf(fid, '\n\n### Specify data for run 1');
fprintf(fid, '\n%s %s\t\t# output filename, ASCII/Binary',output_filename,AorB); % output filename, ASCII/Binary
fprintf(fid, '\n%d\t\t\t# No. of photons',number_of_photons); % No. of photons
fprintf(fid, '\n%g %g\t\t# dz, dr',dz,dr); % dz, dr
fprintf(fid, '\n%d %d %d\t\t# No. of dz, dr & da',number_of_dz, number_of_dr, number_of_da); % No. of dz, dr & da

fprintf(fid, '\n\n%d\t\t\t# No. of layers',number_of_layers); % No. of layers
fprintf(fid, '\n%f\t\t# n for medium above',n_above); % n for medium above.
fprintf(fid, '\n#n mua mus g d\t\t# One line for each layer');
for i=1:1:number_of_layers
    fprintf(fid, '\n%g %g %g %g %g\t# layer %d',layers(i,1),layers(i,2),layers(i,3),layers(i,4),layers(i,5),i); % layer i
end
fprintf(fid, '\n%f\t\t# n for medium below',n_below); % n for medium below.

%close the file
status=fclose(fid);


%create output structure and save all interesting data 
h.input_filename=input_filename;
h.output_filename=output_filename;
h.fopen_message=message;
h.fclose_status=status;

h.AorB=AorB;
h.number_of_photons=number_of_photons;
h.layers=layers;
h.number_of_layers=number_of_layers;
h.n_above=n_above;
h.n_below=n_below;
h.dz=dz;
h.dr=dr;
h.number_of_dz=number_of_dz;
h.number_of_dr=number_of_dr;
h.number_of_da=number_of_da;

end %function create_MCML_input_file