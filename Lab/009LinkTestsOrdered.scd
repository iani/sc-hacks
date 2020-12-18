/* 17 Sep 2017 13:37
Testing linking of environments with ordered groups.
*/



//:
SynthDef("impulse", { | out = 0 |
        Out.ar(out, Impulse.ar(4, 0, 0.1))
}).add;
SynthDef("decay", { | out = 0 |
        Out.ar(out,
                WhiteNoise.ar(
                        Decay2.kr(Impulse.kr(1), 0.3, 0.4, 0.1)
                )
        )
}).add;
SynthDef("ring", {
        Ringz.ar(Fin(), LFNoise0.kr(1).range(150, 500))
}).add;
//:
\writer1 *> \reader1;
\writer2 *< \reader1;
//:
\ring +> \reader1;
\impulse +> \writer1;


//:
\writer1 *> \reader1;
\writer2 *< \reader1;
// OK: start order: reader, writer1, writer2
{ Ringz.ar(Fin(), LFNoise0.kr(1).range(150, 1000), 0.1) } +> \reader1;
{ Impulse.ar(4, 0, 0.1) } +> \writer1;
{ WhiteNoise.ar(Decay2.kr(Impulse.kr(0.5, 0, 0.1), 0.3, 1, 0.1)) } +> \writer2;
//: OK: start order: writer 1, writer2, reader
{ Impulse.ar(4, 0, 0.1) } +> \writer1;
{ WhiteNoise.ar(Decay2.kr(Impulse.kr(0.5, 0, 0.1), 0.3, 1, 0.1)) } +> \writer2;
{ Ringz.ar(Fin(), LFNoise0.kr(1).range(150, 1000), 0.1) } +> \reader1;
//: start order: writer 1, reader, writer2
// PROBLEM: writer2 overwrites writer1
{ Impulse.ar(4, 0, 0.1) } +> \writer1;
{ Ringz.ar(Fin(), LFNoise0.kr(1).range(150, 1000), 0.1) } +> \reader1;
{ WhiteNoise.ar(Decay2.kr(Impulse.kr(0.5, 0, 0.1), 0.3, 1, 0.1)) } +> \writer2;

//:
\writer1.ev.writers;
\reader1.ev.writers;
//:
\w1.ev.writers add: \w2.ev;
\w2.ev.writers add: \w3.ev;
\w1.ev.writers add: \w2b.ev;
\r1.ev.writers add: \w1.ev; // w1 becomes a writer of r1
//:
\r1.ev.allWriters(Set());
//:
\r1.ev.canAddWriter(\r1.ev);
\r1.ev.canAddWriter(\w1.ev);
/* If you add r1 as writer to w1, note that 
w1 is a writer of r1. So:
Originally w1 writer to r1 !:
r1 <- w1 
After adding r1 AS WRITER to w1:
r1 <- w1 <- r1
This would clearly be a cycle.
*/
\w1.ev.canAddWriter(\r1.ev);
\w1.ev.allWriters(Set());
\

Set() add: 1;