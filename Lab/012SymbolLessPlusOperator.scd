// 25 Sep 2017 14:02
// Preparing implementation of Symbol <+. Cases:
/*
** DONE 3. Symbol =<+= Number: Set parameter
** DONE 4. Symbol =<+= Function: Map parameter
** DONE 5. Symbol =<+= Env: Map parameter
** TODO 6. Symbol =<+= Symbol: Set bufnum
*/
//: Finetune pushing envirs from play operators.
currentEnvironment;
//:
{ WhiteNoise.ar(0.1) } +> \test;
// Test <+ float/integer
//:
\freq <+ 155.5;
//:
\default.play;
// ================================================================
// Map function as control synth to parameter.
//: Building step by step.
~bus = Bus.control;
~bus.set(1500);
~freq = ~bus;
//:
\default.play;
//:
{ Out.kr(~bus.index, LFNoise0.kr(5).range(150, 1500)) }.play;
//: How to set the output bus in kr funcs
{ LFNoise1.kr(10) }.play;
//:
a = { Out.kr(\out.kr, LFNoise1.kr(10)) }.play(args: [out: 2]);
//:
a = { LFNoise1.kr(10) }.play(outbus: 3);
//: outbus not changeable at synth runtime - but not required here
a.set(\outbus, 0)
//:
~bus = Bus.control;
~bus.set(1500);
~freq = ~bus;
{ LFNoise1.kr(10).range(400, 1400) }.play(outbus: ~bus.index);
//:
\default.play;
//:
currentEnvironment.atFail(\blah, { "hello.postln;"});
//:
\freq <+ { LFNoise1.kr(10).range(400, 1400) };
//:
\freq <+ { LFNoise0.kr(20).range(1400, 4000) };
// ================================================================
// play Env as function and map parameter.
//: initial tests
\freq <+ Env(Array.rand(150, 400, 4000), 0.1 ! 149, \hold);
//:
\default.play;
