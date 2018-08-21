SynthDef("mysterymetals", {
	var x;
	GVerb.ar(TGrains.ar(2,
		Pulse.ar(\pulse.kr(3)),
		Buffer.read(s,Platform.resourceDir+/+"sounds/a11wlk01.wav"),
		Sweep.ar(x=Pulse.ar(\spulse.kr(4s))),x,Sweep.ar(x))
	).adsrOut 
}).add;