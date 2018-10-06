/* Notes and first tries

These are the clearest instructions so far:

From: https://cycling74.com/forums/jonathan-harveys-ricercare-una-melodia
Alistair Macdonald, MAR 27 2018 | 11:19 PM

The original performance involved two four-track reel-to-reel tape recorders with one reel of tape running between them (to create tape delay), a mic and 4 loudspeakers (& amps!). The first part of the piece is simple delay to each of the 4 speakers, 3 seconds apart. Trumpet is recorded on machine 1 track one and played back on machine 2, and also fed into machine 1 track 2, which is played back on machine 2, and so on. In the second part, the playback machine plays at half speed so tape starts accumulating on the floor and each recorded layer plays back an octave lower... With max you just need a mic and an interface with 1 input & 4 outputs feeding 4 speakers.

And:

Hi. It's a 4 channel piece with speakers surrounding the audience so no, 2 speakers won't do it. There is no official patch, but lots of people have made their own versions with delays & record~/play~ objects. If you like I could dig out my old patch which probably still works.

This is easy to do in SC. 
*/
//:Loudspeaker delay setup
/*
Speaker 1: 3 seconds
Speaker 2: 6 seconds
Speaker 3: 12 seconds
Speaker 4: 18 seconds

Second part (from readme of maxpat downloaded from Faber site):

5. 	after 6, 18, 42, 90 sec, with the same durations the incoming signal is transposed, delayed and feds the channels 1, 2, 3, 4 

"with the same durations " I cannot understand - will try several interpretations.
*/
//:preload buffer for harvey
\harvey.b(600); // 10 minute duration buffer
//:start recording
{
{
	RecordBuf.ar(In.ar(4), \harvey.b.bufnum, doneAction: 2);
	Silent.ar();
} +> \harveyrecording;
3.wait;
// start playback speaker 1;
{
	Out.ar(0, 
		PlayBuf.ar(1, \harvey.b.bufnum, \rate1.kr(1), doneAction: 2)
	);
} +> \harveyspkr1;
3.wait;
// start playback speaker 2;
{
	Out.ar(1, 
		PlayBuf.ar(1, \harvey.b.bufnum, \rate1.kr(1), doneAction: 2)
	);
} +> \harveyspkr2;
3.wait;
// start playback speaker 3;
{
	Out.ar(2, 
		PlayBuf.ar(1, \harvey.b.bufnum, \rate1.kr(1), doneAction: 2)
	);
} +> \harveyspkr3;
3.wait;
// start playback speaker 4;
{
	Out.ar(3, 
		PlayBuf.ar(1, \harvey.b.bufnum, \rate1.kr(1), doneAction: 2)
	);
} +> \harveyspkr4;
}.fork;	

//:


//:


//:try timing que [1] start default test
\default +> \test;

//:try timing que [2] stop test
\test.stop
//:try fader actions with parameter mapping.
{
	\default +> \test2;
	1.wait;
	\amp <+ { Line.kr(0.5, 0.0, 12) };
	13.wait;
	\amp <+.test2 { LFNoise0.kr(5).range(0.01, 0.3) };
	5.wait;
	\amp <+.test2 { LFNoise2.kr(2.reciprocal).range(0.01, 0.3) };
}.fork;
//:
\amp <+.test { LFNoise2.kr(5).range(0.1, 0.5) };
//:start test again [3];
\default +> \test;
//:map something in test [4];
\amp <+ { Line.kr(0.3, 0.003, 10) };
//:map something else in test [14];
\amp <+ { LFNoise2.kr(2).range(0.2, 0.4) };
//:map something else in test [18];
\amp <+ { LFNoise0.kr(2).range(0.2, 0.4) };
//:map something else in test [24];
\amp <+ { LFNoise2.kr(1.5).range(0.002, 0.4) };
//: