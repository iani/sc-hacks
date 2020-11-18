

{ SinOsc.ar(400, 0, 0.1) }.play;
//:
~alpha = { | out = 0 |
	var src;
	src = SinOsc.ar(400, 0, 0.1);
	Out.ar(out, src;)
}.play;
//:
a = { | out = 0, freq = 400 |
	var src;
	src = SinOsc.ar(freq, 0, 0.1);
	Out.ar(out, src;)
}.play;
//:*
inf do: { | count |
	a.set(\out, count % 2, \freq, 400 rrand: 5000);
	0.25.wait;

}
//:
SynthDef("simplesine", { | out = 0, freq = 400 |
	var src;
	src = SinOsc.ar(freq, 0, 0.1);
l	Out.ar(out, src;)
}).add;