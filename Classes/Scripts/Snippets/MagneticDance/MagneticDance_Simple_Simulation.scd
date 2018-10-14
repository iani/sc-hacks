//:send test deta
{
	var a, gyro, mag, accel;
	gyro = { [-40, 40, 3.5].pbrown.asStream } ! 3;
	mag = { [-0.5, 0.5, 0.1].pbrown.asStream } ! 3;
	accel = { [-10, 10, 0.1].pbrown.asStream } ! 3;	
	loop {
		a = NetAddr.localAddr;
		a.sendMsg('/gyroscope', *(gyro collect: _.next));
		a.sendMsg('/magnetometer', *(mag collect: _.next));
		a.sendMsg('/acceleration', *(accel collect: _.next));
		0.05.wait;
	}
}.fork
//:connect input to parameters
\period <+.grainbuf '/gyroscope'.osc(0, [-40, 40], [0.05, 2.0]);
\dur <+.grainbuf '/gyroscope'.osc(1, [-40, 40], [0.1, 2.0]);
\rate <+.grainbuf '/gyroscope'.osc(2, [-40, 40], [0.1, 10]);
\pos <+.grainbuf '/acceleration'.osc(0, [-10, 10], [0, 3.5]);
//:open parameter gui
\grainbuf.push;
\grainbuf.v(
	\period.slider([0.05, 2]),
	\dur.slider([0.05, 2]),
	\rate.slider([0.1, 10]),
	\pos.slider([0, 3.5])
);