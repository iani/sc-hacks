//: 12 Jan 2021 09:32 make setSource work: set def as source of the player.
/* 
setSource: set the source of the player, but do not start it.
*/
//: TESTING:
//:The sourcePlayer of a newly accessed player is nil
\test.pp; // nil.
//:test the above again, starting with .p first
\test2.p.postln;
\test2.pp.postln;
\test2.p.sourcePlayer.postln;
//:How does a Player with no sourcePlayer play?
\test3.play;
//:
\test3.pp.source.name;
//:
\test3.play;
//:
\test3.p.setSource({ SinOsc.ar(\freq.kr(1500), 0, 0.2).dup });
//:
\test3.play;
//:
\freq <+.test3 1200;