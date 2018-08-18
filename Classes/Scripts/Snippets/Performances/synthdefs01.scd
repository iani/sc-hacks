/* 12 Aug 2018 13:19
Some synthdefs repeatedly used since 2016
*/
[
	SynthDef("mysterymetals", {
		var x;
		GVerb.ar(TGrains.ar(2,
			Pulse.ar(\pulse.kr(3)),
			Buffer.read(s,Platform.resourceDir+/+"sounds/a11wlk01.wav"),
			Sweep.ar(x=Pulse.ar(\spulse.kr(4s))),x,Sweep.ar(x))
		).adsrOut 
	}),
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
	}),
	SynthDef("gardellino", {
		var a, b;
		a = SinOsc;
		Formlet.ar(
			a.ar(
				Convolution.ar(
					b = GbmanN.ar(
						Stepper.ar(
							a.ar(\stepper.kr(5)))
					), b
				)
			),
			a.ar(Sweep.ar(a.ar(\sweep.kr(1/9)), \sweep2.kr(2)))
			.range(\lo.kr(1e3), \hi.kr(4e3)), 
			\form1.kr(0.01), \form2.kr(1/99)
		).dup(2).ladsrOut;
	})
] do: _.add;
