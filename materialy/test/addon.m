
%spousteni procedur se spozdenim

t = timer;
t.TimerFcn       = @(x, y) disp("Ahoj");
t.BusyMode       = 'queue';
t.StartDelay = 5;

start(t);
for i=1:10
    disp(t.running);
    pause(1);
end

t.TimerFcn = @(x, y) disp("Nazdar");
start(t);
for i=1:10
    disp(t.running);
    pause(1);
end


%legendy

figure
t=linspace(0,10,100);
plot(t,sin(t));
hold on;

h = zeros(3, 1);
h(1) = plot(NaN,NaN,'Color',[0 0 1]);
h(2) = plot(NaN,NaN,'Color',[0 0 1]);
h(3) = plot(NaN,NaN,'Color',[0 0 1]);
se = legend(h, ["ahoj", "tady", "je"]);
se.Location = "northoutside";
whos se;