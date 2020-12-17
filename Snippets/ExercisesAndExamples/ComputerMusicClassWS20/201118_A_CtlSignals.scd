//:17 Nov 2020 08:24 control signal operation exercise
/*
Split a (control) signal to its positive and non-positive parts.
Reverse the non-positive part to its positive mirror shape.
*/
//:saw shape
{ Out.kr(0, LFSaw.kr(0.2)) } +> \cm1;
//:copy signal into another bus (for testing)
{ Out.kr(1, In.kr(0)) } +> \cm2;
//:reverse (mirror) saw shape
//:Use original saw from previous synth as input
{ Out.kr(1, In.kr(0) * -1) } +> \cm2;
//:Pass only positive part
{ Out.kr(2, In.kr(0) * (In.kr(0) > 0))} +> \cm3;
//:Pass only negative part
{ Out.kr(3, In.kr(0) * (In.kr(0) < 0))} +> \cm4;
//:mirror only negative part;
{ Out.kr(4, In.kr(0) * (In.kr(0) < 0) * -1)} +> \cm5;
//:change period of source signal
{ Out.kr(0, LFSaw.kr(1)) } +> \cm1;
//:================================================================
//:Repeat the above in audio rate - view signal in audio scope
/*
THE EXAMPLES BELOW ONLY WORK IF YOU START THE SOURCE SYNTH
(cm1), !!! AFTER !!! STARTING THE SYNTHS THAT READ FROM IT
Alternatively, fix the order by linking the players
beforehand using the *< operator (link 1-to-many).
For this, see next section below.
*/
//:saw shape
{ Out.ar(10, LFSaw.ar(35.16, 0, 0.5)) } +> \cm1;
//:reverse (mirror) saw shape
//:need to place cm1 synth before cm2
//:Use original saw from previous synth as input
{ Out.ar(11, In.ar(10) * -1) } +> \cm2;
//:Pass only positive part
{ Out.ar(12, In.ar(10) * (In.ar(10) > 0))} +> \cm3;
//:Pass only negative part
{ Out.ar(13, In.ar(10) * (In.ar(10) < 0))} +> \cm4;
//:mirror only negative part;
{ Out.ar(14, In.ar(10) * (In.ar(10) < 0) * -1)} +> \cm5;
//:change period of source signal
{ Out.ar(10, LFSaw.ar(1)) } +> \cm1;
//:================================================================
//:Redoing the above using Player linking with sc-hacks *> operator.
//:Test source: Saw waveform.
{ LFSaw.ar(35.15, 0, 0.1) } +> \testsaw;
//:Link \testsaw to \o2m1, \o2m2, \o2m3;
\testsaw *< \o2m1;
\testsaw *< \o2m2;
\testsaw *< \o2m3;
//:Play inverse of source in \o2m1;
{ Out.ar(4, Inp.ar) } +> \o2m1;
//:Play positive part of source in \o2m2
{ Out.ar(5, Inp.ar > 0 * Inp.ar) } +> \o2m2;
//:Play inverted positive part of source in \o2m3
{ Out.ar(6, Inp.ar > 0 * Inp.ar * -1) } +> \o2m3;
