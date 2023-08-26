close all; clearvars; clc

% Input data
p_amb = 101325; % ambient pressure in Pascal
T_amb = 22;     % temperature in Celsius of ambient air
phi_amb = 0.6;  % relative humidity (0.05 - 1.00) of ambient air
T_prh = 72;     % temperature in Celsius of preheated air

% Water vapor pressure in Pascal
vaporPressure = @(T) 0.61121 * exp((18.678 - T/234.5) .* T./(257.14 + T)) * 1000;
pv_amb = vaporPressure(T_amb); % water vapor pressure of ambient air
pv_prh = vaporPressure(T_prh); % water vapor pressure of preheated air

% Air humidity in kg water per kg dry air
Y = 18.01/28.96 * phi_amb * pv_amb ./ (p_amb - phi_amb * pv_amb);

% Relative humidity of preheated air
phi_prh = p_amb / pv_prh * Y / (18.01/28.96 + Y);

% Air and water vapor constants
Cpg = 1000; % air specific heat at constant pressure in J / (kg K)
Cpv = 1860; % water vapor specific heat at constant pressure in J / (kg K)
Cpl = 4200; % liquid water specific heat at constant pressure in J / (kg K)
delta_hv_0 = 2500900; % water vaporization enthalpy at 0°C in J/kg

% Enthalpy of preheated air
h = Cpg * T_prh + Y * (delta_hv_0 + Cpv*T_prh);

% Saturation coordinates
Y_star_fun = @(T) 18.01/28.96 * vaporPressure(T) ./ (p_amb - vaporPressure(T));
h_star_fun = @(T) Cpg * T + Y_star_fun(T) * (delta_hv_0 + Cpv*T);
adb_line_fun = @(T) (h_star_fun(T) - h) / (Y_star_fun(T) - Y) - Cpl*T;

T_star = fzero(adb_line_fun,T_prh);
Y_star = Y_star_fun(T_star);
h_star = h_star_fun(T_star);

% Drying rate
alpha = 20; % heat transfer coefficient in W / (m2 K)
delta_hv = 2430300; % vaporization enthalpy at T* in J/kg
Mdot = alpha * (T_prh - T_star) / delta_hv * 3600;  % drying rate in kg / (m2 h)

%% Plot of the Mollier diagram
temp = [-20, 80];
mollier([phi_amb, phi_prh, 1.0], [40, 80, 120]*1000, temp, p_amb)

% Add annotations
hold on
ax = plot([Y, Y]*1000, [temp(1), T_amb], 'k--');
label(ax,'Y', 'location','left')

ax = plot([Y_star, Y_star]*1000, [temp(1), T_star], 'k--');
label(ax,'Y^*', 'location','left')

ax = plot([0, Y]*1000, [T_amb, T_amb], 'k');
label(ax,'T_{amb}', 'location','top')

ax = plot([0, Y]*1000, [T_prh, T_prh], 'k');
label(ax,'T_{preheat}', 'location','top')

ax = plot([Y, Y_star]*1000, [T_prh, T_star], 'k', 'LineWidth',0.1);
label(ax,'adiabatic saturation line', 'location','left','slope')

ax = plot([0, Y_star]*1000, [T_star, T_star], 'k');
label(ax,'T^*', 'location','top')

quiver(0,T_amb,Y*1000,0,'off','LineWidth',2)
quiver(Y*1000,T_amb,0,T_prh-T_amb,'off','LineWidth',2)
quiver(Y*1000,T_prh,(Y_star-Y)*1000,T_star-T_prh,'off','LineWidth',2);
quiver(Y_star*1000,T_star,-Y_star*1000,0,'off','LineWidth',2)

hold off
xlabel('Humidity, g H_2O / kg dry air')