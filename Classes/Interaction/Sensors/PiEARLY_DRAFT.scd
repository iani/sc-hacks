/* 26 Sep 2019 08:04

First draft discontinued. 
Interface for using sensor data received from RPI

Receives data from OSC message named after var id
(usually pi1, pi2 ... piN). 
Format of data is:
ax, ay, az, gx, gy, gz, mx, my, mz
where a = accellerometer, g = gyroscope, m = magnetometer.
Scales each data item above from an input range axinmin - axinmax
to an output range axoutmin - axoutmax.

For each of the data parameters above there is also a parameter name,
axparam, ayparam ... etc.

When an osc message id is received, all input data ax, ay ...
are scaled, and the results are used to set parameters named 
axparam, ayparam ... in environment name id.

*/

Pi {
	var <id; // OSC message for receiving pi data
	
}