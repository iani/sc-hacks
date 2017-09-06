//:+  6 Sep 2017 01:15 Preparing PatternPlayer
a = (dur: 0.1).p;
0.1.wait;
a.isPlaying.postln;
2.0.wait;
a.stop;
a.isPlaying.postln;
1.wait;
a.isPlaying.postln;
a.play;
a.isPlaying.postln;
//  3 Sep 2017 13:49 First study how to play EventPatterns
//: Very basic
a = (degree: Pseq((0..7), inf));
b = EventPattern (a);
c = b.play;
//:
1 + 1;
b;

//: Using p shortcut method
~a = (degree: Pseq((0..7), inf)).p;
~a.pause;
~a.play;
~a.stop;
~a.reset;
~a.inspect;
~a.originalStream.event[\dur] = 0.1;
~a.originalStream.inspect;
//:
{
	var a;
	a = (degree: Pseq((0..7), inf), dur: 0.1).p;
	3.wait;
	a.originalStream.event[\degree] = Pbrown(0, 7, 1).asStream;
	1.wait;
	a.stop;
	0.5.wait;
	a.originalStream.event[\degree] = Pwhite(0, 20).asStream;
	1.wait;
	a.play;
	3.wait;
	a.originalStream.event[\degree] = Pbrown(0, 7, 1).asStream;
	5.wait;
	a.stop;
}.fork;
//: Now try using EventStreamPlayer directly as source for PatternPlayer.
~pattern = EventPattern ((degree: Pseq((0..7), inf), dur: 0.5));
~pattern.play;
/*
Pattern:play method code:

	play { arg clock, protoEvent, quant;
		^this.asEventStreamPlayer(protoEvent).play(clock, false, quant)
	}
*/
~player = ~pattern.asEventStreamPlayer;
~player.play;