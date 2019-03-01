// 24 Feb 2019 16:29
// Shortcut for creating synthefs from a single synthesis source.
// Create and add a stereo synthdef that works with patterns.
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
// (instrument: \default, dur: 0.2, degree: [0, 10, 1].pbrown) +> \test;
//:Testing linen - example 1
/*
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
(instrument: \linen01, dur: 1.5, legato: 0.2, degree: [-10, 10, 1].pbrown) +> \test;

Linen : UGen {
	*kr { arg gate = 1.0, attackTime = 0.01, susLevel = 1.0, releaseTime = 1.0, doneAction = 0;
		^this.multiNew('control', gate, attackTime, susLevel, releaseTime, doneAction)
	}
}

*/

SimpleDef {
	*new { | name, sourceFunc |
		^SynthDef(name, { | out = 0, freq = 100, amp 0.1, pan = 0, gate = 1 |
			var src;
			src = sourceFunc.(freq);
			src = src * Linen.kr(gate, 0.01, 1, 0.3, 2);
			Out.ar(out, Pan2.ar(src, pan, amp));
		}).add;
	}

	/*
		Note: if using .perc, then you should not change the legato parameter of the event played
		by the pattern.
	*/

	*perc { | name, sourceFunc |
		^SynthDef(name, { | out = 0, freq = 100, amp 0.1, pan = 0, gate = 1 |
			var src;
			src = sourceFunc.(freq);
			src = src * EnvGen.kr(Env.perc(0.01, 0.99, 1), gate, timeScale: \dur.kr, doneAction: 2);
			Out.ar(out, Pan2.ar(src, pan, amp));
		}).add;
	}

	/* Note: You can get perc-like sounds with asr, which work with different 
		values of legato.  
	*/
	*asr { | name, sourceFunc |
		^SynthDef(name, { | out = 0, freq = 100, amp 0.1, pan = 0, gate = 1 |
			var src;
			src = sourceFunc.(freq);
			src = src * EnvGen.kr(Env.asr, gate, timeScale: \dur.kr, doneAction: 2);
			Out.ar(out, Pan2.ar(src, pan, amp));
		}).add;
	}
}

/*
SimpleDef(\pf, { WhiteNoise.ar });
(instrument: \pf, dur: 0.15) +> \test;

SimpleDef(\sf, { | freq | SinOsc.ar(freq) });
(instrument: \sf, dur: 0.15, degree: [-10, 10, 1].pbrown, legato: 0.2) +> \test;

SimpleDef.perc(\p, { | freq | SinOsc.ar(freq) });
(instrument: \p, dur: 0.15, degree: [-10, 10, 1].pbrown, legato: 0.2) +> \test;

SimpleDef.asr(\asr, { | freq | SinOsc.ar(freq) });
(instrument: \asr, dur: 0.15, degree: [-10, 10, 1].pbrown, legato: 0.2) +> \test;

SimpleDef.asr(\wn, { WhiteNoise.ar });
(instrument: \wn, dur: 0.15, degree: [-10, 10, 1].pbrown, legato: 0.2) +> \test;

(legato: 0.1) +> \test;

(legato: 1) +> \test;

(legato: 1.5) +> \test;

(legato: 0.5) +> \test;

(dur: 1) +> \test;

(dur: 0.1) +> \test;

(dur: 2) +> \test;

(legato: 2) +> \test;

(legato: 0.2) +> \test;

(legato: 0.02) +> \test;

(dur: 0.181) +> \test;

*/