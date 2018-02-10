// 20 Nov 2017 19:55
// Start a SynthPlayer or a PatternPlayer at the next beat.
// Step by step development
// Starting point: http://doc.sccode.org/Classes/TempoClock.html#-nextTimeOnGrid
//: Step 1: Define a global beat.
TempoClock.default.nextTimeOnGrid;
//: Adapting example from doc page above:
t = TempoClock(1); // create a TempoClock

// schedule an event at next whole beat
t.schedAbs(t.beats.ceil, { arg beat, sec; [beat, sec].postln; 1 });

t.tempo = 2;
t.tempo = 4;
t.tempo = 0.5;
t.tempo = 1;

t.clear;

t.schedAbs(t.beats.ceil, { arg beat, sec; [beat, sec].postln; 1 });

t.stop;
//: Use a pattern producing symbols to notify players as dependants.
~clock = TempoClock.default;
~beatScore = Pseq([\metabar1, Pn(\subbar, 2)], inf).asStream;

~clock.schedAbs(~clock.beats.ceil, {
	var beatName;
	beatName = ~beatScore.next.postln;
	~clock.changed(beatName);
	1;
});
//:
\player.addNotifier(~clock, \metabar1,
	{ (degree: 0, dur: 0.2).play; });

//:
\player.addNotifier(~clock, \subbar,
	{ (degree: 4, dur: 0.2).play; });
//: using new playScore method
TempoClock.default.playScore(
	Pseq([\one, \two, \three], inf)
);
//:
\player.addNotifier(TempoClock.default, \one, {
	(degree: 0, dur: 0.2).play;
});

//:
\player.addNotifier(TempoClock.default, \two, {
	(degree: 2, dur: 0.2).play;
});

//:
\player.addNotifier(TempoClock.default, \three, {
	(degree: 4, dur: 0.2).play;
});
// ================================================================
// Playing EventPatterns and EventStreams with custom clock.
//: How does Pattern play in EventStreamPlayer with play?
~clock = TempoClock();
~streamPlayer = Pbind(\dur, 1, \degree, Pseq((0..7), inf)).play(~clock);
//: change tempo
~clock.tempo = 2;

//: change tempo
~clock.tempo = 4;

//: change tempo
~clock.tempo = 8;

//: change tempo
~clock.tempo = 1.5;
//: Testing with sc-hacks Player;
\tempoPlayer.push;
~clock = TempoClock();
(degree: Pseq((..7), inf)) +> \tempoPlayer;
//:
~clock.tempo = 10;
//: Test tempoClock playScore
a = TempoClock.default.schedAbs(TempoClock.default.beats.ceil, {
	1.postln;
	1
});
//:
a;
//: Testing PlayerClock
p = PlayerClock();
//:
p.isPlaying;
//:
p.play;
//:
p.isPlaying;
//:
p.clock.tempo = 1;
//:
\player1.addNotifier(p, \beat, { (degree: 20).play.postln; });
//:
\player2.addNotifier(p, \beat, { (degree: 22).play.postln; });
//:
\player2.removeNotifier(p, \beat, { (degree: 12).play.postln; });
//:
\player1.removeNotifier(p, \beat, { (degree: 12).play.postln; });
//:
p.clock.tempo = 0.5;
//:
p.clock.tempo = 0.5;
