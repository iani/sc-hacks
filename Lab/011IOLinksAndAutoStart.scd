// 24 Sep 2017 16:17
// Modeling splitting IO with synths that copy signal from one audio bus to another.
// Approach:
// 1. IO splitter is a player in its own envir, with a synth that is built on the spot,
// with customizeable number of input channels.
// The number of output channels are specified for the bus.  They remain unspecified in the Out.ar.
// 2. Test auto-starting envir's players after the groups are re-allocated after ServerTree.
// Test 1: io signal copy player in envir.
//: Test custom number of channels bus allocation with PersistentBusProxy.
a = \io @.2 \out;
//:
a.inspect;
//:
b = a.getBus;
//:
b.inspect;
//: The bus has the right number of channels:
\io.e.busses[\out].inspect;
// now let's make a link synth player for the configured envir.
//: First obtain the number of channels to work with.
\io.e.busses[\out].numChannels;
//: Then make the function with the number of channels:
var numChans;
numChans = \io.e.busses[\out].numChannels;
numChans.postln;
{ In.ar(\in.kr, numChans.postln;) } +> \io;
//: now do all the steps, starting with a symbol.
// You need both an in and an out bus with the right number of channels.
var linkName = \io, argChannels = 2, numChannels;
numChannels = PersistentBusProxy(linkName, \in, argChannels).getBus.numChannels;
PersistentBusProxy(linkName, \out, argChannels).getBus;
linkName.e.busses;
{ In.ar(\in.kr, numChannels) } +> linkName;
\writerTest *> linkName;
linkName *> \readerTest;
//:
{ WhiteNoise.ar(0.1) } +> \writerTest;
{ Ringz.ar(In.ar(\in.kr), LFNoise0.kr([5, 10]).range(400, 4000), 0.5, 0.1) } +> \readerTest;
//: ================================================================
// Above has problems. Redoing clean here:

//: Redoing this to test group ordering.
\writerTest *> \io;
\io *> \readerTest;
//:
\readerTest.e;
\io.e;
\writerTest.e;
//: Now the link synth, and persistency
{ In.ar(\in.kr) } +> \io.persist;
{ WhiteNoise.ar(0.1) } +> \writerTest.persist;
{ Ringz.ar(In.ar(\in.kr), LFNoise0.kr(5).range(400, 2000), 0.5, 0.1) } +> \readerTest.persist;
//: Now add customizations for number of channels and i/o parameters
/* Create 2 busses of 2 channels and store them as audio busses of envir \io.
A writer that wants to write to \io at \in bus, can get the \out bus from it,
and store it as its own audio bus, under any parameter name.
Similarly also for a reader reading from the \out bus.
*/
PersistentBusProxy(\io, \in, 2).getBus;
PersistentBusProxy(\io, \out, 2).getBus;
// ================================================================
// One can do the linking without PersistentBusProxy if one is not using the @ or * operators
//: Example of customizing the name of parameter for a writer
\customWriterTest.e.addAudioBus(\out2, \io.e.getAudioBus(\in, 2));
\customReaderTest.e.addAudioBus(\in2, \io.e.getAudioBus(\out, 2));
\customReaderTest.e.busses.postln;
\customWriterTest.e.busses.postln;
//: Redoing example with default i/o parameter names.
\stereoWriterTest.e.addAudioBus(\out, \io.e.getAudioBus(\in, 2));
\stereoReaderTest.e.addAudioBus(\in, \io.e.getAudioBus(\out, 2));
\stereoReaderTest.e.busses.postln;
\stereoWriterTest.e.busses.postln;
//:
{ In.ar(\in.kr, \stereoWriterTest.e.getAudioBus(\out).numChannels) } +> \io.persist;
//:
\stereoWriterTest *> \io;
\io *> \stereoReaderTest;
{ WhiteNoise.ar(0.1) } +> \stereoWriterTest.persist;
{ Ringz.ar(In.ar(\in.kr), LFNoise0.kr(5).range(400, 2000), 0.5, 0.1) } +> \stereoReaderTest.persist;
// ================================================================
//: Retrying the above in one block of code: Perhaps defer is necessary for starting the synths
//: This in this order is ok in one block.
\stereoWriterTest.e.addAudioBus(\out, \io.e.getAudioBus(\in, 2));
\stereoReaderTest.e.addAudioBus(\in, \io.e.getAudioBus(\out, 2));
\stereoReaderTest.e.busses.postln;
\stereoWriterTest.e.busses.postln;
\stereoWriterTest *> \io;
\io *> \stereoReaderTest;
{ In.ar(\in.kr, \stereoWriterTest.e.getAudioBus(\out).numChannels) } +> \io.persist;
{ WhiteNoise.ar(0.1) } +> \stereoWriterTest.persist;
{ Ringz.ar(In.ar(\in.kr), LFNoise0.kr(5).range(400, 2000), 0.5, 0.1) } +> \stereoReaderTest.persist;
//: Retrying the above in one block of code: Perhaps defer is necessary for starting the synths
// Splitting this so that the writer and reader are started at any other later point is also ok.
\stereoWriterTest.e.addAudioBus(\out, \io.e.getAudioBus(\in, 2));
\stereoReaderTest.e.addAudioBus(\in, \io.e.getAudioBus(\out, 2));
\stereoReaderTest.e.busses.postln;
\stereoWriterTest.e.busses.postln;
\stereoWriterTest *> \io;
\io *> \stereoReaderTest;
{ In.ar(\in.kr, \stereoWriterTest.e.getAudioBus(\out).numChannels) } +> \io.persist;
//:
{ WhiteNoise.ar(0.1) } +> \stereoWriterTest.persist;
{ Ringz.ar(In.ar(\in.kr), LFNoise0.kr(5).range(400, 2000), 0.5, 0.1) } +> \stereoReaderTest.persist;
// ================================================================
//: Now steps towards formulating this as a method:
/* Starting point:
- writer, reader, numchannels (common to writer and reader), 
- writer's out param name, reader's in param name.  Prototype:
writer.copyAudio(reader, numChans, outparam, inparam);
*/
//: Testing stereo
// correct 2 channel link: 2 pulses off-phase coming out of 2 channels processed separately
\testWriter.copyAudio(\testReader, 2);
{ WhiteNoise.ar(Decay.kr(Impulse.kr([2, 2] / 2, [0, 0.5]), 0.1, 0.5)) } +> \testWriter;
{ Ringz.ar(In.ar(\in. kr, 2), [400, 600], 0.4, 0.1) } +> \testReader;

//: Testing stereo - counterexample with 1 channel link, (user error.)
// The second channel of the stereo output of the writer is copied onto the first input channel.
/* Explanation of resulting error:
	\testWriter2.e.busses[\out].index; // 4
	\testReader2.e.busses[\in].index; // 5
	\testReader2.e.writers.asArray.first; // in index: 4. Out index: 5

testWriter2 writes its output to bus \out with 1 channel, at index 4.
But the actual output has 2 channels, so it writes in channel 4 and 5.
The link environment/player _link_1002_ reads input at in = 4 and writes output at out  = 5.
Therefore it copies the first of the 2 channels of output of testWriter2 from 4 to 5.
So 5 receives the output of 4. So 5 has both the second channel of output of testWriter2 and the first.
\testReader2 reads channel 5, and thus reads both channels output by testWriter2.
Note that if we make the input of testReader2 have 2 channels, then it will read silence in the 
second channel, and thus the second channel of its output will remain silent.
In contrast, in the example after that (testWriter3), testReader3 has 1 channel input,
which it expands to 2 channels because of the frequency argument, and therefore it expands
the input of channel 5, which contains both channels output by testWriter3.
*/
\testWriter2.copyAudio(\testReader2, 1);
{ WhiteNoise.ar(Decay.kr(Impulse.kr([10, 2] / 2, [0, 0.5]), 0.1, 0.5)) } +> \testWriter2;
{ Ringz.ar(In.ar(\in.kr, 2), [400, 600], 0.4, 0.1) } +> \testReader2;
//:
(dur: 0.1) +> \testWriter2;

(degree: Pbrown(0, 10)) +> \testWriter2;

{  In.ar(\in.kr, 2) } +> \testReader2;


//: Testing stereo - counterexample with 1 channel link 2
// The 2 channels wrap onto 1, which is expanded back by the reader.
\testWriter3.copyAudio(\testReader3, 1);
{ WhiteNoise.ar(Decay.kr(Impulse.kr([2, 2] / 2, [0, 0.5]), 0.1, 0.5)) } +> \testWriter3;
{ Ringz.ar(In.ar(\in.kr, 1), [400, 600], 0.4, 0.1) } +> \testReader3;
// ================================================================
// Demonstrating persist and auto messages
//: 1: Persist. Always restarts after stopping with C-c C-s (emacs) or Command-period (SCIDE).
\testWriter.copyAudio(\testReader, 2); // link is persistent per default
// these players must be made persistent explicitly:
{ WhiteNoise.ar(Decay.kr(Impulse.kr([2, 2] / 2, [0, 0.5]), 0.1, 0.5)) } +> \testWriter.persist;
{ Ringz.ar(In.ar(\in. kr, 2), [400, 600], 0.4, 0.1) } +> \testReader.persist;
//: 2: Auto.  Restart when user issues Main.run message. (In emacs: C-c C-r. In SCIDE?)
\testWriter.copyAudio(\testReader, 2); // link is persistent per default
{ WhiteNoise.ar(Decay.kr(Impulse.kr([2, 2] / 2, [0, 0.5]), 0.1, 0.5)) } +> \testWriter.auto;
{ Ringz.ar(In.ar(\in. kr, 2), [400, 600], 0.4, 0.1) } +> \testReader.auto;