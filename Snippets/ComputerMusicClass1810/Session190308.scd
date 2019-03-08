//  8 Mar 2019 17:09
//: mary lou theologiti's original: 
var myDurs = Pseq([1/2, 1, 1, 1/2, 1, 2, 2, 1, 1, 1, 1, 1, Pn(1/2, 4), 1, 1/2, 1, 1, 1/2,1/2, 2], inf) * 0.4;

~upperMelody =  Pbind(
	\midinote, Pseq([76, 76, 76, 72, 76, 79, 67, 72, 67, 64, 69, 71, 70, 69, 67, 76, 79, 81, 77, 79, 76, 72, 74, 71], 2),
	\dur, myDurs 
);

~lowerMelody =  Pbind(
	\midinote, Pseq([50, 50, 50, 50, 50, 55, 55, 55, 52, 48, 53, 55, 54, 53, 52, 60, 64, 65, 62, 64, 60, 57, 59, 55], 2),
	\dur, myDurs / 2 // / 2 is modification to get double pace
);

//:
~player1 = ~upperMelody.play;
~player2 = ~lowerMelody.play;
//:

~player1.stop;
~player2.stop;

//:Alternative coding with Ppar (IZ)
~par = Ppar([~upperMelody, ~lowerMelody], inf).play;
//:
~par.stop;
//:
~par respondsTo: \set;
//================================================================
//:2nd idea: Rewrite using sc-hacks
~myDurs = Pseq([1/2, 1, 1, 1/2, 1, 2, 2, 1, 1, 1, 1, 1, Pn(1/2, 4), 1, 1/2, 1, 1, 1/2,1/2, 2], inf) * 0.4;
(dur: ~myDurs, midinote: Pseq([76, 76, 76, 72, 76, 79, 67, 72, 67, 64, 69, 71, 70, 69, 67, 76, 79, 81, 77, 79, 76, 72, 74, 71], inf)) +> \voice1;
(dur: ~myDurs, midinote: Pseq([50, 50, 50, 50, 50, 55, 55, 55, 52, 48, 53, 55, 54, 53, 52, 60, 64, 65, 62, 64, 60, 57, 59, 55], inf)) +> \voice2;


//================
//:2nd idea: Rewrite using sc-hacks
~myDurs = (0.4 * [1/2, 1, 1, 1/2, 1, 2, 2, 1, 1, 1, 1, 1, Pn(1/2, 4), 1, 1/2, 1, 1, 1/2,1/2, 2]).pseq;
(dur: ~myDurs, midinote: [76, 76, 76, 72, 76, 79, 67, 72, 67, 64, 69, 71, 70, 69, 67, 76, 79, 81, 77, 79, 76, 72, 74, 71].pseq) +> \voice1;
//:
~myDurs = (0.1 * [1/2, 1]).pseq(inf);
(dur: ~myDurs, midinote: [76, 74].pseq(inf)) +> \voice1;
//:
(dur: (0.1 * [1/2, 1, 1, 1/2, 1, 2, 2, 1, 1, 1, 1, 1, Pn(1/2, 4), 1, 1/2, 1, 1, 1/2,1/2, 2]).pseq) +> \voice1;
//:
(midinote: [76, 76, 76, 72, 76, 79, 67, 72, 67, 64, 69, 71, 70, 69, 67, 76, 79, 81, 77, 79, 76, 72, 74, 71].pseq) +> \voice1
//:

(dur: ~myDurs, midinote: [50, 50, 50, 50, 50, 55, 55, 55, 52, 48, 53, 55, 54, 53, 52, 60, 64, 65, 62, 64, 60, 57, 59, 55].pseq) +> \voice2;
//:
(dur: ~myDurs / 2) +> \voice2;
//:
(dur: ~myDurs / 2) +> \voice1;