\allsensors.v(
	\gyroscope_x.slider([0, 1.0], \allsensors),
	\gyroscope_y.slider([0, 1.0], \allsensors),
	\gyroscope_z.slider([0, 1.0], \allsensors),
	\magnetometer_x.slider([0, 1.0], \allsensors),
	\magnetometer_y.slider([0, 1.0], \allsensors),
	\magnetometer_z.slider([0, 1.0], \allsensors),
	\accelerometer_x.slider([0, 1.0], \allsensors),
	\accelerometer_y.slider([0, 1.0], \allsensors),
	\accelerometer_z.slider([0, 1.0], \allsensors),
);
//:

\gyroscope_x <+.allsensors '/gyroscope'.osc(0, [-50, 50.0], [0.0, 1] );
\gyroscope_y <+.allsensors '/gyroscope'.osc(1, [-50, 50.0], [0.0, 1] );
\gyroscope_z <+.allsensors '/gyroscope'.osc(2, [-50, 50.0], [0.0, 1] );
\magnetometer_x <+.allsensors '/magnetometer'.osc(0, [-1.0, 1.0], [0.0, 1]);
\magnetometer_y <+.allsensors '/magnetometer'.osc(1, [-1.0, 1.0], [0.0, 1]);
\magnetometer_z <+.allsensors '/magnetometer'.osc(2, [-1.0, 1.0], [0.0, 1]);
\accelerometer_x <+.allsensors '/acceleration'.osc(0, [-50, 50.0], [0.0, 1]);
\accelerometer_y <+.allsensors '/acceleration'.osc(1, [-50, 50.0], [0.0, 1]);
\accelerometer_z <+.allsensors '/acceleration'.osc(2, [-50, 50.0], [0.0, 1]);