//:saw shape
{ Out.kr(0, SinOsc.kr(10.8)) } +> \cm1;
// { Out.kr(0, Pulse.kr(10)) } +> \cm1;
// { Out.kr(0, LFSaw.kr(10)) } +> \cm1;
// { Out.kr(0, LFSaw.kr(10)) } +> \cm1;
//:copy signal into another bus (for testing)
{ Out.kr(1, In.kr(0) * -1) } +> \cm2;
//:
{
	Out.kr(0,
		[
			SinOsc.kr(10.8),
			// SinOsc.kr(10.8, 1 * pi) * -1,
			SinOsc.kr(10.8, LFTri.kr(1/5) * pi) * -1,
		]
	)


} +> \cm1;
//:
{
	Out.kr(0, SinOsc.kr(10.768, \phase.kr(0)))
} +> \cm1;
//:
\phase <+.cm1 (1* pi);
\phase <+.cm1 (0.5* pi);
//:*

0.2.wait;
//:
{ Out.kr(2, In.kr(1) * 1) } +> \cm3;
//:
\cm3.stop;
\cm3.bus.set(0);

//:reverse (mirror) saw shape
//(Use original saw from previous synth as input)

//:Pass only positive part

//:Pass only negative part

//:mirror only negative part;

//:change period of source signal
{ Out.kr(0, LFSaw.kr(1)) } +> \cm1;
//:
0.0.sin;
1.sin;
pi.sin;
2pi.sin;
(pi * 3 / 2).sin;