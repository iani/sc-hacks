//: ================================================================
// location of python script for sensestage connection:
// /home/iani/Dev/sensestage191118/ssdn_python
// terminal / python command to start sensestage connection:
// sudo pydoncli.py -P osc -c newconfig_2019_Dec_13_13-28-37.xml -s /dev/ttyUSB0
// ================================================================
//:setup sensors
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\testbus1_x, 1, 0.47, 0.53, 1],
	[\testbus1_y, 2, 0.47, 0.53, 1],
	[\testbus1_z, 3, 0.47, 0.53, 1],
	[\testbus2_x, 1, 0.47, 0.53, 3], // using sensor module 3
	[\testbus2_y, 2, 0.47, 0.53, 3],
	[\testbus3_z, 3, 0.47, 0.53, 3]
);
//:
