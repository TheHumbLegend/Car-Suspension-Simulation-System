% Task 4: Validating Suspension Design Using Realistic Road Profiles
% Name: Rotimi Dayo
% Date: 18 December 2024
%Unfortunately the code prints the mae and rmse right wheel a bunch of
%times, I have tried everything :( and also my graph is....

% Set the sampling time of the model to 1 second
set_param('Whole_Axle_Suspension_Model', 'FixedStep', '1');

% Load the timeseries road profile data
load('roadProfile_ts.mat'); % Contains 'roadprofileL_ts' and 'roadprofileR_ts'

% Check if the variables are loaded correctly
if exist('roadprofileL_ts', 'var') && exist('roadprofileR_ts', 'var')
    disp('Timeseries road profiles loaded successfully.');
else
    error('Timeseries road profiles not found in the workspace.');
end

% Prompt the user for sports or cruise mode selection
mode = input('Select mode (sport/cruise): ', 's');

% Set parameters based on mode
if strcmpi(mode, 'sport')
    C2 = 6000; % Optimal value found in Task 3
    K2 = 30000; % Optimal value found in Task 3
    disp('Sports mode selected: C2 = 6000 Ns/m, K2 = 50000 N/m');
elseif strcmpi(mode, 'cruise')
    C2 = 900; % Damping for cruise mode
    K2 = 8000; % Stiffness for cruise mode
    disp('Cruise mode selected: C2 = 900 Ns/m, K2 = 8000 N/m');
else
    error('Invalid input. Please enter "sports" or "cruise".');
end

% Assign other parameters (common for both wheels)
M1 = 50;        % Unsprung mass (kg)
M2 = 250;       % Sprung mass (kg)
M3 = 100;       % Chassis mass (kg)
K1 = 2200;      % Driver's seat stiffness (N/m)
C1 = 700;       % Driver's seat damping (Ns/m)
C3 = 300;       % Seat back friction damping (Ns/m)
K3 = 120000;    % Tire stiffness (N/m)

% Update Simulink model parameters
simin = Simulink.SimulationInput('Whole_Axle_Suspension_Model');
simin = simin.setVariable('C2', C2);
simin = simin.setVariable('K2', K2);
simin = simin.setVariable('roadprofileL_ts', roadprofileL_ts);
simin = simin.setVariable('roadprofileR_ts', roadprofileR_ts);

% Run the simulation
out = sim(simin);

% Access logged signals using indexing
logs = out.logsout;

left_wheel_pos = logs{3}.Values.Data;
right_wheel_pos = logs{4}.Values.Data;
time = logs{3}.Values.Time;

% Ensure single-dimensional data
left_wheel_pos = squeeze(left_wheel_pos);
right_wheel_pos = squeeze(right_wheel_pos);

% Check and adjust dimensions if necessary
min_len = min([length(left_wheel_pos), length(right_wheel_pos), length(roadprofileL_ts.Data), length(roadprofileR_ts.Data), length(time)]);
left_wheel_pos = left_wheel_pos(1:min_len);
right_wheel_pos = right_wheel_pos(1:min_len);
roadprofileL_ts.Data = roadprofileL_ts.Data(1:min_len);
roadprofileL_ts.Time = roadprofileL_ts.Time(1:min_len);
roadprofileR_ts.Data = roadprofileR_ts.Data(1:min_len);
roadprofileR_ts.Time = roadprofileR_ts.Time(1:min_len);
time = time(1:min_len);

% Calculate RMSE for each wheel
RMSE_left = sqrt(mean((left_wheel_pos - roadprofileL_ts.Data).^2));
RMSE_right = sqrt(mean((right_wheel_pos - roadprofileR_ts.Data).^2));

% Calculate MAE for horizontal stability
MAE_horizontal_stability = mean(abs(left_wheel_pos - right_wheel_pos));

% Plot results
figure;
subplot(2, 1, 1);
plot(time, left_wheel_pos, 'b', time, roadprofileL_ts.Data, 'r--');
xlabel('Time [s]');
ylabel('Left Wheel Position [m]');
title('Left Wheel Position vs. Road Profile');
legend('Left Wheel Position', 'Road Profile');

subplot(2, 1, 2);
plot(time, right_wheel_pos, 'b', time, roadprofileR_ts.Data, 'r--');
xlabel('Time [s]');
ylabel('Right Wheel Position [m]');
title('Right Wheel Position vs. Road Profile');
legend('Right Wheel Position', 'Road Profile');

% Display findings
fprintf('--- Suspension Validation Results ---\n');
fprintf('RMSE (Left Wheel): %.4f m\n', RMSE_left);
fprintf('RMSE (Right Wheel): %.4f m\n', RMSE_right);
fprintf('MAE (Horizontal Stability): %.4f m\n', MAE_horizontal_stability);

% Comment on Findings
if strcmpi(mode, 'sport')
    disp('In Sports Mode: The suspension provides better stability with quick response time.');
else
    disp('In Cruise Mode: The suspension ensures a smoother ride with reduced stiffness and damping.');
end
