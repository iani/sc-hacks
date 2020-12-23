SynthDef("boombah", {
	var a, f;
	a = SinOsc.ar(_);
	f = Stepper.ar(
		LFPulse.ar(
			\pfreq.kr(53) + (
				\mystery.kr(329) 
				* a.(Duty.ar(
					\dutyRate.kr(1), 0, Dseq([\d1.kr(5),\d2.kr(5),\d3.kr(5),\d4.kr(7)],
						inf))))));
	a.(\mystery2.kr(334)/f).tanh
	.dup(2).ladsrOut;
}).add