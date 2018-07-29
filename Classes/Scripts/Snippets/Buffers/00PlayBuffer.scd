
//:preload default sample once
/* This snippet is *automatically* run once only, 
before running a snippet from this file for the first time. 
*/
\allwk.loadBuffer(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
\s28.loadBuffer("~/Music/sounds/sounds-tetatet/hi/28.wav".standardizePath);
\s12.loadBuffer("~/Music/sounds/sounds-tetatet/hi/12.wav".standardizePath);
\clap.loadBuffer("~/Music/sounds/sounds-lindrum-etc/clap.wav".standardizePath);

//:play with default method
\allwk.b.play;
//:test another sample from buffer
\s28.b.play;
//:Ask number of channels
\allwk.b.numChannels;
//:play with PlayBuf
{
	PlayBuf.ar(\allwk.b.numChannels, \allwk.b, loop: 1);	
} +> \playbuf;
//:play with PlayBuf and controllable bufnum
{ | bufnum = 0 |
	PlayBuf.ar(1, bufnum, loop: 1);	
} +> \playbuf;
//:Manually change bufnum
\bufnum <+ 1;
//:Manually change bufnum back
\bufnum <+ 0;
//:Change bufnum to "allwk" by buffer name
\bufnum <+ \allwk;
//:Change bufnum to "s28" by buffer name
\bufnum <+ \s28;
//:Change bufnum to "s12" by buffer name
currentEnvironment.postln;
\bufnum <+ \s12;
//:Change bufnum to "clap" by buffer name
\bufnum <+ \clap;
//:play with startPos
{
	PlayBuf.ar(\allwk.b.numChannels,
		\allwk.b,
		trigger: \trig.kr(0),
		startPos: \sp.kr(2.5) * \sp.b.sampleRate,
		loop: 0);	
} +> \playbuf;
//:Prepare trigger: set to 0
\trig <+ 0;
//:Trigger: set trigger to 1
\trig <+ 2;
//:change start position to 1
\sp <+ 1;
//:change start position to 2.5
\sp <+ 2.5;
//:change start to 0 and retrigger
\sp <+ 0;
{
\trig <+ 0;
0.01.wait; // obligatory!
\trig <+ 1;
}.fork;
//:alternative trigger method using Changed.kr
{
	PlayBuf.ar(\allwk.b.numChannels,
		\allwk.b,
		trigger: Changed.kr(\trig.kr(0)),
		startPos: \sp.kr(2.5) * \sp.b.sampleRate,
		loop: 0);	
} +> \playbuf;
//:simple retriggering loop+gui
~dt = 1;
{
	var values;
	values = Pseries(1, 1, inf).asStream;
	loop {
		\trig <+ values.next.postln;
		~dt.postln;
		(~dt max: 0.1).wait;
	}
}.fork;
\playbuf.v(
	// less than 0.1 delay risks entering perceptible frequency range
	\dt.slider([0.1, 3.0]),
	\sp.slider([0.0, 3.0])
)
//:reset start to random point;
\sp <+ 3.0.rand; // must use trigger when starting point changes source below
//:trigger when starting point changes, using Changed.kr
{
	var sp;
	sp = \sp.kr(0);
	PlayBuf.ar(\allwk.b.numChannels,
		\allwk.b,
		trigger: Changed.kr(sp),
		startPos: sp * \sp.b.sampleRate,
		loop: 0);	
} +> \playbuf;
//:retriggering loop without routine, using Impulse UGen
{
	var sp;
	sp = \sp.kr(0);
	PlayBuf.ar(\allwk.b.numChannels,
		\allwk.b,
		trigger: Impulse.kr(\period.kr(1).reciprocal) + Changed.kr(sp),
		startPos: sp * \sp.b.sampleRate,
		loop: 0);	
} +> \playbuf2;
\playbuf2.v(
	// less than 0.1 delay risks entering perceptible frequency range
	\period.slider([0.1, 3.0]),
	\sp.slider([0.0, 3.0])
)