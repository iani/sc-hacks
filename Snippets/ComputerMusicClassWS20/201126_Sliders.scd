//: 26 Nov 2020 17:58
// Constructing simple guis connected to players
//:A gui connected to the player named \test
\test.sliders;
/* This creates no sliders, because no parameters are given.

But the gui can toggle the player on/off.

Click on the button to toggle the player.
Typing the space key also toggles the player.
*/
//:The button always keeps track of the player state
// Toggle the player on / off via code
// The button changes to reflect its state:
\test.toggle;
//:* Routines also work
\test.toggle;
0.1.rrand(1).wait;
// Stop the routine above by typing command-period.
// (This also stops the sound.)
//:Add some sliders to control parameters of the player's synth
\test.sliders(\freq, \amp, \pan);
//:+ The environment remembers the last setting of the parameters
// Toggle the sound on and off and see that it starts
// with the parameters as set.
/* Note: You can use the messages \start or play to start
and the message \stop to stop the player:
*/
\test.play;
1.wait;
\test.stop;
1.wait;
\test.start;
1.wait;
\test.stop;
//:+Change the parameters in a routine
// The gui elements reflect the changes of values
\test.start;
50 do: { | i |
	\freq <+.test (40 + i).midicps;
	0.1.wait;
	\amp <+.test (5 + i).reciprocal;
	0.1.wait;
	\pan <+.test -1.rrand(1.0);
	0.1.wait;
};
\fadeTime <+.test 5;
"Releasing... ".post;
\test.release;
//:Set custom ControlSpec by specifying its parameters like this:
\test.sliders(\freq, [\q, [0.01, 5, \exp, 0, 0.5]]);
{ Resonz.ar(WhiteNoise.ar(0.5), \freq.kr(400), \q.kr(0.3)).dup } +> \test;
//:
