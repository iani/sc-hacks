// 13 Oct 2018 13:23
//:preload 5 second buffer
\buffer.b(5);
//:recording test
{
	RecordBuf.ar(In.ar(4), \buffer.b.bufnum, 0, loop: 1);
	Silent.ar;
} +> \record;
//:
\buffer.b.play;
//:
{
	PlayBuf.ar(1, \buffer.b, loop: 1);
} +> \play;
//:
{ | out = 1 |
	var src;
	src = PlayBuf.ar(1, \buffer.b, loop: 1);
	Out.ar(out, src);
} +> \play;
\out <+ 1;
//:playbuf
{ | out = 1 |
	var src;
	src = PlayBuf.ar(1, \buffer.b, rate: \rate.kr(0.5) , loop: 1);
	Out.ar(out, src);
} +> \play;

\out <+ 1;
//:granulation on playbuf
{ | out = 1 |
	var src;
	src = GrainBuf.ar(1,
		Impulse.kr(30),
		0.1,
		
		\buffer.b.bufnum, rate: \rate.kr(0.5));
	Out.ar(out, src);
} +> \play;
\out <+ 1;
//:gui slider rate
\play.v(
	\rate.slider([0.25, 2], \play)
);
//:gyroscope rate experiment
\rate <+.play '/gyroscope'.osc(2, [-30.5, 30], [0.25, 2]);

//:


\rate <+ 2 / 3 ;
//:
StockhausenSolo.formschemaI.gui;
//:
OSCFunc.trace(true)
//:
GrainIn
//:try grainin
var winenv;
// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

SynthDef(\in_grain_test, { |out, gate = 1, amp = 1, envbuf|
	var pan, env;
	// use mouse x to control panning
	pan = MouseX.kr(-1, 1);
	env = EnvGen.kr(
		Env([0, 1, 0], [1, 1], \sin, 1),
		gate,
		levelScale: amp,
		doneAction: Done.freeSelf);
	Out.ar(out,
		// GrainIn.ar(2, Impulse.kr(32), 1, PinkNoise.ar * 0.05, pan, envbuf) * env
		GrainIn.ar(2, Impulse.kr(32), MouseY.kr(0.01, 1), In.ar(4) * 0.05 , pan, envbuf) * env
	)
}).add;
//:
x = Synth(\in_grain_test, [\envbuf, -1]);
//:
Server.default.record;
//:
Server.default.stopRecording;