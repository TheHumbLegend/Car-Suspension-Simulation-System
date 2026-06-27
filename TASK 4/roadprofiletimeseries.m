% Load the road profile data
load('roadProfile.mat'); % Assuming this file contains 'roadprofileL' and 'roadprofileR'

% Define the fixed step size
fixedStepSize = 1; % 1 second

% Create a time vector based on the length of the road profile data and fixed step size
numSamples = length(roadprofileL);
timeVector = (0:fixedStepSize:(numSamples-1)*fixedStepSize)';

% Ensure the time vector has the same length as the data
if length(timeVector) ~= numSamples
    error('Time vector length does not match the road profile data length.');
end

% Convert the road profile data to timeseries
roadprofileL_ts = timeseries(roadprofileL, timeVector);
roadprofileR_ts = timeseries(roadprofileR, timeVector);

% Save the timeseries objects to a new .mat file
save('roadProfile_ts.mat', 'roadprofileL_ts', 'roadprofileR_ts');

disp('Road profile data successfully converted to timeseries and saved.');
