function temp_monitor(a) % set the code as a function

% first need to define the pins
GreenLED= 'D7'; % green LED in D7
YellowLED= 'D4'; % yellow LED in D4
RedLED= 'D2'; % red LED in D2
Temp= 'A4'; % thermistor in A4

% configure pins to outputs
configurePin(a, GreenLED, 'DigitalOutput');
configurePin(a, YellowLED, 'DigitalOutput');
configurePin(a, RedLED, 'DigitalOutput');

% define arrays for the data to be stored in
tempdata= []; % temperature array
timedata=[]; % time array
startTime= datetime('now');

% now need to create the live plot
figure;
hold on;
xlabel('Time (s)'); % creates the x label
ylabel('Temperature (°C)'); % creates the y label
title('Live temperature monitoring') % creates the graph title

% the loop needs to run constantly
while true
    % reads the temperature from the sensor
    data= readVoltage(a,Temp);
    Temperature= (data-0.5)*100; % converts voltage to degrees

    % updates the arrays with the data in
    timeran= seconds(datetime('now')-startTime);
    tempdata= [tempdata, Temperature];
    timedata= [timedata, timeran];

    % updates the live plot
    plot(timedata, tempdata, 'b-', 'LineWidth', 1.5);
    xlim([max(0, timeran-30), timeran+1]); % limits the x axis to last 30s of data
    ylim([min(tempdata)-2, max(tempdata)+2]); % adjusts the y axis as needed
    drawnow;

    % led control
    if Temperature >= 18 && Temperature <= 24
        writeDigitalPin(a, GreenLED, 1); % green led turns on
        writeDigitalPin(a, YellowLED, 0);
        writeDigitalPin(a, RedLED, 0);
    elseif Temperature < 18
        writeDigitalPin(a, GreenLED, 0);
        for i= 1:10
            writeDigitalPin(a, YellowLED, mod(i,2));
            pause(0.5); % yellow Led flashes every 0.5s
        end
    else 
        writeDigitalPin(a,GreenLED,0);
        for i = 1:20
            writeDigitalPin(a,RedLED, mod(i,2));
            pause(0.25); % red LED flashes every 0.25s
        end
    end

    pause(1) % takes readings at regular intervals
end
end


% thia code constantly measures the temperature recieved from the
% thermistor which is connected to the arduino and then the LEDs are
% controlled and light up depending on the temperature