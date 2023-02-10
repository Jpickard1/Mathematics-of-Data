%% MATH-BIOINF-STATS 547: Mathematics of Data
% Problem Set 3
close all

%% Problem 1 
% Parameters
t_span = 100;
e=0.01;
varnames = {'x1','y1','x2','y2'};

for z = 1:3
    %%% Coupling parameter and initial conditions %%%
    if z == 1
        c = 0.0;
        init = [.1, -.1, -.5, 1];
    elseif z == 2
        c = 0.1;
        init = [.1, -.1, -.5, 1];
    elseif z == 3
        c = .6;
        init = [.1, -.1, -.1, .1];
    end
    
    %%% ODE solver %%%
    [t, y_eq] = ode45(@(t,y) PS3_eq(t,y,c), [0,t_span], init);%, odeopts);

    %%% function plot over time %%%
    h = figure('Position', [496 401 798 583]);
    subplot(3,3,[1,2])
    plot(t, y_eq(:,:),'LineWidth',1)
    ylabel('x,y')
    xlabel('t')
    legend(varnames)
    title(['IC = [',num2str(init(1)),' ',num2str(init(2)),' ',num2str(init(3)),...
            ' ',num2str(init(4)),'], c=',num2str(c)])
    xlim([0, t_span])
    set(gca,'FontSize',12,'LineWidth',1.25)

    %%% phase coupling plot %%%
    subplot('position',[0.73,0.71,0.16,0.22])
    plot(y_eq(:,1), y_eq(:,2),'LineWidth',1);hold on
    plot(y_eq(:,3), y_eq(:,4),'LineWidth',1)
    xlabel('x')
    ylabel('y')
    axis square
    buff = .1;
    axis([min([y_eq(:,1);y_eq(:,3)])-buff max([y_eq(:,1);y_eq(:,3)])+buff...
        min([y_eq(:,2);y_eq(:,4)])-buff max([y_eq(:,2);y_eq(:,4)])+buff])
    set(gca,'FontSize',12,'LineWidth',1.25)

    %%% DMD %%%
    thresh = .9;
    deltaT = mean(diff(t));
    p = 20;

    Output = DMD(y_eq',[],thresh);
    
    for i = 1:Output.DMD.r
        emp_omega_r_phi(i,1) = imag(log(Output.DMD.D(i))/deltaT)/(2*pi);
        emp_omega_r_phi(i,2) = abs(Output.DMD.D(i));
        emp_omega_r_phi(i,3) = atan2(imag(Output.DMD.D(i)),real(Output.DMD.D(i)))*(180/pi);
    end

    %%% eigen value spectrum of A tilde %%%
    figure(h)
    subplot('position',[.05 .1 .4 .4])
    D = Output.DMD.D;
    D_plot = zeros(length(D),2);
    for i = 1:length(D)
        D_plot(i,1) = real(D(i));
        D_plot(i,2) = imag(D(i));
    end

    M_size = sort(1:Output.DMD.r,'descend');
    M_size_norm = normalize_var(M_size,5,10);

    circle(0,0,1);hold on
    line([0 0],[-2 2])
    line([-2 2], [0 0])
    for i = 1:length(D)
        plot(D_plot(i,1), D_plot(i,2), 'rx','MarkerSize', M_size_norm(i),'LineWidth', M_size_norm(i)/2)
        text(D_plot(i,1),D_plot(i,2),num2str(norm(D_plot(i,:))))
    end
    xlim([-1.5 1.5])
    ylim([-1.5 1.5])
    axis square
    xlabel('Real')
    ylabel('Imaginary')
    title('Eigenvalues of A tilde')
    box on
    set(gca,'FontSize',12,'LineWidth',1.25)

    %%% Mode selection %%%
    for i = 1:Output.DMD.r
        x(i) = abs(emp_omega_r_phi(i,1));
        y(i) = (abs(Output.DMD.D(i))^p)*norm(Output.DMD.DynamicModes(:,i));
    end

    %%% phase of variables to first dynamic mode %%%
    figure(h)
    subplot('position',[.55 .1 .4 .4])
    circle(0,0,1);hold on
    line([0 0],[-2 2])
    line([-2 2], [0 0])
    plot(Output.DMD.DynamicModes(:,1),'rx')
    for i = 1:length(Output.DMD.DynamicModes(:,1))
        text(real(Output.DMD.DynamicModes(i,1)),imag(Output.DMD.DynamicModes(i,1)),varnames{i})
    end
    xlim([-1.5 1.5])
    ylim([-1.5 1.5])
    axis square
    xlabel('Real')
    ylabel('Imaginary')
    title('Variable phase in first dynamic mode')
    box on
    set(gca,'FontSize',12,'LineWidth',1.25)

end


%% Problem 2
load('ecog_window.mat');

% Uncomment this if you'd like to visualize the data
% figure
% imagesc(X)

% Parameters:
thresh = .9;
nstacks = 17; % number of stacks

% Construct the augmented, shift-stacked data matrices
% This resolves DMD's issues with standing waves
Xaug = [];
for st = 1:nstacks
    Xaug = [Xaug; X(:, st:end-nstacks+st)];
end

for i_aug = 1:2
%%% Compute DMD on Xaug (or X) %%% 
    if i_aug == 1
        Output = DMD(X,[],thresh);
    elseif i_aug == 2
        Output = DMD(Xaug,[],thresh);
    end



    % Extracting out DMD outputs with nicer variable names
    lambda = Output.DMD.D;
    omega = log(lambda)/dt/2/pi;
    S_r = Output.DMD.Sig(1:Output.DMD.r,1:Output.DMD.r);
    V_r = Output.DMD.VX(:,1:Output.DMD.r);
    Atilde = Output.DMD.A;
    X = Output.X;
    Xp = Output.Xp;

    %%% Plot eigenvalues %%%
    figure('Position', [496 401 798 583]);
    subplot(2,2,1);
        plot(lambda, 'k.');
        rectangle('Position', [-1 -1 2 2], 'Curvature', 1, ...
            'EdgeColor', 'k', 'LineStyle', '--');
        axis(1.2*[-1 1 -1 1]);
        axis square;
        title('\lambda')
        set(gca,'FontSize',12,'LineWidth',1.25)
        xlabel('Real')
        ylabel('Imaginary')
    subplot(2,2,2);
        plot(omega, 'k.');
        line([0 0], 200*[-1 1], 'Color', 'k', 'LineStyle', '--');
        axis([-8 2 -170 +170]);
        axis square;
        title('\omega')
        set(gca,'FontSize',12,'LineWidth',1.25)
        xlabel('Real')
        ylabel('Frequency (Hz)')

    set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 6 3], 'PaperPositionMode', 'manual');
    % print('-depsc2', '-loose', ['../figures/DMD_eigenvalues.eps']);

    %%% DMD and FFT Spectra %%%
    % alternate scaling of DMD modes
    Ahat = (S_r^(-1/2)) * Atilde * (S_r^(1/2));
    [What, D] = eig(Ahat);
    W_r = S_r^(1/2) * What;
    Phi = Xp*V_r/S_r*W_r;

    f = abs(imag(omega));
    P = (diag(Phi'*Phi));

    % DMD spectrum
    subplot(2,2,3);
        stem(f, P, 'k');
        xlim([0 150]);
        axis square;
        title('DMD Spectrum')
        set(gca,'FontSize',12,'LineWidth',1.25)
        xlabel('Frequency (Hz)')
    % FFT spectrum
    timesteps = size(X, 2);
    srate = 1/dt;
    nelectrodes = 59;
    NFFT = 2^nextpow2(timesteps);
    f = srate/2*linspace(0, 1, NFFT/2+1);
    subplot(2,2,4); 
        hold on;
        for c = 1:nelectrodes
            fftp(c,:) = fft(X(c,:), NFFT);
            plot(f, 2*abs(fftp(c,1:NFFT/2+1)), ...
                'Color', 0.6*[1 1 1]);
        end
        plot(f, 2*abs(mean(fftp(c,1:NFFT/2+1), 1)), ...
            'k', 'LineWidth', 2);
        xlim([0 150]);
        ylim([0 400]);
        axis square;
        box on;
        title('FFT Spectrum')
        set(gca,'FontSize',12,'LineWidth',1.25)
        xlabel('Frequency (Hz)')
end
