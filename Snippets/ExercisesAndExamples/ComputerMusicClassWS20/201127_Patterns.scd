//:27 Nov 2020 19:36 draft of intro to patterns in sc-hacks
/* TODO:
Sometimes when switching from synth to pattern, the
status button of the sliders gui remains green on start
during the whole time while the pattern is playing.
The pattern Player misses to notify for its start - or rather,
it notifies its start too early, and the synth switches
the state back to off when it stops *AFTER* the pattern has started.

THEREFORE:

The SynthPlayer needs to check whether a pattern has already started
playing or is scheduled to start, before notifying stopped.

RULE:

WHEN THE SYNTHPLAYER'S SYNTH NOTIFIES THAT IT HAS ENDED
(AS A RESULT OF SYNTH:ONEND), THE SYNTHPLAYER MUST CHECK IF
ITS PLAYER HAS A PATTERNPLAYER THAT HAS STARTED OR IS SCHEDULED
TO START AT THE NEXT BEAT, AND IF THAT IS THE CASE, THEN
THE SYNTHPLAYER SHOULD NOT NOTIFY STOPPED.

*/
//:Test that start-stop button also works for patterns.
\patest.sliders;
//:start a pattern, then switch on-off from gui above
(dur: 0.1, degree: [-5, 5, 3].pbrown) +> \patest;
//:stop from code, and see that gui updates
\patest.stop;
//:play a synthdef in the player. It replaces the pattern
\default +> \patest;
//:need to fix updating the gui when switching from synth to pattern.
//:+test creating sliders from inside a routine
0.5.wait;
"trying now".postln;
\patest.sliders;
//:+Automated test of switching between synth and pattern
\patest.stop;
0.5.wait;
\patest.sliders;
loop {
	1.5.wait;
	\default +> \patest;
	"the button should be RED FOR SYNTH now".postln;
	2.wait;
	(dur: 0.5, degree: (0..5).pseq) +> \patest;
	"the button should be RED FOR PAT now".postln;
	3.wait;
};
//:+Same test with shorter quant
\patest.stop;
\quant <+.patest 0.1;
0.5.wait;
\patest.sliders;
loop {
	1.5.wait;
	\default +> \patest;
	"the button should be RED FOR SYNTH now".postln;
	2.wait;
	(dur: 0.5, degree: (0..5).pseq) +> \patest;
	"the button should be RED FOR PAT now".postln;
	3.wait;
};
//:+Same test with LONGER quant
\patest.stop;
\quant <+.patest 4.0;
0.5.wait;
\patest.sliders;
loop {
	1.5.wait;
	\default +> \patest;
	"the button should be RED FOR SYNTH now".postln;
	2.wait;
	(dur: 0.5, degree: (0..5).pseq) +> \patest;
	"the button should be RED FOR PAT now".postln;
	3.wait;
};
//: ================================================================
//:debugging started/stopped notifications when switching from pattern to synth
//:first testing synth to synth alone.
\default +> \test;
\test.toggle;
{ SinOsc.ar(400, 0, 0.1).dup } +> \test;
//:
(dur: 0.1) +> \test;