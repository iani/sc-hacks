Server.default.plotTree;
//:
SynthDef("impulse", { | out = 0 |
	Out.ar(out, Impulse.ar(2, 0, 0.05))
}).add;
SynthDef("decay", { | out = 0 |
	Out.ar(out,
		WhiteNoise.ar(
			Decay2.kr(Impulse.kr(0.5), 0.7, 1.2, 0.05)
		)
	)
}).add;
SynthDef("ring", { | out = 0 |
	Out.ar(out,
		// Ringz.ar(InFeedback.ar(in, 1), LFNoise0.kr(1).range(150, 500))
		Ringz.ar(Fin(), LFNoise1.kr([10, 1]).range(150, 1500), 0.1)
	);
}).add;
//:
\source1 *> \effect1;
\source2 *< \effect1;
//:
\ring +> \effect1;
\impulse +> \source1;
\decay +> \source2;
//:
\source1.stop;
\source2.stop;
\effect1.stop;
//: ================================================================
// TRYING ALL PERMUTATIONS OF SYNTH ORDER
// NOTE: The order of statements is inverse to the order of synths.
//: source1, source2, effect
\ring +> \effect1;
\decay +> \source2;
\impulse +> \source1;
//: source2, source1, effect
\ring +> \effect1;
\impulse +> \source1;
\decay +> \source2;
//: source2, effect, source1
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Here the source1 = impulse is lost.
\impulse +> \source1;
\ring +> \effect1;
\decay +> \source2;
//:
/*
Therefore need to order the synths of linked players in the correct order.
*/
//:

\source1 *> \effect1;
{ Impulse.ar(4, 0, 0.1) } +> \source1;
{ Ringz.ar(Fin(), LFNoise0.kr(1).range(150, 1000), 0.1) } +> \effect1;
\source2 *< \effect1;
{ Impulse.ar(0.5, 0, 0.1) } +> \source2;
{ WhiteNoise.ar(Decay.kr(Impulse.kr(0.5, 0, 0.1))) } +> \source2;
//:
\decay +> \source2;
\impulse +> \source1;
//:
\source1.stop;
//:
\source1.e;
//:
