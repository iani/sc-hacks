// 23 Jun 2017 18:34
//:
currentEnvironment;


//:
\synth.synth.play;
//:
~freq = 1660;
//:
a = \synth.synth;
//:
a.play;
//:
\envir.push;
//:
currentEnvironment;
//:
~dt = 1;
//:
{
	loop {
		~dt.postln.wait
	}
}.rout
//:
~dt = 1;
{
	var funcs;
	funcs = Pseq ([
		{ WhiteNoise.ar (0.1)},
		{ PinkNoise.ar (0.1)},
		{ LFNoise2.ar (3000, 0.1)},
		{ LFNoise0.ar (5000, 0.1)},
		{ SinOsc.ar (400, 0, 0.1)},
		{ LFTri.ar (600, 0, 0.1)},
		{ LFSaw.ar (800, 0, 0.1)},
		\default
	], inf).asStream;
	loop {
		\synth.synth.play (funcs.next);
		~dt.wait;
	}
}.rout
//:
~dt = 1;
~fadeTime = 1;
{
	var funcs;
	funcs = Pseq ([
		{ WhiteNoise.ar (0.1)},
		{ PinkNoise.ar (0.1)},
		{ LFNoise2.ar (3000, 0.1)},
		{ LFNoise0.ar (5000, 0.1)},
		{ SinOsc.ar (400, 0, 0.1)},
		{ LFTri.ar (600, 0, 0.1)},
		{ LFSaw.ar (800, 0, 0.1)},
		\default
	], inf).asStream;
	loop {
		\synth.splay (funcs.next);
		~dt.wait;
	}
}.fork
//:
~fadeTime = 1;
//:
~fadeTime = 0.1;
//:
~fadeTime = 2;
//:
~fadeTime = 0.01;
//:
currentEnvironment;
//:
\envir.push;

//:
Library.at (\environments)