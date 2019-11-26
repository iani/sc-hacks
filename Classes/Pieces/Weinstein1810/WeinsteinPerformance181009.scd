// =====================================================================
// SuperCollider Workspace
// =====================================================================
//:
Recording.gui;
//:
HarveyRicercare.start;
//:
StockhausenSolo.start;
//:
\default +> \test;

\test.stop(5);
\test.ppp release: 5;


\channel4.ppp release: 1;
//:
Server.killAll;

//:
{
	var in;
	in = In.ar(4);
	Out.ar(0, (in * \level.kr(0.01)).dup(4))

} +> \direct;
\level <+.direct 0.09;
\direct.v(
	\level.slider([0, 1])
);
//:
{ | out = 0 |
	Out.ar(out, (PinkNoise.ar(0.05) *
		Decay.kr(Impulse.kr(4))
		* \level.kr(0.05)) // .dup(4)
	)

} +> \soundcheck;
//:
\out <+ 0;
//:
\out <+ 1;
//:
\out <+ 2;
//:
\out <+ 3;
//:
\level <+ 0.3;
//:
{
	inf do: { | i |
		i.postln;
		i = i % 4;
		i.postln;
		\out <+.soundcheck i;
		1.wait;
	};
}.fork;
//:
StockhausenSolo.formschemaIII.gui;
//:
LucierJars.start;
HarveyRicercare
//:
Server.default.options.numOutputBusChannels = 4;

//:Sound check

{

	SinOsc.ar(300 * Array.rand(4, 1.0, 2.0), 0, LFNoise2.kr(2.1.dup(4)).range(0, 0.01))
	
} +> \test;
//:Recording
Recording.gui;