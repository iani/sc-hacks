//: 25 Dec 2020 10:24
/*
*** Start 7 Synths with frequencies taken from the midi notes [60, 62, 63, 66, 67, 68, 72], and release them with fades taken from [0.1, 0.5, 1, 2, 5, 7, 0.1], 

Do the release with 1 statement for all 7 synths.
*/
//:test stuff first
[60, 62, 63, 66, 67, 68, 72].size;
[0.1, 0.5, 1, 2, 5, 7, 0.1].size;
//:+Simple solution with one fade time
~synths = [60, 62, 63, 66, 67, 68, 72].midicps collect: { | f | Synth(\default, [freq: f])};
2.wait;
~synths do: (_ release: 5);
//:+Full solution, with release times from array
~synths = [60, 62, 63, 66, 67, 68, 72].midicps collect: { | f | Synth(\default, [freq: f])};
2.wait;
[0.1, 0.5, 1, 2, 5, 7, 0.1] do: { | rt, i | ~synths[i] release: rt };
//:Prepare alternative way, combining 2 arrays
var synths, dts;
synths = (61..67).midicps;
dts = (1..7).reciprocal;
[synths, dts].flop.flat pairsDo: { | a, b | postf("a is: %, b is: %\n", a, b); };

//:+Alternative way, combining 2 arrays
~synths = [60, 62, 63, 66, 67, 68, 72].midicps collect: { | f | Synth(\default, [freq: f])};
2.wait;
[~synths, [0.1, 0.5, 1, 2, 5, 7, 0.1]].flop.flat pairsDo: { | s, dt | s release: dt };

//:+Alternative way, combining 2 arrays - try using array comprehension
~synths = [60, 62, 63, 66, 67, 68, 72].midicps collect: { | f | Synth(\default, [freq: f])};
2.wait;
[~synths, [0.1, 0.5, 1, 2, 5, 7, 0.1]].flop.flat pairsDo: (_.release(_));

//:+Alternative way, using local variables and custom synth-making function;
var synths, amps, synthFunc;
synths = [60, 62, 63, 66, 67, 68, 72].midicps;
amps = [0.1, 0.5, 1, 2, 5, 7, 0.1];
synthFunc = { | freq | Synth(\default, [freq: freq]) }; 
~synths = [60, 62, 63, 66, 67, 68, 72].midicps collect: synthFunc.(_);
2.wait;
[~synths, [0.1, 0.5, 1, 2, 5, 7, 0.1]].flop.flat pairsDo: (_.release(_));
