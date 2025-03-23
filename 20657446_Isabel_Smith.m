% Isabel Smith
% egyis3@nottingham.ac.uk


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]

% a) The first thing when starting this coursework i needed to do was set
% up a GitHub account and create and link a repository where my work will
% be stored

% b) Next i updated my matlab to include the Arduino hardware package which
% enables me to interact with the arduino during coding

% c) 
a=arduino("COM5","Uno");% First i needed to establish a connection with the arduino by asigning
% it to a variable.
writeDigitalPin(a,'D4',1)% This line sends a command to apply 5V to the LED turning the light on
writeDigitalPin(a,'D4',0)% This selects the low voltage option of 0V turning off the light

for i = 1:20  % loop will cause the LED to blink 20 times
    writeDigitalPin(a, 'D4', 1); % turns LED ON
    pause(0.5); % wait for 0.5 seconds
    writeDigitalPin(a, 'D4', 0); % turns LED OFF
    pause(0.5); % wait for 0.5 seconds
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
a=arduino("COM5","Uno");
% a) First task was to set up the breadboard and circuit to allow the data
% to be taken from the sensor 

% b) This part collects the data from the sensor and stores it in an
% array
% First we need to define the variables
duration = 600; % acquisition time in seconds
data = zeros(1, duration); % creates the array for acquired data
time = 0:1:duration-1; % creates the array for time

% Then we need to add the sensor calibration constants 
TC = 0.01; % temperature coefficient in V/°C 
V0 = 0.5; % voltage at 0°C

% This section creates a loop for the data aquisition and puts it into the array
for t = 1:duration
    voltage = readVoltage(a, 'A4'); % reads the voltage from the sensor
    temperature = (voltage - V0) / TC; % converts the voltage to temperature
    data(t) = temperature; % puts the temperature data into the array
    pause(1); % wait for 1 second
end

% Now we can calculate the three statistical quantities
min_temp = min(data);% minimum temperature value
max_temp = max(data);% maximum temperature value
avg_temp = mean(data);% average temperature value

% c) Here the code will create a graph of temperature against time
figure;
plot(time, data, 'b-'); % generates the plot
xlabel('Time (seconds)'); % x axis label
ylabel('Temperature (°C)'); % y axis label
title('Temperature vs. Time'); % graph title

% d) This section of the code prints the recorded data to the screen
disp('Data logging initiated - 20/3/2025'); % date of data recording
disp('Location - Coates C20'); % location of data recording
for t = 1:60:600 % takes t every 60 seconds for the whole time
    fprintf('\nMinute      %d', (t-1)/60); % prints the minute the data is taken from
    fprintf ('\nTemperature %.2f°C\n',data(t(1:60:end,1:60:end))) %outputs the temperature value every 60s
end
fprintf('\nMax temperature     %.2f°C\n',max_temp) %displays the max temp
fprintf('Min temperature     %.2f°C\n',min_temp) %displays the minimum temp
fprintf('Average temperature %.2f°C\n',avg_temp) % displays the average temp
fprintf('\nData logging terminated\n') %prints data logging terminated 

% e) This section writes the data to a file
fileID = fopen('temperature.txt', 'w');
fprintf(fileID, 'Temperature Data Log:\n');
fprintf(fileID, 'Date - 20/3/2025\n'); 
fprintf(fileID, 'Location - Coates C20\n\n'); 
for t = 1:60:600 % takes t every 60seconds for the whole time
    fprintf(fileID,'\nMinute      %d', (t-1)/60); % prints the minute the data is taken from
    fprintf (fileID,'\nTemperature %.2f°C\n',data(t(1:60:end,1:60:end))); %outputs the temperature value every 60s
end
fclose(fileID);

% Verify file contents
fileID = fopen('temperature.txt', 'r');
fileContents = fread(fileID, '*char')';
fclose(fileID);


%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
a=arduino("COM5","Uno");
% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert reflective statement here (400 words max)


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answershere, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order