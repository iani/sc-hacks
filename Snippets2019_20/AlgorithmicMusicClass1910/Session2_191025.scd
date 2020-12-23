//:
Ndef(\test).play
Ndef(\test2).play;
Ndef(\test).fadeTime = 2
Ndef(\test2).fadeTime = 2
Ndef(\test, { WhiteNoise.ar(0.1) });
Ndef(\test2, { SinOsc.ar(2000 * [0.9, 1], 0, 0.1) });
Ndef(\test).clear(1/20);
Ndef(\test2).clear;
Ndef(\test, {});

Ndef.clear;
//:
{ WhiteNoise.ar(0.1) } +> \test;