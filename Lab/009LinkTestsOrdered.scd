/* 17 Sep 2017 13:37
Testing linking of environments with ordered groups.
*/

\source1 *> \effect1;
\source2 *< \effect1;
// OK: start order: effect, source1, source2
{ Ringz.ar(Fin(), LFNoise0.kr(1).range(150, 1000), 0.1) } +> \effect1;
{ Impulse.ar(4, 0, 0.1) } +> \source1;
{ WhiteNoise.ar(Decay2.kr(Impulse.kr(0.5, 0, 0.1), 0.3, 1, 0.1)) } +> \source2;
//: OK: start order: source 1, source2, effect
{ Impulse.ar(4, 0, 0.1) } +> \source1;
{ WhiteNoise.ar(Decay2.kr(Impulse.kr(0.5, 0, 0.1), 0.3, 1, 0.1)) } +> \source2;
{ Ringz.ar(Fin(), LFNoise0.kr(1).range(150, 1000), 0.1) } +> \effect1;
//: start order: source 1, effect, source2
// PROBLEM: source2 overwrites source1
{ Impulse.ar(4, 0, 0.1) } +> \source1;
{ Ringz.ar(Fin(), LFNoise0.kr(1).range(150, 1000), 0.1) } +> \effect1;
{ WhiteNoise.ar(Decay2.kr(Impulse.kr(0.5, 0, 0.1), 0.3, 1, 0.1)) } +> \source2;

//:
\source1.e.writers;
\effect1.e.writers;
//:
\w1.e.writers add: \w2.e;
\w2.e.writers add: \w3.e;
\w1.e.writers add: \w2b.e;
\r1.e.writers add: \w1.e; // w1 becomes a writer of r1
//:
\r1.e.allWriters(Set());
//:
\r1.e.canAddWriter(\r1.e);
\r1.e.canAddWriter(\w1.e);
/* If you add r1 as writer to w1, note that 
w1 is a writer of r1. So:
Originally w1 writer to r1 !:
r1 <- w1 
After adding r1 AS WRITER to w1:
r1 <- w1 <- r1
This would clearly be a cycle.
*/
\w1.e.canAddWriter(\r1.e);
\w1.e.allWriters(Set());
\

Set() add: 1;