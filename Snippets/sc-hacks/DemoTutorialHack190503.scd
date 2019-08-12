//code from Cyanotype v 1  3 May 2019 11:14

//:for midi
~sourceArr = [\0, \1, \2, \3];
//:synthdef 0
SynthDef(\0, {|
	pot1 = 0,
	pot2 = 0, // moogVCF res
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0.20,// amp
	freq = 55,
	gate = 1,
	pitchModifier = 1,
	out = 0 |
	var src, envgen, env;
	env = Env.asr(1,1);
	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
	src = LFTri.ar(freq * pitchModifier);
	src = MoogFF.ar(src, 4400 * pot1, pot2);
	Out.ar(out, Pan2.ar(src * pot8 * envgen));
}).add;
//:
SimpleDef('0s', {| freq = 440 |
	var pot1, pot2, pot3, pot4, pot5, pot6, pot7,
	pot8, pitchModifier;
	\pot1.kr(0);
	\pot2.kr(0);
	\pot3.kr(0);
	\pot4.kr(0);
	\pot5.kr(0);
	\pot6.kr(0);
	\pot7.kr(0);
	\pot8.kr(0.20);
	\pitchModifier.kr(1);
	var src; // , envgen, env;
	// env = Env.asr(1,1);
	// envgen = EnvGen.kr(env, gate: gate, doneAction:2);
	src = LFTri.ar(freq * pitchModifier);
	src = MoogFF.ar(src, 4400 * pot1, pot2);
	src * pot8
	// Out.ar(out, Pan2.ar(src * pot8 * envgen));
});
//:
\0 +> \test;
//:
'0s' +> \test;
//:
(dur: 1) +> \test;
//:
(degree: [0, 10].pwhite) +> \test;
//:
(dur: 0.1) +> \test;
//:
\pot0 <+ 0.1;
//:
\pot2 <+ 0.04;
//:
\pot1 <+ 0.3;
//:
\freq <+ 300;
//:
'test'.pp.release;
//:
\test.ppp.release;
//:
\test.ppp release: 2;
//:
\test.p.inspect;

//:
SynthDescLib.default.at(\0);
//:
SynthDescLib.default.at(\0).inspect;
//:
SynthDescLib.default.at(\0).controls;
//:
SynthDescLib.default.at(\0).controls.size;
//:
SynthDescLib.default.at(\0).controlNames.size;
//:
SynthDef(\1, {|
	pot1 = 0,//dust frequency
	pot2 = 0,// sine frequency
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0.20,// amp
	freq = 880,
	gate = 1,
	pitchModifier = 1|
	var src, envgen, env;
	env = Env.asr(attackTime:0.1, releaseTime:0.1);
	envgen = EnvGen.kr(env, gate: Dust.kr(1000 * pot1, 1, -0.5), doneAction:0, timeScale: 0.5);
	src = SinOsc.ar(freq * pot2);
	Out.ar(127, Pan2.ar(src * pot8 * envgen, pos: (2*(pot3 - 0.5))));
}).add;
SynthDef(\2, {|
	pot1 = 0,//dust frequency
	pot2 = 0,// sine frequency
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0.20,// amp
	freq = 880,
	gate = 1,
	pitchModifier = 1|
	var src, envgen, env;
	env = Env.asr(attackTime:0.1, releaseTime:0.1);
	envgen = EnvGen.kr(env, gate: Dust.kr(1000 * pot1, 1, -0.5), doneAction:0, timeScale: 0.5);
	src = PinkNoise.ar();
	Out.ar(127, Pan2.ar(src * pot8 * envgen, pos: (2*(pot3 - 0.5))));
}).add;
~buf0 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "samples/2.wav", bufnum: 1);
SynthDef(\3,{|
	pot1 = 0,//dust frequency
	pot2 = 0,// sine frequency
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0.20,// amp
	gate = 1
	|
	var src, envgen, env;
	env = Env.asr(attackTime:1, releaseTime:1);
	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
	src = GrainBuf.ar(1,Impulse.kr(pot4 * 440), pot3, ~buf0.bufnum, rate: pot2, pos: pot1, maxGrains: 128);
	Out.ar(0, Pan2.ar(src * envgen * pot8));
}).add;
// SynthDef(\1, {|
// 	pot8 = 0.15,//amp
// 	freq = 55,
// 	gate = 1,
// 	pitchModifier = 1|
// 	var src, envgen, env;
// 	env = Env.asr(attackTime:1, releaseTime:1);
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = SinOsc.ar(freq * pitchModifier);
// 		Out.ar(0, Pan2.ar(src * pot8 * envgen));
// }).add;
// // not a grain wOOOOOOOOOOOw :o
// SynthDef(\2,{|pot8 = 0.2,//amp
// 	gate = 1,
// 	synfreq = 55,
// 	pitchModifier = 1|
// 	var src, envgen, env;
// 	synfreq = synfreq + pitchModifier;
// 	env = Env.perc();
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = SinOsc.ar(Line.kr(synfreq, 9/8 * synfreq)); // + LFTri.ar(synfreq, mul: pot8/4);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8 * 1.4));
// }).add;
// SynthDef(\3,{|pot8 = 0.2,//amp
// 	gate = 1,
// 	synfreq = 55|
// 	var src, src2, envgen, env;
// 	env = Env.perc();
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = LPF.ar(WhiteNoise.ar(1),6000);
// 	src2 = HPF.ar(src, 2000);
// 	Out.ar(0, Pan2.ar(src2 * envgen  * pot8));
// }).add;

