// 13 Aug 2017 10:51

//: This should not work
a = { Out.ar(100, (Impulse.ar(5))) }.play; // output first
b = { Ringz.ar(In.ar(100), LFNoise0.kr([1, 0.5]).range (500, 1000), 2) }.play;
//: This should work. : FX first
b = { Ringz.ar(In.ar(100, 2), LFNoise0.kr([1, 0.5]).range (500, 1000), 2) }.play;
a = { Out.ar(100, (Dust.ar([1, 2]))) }.play;
//: This should work despite output first
a = { Out.ar(100, (Dust.ar([1, 2]))) }.play;
b = { Ringz.ar(InFeedback.ar(100, 2), LFNoise0.kr([1, 0.5]).range (500, 1000), 2) }.play;


////////////////////////////////////////////////////////////////

//: Testing with Fin:
a = { Out.ar(100, (Dust.ar([1, 2]))) }.play;
b = { Ringz.ar(Fin(\in, 100, 2), LFNoise0.kr([1, 0.5]).range (500, 1000), 2) }.play;
//: