// Demand ugen studies taken from examples of SC Help

//:server include meter
//:preload include scope

//:example 1
{
	var trig, seq, freq;
	trig = Impulse.kr(24);
	seq = Drand([Dseq((1..5).mirror1, 1), Drand((4..10), 8)], 2000);
	freq = Demand.kr(trig, 0, seq * 100);
	SinOsc.ar(freq + [0,0.7]).cubed.cubed.scaleneg(MouseX.kr(-1,1)) * 0.1;
} +> \demand;

//:example 2
{
	var trig, seq, freq;
	trig = Impulse.kr(12);
	seq = Drand([Dseq((1..5).mirror1, 1), Drand((4..10), 8)], 2000) * Drand([1,2,4,8],2000);
	freq = Demand.kr(trig, 0, seq * 100);
	SinOsc.ar(freq + [0,0.7]).cubed.cubed.scaleneg(MouseX.kr(-1,1)) * 0.1;
} +> \demand;

//:example 3
{
	var freq, trig, reset, seq;
	trig = Impulse.kr(10);
	seq = Diwhite(60, 72, inf).midicps;
	freq = Demand.kr(trig, 0, seq);
	SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
} +> \demand;

//:example 4
{
	var freq, trig, reset, seq;
	trig = Impulse.kr(10);
	seq = Dseq([72, 75, 79, Drand([82,84,86])], inf).midicps;
	freq = Demand.kr(trig, 0, seq);
	SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
} +> \demand;

//:example 5
{
	var freq, trig, reset, seq;
	trig = Impulse.kr(10);
	seq = Dswitch1(
		[
			Diwhite(60, 72, inf),
			Dseq([72, 75, 79, Drand([82,84,86])], inf)
		],
		LFPulse.kr(0.2)
	);
	freq = Demand.kr(trig, 0, seq.midicps);
	SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
} +> \demand;

//:example 6
{
	var freq, trig, reset, seq1, seq2;
	trig = Impulse.kr(10);
	seq1 = Drand([72, 75, 79, 82] - 12, inf).midicps;
	seq2 = Dseq([72, 75, 79, Drand([82,84,86])], inf).midicps;
	freq = Demand.kr(trig, 0, [seq1, seq2]);
	SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
} +> \demand;

//:example 7
{
	var trig, seq;
	trig = Impulse.kr(8);
	seq = Drand([
		Dseq([4,0,0,1,2,1,0,1]),
		Dseq([4,0,2,0,1,0,1,1]),
		Dseq([4,0,0,2,0,0,1,1]),
		Dseq([4,0,1,2,0,1,2,0]),
		Dseq([4,1,1,1,2,2,3,3]),
		Dseq([4,1,0,1,0,1,0,1])
	], inf);
	trig = Demand.kr(trig, 0, seq * 0.4) * trig;
	{LPF.ar(PinkNoise.ar, 5000)}.dup * Decay.kr(trig, 0.5);
} +> \demand;
//:dtag example
{
	var tag, axiom, rules, size, dt, sineFreq;
	dt = MouseX.kr(1e-1, 1e-4, 1);
	size = 48000 * 2;
	axiom = [1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1];
	v = 3;
	rules = [[1, 0], [1, 1, 0, 1]];
	tag = Dtag(size, v, axiom, rules);
	sineFreq = Duty.ar(dt, 0, tag, doneAction: 2) * 200 + 300;
	(SinOsc.ar(sineFreq.lag(dt)) * AmpCompA.kr(sineFreq) * 0.2).dup
} +> \demand;
//:recycling tag system, vals 0-2
{
    var tag, trig;
    var deletionNumber = 3;
    var axiom = [0, 1, 2];
    var rules = [[0, 1], [2, 0], [1, 1]];
    var recycle = -3; // head start when writer was tagged.
    tag = Dtag(9, deletionNumber, axiom, rules, recycle, 5);

    SinOsc.ar(
        Duty.kr(1, 0, tag, doneAction:2)
        * 100 + 300 + SinOsc.kr([4, 4.1], 0, 8)
    )
    * 0.1 ! 2
} +> \demand;
//:exprand buffer b
/*
This 
*/
{
	b = Buffer.alloc(s, 24, 1);
	0.1.wait;
	b.setn(0, { exprand(200, 500) } ! b.numFrames);
	// a delay is necessary here otherwise getting error.
	0.1.wait;
	b.getn(0, b.numFrames, {|x| x.postln })
}.fork;

{ var indexPattern;
	    indexPattern = Dseq([Dseq([0, 3, 5, 0, 3, 7, 0, 5, 9], 3), Dbrown(0, 23, 1, 5)], inf);
	    SinOsc.ar(
		        Demand.kr(Dust.kr(10), 0, Dbufrd(b, indexPattern))
		    ) * 0.1
} +> \demand;

//:buffer as a time pattern
// alloc buffer c for Dbufrd
{
	b = Buffer.alloc(s, 24, 1);
	0.1.wait;
	b.setn(0,
		Pbrown(45, 95, 3, inf).asStream.nextN(b.numFrames).midicps
		//	{ /* exprand(200, 500) */ 55.rrand(100).midicps } ! b.numFrames
	);
	// a delay is necessary here otherwise getting error.
	0.1.wait;
	b.getn(0, b.numFrames, {|x| x.postln });
	c = Buffer.alloc(s, 24, 1);
	0.1.wait;
	c.setn(0, { [1, 0.5, 0.25].choose } ! c.numFrames);
	0.1.wait;
	c.getn(0, c.numFrames, {|x| x.postln });
	0.1.wait;

	{
		var indexPattern;
		indexPattern = Dseq([Dseq([0, 3, 5, 0, 3, 7, 0, 5, 9], 3), Dbrown(0, 23, 1, 25)], inf);
		SinOsc.ar(
			Duty.kr(
				Dbufrd(c, Dseries(0, 1, inf)) * 0.25, // durations
				0,
				Dbufrd(b, indexPattern) // frequencies
			)
		) * 0.1
	} +> \demand;
}.fork;
//:Deconstructing the above. Duty as trigger timer.

{
	var indexPattern;
	indexPattern = Dseq([Dseq([0, 3, 5, 0, 3, 7, 0, 5, 9], 3), Dbrown(0, 23, 1, 25)], inf);
	Decay.kr(
		Changed.kr(
			Duty.kr(
				Dseq([0.1, 0.1, 0.2, 0.4], inf), // durations
				0,
				Dseq((0..1), inf) // trigger
			)
		)
	) * WhiteNoise.ar(0.1)
} +> \demand;

//:free buffers

b.free; c.free;