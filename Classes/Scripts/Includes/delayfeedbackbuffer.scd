//:Variable delay using impulse. Buffer size: Max 30 seconds delay
// and move playback position anywhere
\delay30.b(30); // max delay time with this buffer is 5 seconds
{
	var trigger; // triggers both record and playback looping to limit duration of delay
	var startPos; // start position is a control that we use several times.
	startPos = \playbackstartposition.kr(0);
	trigger = Impulse.kr(\period.kr(10).reciprocal); // trigger every period seconds
	// record + playback creates feedback loop with input
	RecordBuf.ar(
		\feedback.kr(1) * PlayBuf.ar( // record input + playback from same buffer:
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
	// playbackstartposition position determines delay time in playback!
	(\pb.kr(1) * PlayBuf.ar(\delay30.b.numChannels,
		\delay30.b,
		// trigger when record loops, but also when startPosition changes
		trigger: Changed.kr(startPos) + trigger, 
		startPos: startPos * \delay30.b.sampleRate, // playback delay 
		loop: 0)).stereo;	
} +> \delayVariablePlaybackPos;
// control for above
\delayVariablePlaybackPos.v(
	\feedback.slider([0.001, 1, \exp]),
	\period.slider([0.1, 29.9, \exp]),
	\playbackstartposition.slider([0, 29.9])
)
