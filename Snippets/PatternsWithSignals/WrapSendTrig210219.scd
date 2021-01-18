//: 18 Jan 2021 12:28 Test wrapping a trigger func into SendTrig,
/* 

To be built into a method Player:makeSendTrigFunc(trigFunc)

*/
//:+1st test case for wrapping.
~src = { WhiteNoise.ar(0.1) };
~def = { Ringz.ar(~src.value, LFNoise1.kr(5).range(1200, 1500)).dup }
.asSynthDef(fadeTime: 0.01, name: SystemSynthDefs.generateTempName);
~def.add;

//+>! \test;
"wait a sec...".postln;
1.wait;
~def.name +>! \test;
"wait another sec...".postln;
1.wait;
\test.start;