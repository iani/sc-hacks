// Examples for playing buffers
//:preload include /buffers default lindrum
/* This snippet loads buffers when the server boots.
It does not play a sound, it only loads buffers for other snippets.
It does however also open the BufferGUI to show which buffers are loaded.
*/
BufferGUI();
nil; // this line prevents the results of the snippet from being sent to the player.
//:Play a buffer one shot
{ PlayBuf.ar(1, \tomll.b).stereo }
//:Play a buffer, looping
{ PlayBuf.ar(1, \tomll.b, loop: 1).stereo }
//:Play a buffer, triggering at random intervals
{ PlayBuf.ar(1, \kick.b, trigger: Dust.kr([3, 3]), loop: 0) }
//:Play a buffer, triggering at regular intervals
{ PlayBuf.ar(1, \kick.b, trigger: Impulse.kr([3, 4]), loop: 0) }
//:Trigger at regular intervals, change start point each time
{
	var buf, trig;
	buf = \a11wlk01.b.bufnum;
	trig = Impulse.kr(3);
	PlayBuf.ar(1, buf,
		trigger: trig,
		startPos: Demand.kr(trig, 0, Dwhite()) * BufFrames.kr(buf),
		loop: 0).stereo
};

//:change start point and rate at each trigger
{
	var buf, trig, rates, spoints;
	buf = \a11wlk01.b.bufnum;
	trig = Impulse.kr(5);
	#rates, spoints = Demand.kr(trig, 0, [Dwhite(0.3, 3), Dwhite()]);
	PlayBuf.ar(1, buf,
		rate: rates,
		trigger: trig,
		startPos: spoints * BufFrames.kr(buf),
		loop: 0).stereo
};

//:As above, with different buffer
{
	var buf, trig, rates, spoints;
	buf = 'a11wlk01-44_1'.b.bufnum;
	trig = Impulse.kr(5);
	#rates, spoints = Demand.kr(trig, 0, [Dwhite(0.3, 3), Dwhite()]);
	PlayBuf.ar(1, buf,
		rate: rates,
		trigger: trig,
		startPos: spoints * BufFrames.kr(buf),
		loop: 0).stereo
};
//:As above, with brownian value sequence
{
	var buf, trig, rates, spoints;
	buf = 'a11wlk01-44_1'.b.bufnum;
	trig = Impulse.kr(5);
	#rates, spoints = Demand.kr(trig, 0, [Dbrown(0.3, 3, 0.1), Dbrown(0, 1, 0.1)]);
	PlayBuf.ar(1, buf,
		rate: rates,
		trigger: trig,
		startPos: spoints * BufFrames.kr(buf),
		loop: 0).stereo
};
//:Control period, rate + start point with GUI
\buffer.v(
	// less than 0.1 delay risks entering perceptible frequency range
	\rate.slider([0.1, 3.0]),
	\startpos.slider([0.0, 1.0]),
	\period.slider([0.1, 3])
);
{
	var buf, trig;
	buf = 'a11wlk01-44_1'.b.bufnum;
	trig = Impulse.kr(\period.kr(1).reciprocal);
	PlayBuf.ar(1, buf,
		rate: \rate.kr(1),
		trigger: trig,
		startPos: \startpos.kr(0) * BufFrames.kr(buf),
		loop: 0).stereo
};
//:Advance starting point
{
	var buf, numFrames, trig, startpos;
	buf = 'a11wlk01'.b.bufnum;
	numFrames = 'a11wlk01'.b.numFrames;
	trig = Impulse.kr(\period.kr(0.1).reciprocal);
	startpos = Demand.kr(trig, 0,
		Dser((0..(numFrames / 441).asInteger) / 100, inf));
	PlayBuf.ar(1, buf,
		rate: \rate.kr(1),
		trigger: trig,
		startPos: startpos * BufSampleRate.kr(buf),
		loop: 0).stereo
}
//:Grain
{
	GrainBuf.ar(2,          // num channels
		Impulse.kr(1),      // trigger
		0.5,                // grain duration
		\a11wlk01.b.bufnum, // buffer
		1,                  // rate
		0                   // position
	)	
}
//:Scrolling Grain
\buffer.v(
	\period.slider([0.05, 1])
);

{
	var buf, bufdur, trig, step = 0.01, startpos;
	buf = \a11wlk01.b;
	bufdur = buf.numFrames / buf.sampleRate;
	trig = Impulse.kr(\period.kr(0.5).reciprocal);
	startpos = Demand.kr(trig, 0,
		Dser((0, step / bufdur ..1), inf));
	GrainBuf.ar(2,              // num channels
		trig, // Impulse.kr(10),                   // trigger
		\dur.kr(0.5),           // grain duration
		buf.bufnum,             // buffer
		1,                      // rate
		startpos                // position
	)	
}
