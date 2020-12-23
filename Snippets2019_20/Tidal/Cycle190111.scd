// Testing Cycle classes
/// ----
//:cycle01 just posts a message
Cycle01().play;
//:cycle02 plays a stream
Cycle02(0.5).play((10..15).collect({ | d | (degree: d)}).pseq(1));
//:Test event stuff
(cycle: { | self, parentCycle |
postf("the period of my parent is: %\n", parentCycle.period);
self.dur = parentCycle.period;
self.play;
}).cycle(Cycle01(pi**2));
//:Prepare+compile a string with nested cycles
"[aa] ".replace("[", "Cycle(").replace( "]", ")");
//:Prepare+compile a string with nested cycles
"[bb[aa]]".replace("[", "Cycle(").replace( "]", ")");

//:Prepare+compile a string with nested cycles
"[bb[aa cc]dd ee]".split($ ) do: _.postln;
//:Prepare+compile a string with nested cycles
"[ bb [[ aa cc ] dd] ee ]".split($ ).collect{ | i |
	if (i[0].isAlpha) { "\\" ++ i ++ ", " } { i }
}
//:Prepare+compile a string with nested cycles
var input, last, first;
input = "[ bb [ [ aa cc ] dd ] ee ]".split($ );
last = input.size - 1;
"".catArgs(*input.collect{ | i, index |
	first = i[0];
	if (first.isAlpha) { "\\" ++ i ++ ", " } {
		if (first === $] and: { index < last }) { i ++ "," } { i }
	}
}).interpret;
//:Prepare+compile a string with nested cycles
var input, last, first;
input = "[ bb [ xx [ aa cc ] ] ee ]".split($ );
last = input.size - 1;
"".catArgs(*input.collect{ | i, index |
	first = i[0];
	if (first.isAlpha) { "\\" ++ i ++ ", " } {
		if (first === $] and: { index < last }) { i ++ "," } { i }
	}
}).interpret do: _.postln;
//:Prepare+compile a string with nested cycles
var input, last, first;
input = "[ bb [ [ xx [ aa cc ] ] ee ] ]".split($ );
last = input.size - 1;
"".catArgs(*input.collect{ | i, index |
	first = i[0];
	if (first.isAlpha) { "\\" ++ i ++ ", " } {
		if (i.last === $] and: { index < last }) { i ++ "," } { i }
	}
}).interpret do: _.postln;
//:convert a string with asCycle - simple, not nested
"a b c".asCycle.inspect;
//:convert a string with asCycle - nested
"a b c [ d e ]".asCycle.inspect;
//:convert a string with asCycle - nested
"a [ b c ] [ d e [ f ] ]".asCycle.inspect;
//:Test TempoClock for scheduling.
var clock;
// 60bpm, starting at 0 now:
clock = TempoClock(1, 0);
postf("% started at % beats\n", clock, clock.beats);
clock.sched(1, {
	postf("% every 1 beat. Now is beat %\n", clock, clock.beats);
	1;
});
//:Beat class: First test.
// starts immediately
~beat = Beat();
//:modifie beats period
~beat.period = 0.5
//:stop by setting beats to nil
~beat.period = nil
//:prepare tests playing sample events
var buf, instr;
// #buf, instr = Registry.at(\tidal)[\808];
#buf, instr = Registry.at(\tidal, \808);
(instrument: instr, buf: buf).play;
//:Can one reset streams? YES
var stream;
stream = Pseq((1..729), 1).asStream;
{
	5 do: {
		5 do: {
			stream.next.postln;
			0.25.wait;
		};
		stream.reset;
	};
	"DONE: I reset the stream 5 times".postln;
}.fork;
//: