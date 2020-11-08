/* 12 Mar 2019 20:30
Building various versions of beat-synchronized players.
*/
//: PROBLEM: Stopped TempoClocks cannot be rescheduled.???? 
~t = TempoClock(5);
//:
~t.running;
//:
Pbind(\degree, 10).play(clock: ~t);

//:+Test built-in beat sync in sc-hacks
(dur: 2) +> \halves;
0.75.wait;
(degree: (0..7).pseq) +> \quarters;
//:+Test built-in beat sync in sc-hacks
(dur: 2) +> \halves;
0.5.wait;
(degree: (0..7).pseq) +> \quarters;
//:+Test built-in beat sync in sc-hacks
(dur: 0.2) +> \halves;
0.51.wait;
(degree: (0..7).prand) +> \quarters;
//:+Test built-in beat sync in sc-hacks
(dur: 0.5, degree: 2) +> \halves2;
0.51.wait;
(degree: (0..7).prand) +> \quarters2;
//:
().inspect;
//:
TempoClock.tempo = 2.1;
// towards midi selected sequencer voices
// ================================================================
//:Start with 1 voice, 8 beats per bar.
TempoClock.tempo = 1.0;
(dur: 1/8, degree: 0) +> \voice1;
//: approach 1.
~a = [1, 2, 3];
(dur: 1/8, degree: ~a.pseq) +> \voice1;
//: change a degree
~a[0] = 0;
//:change another degree
~a[1] = 4
//: Pause!
~a[0] = \;
//:Play slower to check that pause is silence, i.e. 0 synths for the beat
TempoClock.tempo = 0.2;
//:

~a.rotate;