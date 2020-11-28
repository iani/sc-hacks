//:28 Nov 2020 11:01
//:Load sounds and start busses
ServerBoot add: {
	(Platform.resourceDir +/+ "sounds/").loadBuffers;
	SenseBus.mute.activate.scope;
};
//:+Test sounds
Buffer.allNames.postln do: { | name |
	postf("now playing: %\, numChannels: %\n", name, name.b.numChannels);
	name.b.play;
	3.wait;
};
//:================================================================
//:Develop triggered playbuf test
//:Simple playbuf
{
	var b;
	b = \houston.b;
	PlayBuf.ar(b.numChannels, b.bufnum, \rate.kr(1), \trig.kr(0), \startPos.kr(0));
} +> \p1;
//:Trigger (works only once)
\trig <+.p1 1;
//:Prepare the above for triggering from SenseData, with threshold
{ | thresh = 0.1 |
	var b;
	b = \houston.b;
	PlayBuf.ar(b.numChannels, b.bufnum,
		Y(1).exprange(0.5, 1.5),
		X(1) > thresh,
		Z(1).range(0, 2) * BufSampleRate.kr(b.bufnum)
	).dup * 5;
} +> \p1;
//:Same as above, but with columbia buffer
{ | thresh = 0.1 |
	var b;
	b = \columbia.b;
	PlayBuf.ar(b.numChannels, b.bufnum,
		Y(2).exprange(0.5, 1.5),
		X(2) > thresh,
		Z(2).range(0, 2) * BufSampleRate.kr(b.bufnum)
	).dup * 5;
} +> \p2;
// ================================================================
//:Same pair as above, but mute with another threshold
//:Prepare the above for triggering from SenseData, with threshold
{ | thresh = 0.1, muteThresh = 0.01 |
	var b;
	b = \houston.b;
	PlayBuf.ar(b.numChannels, b.bufnum,
		Y(1).exprange(0.5, 1.5),
		X(1) > thresh,
		Z(1).range(0, 2) * BufSampleRate.kr(b.bufnum),
		1.0
	).dup * 1 * (X(1) > muteThresh);
} +> \p1;
//:Same as above, but with columbia buffer
{ | thresh = 0.1, muteThresh = 0.01 |
	var b;
	b = \columbia.b;
	PlayBuf.ar(b.numChannels, b.bufnum,
		Y(2).exprange(0.5, 1.5),
		X(2) > thresh,
		Z(2).range(0, 2) * BufSampleRate.kr(b.bufnum),
		1.0
	).dup * 1 * (X(2) > muteThresh);
} +> \p2;
// ================================================================
//:Same pair as above, but mirror X polarity
//:Prepare the above for triggering from SenseData, with threshold
{ | thresh = 0.1, muteThresh = 0.01 |
	var b;
	b = \houston.b;
	PlayBuf.ar(b.numChannels, b.bufnum,
		Y(1).exprange(0.5, 1.5),
		(-1 * X(1)) > thresh,
		Z(1).range(0, 2) * BufSampleRate.kr(b.bufnum),
		1.0
	).dup * 1 * ((X(1) * -1) > muteThresh);
} +> \p1;
//:Same as above, but with columbia buffer
{ | thresh = 0.1, muteThresh = 0.01 |
	var b;
	b = \columbia.b;
	PlayBuf.ar(b.numChannels, b.bufnum,
		Y(2).exprange(0.5, 1.5),
		(-1 * X(2)) > thresh,
		Z(2).range(0, 2) * BufSampleRate.kr(b.bufnum),
		1.0
	).dup * 1 * ((X(2) * -1) > muteThresh);
} +> \p2;

// ================================================================
//:Same pair as above, but with grainbuf
//:Prepare the above for triggering from SenseData, with threshold
{ | thresh = 0.1, muteThresh = 0.01 |
	var b, bufnum;
	b = \houston.b;
	bufnum = b.bufnum;
	GrainBuf.ar(b.numChannels,
		Impulse.kr(X(1).exprange(1, 10)), // trigger
		X(1).exprange(1, 10).reciprocal + 0.1,// dur
		bufnum, // sndbuf
		Y(1).exprange(0.5, 1.5), // Rate
		Z(1).range(0, 3), // pos
		Z(1).range(0, 2) * BufSampleRate.kr(bufnum),
		1.0
	).dup * 1 * (X(1) > muteThresh);
} +> \p1;
//:Same as above, but with columbia buffer
{ | thresh = 0.1, muteThresh = 0.01 |
	var b;
	b = \columbia.b;
	GrainBuf.ar(b.numChannels, b.bufnum,
		Y(2).exprange(0.5, 1.5),
		X(2) > thresh,
		Z(2).range(0, 2) * BufSampleRate.kr(b.bufnum),
		1.0
	).dup * 1 * (X(2) > muteThresh);
} +> \p2;

//================================================================
//:trigger manually
\x1 <@ 0;
//:
\x1 <@ 1;
//:change the rate
\rate <+.p1 0.7;
//:
\startPos <+.p1 0;
//:
\startPos <+.p1 1.5;
//:change the startPos
\startPos <+.p1 (2 * 41000);
//:Start busses and data
SenseBus.mute.activate.scope;
SensePlayer.read("/home/iani/.local/share/SuperCollider/MD/201117_153721.txt");
SensePlayer.play;
//:
