// Adding voice for second hand for jun
//:sound check
\default +> \check;
//:sound check - stereo
{ PinkNoise.ar(0.1) /*.dup(4) */ } +> \check;
{
	inf do: { | i |
		i = i % 4;
		2.wait;
		i.postln;
		\out <+.check i;
	}
}.fork;
//:
\out <+.check 0;

