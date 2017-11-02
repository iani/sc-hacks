//:
// first tests 18 Jun 2017 03:23

SynthPlayer ();

//:
currentEnvironment

//:
{ | freq = 400, amp = 0.1 | SinOsc.ar (freq * 1.2, 0, amp) } +> \default;
//:
{ | freq = 400, amp = 0.1 | SinOsc.ar (freq, 0, amp) } +> \test;
//:

{ | freq = 400, amp = 0.1 | SinOsc.ar (freq, 0, amp) } +> \test2;
//:
(degree: Pbrown (10, 20, 2)).eplay;
//:
(degree: Pseq ((0..7), inf), dur: 0.1).eplay;
//:
(degree: Pseq ((0..7), inf), dur: 1, test: Pseq ([\play, \stop], inf)).eplay;
//:
(degree: Pseq ((0..7), inf), dur: 0.1, test: Pseq ([\play, \stop], inf)).eplay;
//:
(dur: 2, degree: Pbrown (10, 20, 2), test: Pseq ([\play, \play, \stop], inf)).eplay;
//:
(dur: 0.2, degree: Pbrown (10, 20, 2), test: Pseq ([\play, \play, \stop], inf)).eplay;
//:
(dur: 0.15, degree: (Pstutter (5, Pbrown (10, 20, 2))), test: Pseq ([\play, \play, \stop], inf)).eplay;
//:
(dur: 0.15, degree: (Pstutter (5, Pbrown (10, 20, 2))), test: Pseq ([\play, \tie, \stop], inf)).eplay;
//:
(dur: 0.2, degree: Pbrown (10, 20, 2), test: Prand ([\play, \play, \stop], inf)).eplay;
//:
(dur: 0.1, degree: Pbrown (10, 20, 2), test: Prand ([\play, \play, \stop], inf)).eplay;
//:
(dur: Prand ([0.1, 0.05], inf), degree: Pbrown (-10, 20, 5), test: Prand ([\play, \play, \stop], inf)).eplay;
//:
(dur: 0.1, degree: Pbrown (-10, 20, 4), test: Pseq ([\play, \play, Pn ('tie', 15), \play, \stop], inf)).eplay;
//:
~fadeTime = 0.75;
//:
~fadeTime = 0.01;
//:
~freq = 880;
//:
~freq = 1200;
//:
(dur: 0.1, degree: Pbrown (10, 20, 2)).eplay;
//:
a = SynthPlayer ().play;
//:
a.stop;
a.play;
//:
(degree: Pseq ((0..7), inf), dur: 0.1, default: Pseq ([\play, \stop, \tie], inf)).eplay;
//:
currentEnvironment.putPattern (\test, (degree: Pbrown (-10, 20, 3, inf), dur: 0.05));
//:
(degree: Pwhite (0, 7, inf), dur: 0.1 / Pstutter (10, Pwhite (1, 3, inf)), default: Pseq ([\play, \stop], inf)).eplay;
//:
(degree: Pwhite (0, 7, inf), dur: 0.1 / Pstutter (10, Pwhite (1, 3, inf)), default: Prand ([\play, \stop, \tie], inf)).eplay;
//:
(degree: Pwhite (0, 7, inf), dur: 1 / Pstutter (10, Pwhite (10, 30, inf)), default: Prand ([\play, \stop, \tie], inf)).eplay;
//:
~freq = 1000;

a.synth;

//:
currentEnvironment;
//:
var p;
p = EventPattern ((degree: Pbrown (1, 20, 1, inf))).asStream;
\test.addNotifier (currentEnvironment, 'type', { p.next.play });

//:
(dur: Pseq ([0.1, 0.2], inf)).eplay (\test);