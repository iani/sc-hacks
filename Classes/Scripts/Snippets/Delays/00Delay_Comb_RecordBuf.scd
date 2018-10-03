//:preload load buffer
\rb.b(3); // store 3 second buffer in \rb

//:Delay 1 sec
{ DelayN.ar(In.ar(2), 1, 1) } +> \delay;

//:Delay+gui: delaytime

{ DelayN.ar(In.ar(2), 5, \delaytime.kr(1)) } +> \delay;
\delay.v(
	\delaytime.slider([0.1, 5])
)

//:Delay+gui: delaytime + feedback

{ DelayN.ar(In.ar(2), 5, \delaytime.kr(1), \mul.kr(1)) } +> \delay;
\delay.v(
	\delaytime.slider([0.1, 5]),
	\mul.slider(\amp)
)
//:Comb+gui: delaytime, decay time

{ CombN.ar(In.ar(2), 5, \delaytime.kr(1), \decay.kr(1)) } +> \comb;
\comb.v(
	\delaytime.slider([0.01, 5]),
	\decay.slider([0.1, 10])
)
//:Comb with synthetic source (Impulse)

{ CombN.ar(Impulse.kr(1), 5, \delaytime.kr(1), \decay.kr(1)) } +> \comb;
\comb.v(
	\delaytime.slider([0.001, 5, \exp]),
	\decay.slider([0.1, 10])
)
//:Record/PlayBuf 1: Delayed synths
{
	{
		RecordBuf.ar(In.ar(2), \rb.b(3), loop: 1);
		Silent.ar();
	} +> \record;
	1.wait;
	{ PlayBuf.ar(1, \rb.b, loop: 1) } +> \play;
}.fork
//:Record/PlayBuf 2: startPos offset
{
	RecordBuf.ar(In.ar(2), \rb.b(3), loop: 1);
	PlayBuf.ar(1, \rb.b, startPos: 1 * BufSampleRate.kr(\rb.b), loop: 1);
} +> \rp;

//:Record/PlayBuf 2: startPos offset
{
	var pb;
	pb = PlayBuf.ar(1, \rb.b, startPos: 1 * BufSampleRate.kr(\rb.b), loop: 1);
	RecordBuf.ar(In.ar(2) + (pb * \fb.kr(1)), \rb.b(3), loop: 1);
} +> \rp;

//:Record/PlayBuf 3: variable startPos offset
{
	PlayBuf.ar(1, \rb.b,
		trigger: Changed.kr(\trig.kr(0)),
		startPos: \sp.kr(1) * BufSampleRate.kr(\rb.b),
		loop: 1);
} +> \rp;
\rp.v(
	\sp.slider([0.1, 2.9])
);
\rp.watch(\sp, { | val, n |
	n.listener.put(\trig, Registry(\rp, \trig, {
		Pseries(1, 1, inf).asStream;
	}).postln.next;
	)
});
//:Test Nenvirs before and after startup
Library.at(\environments).values.postln;