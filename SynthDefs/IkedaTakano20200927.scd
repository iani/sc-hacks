/*
	Originally by Takumi Ikeda, selected/curated by Mari Takano.
	2020 08 20-27.

*/

//ガラスみたいできれい。ソロのところに？どうやったらテンポおとせる？
SynthDef("peb", { | bus = 50 |
	Mix.fill(8, {
		var fb, env, fq, osc;
		fb = (LFSaw.ar(
			Latch.ar(
				WhiteNoise.ar(0.5).abs
				+ 0.5,
				InFeedback.ar(bus,1)),1)+0.999)/2;
		Out.ar(bus, fb);
		env = 1-fb;
		fq = Latch.ar(WhiteNoise.ar(
			\noise.kr(1000))
			+ \noisep.kr(6000), fb);
		osc = SinOsc.ar(SinOsc.ar(fq*5/3,0,env**2*10000,fq),0,LPF.ar(env,100));
		Out.ar(0, \amp.kr(1)*Pan2.ar(osc,Latch.ar(WhiteNoise.ar(1),fb),0.05))})
};
); // .load;

SynthDef("pebb", { | bus = 50 |
	Mix.fill(8, {
		var fb, env, fq, osc;
		fb = (LFSaw.ar(
			Latch.ar(
				WhiteNoise.ar(0.5).abs
				+ 0.5,
				InFeedback.ar(bus,1)),1)+0.999)/2;
		Out.ar(bus, fb);
		env = 1-fb;
		fq = Latch.ar(WhiteNoise.ar(
			\noise.kr(1000))
			+ \noisep.kr(6000), fb);
		osc = SinOsc.ar(SinOsc.ar(fq*5/3,0,env**2*10000,fq),0,LPF.ar(env,100));
		Out.ar(0, \amp.kr(1)*Pan2.ar(osc,Latch.ar(WhiteNoise.ar(1),fb),0.05))})
};
); // .load;


SynthDef("peb1", {
	var env;
	env = Env.adsr;
	Out.ar(0,
		\amp.kr(1) *
		EnvGen.kr(env, \gate.kr(1), doneAction: 2) *
		Pan2.ar(
			SinOsc.ar(
				Resonz.ar(
					StandardL.ar(
						SampleRate.ir/50, 1),2000,0.1)*4000)
			, \pos.kr(0), \level.kr(1)))
};
); // .load;

SynthDef("peb2", {
	var aa, env;
	aa = 4/3;
	env = Env.adsr;
	Out.ar(0,
		\amp.kr(1) *
		EnvGen.kr(env, \gate.kr(1), doneAction: 2) *
		Pan2.ar(
			Mix.fill(4, {
				LPF.ar(Resonz.ar(WhiteNoise.ar(1)
					**1,aa
					**Rand(0,20).ceil*50,0.01,10),200,1)
			}),0))};); // .load;

SynthDef("peb3", {
	var aa, env;
	env = Env.adsr;

	aa = 4/3;
	Out.ar(0,
		\amp.kr(1) *
		EnvGen.kr(env, \gate.kr(1), doneAction: 2) *
		Pan2.ar(
			Mix.fill(8, {
				LPF.ar(
					Resonz.ar(WhiteNoise.ar(1)
						**1,aa
						**Rand(0,20).ceil
						*50,0.01,10),300,1
				)
			}),0))
};
); // .load;

