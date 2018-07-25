//:load default sample
// Normally done by include. Will do nothing if allwk has already been loaded:
\allwk.loadBuffer(Platform.resourceDir +/+ "sounds/a11wlk01.wav");

//:play with default method
\allwk.b.play;
//:Ask number of channels
\allwk.b.numChannels;
//:play with PlayBuf
{
	PlayBuf.ar(\allwk.b.numChannels, \allwk.b, loop: 1);	
} +> \playbuf;
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
\sp <+ 3.0.rand;
