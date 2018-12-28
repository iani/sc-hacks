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
}).add;