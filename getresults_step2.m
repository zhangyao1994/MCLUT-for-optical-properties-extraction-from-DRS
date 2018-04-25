% MCLUT inverse model
% Yao Zhang updated
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract scattering and absorption from reflectance data
% Written by Ricky Hennessy
% Please cite J. Biomed. Opt. 18(3), 037003

%% Calibration: calculate ratio of modeled and measured reflectance
close all, clear all

global LUT mua_v musp_v Fig1 Fig2 F
Fig0 = 0; % 1: display calibration fit; 0: don't display
Fig1 = 0; % 1: display fitting process; 0: don't display fitting process
Fig2 = 0; % 1: display fitting results; 0: don't display fitting results
PlotErrors = 0; % 1: Plot Errors; 0: No plot
num_Cal = 1; % Choose one Calibration phantom

cd CreateLUT_step1
load LUT0.mat
cd ..
load phantoms.mat % experiment data

R1 = reflectance(:,num_Cal);
R2 = MC_LUT_forward(lambdaMeas,[CHbknown(num_Cal) mus630known(num_Cal) -1.2]);
ratio(:) = R1./R2(:,2);
F=mean(ratio);

%% Construct questdlgs with options for figure plotting
choice = questdlg('Would you like checking the calibration fit?', ...
	'1-layer MCLUT inverse model', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        Fig0 = 1;
    case 'No'
        Fig0 = 0;
end

if Fig0
    figure(1)
    plot(lambdaMeas,R2(:,2).*mean(ratio),'r','linewidth',2)
    hold on
    plot(lambdaMeas,reflectance(:,num_Cal),'k--','linewidth',4)
    legend('Modeled','Measured')
    set(gca,'fontsize',16)
    xlabel('wavelength (nm)','fontsize',16)
    ylabel('R','fontsize',16)
    axis([min(lambdaMeas) max(lambdaMeas) min(reflectance(:,num_Cal))-.02 max(reflectance(:,num_Cal))+.02])
    title('Calculation Fit')
end

% Construct questdlgs with options
choice = questdlg('Would you like checking the fitting process?', ...
	'1-layer MCLUT inverse model', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        Fig1 = 1;
    case 'No'
        Fig1 = 0;
end

close(figure(1))

% Construct questdlgs with options
choice = questdlg('Would you like checking the fitting results?', ...
	'1-layer MCLUT inverse model', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        Fig2 = 1;
    case 'No'
        Fig2 = 0;
end

%% Extract scattering and absorption
R(:,1) = lambdaMeas;
[~,num_Phantom] = size(reflectance);
H = waitbar(0,'Please Wait...');
tic
for i = 1:num_Phantom
    waitbar(i/num_Phantom,H)
    R(:,2) = reflectance(:,i);
    [S params(:,i)] = MC_LUT_inverse(R);
    [musp1(:,i) mua1(:,i)] = optprop(lambdaMeas, params(:,i));
end
toc
close(H)

%% Compare extracted and measured parameters
% calculate percent errors
E_mus = sqrt(mean((mus_p(:) - musp1(:)).^2)) / ...
	(max(mus_p(:))-min(mus_p(:)));

E_mua = sqrt(mean((mua(:) - mua1(:)).^2)) / ...
	(max(mua(:))-min(mua(:)));

E_CHb = sqrt(mean((params(1,:) - CHbknown).^2)) / ...
	(max(CHbknown)-min(CHbknown));

disp(['mus Percent Error = ',num2str(E_mus * 100),'%'])
disp(['mua Percent Error = ',num2str(E_mua * 100),'%'])
disp(['CHb Percent Error = ',num2str(E_CHb * 100),'%'])

% plot musp at 630 nm 
figure(1)
for i = 1:21	
    plot(mus630known(i),mean(musp1(311,i)),'ko','markersize',10)% 
    hold on
end
plot(0:50,0:50,'k','linewidth',2)
hold off
axis([0 30 0 30])
title('Extracted vs Expected mus')
xlabel('Expected \mu_s''(\lambda_0)')
ylabel('Extracted \mu_s''(\lambda_0)')

% plot CHbknown
figure(2)
for i = 1:21	
    plot(CHbknown(i),params(1,i),'ko','markersize',10)
    hold on
end
plot(0:5,0:5,'k','linewidth',2)
hold off
axis([0 3.5 0 3.5])
title('Extracted vs Expected [Hb]')
xlabel('Expected [Hb]')
ylabel('Extracted [Hb]')

%% Plot Errors
if PlotErrors
    figure(1)
    for i = 1:21	
        Emus(i)=(mus630known(i)-musp1(311,i))/mus630known(i)*100;% 
    end
    bar(Emus);
    title('LUT SDS=0.035cm r=s=0.01cm mus')
    xlabel('Phantom Number')
    ylabel('Percent Error of mus/%')
    figure(2)
    for i = 1:21	
        EChb(i)=(CHbknown(i)-params(1,i))/CHbknown(i)*100;
    end
    bar(EChb);
    title('LUT SDS=0.035cm r=s=0.01cm mus')
    xlabel('Phantom Number')
    ylabel('Percent Error of [Hb]/%')
end