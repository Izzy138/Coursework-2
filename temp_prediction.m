function temp_prediction(a)

    % Define the pins
    GreenLED = 'D7'; 
    YellowLED = 'D4'; 
    RedLED = 'D2';
    Temp= 'A4'; 

    % Configure LED pins
    configurePin(a, GreenLED, 'DigitalOutput');
    configurePin(a, YellowLED, 'DigitalOutput');
    configurePin(a, RedLED, 'DigitalOutput');

    % Initialize data storage
    tempData = [];
    timeData = [];
    windowSize = 10; % Number of samples for smoothing
    startTime = datetime('now');

    fprintf('Monitoring Temperature Variations...\n');
    
    % Continuous monitoring loop
    while true
        % Read current temperature
        Temperature = readVoltage(a, Temp);
        temperature = (Temperature - 0.5) * 100; % Convert voltage to °C
        currentTime = seconds(datetime('now') - startTime);

        % Store values
        tempData = [tempData, temperature]; %#ok<AGROW>
        timeData = [timeData, currentTime]; %#ok<AGROW>

        % Compute rate of change (°C/s)
        if length(tempData) > 1
            tempChangeRate = diff(tempData) ./ diff(timeData); % Derivative
            smoothedRate = mean(tempChangeRate(max(1, end - windowSize + 1):end)); % Moving average

            % Predict temperature in 5 minutes
            tempIn5Min = temperature + (smoothedRate * 300); % 300s = 5 min

            % Print values
            fprintf('Current Temp: %.2f°C | Rate: %.3f°C/s | Predicted (5 min): %.2f°C\n', ...
                    temperature, smoothedRate, tempIn5Min);

            % Control LEDs based on rate of change
            if abs(smoothedRate) <= 0.067 % ±4°C/min threshold
                writeDigitalPin(a, GreenLED, 1);
                writeDigitalPin(a, YellowLED, 0);
                writeDigitalPin(a, RedLED, 0);
            elseif smoothedRate > 0.067 % Heating too fast
                writeDigitalPin(a, GreenLED, 0);
                writeDigitalPin(a, RedLED, 1);
                writeDigitalPin(a, YellowLED, 0);
            elseif smoothedRate < -0.067 % Cooling too fast
                writeDigitalPin(a, GreenLED, 0);
                writeDigitalPin(a, RedLED, 0);
                writeDigitalPin(a, YellowLED, 1);
            end
        end

        pause(1); % Ensure consistent timing
    end
end

% TEMP_PREDICTION Monitors temperature variation and predicts future values
% This function reads temperature values from an Arduino, calculates the 
% rate of change, predicts the temperature in 5 minutes, and controls 
% LEDs accordingly.
