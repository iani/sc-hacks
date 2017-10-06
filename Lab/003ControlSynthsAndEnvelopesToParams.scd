//: Test an envelope.
Env([60, 67, 64, 65].midicps.dup(3).flat ++ [100], 0.1 ! 13, [\lin, \sine, 3].stutter(4) ++ [\lin]).plot;
//: PLay it in a synth
\default.play;
//:
\freq <+ Env([60, 67, 64, 65].midicps.dup(5).flat ++ [440], 0.2 ! 21, [\lin, \sine, 3].stutter(4) ++ [\lin]);
//:* Improvise something longer with random permutations.
\freq <+ Env([60, 67, 44, 65].midicps.dup(5).flat.scramble ++
	[440, 660, 880].choose, [0.2, 0.1, 0.8].choose ! 21, [\lin, \sine, 3].stutter(4) ++ [\lin]);
5.wait;
//: