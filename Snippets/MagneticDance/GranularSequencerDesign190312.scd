/* 12 Mar 2019 13:36

Exploring different approaches to buffer playback, including granulation.
With view to emulate a sequencer and include 

Prerequisites:
Nikk's samples have been copied onto local disk, and a symbolic alias has been
created under SuperDirt samples dir in downloaded quarks.

Boot server to load SuperDirt samples, including nikk samples.

Now samples are available in Registry.

*/
//:+ Play all buffers under nikk, at 2 seconds interval:
Registry.at(\buffers).keys select: { | key |
	key.asString[..3] == "nikk"
} do: { | key |
	key.b.play;
	2.wait;
};
//:Play full sample when triggering.
// restart at each trigger. Play till retriggered.
// Do not loop, but do not free buffer when done, so that you can retriggeer.
{ | buf = 0 |
	// buf 0 is default. can be changed by user at any moment
	// via \buf <+envirname \samplename.b.bufnum;
	PlayBuf.ar(1, buf, 1, \trig .kr(0), 0, loop: 0, doneAction: 0);
} +> \buftest;
//: Works only once. Must reset trig to 0 and retry
\trig <+.buftest 1;
//:+ Countertest: this will not retrigger many times:
10 do: { | i |
	postf("this is the %th try\n", i + 1);
	"setting trig to 1".postln;
	\trig <+.buftest 1;
	"waiting 0.25 seconds".postln;
	0.25.wait;
};
//:+ Workaround: reset trig to 0 and then back to 1
/* Note:
This is not a good solution, because we have to wait before retriggering is possible.
*/
10 do: { | i |
	postf("this is the %th try\n", i + 1);
	"setting trig to 0".postln;
	\trig <+.buftest 0;
	"waiting 0.01 seconds".postln;
	0.01.wait;
	"setting trig to 1".postln;
	\trig <+.buftest 1;
	"waiting 0.25 seconds".postln;
	0.25.wait;
};
//Better solution: Use Changed.kr and a counter.
//: Starting a better resettable playbuf, using Changed.kr
// restart at each trigger. Play till retriggered.
// Do not loop, but do not free buffer when done, so that you can retriggeer.
{ | buf = 0 |
	// buf 0 is default. can be changed by user at any moment
	// via \buf <+envirname \samplename.b.bufnum;
	PlayBuf.ar(1, buf, 1, Changed.kr(\trig.kr(0)), 0, loop: 0, doneAction: 0);
} +> \buftest;

//:+ test with new value of trig every time.
// to generate unique numbers, use UniqueId.next; works every time. 
10 do: { | i |
	postf("this is the %th try\n", i + 1);
	"setting trig to 0".postln;
	\trig <+.buftest UniqueID.next.postln;
	"waiting 0.25 seconds".postln;
	0.25.wait;
};
//Next: Try longer buffer. 
//:Find long nikk buffer. nikk.b is the long one.
\buf <+.buftest \nikk.b.bufnum;
{ | buf = 0 |
	// buf 0 is default. can be changed by user at any moment
	// via \buf <+envirname \samplename.b.bufnum;
	PlayBuf.ar(1, buf, 1, Changed.kr(\trig.kr(0)), 0, loop: 0, doneAction: 0);
} +> \buftest;

// ================================================================
// ΝΟΤΕ! TODO: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//:Need to debug node with synth player ;-()
//:trying with buftest above first
\buftest.stop;
//:test while debugging
\buf <+.buftest 10000;
//:new try next:
{ SinOsc.ar(\freq.kr(400), 0, 0.1) } +> \nodetest;
//:Need to debug node with synth player ;-()
{ LFSaw.ar(\freq.kr(400), 0, 0.1) } +> \nodetest;
//:
\nodetest.stop;
//:
\freq <+.nodetest 500;
//:
UniqueID();
//:
\buftest.envir.put(\trig, 1000);
\buftest.envir.class;
