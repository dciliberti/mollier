function mollier(varargin)
% MOLLIER() without input data draws the Mollier chart for several curves.
% By default, the fluids are water and air.
%
% REQUIRES THE 'LABEL' PACKAGE BY CHAD GREENE
% https://www.mathworks.com/matlabcentral/fileexchange/47421-label
%
% MOLLIER([PHI],[ENT]) draws the Mollier chart with specified curves for
% the relative humidity and enthalpy. PHI is a numeric array of relative
% humidities (accept values between 0.01 and 1.00) and ENT is a numeric
% array of specific entalpy in J/kg. The last PHI value will always be 1.0,
% independtly from the user input.
%
% MOLLIER([PHI],[ENT],[TEM]) draws the Mollier chart as the previous case
% with the prescribed range of temperature TEM, defined as [t_initial,
% t_final] in Celsius degrees.
%
% MOLLIER([PHI],[ENT],[TEM],P) also prescribes the ambient pressure with
% the scalar P in Pascal.
%
% MOLLIER([PHI],[ENT],[TEM],P,CPG,CPV,DELTA_HV_0) adds custom values for
% the constant pressure spefici heat for the gas CPG and the vapor CPV in
% J/(kg K), as well as the liquid vaporization enthalpy at 0°C in J/kg.

% Check if the 'label' community package has been installed
addons = matlab.addons.installedAddons;
if ~any(strcmp("label", addons.Name))
    error(['LABEL add-on not found. Please retrieve it from: ',...
        'https://www.mathworks.com/matlabcentral/fileexchange/47421-label'])
end

narginchk(0,7)

% Demo mode
relHum = [0.05, 0.2, 0.6, 1.0]; % relative humidity array
enthalpy = [40000, 80000, 120000]; % specific enthalpy array, J/kg
temp = [-20,80]; % temperature array, Celsius
pamb = 101325; % ambient pressure, Pa
Cpg = 1000; % air specific heat at constant pressure, J / (kg K)
Cpv = 1860; % water vapor specific heat at constant pressure, J / (kg K)
delta_hv_0 = 2500900; % water vaporization enthalpy at 0°C, J/kg

if nargin > 0
    relHum = varargin{1};
    enthalpy = varargin{2};

    % Check limits for relative humidity
    if min(relHum) < 0 || max(relHum) > 1
        error('Relative humidity values are out of bounds [0, 1]')
    end

    % The last value of relative humidity must be 1.0
    if relHum(end) < 1
        relHum = [relHum, 1.0];
    end
end

if nargin > 2
    temp = varargin{3};
end

if nargin > 3
    pamb = varargin{4};
end

if nargin > 4
    Cpg = varargin{5};
    Cpv = varargin{6};
    delta_hv_0 = varargin{7};
end

% Water vapor pressure in Pascal
T = temp(1):temp(2);
pv_star = (0.61121 * exp((18.678 - T/234.5) .* T./(257.14 + T))) * 1000;

% Check if vapor pressure gets larger than ambient pressure
if any(pv_star > pamb)
    warning(['Some values of the vapor pressure are larger than the ',...
        'ambient pressure. Please check the temperature interval as ',...
        'well as the ambient pressure, together with the gas properties.'])
end

% Air humidity in kg water per kg dry air
figure
xlim([0,40])
hold on
for phi = relHum
    Y_phi = 18.01/28.96 * phi * pv_star ./ (pamb - phi * pv_star);

    ax = plot(Y_phi*1000,T,'k');
    label(ax,['\phi = ', num2str(phi,'%.2f')],'location','right','slope')
end

for h = enthalpy
    Y_h = (h - Cpg*T) ./ (delta_hv_0 + Cpv*T);

    % Clear data points beyond 100% relative humidity
    Y_h (Y_h > Y_phi) = NaN;

    ax = plot(Y_h*1000,T,'k--');
    label(ax,['h = ', num2str(h/1000), ' kJ/kg'], 'location','center','slope')
end

hold off
xlabel('Humidity, g vapor / kg dry gas')
ylabel('Temperture, Celsius')

end