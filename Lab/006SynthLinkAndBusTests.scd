/*
Cases to test: 

*/
//: 
\source1 *> \effect1;
{ WhiteNoise.ar(0.1) } +> \source1;
{ Ringz.ar(Fin(), LFNoise0.kr(4).range(100, 1200), 0.15) } +> \effect1;
//:
{ Ringz.ar(Fin(), LFNoise0.kr(10).range(5000, 12200), 1.15) } +> \effect2;
//:
\source1 *> \effect2;
//:
(dur: 0.1, degree: Pbrown(0, 10)) +> \source;
//:
(dur: 1, degree: Pwhite(0, 10)) +> \source2;
//:
\source2 *> \effect2;
//:
\source *> \effect3;
//:
\source *< \effect3;
//:
{ Ringz.ar(Fin(), LFNoise0.kr(4).range(100, 1200), 0.15) } +> \effect;
//:
\source.ppp.originalStream.event;
//:
{ Fin() } +> \effect;
//: Exploring PatternPlayer updates for busses
(dur: 0.1, degree: Pbrown(0, 10)) +> \source2;
//:
\source2.p.sourcePlayer.source.put(\out, 40);
//:
\source2.p.sourcePlayer.source;
//:
\source2.p.sourcePlayer.process.originalStream.event.put(\out, 40);
//:

//:
{ PinkNoise.ar(0.1) } +> \source2;

// ================================================================
//  7 Sep 2017 13:17
\test.push;
//:
currentEnvironment;
//:
\test.ev.getAudioBus;
//:
\test.ev.inspect;
\test.ev.something;
//:
{ WhiteNoise.ar(0.05) } +> \source;
\source.ev.getAudioBus(\out);
//:
{ Ringz.ar(Fin(), 1000, ) } +> \effect;
\effect.ev.getAudioBus(\in);
//:
\effect.ev;
//:
\source.ev;
//:
\source *> \effect;
//:
\source.ev;
//:
\effect.ev;
