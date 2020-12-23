/* 25 Nov 2020 15:26
Session with Vassilis Agiomyrgianakis.
Explaining features of the library in some order.
*/
//:create a player by playing a synthdef by name!
\default +> \myfirstsound;
//:substitute a different content into the player by sending a function
{ SinOsc.ar(600, 0, 0.1).dup } +> \myfirstsound;
//:stop
\myfirstsound.stop;
//:restart
\myfirstsound.start;
//:play a pattern
() +> \myfirstsound;
//:change the pattern on the fly
(dur: 0.2) +> \myfirstsound;
//:more changes
(degree: Pbrown(-5, 5, 3)) +> \myfirstsound;
//:and even more changes
(dur: [0.2, 0.4, 0.1 ! 5].flat.prand) +> \myfirstsound;
//: ================================================================
//: Settig parameters in the current environment also sets them in its players
{ SinOsc.ar(\freq.kr(600), 0, 0.1).dup } +> \settable;
//:
\freq <+ 400;
//:*
\freq <+ 400.rrand(2000);
0.1.wait;
//:
~freq;
//:
currentEnvironment;
//:targetting an environment by name (longer but safer!!!)
//:*
\freq <+.settable 400.rrand(2000);
0.1.wait;
//: play another player in another environment in parallel
{ SinOsc.ar(\freq.kr(600), 0, 0.1).dup } +> \settable2;
//:*
\freq <+.settable2 400.rrand(2000);
0.1.wait;
//:



\myfirstsound.stop;


\myfirstsound.p;

\myfirstsound.release;

//:================================================================
//:Understanding Registry internals
Library.global.at(\buffers).keys

//:================================================================
//:Buffer stuff
Buffer.all;
