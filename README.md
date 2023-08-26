[![View Mollier chart on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://it.mathworks.com/matlabcentral/fileexchange/134312-mollier-chart)

# Mollier chart
Draws a Mollier chart in MATLAB and calculate drying rate for solid materials.

To get an example chart it is sufficient to call the function `mollier` without arguments.
![image](https://github.com/dciliberti/mollier/assets/52099779/da92080f-3ef5-43bf-aef6-5882598c90dd)

Additionally, it is possible to choose the relative humidity and specific enthalpy lines to be drawn, as well as the ambient pressure, the range of temperature defining the axis limits, and the properties of the flows.

Includes a MATLAB script (`drying_example.m`) for an application of the Mollier chart to calculate the drying rate of a non-porous, wet solid and a MATLAB live script (`drying_example.mlx`) with the theory used to develop the code, the same numerical example of the script and an advanced, interactive example. The same live script has been converted to pdf (`drying_example.pdf`) for documentation purposes.

Requires the `label` package by Chad Greene, included with a license in this repository.
[https://www.mathworks.com/matlabcentral/fileexchange/47421-label](https://www.mathworks.com/matlabcentral/fileexchange/47421-label)
