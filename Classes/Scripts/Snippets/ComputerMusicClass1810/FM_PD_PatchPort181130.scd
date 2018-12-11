/*
Port of 3 FM patches from Maximos Kaliakatsos.

Reference: Curtis Roads, The Computer Music Tutorial, p. 236-242.
*/
//:Test Basic FM code from SC doc
/*
	// Original code from: https://sccode.org/1-4UA
	// "Frequency Modulation GUI Demo 1"
SynthDef("freq-mod", {
			arg carrFreq = 440, modFreq = 5, freqDev = 20, amp = 0.01;
			var carrier, modulator;
			modulator = SinOsc.ar(freq: modFreq, mul: freqDev);
			carrier = SinOsc.ar(freq: carrFreq + modulator, mul: amp);
			Out.ar(0, [carrier, carrier]);
		})
*/
{ | carrFreq = 440, modFreq = 5, freqDev = 20, amp = 0.01 |
	var carrier, modulator;
	modulator = SinOsc.ar(freq: modFreq, mul: freqDev);
	carrier = SinOsc.ar(freq: carrFreq + modulator, mul: amp);
	Out.ar(0, carrier.dup);
} +> \fmtest
//:
\modFreq <+ 100;
//:
\freqDev <+ 300;
//:* run a routine loop to modify the arguments
\modFreq <+ 100.rrand (1000);
\freqDev <+ 30.rrand (100);
//~freqDev.postln;
0.10.wait;
//:Modify the arguments with control rate
//:other Test
{ Mix.ar(SinOsc.ar(
	100 * (1, 3/2),
	0,
	0.01
)) } +> \harmonics;
//:other Test
{ Mix.ar(SinOsc.ar(
	100 * [1, 16],
	0,
	0.01
)) } +> \harmonics;
