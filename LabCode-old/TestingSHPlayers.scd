//:
~dt = 0.3;
~fadeTime = 2.5;
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
~fadeTime = 3;
//:
\envir.push;

//:
\synth.synth.play;

//:
~dt = 1;
{
	loop {
		\synth.synth.play;
		~dt.wait;
	}
}.rout
//:
~dt = 0.5;
//:
~dt = 0.1;
//:
~dt = 0.05;
//:
~dt = 0.01;
//:
//:
~dt = 1;
{
	loop {
		\synth.synth.play ({ WhiteNoise.ar (0.1)});
		~dt.wait;
	}
}.rout
//:
~dt = 1;
{
	loop {
		\synth.synth.play ([{ WhiteNoise.ar (0.1)}, \default].choose);
		~dt.wait;
	}
}.rout
//:
\envir.push;
~dt = 1;
{
	loop {
		\synth.synth.play ([{ WhiteNoise.ar (0.1)}, \default].choose);
		~dt.wait;
	}
}.rout
//:
~freq = 1000;
//:
~fadeTime = 0.5;
//:
\envir.push;
//:
~dt = 3;
~fadeTime = 2.5;
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
currentEnvironment;
//:
\envir.push;



\routine.routine;
\pattern.pattern.inspect;
\window.window.front;

\envir.push;

\synth2.synth.play;
\envir.synths;
\envir.windows;

