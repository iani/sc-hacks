/* README: Implementation plan. 
 2 Oct 2018 15:55: Building the stockhausen solo piece code from scratch.

We need to implement following functions: 

1. Recording
2. Feedback
3. Playback

*/
//:preload create necessary buffer for piece
// This buffer is created by the system before running any snippets.
// duration is 25.3 seconds as required in cycle D of formschema version 1.
\buffer.b(25.3)
//:Test with synthetic source
/* Proof that the playback is done _BEFORE_ the source being recorded:
The sound will start 5 seconds after starting this patch.
However, when doing \buffer.b.play; the sound will start immediately.
*/
{
	var trigger, scale, rates, data;
	var source, playback;
	// Synthetic source - can be removed later
	trigger = Impulse.kr(5.reciprocal);
	scale = Dseq(([0, 2, 4, 5, 7, 9, 11, 12] + 60).midicps, inf);
	rates = Dseq((1..8), inf);
	data = Demand.kr(trigger, 0, [scale, rates]);
	source = SinOsc.ar(data[0], 0, Decay.kr(Impulse.kr(data[1]), 0.1, 0.1));
	// end of synthetic source
	// playback _BEFORE_ recording
	playback = PlayBuf.ar(1, \buffer.b.bufnum, trigger: trigger, startPos: 0);
	RecordBuf.ar( // record + feedback
		source + PlayBuf.ar(1, \buffer.b.bufnum, trigger: trigger, startPos: 0),
		\buffer.b.bufnum, offset: 0, loop: 1, trigger: trigger);
	playback; // playback before recording
} +> \src;
//:test that the input was recorded from beginning of buffer:
\buffer.b.play;
//:free buffer and create new one.
\buffer.free;
\buffer.b(25.3);
//:Test free buffer
\buffer.b.play;
//:Correct patch with faders. stock1 = left channel
\stock1.v(
	\input.slider([0, 1.0]),
	\feedback.slider([0, 1.0]),
	\playback.slider([0, 1.0]),
);
{
	var dt, trigger, playback;
	dt = \dt.kr(6); // Formschema 1 A
	trigger = Impulse.kr(dt.reciprocal) + Changed.kr(dt);
	// playback _BEFORE_ recording
	playback = \playback.kr(0) *
	PlayBuf.ar(1, \buffer.b.bufnum, trigger: trigger, startPos: 0);
	RecordBuf.ar( // record + feedback
		(
			\input.kr(0 ) * In.ar(2)
		) +
		(
			\feedback.kr(0) *
			PlayBuf.ar(1, \buffer.b.bufnum, trigger: trigger, startPos: 0)
		),
		\buffer.b.bufnum, offset: 0, loop: 1, trigger: trigger);
	playback; // playback before recording
} +> \stock1;

//: EARLIER EXAMPLES
//:Recording simple example
{
	RecordBuf.ar(In.ar(2), \buffer.b.bufnum, 0,
		loop: 0, doneAction: 2);
	Silent.ar;
} +> \stockrecord;

//:Simple Feedback example
\stockrecord.stop;

{
	RecordBuf.ar(
		In.ar(2)
		+
		PlayBuf.ar(1, \buffer.b.bufnum, loop: 0, doneAction: 2),
		\buffer.b.bufnum, 0,
		loop: 0, doneAction: 2);
	Silent.ar;
} +> \stockfeedback;

{
	PlayBuf.ar(1, \buffer.b.bufnum, loop: 0, doneAction: 2);
} +> \stockplayback;

//:Test playback what has been done so far.

{
	PlayBuf.ar(1, \buffer.b.bufnum, loop: 0, doneAction: 2);
} +> \stockplayback;




//: OLD STUFF STARTS HERE ------
//:sound check
() +> \stock;
//:test number of available inputs
Server.default.options.numInputBusChannels;
//:test number of available outputs
Server.default.options.numOutputBusChannels;
//:get the input
// This is calculated on the basis of numOutputBusChannels;
{ In.ar(2) } +> \stock;
//:Now DELAY the input
{ DelayN.ar(In.ar(2), 1, 0.5) } +> \stock;
//:control delay time per GUI slider
\stock.v(
	\dt.slider([0.0, 1.0])
);
{ DelayN.ar(In.ar(2), 1, \dt.kr(0.1)) } +> \stock;
//:preload the buffer for the delay
// name of buffer is symbol.
// .b message tells to create or get a buffer.
// argument tells length of buffer in seconds.
\rb.b(3); // store 3 second buffer in \rb
//:Here check existence of preloaded buffer.
\rb.b;
//:use buffer for a delay. (NO FEEDBACK!)
/*
For this we need to do 2 things:
1. Record the input.
2. Play the recorded input back, _DELAYED_.

NOTE: The recorded input is played back delayed,
   but there is no feedback.
For feedback we must add the playback into the recording.
This is done in the next example.
*/ 
\stock.v(
	\dt.slider([0.0, 3.0])
);
{
	var dt;
	dt = \dt.kr(0.1);
	RecordBuf.ar(In.ar(2), \rb.b(3), loop: 1);
	// the delay is given by the startPos argument.
	// additionally, we need to retrigger the PlayBuf whenever the startpos changes,
	// in order for the reading position to actually change.
	// To retrigger, we use the parameter 'trigger'.
	// We set it to 1 whenever the startPos changes.
	// To track when the startPos changes, we use the UGen called 'Changed'
	PlayBuf.ar(1, \rb.b,
		trigger: Changed.kr(dt),
		startPos: dt * BufSampleRate.kr(\rb.b), 
		loop: 1);
} +> \stock;
//:Feedback the input into the buffer