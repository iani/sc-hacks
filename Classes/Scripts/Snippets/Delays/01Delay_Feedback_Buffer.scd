/* 25 Jul 2018 07:10
Delay with feedback using buffer
This allows delay time as long as buffer size.
(Note: Delay and Comb ugen maximum delay time is limited to scsynth internal allocated memory,
       which by default is less than 60 seconds.)
*/
//:alternative trigger method using Changed.kr

// NOTE: USE HEADPHONES TO PREVENT ACCUMULATING FEEDBACK FROM LOUDSPEAKERS!

\delaybuf.b(60 * 30); // max delay time with this buffer is 30 minutes
{
	var trigger; // triggers both record and playback looping to limit duration of delay
	trigger = Changed.kr(\trig.kr(0));
	// record + playback creates feedback loop with input
	RecordBuf.ar(
		In.ar(2) + PlayBuf.ar( // record input + playback from same buffer:
			\delaybuf.b.numChannels,
			\delaybuf.b,
			trigger: trigger, // restart the playback for feedback at trigger
			startPos: 0,
			loop: 0
		),
		\delaybuf.b,
		trigger: trigger,    // reset the recording position to beginning at trigger
		loop: 0
	);
	// Playback from the recorded buffer
	// sp position determines delay time in playback!
	PlayBuf.ar(\delaybuf.b.numChannels,
		\delaybuf.b,
		trigger: trigger, // default delay: 1 second
		startPos: \sp.kr(1) * \sp.b.sampleRate,
		loop: 0);	
} +> \playbuf;
//:simple retriggering loop+gui
~dt = 1;
{
	var values;
	values = Pseries(1, 1, inf).asStream;
	loop {
		\trig <+ values.next.postln;
		~dt.postln;
		(~dt max: 0.1).wait;
	}
}.fork;
\playbuf.v(
	// less than 0.1 delay risks entering perceptible frequency range
	\dt.slider([0.1, 3.0]),
	\sp.slider([0.0, 3.0])
)
//:Experiment with static delay of 1.2 seconds
\delay5.b(5); // max delay time with this buffer is 5 seconds
{
	var trigger; // triggers both record and playback looping to limit duration of delay
	trigger = Impulse.kr(1.reciprocal); // trigger every 2 seconds
	// record + playback creates feedback loop with input
	RecordBuf.ar(
		\fb.kr(1) * PlayBuf.ar( // record input + playback from same buffer:
			\delay5.b.numChannels,
			\delay5.b,
			trigger: trigger, // restart the playback for feedback at trigger
			startPos: 0,
			loop: 0
		) + In.ar(2),
		\delay5.b,
		trigger: trigger,    // reset the recording position to beginning at trigger
		loop: 0
	);
	// Playback from the recorded buffer
	// sp position determines delay time in playback!
	(\pb.kr(1) * PlayBuf.ar(\delay5.b.numChannels,
		\delay5.b,
		trigger: trigger, // default delay: 1 second
		startPos: 0 * \sp.b.sampleRate, // delay: 1.9 seconds
		loop: 0)).stereo;	
} +> \delay2;
//:Variable delay using impulse. Buffer size: Max 30 seconds daly
\delay30.b(30); // max delay time with this buffer is 5 seconds
{
	var trigger; // triggers both record and playback looping to limit duration of delay
	trigger = Impulse.kr(\dt.kr(1).reciprocal); // trigger every dt seconds
	// record + playback creates feedback loop with input
	RecordBuf.ar(
		\fb.kr(1) * PlayBuf.ar( // record input + playback from same buffer:
			\delay30.b.numChannels,
			\delay30.b,
			trigger: trigger, // restart the playback for feedback at trigger
			startPos: 0,
			loop: 0
		) + In.ar(2),
		\delay30.b,
		trigger: trigger,    // reset the recording position to beginning at trigger
		loop: 0
	);
	// Playback from the recorded buffer
	// sp position determines delay time in playback!
	(\pb.kr(1) * PlayBuf.ar(\delay30.b.numChannels,
		\delay30.b,
		trigger: trigger, // default delay: 1 second
		startPos: 0 * \sp.b.sampleRate, // playback delay 
		loop: 0)).stereo;	
} +> \delayImpulse;
// control for above
\delayImpulse.v(
	\fb.slider([0.001, 1, \exp]),
	\dt.slider([0.1, 29.9, \exp]),
	
)

//:Like above, + move playback position anywhere
\delay30.b(30); // max delay time with this buffer is 30 seconds
{
	var trigger; // triggers both record and playback looping to limit duration of delay
	var startPos; // start position is a control that we use several times.
	startPos = \sp.kr(0);
	trigger = Impulse.kr(\dt.kr(1).reciprocal); // trigger every dt seconds
	// record + playback creates feedback loop with input
	RecordBuf.ar(
		\fb.kr(1) * PlayBuf.ar( // record input + playback from same buffer:
			\delay30.b.numChannels,
			\delay30.b,
			trigger: trigger, // restart the playback for feedback at trigger
			startPos: 0,
			loop: 0
		) + In.ar(2),
		\delay30.b,
		trigger: trigger,    // reset the recording position to beginning at trigger
		loop: 0
	);
	// Playback from the recorded buffer
	// sp position determines delay time in playback!
	(\pb.kr(1) * PlayBuf.ar(\delay30.b.numChannels,
		\delay30.b,
		// trigger when record loops, but also when startPosition changes
		trigger: Changed.kr(startPos) + trigger, 
		startPos: startPos * \sp.b.sampleRate, // playback delay 
		loop: 0)).stereo;	
} +> \delayVariablePlaybackPos;
// control for above
\delayVariablePlaybackPos.v(
	\fb.slider([0.001, 1, \exp]),
	\dt.slider([0.1, 29.9, \exp]),
	\sp.slider([0, 29.9])
)
