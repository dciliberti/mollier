close all; clearvars; clc

% Ambient pressure in Pascal
p = 101325;

% Input temperature array in Celsius
T = -20:80;

% Water vapor pressure in Pascal
pv_star = (0.61121 * exp((18.678 - T/234.5) .* T./(257.14 + T))) * 1000;

% Air humidity in kg water per kg dry air
figure
xlim([0,40])
hold on
for phi = [0.05, 0.2, 0.6, 1.0] % THE LAST MUST BE 1.0
    Y_phi = 18.01/28.96 * phi * pv_star ./ (p - phi * pv_star);

    ax = plot(Y_phi*1000,T,'k');
    label(ax,['\phi = ', num2str(phi)],'location','right','slope')
end

% Enthalpy of moist air (inverse function)
Cpg = 1000; % air specific heat at constant pressure in J / (kg K)
Cpv = 1860; % water vapor specific heat at constant pressure in J / (kg K)
delta_hv_0 = 2500900; % water vaporization enthalpy at 0°C in J/kg

for h = [40000, 80000, 120000]
    Y_h = (h - Cpg*T) ./ (delta_hv_0 + Cpv*T);

    % Clear data points beyond 100% relative humidity
    Y_h (Y_h > Y_phi) = NaN;

    ax = plot(Y_h*1000,T,'k--');
    label(ax,['h = ', num2str(h/1000), ' kJ/kg'], 'location','center','slope')
end

hold off
xlabel('Y, g H_2O / kg dry air')
ylabel('T, Celsius')