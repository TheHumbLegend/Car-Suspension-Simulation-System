% Quarter Car Suspension System Simulation
% Rotimi Dayo 240115322
% 18th of December 2024

% Prompt user for mode selection
 valid = false;
while ~valid
    mode = input('Enter mode (sport/cruise): ', 's');
    if strcmp(mode, 'sport') || strcmp(mode, 'cruise')
        valid = true;
    else
        disp('Invalid mode. Please enter "sport" or "cruise".');
    end
end

% Set parameters based on mode
if strcmp(mode, 'sport')
    M1 = 50;     % in kg, wheels-axles etc. (for quarter car)
    M2 = 250;    % in kg, chassis (for quarter car)
    M3 = 100;     % in kg, seat and driver (for quarter car)

    K1 = 2200;   % N/m, spring coefficient
    K2 = 13000;  % N/m, spring coefficient (sports mode)
    K3 = 120000; % N/m, spring coefficient

    C1 = 700;    % Ns/m, damping coefficient
    C2 = 1500;   % Ns/m, damping coefficient
    C3 = 300;    % Ns/m, damping coefficient
else
    M1 = 50;     % in kg, wheels-axles etc. (for quarter car)
    M2 = 250;    % in kg, chassis (for quarter car)
    M3 = 100;     % in kg, seat and driver (for quarter car)

    K1 = 2200;   % N/m, spring coefficient
    K2 = 8000;  % N/m, spring coefficient (cruise mode)
    K3 = 120000; % N/m, spring coefficient

    C1 = 700;    % Ns/m, damping coefficient
    C2 = 900;   % Ns/m, damping coefficient (cruise mode)
    C3 = 300;    % Ns/m, damping coefficient
end

% Run Simulink model
sim('car_suspension_absolutedisplacements');

%% Plotting
f_size = 15; 
figure
plot(output.Time, output.Data(:,4), 'linewidth', 2, 'markersize', 12); % plot 1st output data vs time, i.e. r
xlabel('Time [s]', 'interpreter', 'latex', 'fontsize', f_size); 
ylabel('Input - r(t)', 'interpreter', 'latex', 'fontsize', f_size); 
grid on; 

% Calculate step response characteristics
info_2 = stepinfo (output.Data(:,4), output.Time, 'SettlingTimeThreshold', 0.02);
info_5 = stepinfo (output.Data(:,4), output.Time,'SettlingTimeThreshold', 0.05);

% Display results
disp(['Mode: ' mode]);
disp(['Rise Time: ', num2str(info_2.RiseTime)]);
disp(['Overshoot: ', num2str(info_2.Overshoot)]);
disp(['Settling Time (2%): ', num2str((info_2.SettlingTime)-1)]);
disp(['Settling Time (5%): ', num2str((info_5.SettlingTime)-1)]);


