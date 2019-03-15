// 15 Mar 2019 13:00
// From: https://sccode.org/1-5bu
// «wavetable interpolation drone» by eli.fieldsteel on 28 Feb'19 01:06
/*
	A lush drone using a waveshaping algorithm for interpolating between multiple wavetables. This code is based off of a similar code example by totalgee:

	http://sccode.org/1-4V1

	It was only after coding this example that I realized the UGens VOsc and VOsc3 are specifically designed for this wavetable interpolating/morphing function. But this code was still very fun to build.

	EF
*/
//:
Server.default.freeAll;
Window.closeAll;
Buffer.freeAll;
//:

/*
	Function for interpolating between two
	values based on an interpolation value:

	0 ==> old, 1 ==> new,
	0.5 ==> halfway between old/new, etc
*/
~interpFn = {
	arg old=20, new=10, bal=0.5;
	old + ((new - old) * bal);
};

/*
	three wacky envelopes, each converted to Signal format.
	each has 12 level points. the first and last value are
	always zero. the inner 10 points are random between -1
	and +1. the internal functions normalize the levels so
	the highest value is always +/-1.0
*/
~wt0 = Env(
	[0]++
	{
		var levs, peak;
		levs = {rrand(-1.0,1.0)}!10;
		peak = levs.abs.maxItem;
		levs = levs * peak.reciprocal;
	}.value ++
	[0],
	{exprand(0.01,1)}!11,
	{exprand(0.1,4)}!11
).asSignal(512);

~wt1 = Env(
	[0]++
	{
		var levs, peak;
		levs = {rrand(-1.0,1.0)}!10;
		peak = levs.abs.maxItem;
		levs = levs * peak.reciprocal;
	}.value ++
	[0],
	{exprand(0.01,1)}!11,
	{exprand(0.1,4)}!11
).asSignal(512);

~wt2 = Env(
	[0]++
	{
		var levs, peak;
		levs = {rrand(-1.0,1.0)}!10;
		peak = levs.abs.maxItem;
		levs = levs * peak.reciprocal;
	}.value ++
	[0],
	{exprand(0.01,1)}!11,
	{exprand(0.1,4)}!11
).asSignal(512);

/*
	Signals that contain values representing interpolations between two wavetables.
	~i0 interpolates between ~wt0 <==> ~wt1
	~i1 interpolates between ~wt1 <==> ~wt2
*/
~i0 = ~wt0.copy;
~i1 = ~wt2.copy;
//:
Server.default.waitForBoot({

	//load signals to buffers in wavetable format
	~wt0Buf = Buffer.loadCollection(s, ~wt0.asWavetable);
	~wt1Buf = Buffer.loadCollection(s, ~wt1.asWavetable);
	~wt2Buf = Buffer.loadCollection(s, ~wt2.asWavetable);
	~i0Buf = Buffer.alloc(s, 1024, 1);
	~i1Buf = Buffer.alloc(s, 1024, 1);
	Server.default.sync;
	~i0Buf.setn(0, ~i0.asWavetable);
	~i1Buf.setn(0, ~i1.asWavetable);

	Server.default.sync;

	/*
		Create two Osc Synths, reading their wavetable
		data from ~i0Buf and ~i1Buf
	*/
	~synths = [~i0Buf, ~i1Buf].collect{
		arg buf, i;
		{
			/*
				detune=0 makes a much more boring sound, but also
				makes the wavetable interpolation more
				observable (evaluate s.scope and adjust the
				horizontal slider to watch the waveform)
			*/
			arg detune=0.15, freq=40, amp=0.1;
			var sig;
			sig = Osc.ar(
				buf.bufnum,

				//frequency with random moving detune value (in semitones)
				freq * LFNoise1.kr({Rand(0.08,0.15)}!8).bipolar(detune).midiratio,

				{Rand(0,2pi)}!8
			);

			//spread 8-channel detuned Osc texture across two channels
			sig = Splay.ar(sig);

			//avoid funky DC bias
			sig = LeakDC.ar(sig);

			sig = sig * amp;
		}.play(fadeTime:4);
	};

	{
		arg min=0.2, max=1;
		var sig;
		sig = LFDNoise1.kr(
			LFNoise1.kr(8!2).exprange(min,max)
		).unipolar(1);

		/*
			uncomment this line to control wavetable
			interpolation with horizontal mouse position
			instead of a noise generator
		*/
		sig = MouseX.kr!2;

		SendReply.kr(Impulse.kr(40), '/mouse', sig);
		0
	}.play(target:h);

	Server.default.sync;

	OSCdef(\mouse, {
		arg msg;

		/*
			when SendReply sends a value to the language,
			use that value as an interpolation parameter
			and update the wavetables from which the Osc
			UGen is reading
		*/

		//modify values
		~i0.waveFill({
			arg x, val, i;
			~interpFn.(~wt0[i], ~wt1[i], msg[3])
		});
		~i1.waveFill({
			arg x, val, i;
			~interpFn.(~wt1[i], ~wt2[i], msg[4])
		});

		//dynamically update Buffers
		~i0Buf.setn(0, ~i0.asWavetable);
		~i1Buf.setn(0, ~i1.asWavetable);
	}, '/mouse').permanent_(true);
})
//:
//watch:
Server.default.scope;
/*(adjust horizontal slider on scope window
as needed to stabilize waveform view)
*/
//:

//:Change frequency
~synths.do(_.set(\freq, 50));
//:2 synths change freqency
//the two Synths can be changed independently
~synths[0].set(\freq, 60);
~synths[1].set(\freq, 106, \amp, 0.05);

//:fade out
~synths.do(_.set(\gate, 0));
// ================================================================
// Reverse engineer the above
