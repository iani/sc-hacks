// Exploring variants of playing buffers directly from the Data

//
Data.default.inspect;
//: Run this  to load the buffers for playing
Data.prepareAll;
//: Test status:
Data.default.xbuffer;

// ================================================================
// 1. As sound buffers
//:
Data.doWith (\nxbuffer, { | buffer |
	{
		PlayBuf.ar (
			1,
			buffer,
			BufRateScale.kr (buffer) * \rate.kr (1),
			\trigger.kr (0),
			\startPos.kr (0),
			\loop.kr (1),
			2 // doneAction
		)
		* \amp.kr (0.1);
	} +> \b1;
})
//:
~amp = 0.5;
//:
~rate = 5;
~rate = 25;
//:
~rate = 0.5;
//: GUI
\x.vlayout (
	CSlider (\rate, [-2.0, 5.0, \lin, 0, 1]),
	CSlider (\amp, [0, 5, \lin, 0])
).front;
//: Try with x, y buffers at the same time
//:
Data.doWith (\nxyzbuffer, { | x, y, z |
	{
		[
			PlayBuf.ar (
				1,
				x,
				BufRateScale.kr (x) * \xrate.kr (1),
				\xtrigger.kr (0),
				\xstartPos.kr (0),
				\xloop.kr (1),
				2					// doneAction
			)
			* \xamp.kr (0.1),
			PlayBuf.ar (
				1,
				y,
				BufRateScale.kr (y) * \yrate.kr (1),
				\ytrigger.kr (0),
				\ystartPos.kr (0),
				\yloop.kr (1),
				2					// doneAction
			)
			* \yamp.kr (0.1)
		];
	} +> \b1;
});
\xy.vlayout (
	CSlider (\xrate, [-2.0, 5.0, \lin, 0, 1]),
	CSlider (\xamp, [0.0, 3]),
	CSlider (\yrate, [-2.0, 5.0, \lin, 0, 1]),
	CSlider (\yamp, [0.0, 3]),
).front;
//:

//:
~xamp = 0.2;
~yamp = 1.5;

//: The third dimension - z - played stereo with Pan2

~xamp = 0.0;
~yamp = 0.0;
~zamp = 0.0;
~xrate = 1.0;
~yrate = 1.0;
~zrate = 1.0;

Data.doWith (\nxyzbuffer, { | x, y, z |
	{
		[
			PlayBuf.ar (
				1,
				x,
				BufRateScale.kr (x) * \xrate.kr (1),
				\xtrigger.kr (0),
				\xstartPos.kr (0),
				\xloop.kr (1),
				2					// doneAction
			)
			* \xamp.kr (0.1),
			PlayBuf.ar (
				1,
				y,
				BufRateScale.kr (y) * \yrate.kr (1),
				\ytrigger.kr (0),
				\ystartPos.kr (0),
				\yloop.kr (1),
				2					// doneAction
			)
			* \yamp.kr (0.1)
		] +
		Pan2.ar (PlayBuf.ar (
			1,
			z,
			BufRateScale.kr (z) * \zrate.kr (1),
			\ztrigger.kr (0),
			\zstartPos.kr (0),
			\zloop.kr (1),
			2					// doneAction
		),
			\pos.kr (0),
			\zamp.kr (0.1)
		);
	} +> \b1;
});
\xyz.vlayout (
	CSlider (\xrate, [-2.0, 5.0, \lin, 0, 1]),
	CSlider (\xamp, [0.0, 3]),
	CSlider (\yrate, [-2.0, 5.0, \lin, 0, 1]),
	CSlider (\yamp, [0.0, 3]),
	CSlider (\zrate, [-2.0, 5.0, \lin, 0, 1]),
	CSlider (\zamp, [0.0, 3]),
	CSlider (\pos, [-1.0, 1.0])
).front;
//:
(
dur: 0.05,
xamp: Pbrown (0.1, 2, 0.1),
yamp: Pbrown (0.1, 2, 0.1),
zamp: Pbrown (0.1, 2, 0.1),
xrate: Pbrown (-1.1, 2, 0.1),
yrate: Pbrown (-1.1, 2, 0.1),
zrate: Pbrown (-1.1, 2, 0.1),
pos: Pbrown (-1.0, 1, 0.1),
) @> \xyz;
//:
~xamp = 0.2;
~yamp = 1.5;
~zamp = 1.5;
// ================================================================
//: Try with granulation

// ================================================================
// 2. As control buffers
//:
Data.doWith (\nxbuffer, { | buffer |
	{
		var ctl;
		ctl = PlayBuf.ar
		(
			1,
			buffer,
			BufRateScale.kr (buffer) * \rate.kr (1),
			\trigger.kr (0),
			\startPos.kr (0),
			\loop.kr (1),
			2							// doneAction
		)
		* \amp.kr (100) + \t.kr (440);

		SinOsc.ar (ctl, 0, 0.1);
		
	} +> \b1;
});
//:
~amp = 100;
~rate = 0.1;
~rate = 0.05;
~amp = 1000;
~t = 2000;
//:
Data.doWith (\nbuffer, { | buffer |
	{
		var ctl;
		ctl = PlayBuf.ar
		(
			3,
			buffer,
			BufRateScale.kr (buffer) * \rate.kr (1),
			\trigger.kr (0),
			\startPos.kr (0),
			\loop.kr (1),
			2							// doneAction
		)
		* \amp.kr (100) + \t.kr (440);
		SinOsc.ar (ctl [0], 0, 0.1)
		+
		SinOsc.ar (ctl [2], 0, 0.1);
	} +> \b1;
});
//:
Data.default.x.plot;
Data.default.y.plot;
Data.default.xyz.plot;