/// GRAINS :|
// W A R N I N G - GrainBuf needs mono spot8le!!!
// ~buf0 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "spot8les/1.wav", bufnum: 1);
// SynthDef(\0,{| pot8 = 0.2, impFreq = 50, grainDur = 0.1, rate = 0.5, pos = 0.5, gate =1, pitchModifier = 1|
// 	var src, envgen, env;
// 	env = Env.asr(attackTime:1, releaseTime:1);
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = GrainBuf.ar(1,Impulse.kr(impFreq), grainDur, ~buf0.bufnum, rate * pitchModifier, pos, maxGrains: 128);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8));
// }).add;
// ~buf1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "spot8les/2.wav", bufnum: 2);
// SynthDef(\1,{| pot8 = 0.2, impFreq = 50, grainDur = 0.1, rate = 0.5, pos = 0.5, gate =1, pitchModifier = 1|
// 	var src, envgen, env;
// 	env = Env.asr(attackTime:1, releaseTime:1);
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = GrainBuf.ar(1,Impulse.kr(impFreq), grainDur, ~buf1.bufnum, rate * pitchModifier, pos, maxGrains: 128);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8));
// }).add;
// spot8le buf2
// SynthDef(\2,{| pot8 = 0.2, impFreq = 50, grainDur = 0.1, rate = 0.5, pos = 0.5, gate =1|
// 	var src, envgen, env;
// 	env = Env.perc();
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = GrainBuf.ar(1,Impulse.kr(impFreq), grainDur, ~buf1.bufnum, rate, pos, maxGrains: 128);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8));
// }).add;

