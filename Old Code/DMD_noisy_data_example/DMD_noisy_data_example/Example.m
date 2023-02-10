clear all;
close all;

% Generate an oscillating big fake data matrix:

deltaT = .1;
omega  = 1;

t = 0 : deltaT : 20;

x1 = sin(omega*2*pi*t);
x2 = sin(omega*2*pi*t + pi/4);

rng(1,'twister');
DATA = randn(10000,2)*[x1;x2];  

% Run DMD - Note the data time - series is now 10000 x 201

Output = DMD(DATA,[],.99);

%Evaluate Singular Value distribution - Note two values are picked.
figure,
semilogy(diag(Output.DMD.Sig)/sum(diag(Output.DMD.Sig)),'.')
xlabel('Sig number')
ylabel('Energy')
set(gca,'LineWidth',1.25,'FontSize',12,'XLim',[0 size(DATA,2)])
xlabel('Time')


%Evaluate eigenvalues - Note the omega of the underlying time-series is
%found
empirical_omega = imag(log(Output.DMD.D(1))/deltaT)/(2*pi);


% Data
figure
subplot(2,1,1)
    plot(x1,'LineWidth',1.25)
    hold on
    plot(x2,'LineWidth',1.25)
    set(gca,'LineWidth',1.25,'FontSize',12,'XLim',[0 size(DATA,2)])
    title('Original Signals')
xlabel('Time')
subplot(2,1,2)
    plot(DATA(1:100,:)','LineWidth',1.25)
    set(gca,'LineWidth',1.25,'FontSize',12,'XLim',[0 size(DATA,2)])
    xlabel('Time')
    title('Noisy Data')


% Identifying most influential variable
Phi = Output.DMD.DynamicModes;
phi_1 = Phi(:,1);
[max_val, max_idx] = max(abs(phi_1));
[min_val, min_idx] = min(abs(phi_1));

figure
plot(DATA(max_idx,:),'LineWidth',1.25)
hold on,
plot(DATA(min_idx,:),'LineWidth',1.25)
legend({'Max','Min'})
set(gca,'LineWidth',1.25,'FontSize',12,'XLim',[0 size(DATA,2)])
xlabel('Time')
