// 17 May 2019 09:56 Defining SYNTHDEFS
//:nefeli's github repo:
// https://gist.github.com/NEFELIKOLLIA
//:Very simple synthdef
// Synths from this synthdef cannot be stopped by patterns
SynthDef(\whitenoise, { | out = 0, amp = 0.1 |
	var src;
	src = WhiteNoise.ar(amp);
	Out.ar(out, src);
}).add; // add synthdef to make it available to the server
//:test without pattern
a = Synth(\whitenoise);
//:you cannot release the synth
a.release;
//:you can free the synth
a.free;
//:pbind will keep adding syths without stopping them:
b = Pbind(\dur, 1, \instrument, \whitenoise).play;
//:synths keep playing
b.stop;
//:Add an envelope to be able to stop the synth
SynthDef(\noisewithenv, { | out = 0, amp = 0.1, gate = 1 |
	var src, env;
	src = WhiteNoise.ar(amp);
	env = Env.linen;
	// doneAction: 2 makes the synth stop when env stops
	Out.ar(out, src * EnvGen.kr(env, gate, doneAction: 2));
}).add;
//:try the new synthdef: stops after 1 second
a = Synth(\noisewithenv);
//:Add an envelope that plays until released
SynthDef(\noisewithadsr, { | out = 0, amp = 0.1, gate = 1 |
	var src, env;
	src = WhiteNoise.ar(amp);
	env = Env.adsr(sustainLevel: 1);
	// doneAction: 2 makes the synth stop when env stops
	Out.ar(out, src * EnvGen.kr(env, gate, doneAction: 2));
}).add;
//:try the new synthdef: stops when released
a = Synth(\noisewithadsr);
//:
a.release;
//:noisewithadsr works with pbind
b = Pbind(\dur, 0.25, \instrument, \noisewithadsr).play;
//:correcting the new synthdef by nefeli
SynthDef(\stf, { | freq = 400, amp = 1.0, out = 0, gate = 1 |
	var env, sig;
	env = Env.adsr(releaseTime: 0.01, sustainLevel: 1);
	sig = SinOsc.ar(freq, 0, env.kr(2, gate));
	Out.ar(out, sig);
}).add;
//:test new synthdef whith pbind
a = Pbind(\degree, Pseq((0..7), inf), \dur, 0.1, \instrument, \stf).play;
//:stop pbind
a.stop;
//:test gate parameter for stopping synth made from synthdef
a = Synth(\stf);
//:setting the gate to 0 releases the synth
a.set(\gate, 0);
//:setting the gate to < 0 releases the synth and sets release time
a.set(\gate, -5.0); // release time of 5 seconds
//:setting the gate to < 0 releases the synth and sets release time
a.set(\gate, -1.05); // release time of 0.05 seconds
//:it is easier to use the release message:
a.release(0.05);
//:it is easier to use the release message:
a.release(0.95);