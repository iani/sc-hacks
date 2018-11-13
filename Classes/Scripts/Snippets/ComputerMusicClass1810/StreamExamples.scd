// Stream examples 13 Nov 2018 14:55
//:Streams vs patterns 1: Create a stream and get some values from it
~pattern = Pseries(1, 1, 7);
~stream = ~pattern.asStream;
10 do: { ~stream.next.postln;};
//:The stream cannot return back.
// after the end, the stream will keep returning nil
~stream.next.postln; // is nil
//:To restart, we create a new stream:
~stream = ~pattern.asStream; // the pattern can create any number of new streams;
~stream.next.postln; // we are now again at the beginning;
// Note: A stream can be a Routine!
/* To see the Routine created by Pseries, look at its source code
AND the source code of embedInStream, 
AND the source code of Pattern:asStream.
The code is divided between different classes and methods.
That makes it difficult to understand.
Here is a first attempt to go just below the surface: 

Pattern:asStream creates a routine that calls this.embedInStream.
this.embedInStream should do 2 things: 

- give the next value;
- call yield on some object, in order to wait for the next call of "next". 
*/
//:stream as data in routine 1: counterexample
//Counterexample without stream:
{
	inf do: { | i |
		(freq: (i % 7 + 60).midicps, dur: 0.1).play;
		0.2.wait;
	}
}.fork;
/*
Limitations: How to stop after a number of repetitions?
Need to count manually by coding.
*/
//:The same using a stream
{
	var stream, freq;
	stream = Pseq(((0..6) + 60).midicps, inf).asStream;
	while { (freq = stream.next).notNil } {
		(freq: freq, dur: 0.1).play;
		0.2.wait;
	}
}.fork
//:Stop after 3 repetitions of the phrase.
{
	var stream, freq;
	stream = Pseq(((0..6) + 60).midicps, 3).asStream;
	while { (freq = stream.next).notNil } {
		(freq: freq, dur: 0.1).play;
		0.2.wait;
	}
}.fork
//:Play the same pattern twice, in canon
{
	var scale, rests, stream1, stream2, freq;
	scale = Pseq(((0..6) + 60).midicps, 3);
	rests = Pn(\rest, 3);
	stream1 = Pseq([scale, rests]).asStream;
	stream2 = Pseq([rests, scale]).asStream;
	while { (freq = stream2.next).notNil } {
		(freq: stream1.next, dur: 0.1).play;
		(freq: freq, dur: 0.1).play;
		0.2.wait;
	}
}.fork
//:Use stream to load things sequentially
/*
Using SynthDescLib update message as described in help documentation 
for SynthDef::add.
*/
//Testing:
/*
SynthDescLib.default.addDependant({ | ... args | args.postln;});
SynthDescLib.default.name.postln;
SynthDef(\test, { Out.ar(0, WhiteNoise.ar(0.1)) }).add(\global);
*/
//:Load a series of synthdefs sequentially.
//Generate test synthdefs algorithmically, and put them in a stream;
{
	var defs;
	defs = Pseq(
		{ | i |
			SynthDef(format("def%", i), {
				Out.ar(0, SinOsc.ar((i + 60).midicps, 0, 0.1));
			});
		} ! 10 // 10 synthdefs
	);
	defs.asStream.addNotifier(SynthDescLib.default, \synthDescAdded, { | desc, notification |
		var def;
		def = notification.listener.next;
		if (def.isNil) {
			"all defs were added!".postln;
			{
				defs.asStream do: { | d |
					var synth;
					synth = Synth(d.name);
					0.1.wait;
					synth.free;
					0.1.wait;
				};
			}.fork;
		}{
			//	0.1.wait;
			desc.def.postln;
			desc.def.name.postln;
			// Synth(n.def.name.asSymbol);
			"adding one more def now".postln;
			//	1.wait;
			def.add;
		}
	});
	defs.asStream.next.add;
}.fork
//:
Synth("def3");