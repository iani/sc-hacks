//:default synthdef from Event
/*
Event:

	*makeDefaultSynthDef k{
		SynthDef(\default, { arg out=0, freq=440, amp=0.1, pan=0, gate=1;
			var z;
			z = LPF.ar(
				Mix.new(VarSaw.ar(freq + [0, Rand(-0.4,0.0), Rand(0.0,0.4)], 0, 0.3, 0.3)),
				XLine.kr(Rand(4000,5000), Rand(2500,3200), 1)
			) * Linen.kr(gate, 0.01, 0.7, 0.3, 2);
			OffsetOut.ar(out, Pan2.ar(z, pan, amp));
		}, [\ir]).add;
	}

*/
/* // NOTE:
Linen.kr creates an EnvGen running an envelope, which works in Events and Patterns.

*/
//:Test default SynthDef explicitly in event
(instrument: \default, dur: 0.2, degree: [0, 10, 1].pbrown) +> \test;
//:Testing linen - example 1
SynthDef(\linen01, { | out = 0, freq = 100, amp 0.1, pan = 0, gate = 1 |
	var src;
	src = SinOsc.ar(freq);
	// \default's OffsetOut ensures sample accuracy in timing - but this is
	// of no practical consequence here, and can be safely ignored:
	//                         attack, sustain level, release time, doneAction
	src = src * Linen.kr(gate, 0.01,   1,             0.3,           2);
	Out.ar(out, Pan2.ar(src, pan, amp));
}).add;
//:test linen. watch how synth gets released
(instrument: \linen01, dur: 1.5, legato: 0.2) +> \test;