//:
SynthDef(\1, {|
	pot1 = 0,//dust frequency
	pot2 = 0,// sine frequency
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0.20,// amp
	freq = 880,
	gate = 1,
	pitchModifier = 1|
	var src, envgen, env;
	env = Env.asr(attackTime:0.1, releaseTime:0.1);
	envgen = EnvGen.kr(env, gate: Dust.kr(1000 * pot1, 1, -0.5), doneAction:0, timeScale: 0.5);
	src = SinOsc.ar(freq * pot2);
	Out.ar(127, Pan2.ar(src * pot8 * envgen, pos: (2*(pot3 - 0.5))));
}).add;
SynthDef(\2, {|
	pot1 = 0,//dust frequency
	pot2 = 0,// sine frequency
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0.20,// amp
	freq = 880,
	gate = 1,
	pitchModifier = 1|
	var src, envgen, env;
	env = Env.asr(attackTime:0.1, releaseTime:0.1);
	envgen = EnvGen.kr(env, gate: Dust.kr(1000 * pot1, 1, -0.5), doneAction:0, timeScale: 0.5);
	src = PinkNoise.ar();
	Out.ar(127, Pan2.ar(src * pot8 * envgen, pos: (2*(pot3 - 0.5))));
}).add;
~buf0 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "samples/2.wav", bufnum: 1);
SynthDef(\3,{|
	pot1 = 0,//dust frequency
	pot2 = 0,// sine frequency
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0.20,// amp
	gate = 1
	|
	var src, envgen, env;
	env = Env.asr(attackTime:1, releaseTime:1);
	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
	src = GrainBuf.ar(1,Impulse.kr(pot4 * 440), pot3, ~buf0.bufnum, rate: pot2, pos: pot1, maxGrains: 128);
	Out.ar(0, Pan2.ar(src * envgen * pot8));
}).add;
// SynthDef(\1, {|
// 	pot8 = 0.15,//amp
// 	freq = 55,
// 	gate = 1,
// 	pitchModifier = 1|
// 	var src, envgen, env;
// 	env = Env.asr(attackTime:1, releaseTime:1);
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = SinOsc.ar(freq * pitchModifier);
// 		Out.ar(0, Pan2.ar(src * pot8 * envgen));
// }).add;
// // not a grain wOOOOOOOOOOOw :o
// SynthDef(\2,{|pot8 = 0.2,//amp
// 	gate = 1,
// 	synfreq = 55,
// 	pitchModifier = 1|
// 	var src, envgen, env;
// 	synfreq = synfreq + pitchModifier;
// 	env = Env.perc();
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = SinOsc.ar(Line.kr(synfreq, 9/8 * synfreq)); // + LFTri.ar(synfreq, mul: pot8/4);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8 * 1.4));
// }).add;
// SynthDef(\3,{|pot8 = 0.2,//amp
// 	gate = 1,
// 	synfreq = 55|
// 	var src, src2, envgen, env;
// 	env = Env.perc();
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = LPF.ar(WhiteNoise.ar(1),6000);
// 	src2 = HPF.ar(src, 2000);
// 	Out.ar(0, Pan2.ar(src2 * envgen  * pot8));
// }).add;

/// GRAINS :|
// W A R N I N G - GrainBuf needs mono spot8le!!!
// ~buf0 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "spot8les/1.wav", bufnum: 1);
// SynthDef(\0,{| pot8 = 0.2, impFreq = 50, grainDur = 0.1, rate = 0.5, pos = 0.5, gate =1, pitchModifier = 1|
// 	var src, envgen, env;
// 	env = Env.asr(attackTime:1, releaseTime:1);
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = GrainBuf.ar(1,Impulse.kr(impFreq), grainDur, ~buf0.bufnum, rate * pitchModifier, pos, maxGrains: 128);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8));
// }).add;
// ~buf1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "spot8les/2.wav", bufnum: 2);
// SynthDef(\1,{| pot8 = 0.2, impFreq = 50, grainDur = 0.1, rate = 0.5, pos = 0.5, gate =1, pitchModifier = 1|
// 	var src, envgen, env;
// 	env = Env.asr(attackTime:1, releaseTime:1);
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = GrainBuf.ar(1,Impulse.kr(impFreq), grainDur, ~buf1.bufnum, rate * pitchModifier, pos, maxGrains: 128);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8));
// }).add;
// spot8le buf2
// SynthDef(\2,{| pot8 = 0.2, impFreq = 50, grainDur = 0.1, rate = 0.5, pos = 0.5, gate =1|
// 	var src, envgen, env;
// 	env = Env.perc();
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = GrainBuf.ar(1,Impulse.kr(impFreq), grainDur, ~buf1.bufnum, rate, pos, maxGrains: 128);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8));
// }).add;
