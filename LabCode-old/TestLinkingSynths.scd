/*  4 Jul 2017 23:36
Linking synths using the groups allocation 
mechanism of Nenvir. 

First tests

Debug: ERROR: Function argument 'out' already declared in Interpreter:functionCompileContext

*/
//: Create a source
a = { | out = 0 |  Out.ar (out, WhiteNoise.ar (0.1)) } +> \source;
//: Set the output of the source to audio bus no 50
~out = 50;
//: Create an effect
b = { LPF.ar (In.ar (\in.kr (0)), 400) } +>.fxenvir \source;
//: Now move the input to the output of the source: 50
// \fxenvir.push; // envir pushes automatically when creating new SynthPlayer.
~in = 50;
//: Sound disappears again, when the effect reads from another bus:
~in = 51;
//: Synths and groups ordering is as expected
Server.default.queryAllNodes;
//:v Linking works like this:
\envir &> \fxenvir;

// ================================================================

//: Test from scratch:
\envir &> \fxenvir;
//:
a = { | out = 0 |  Out.ar (out, WhiteNoise.ar (0.1)) } +> \source;
//:
b = { LPF.ar (In.ar (\in.kr (0)), 400) } +>.fxenvir \source;

