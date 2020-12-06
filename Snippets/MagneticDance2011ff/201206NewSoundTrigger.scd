//:  6 Dec 2020 16:11
/* trying out new sounds sent by AG

*/
//:boot and load sounds
Server.default.waitForBoot({
	(Platform.resourceDir +/+ "sounds/").loadBuffers;
});
//:list sounds for reference
Buffer.allNames.sort.asCompileString;
//:+
Buffer.allNames.sort do: { | name |
	postf("now playing buffer named: %\n", name);
	name.b.play;
	5.wait;
};

//:+
Buffer.allNames.sort do: { | name |
	var synth;
	postf("now playing buffer named: %\n", name);
	synth = name.b.play;
	5.wait;
	synth.free;
};
//:
'AkaPygmy_07_flute'.b.play;
//:
'SomeiSatoh_1'.b.play;
//:
'NewSeeds_01'.b.play;
//:Try triggering, with new sound buffers
{ | thresh = 0.1, muteThresh = 0.01 |
	var b, c, e, f;
	b = 'AkaPygmy_07_flute'.b;
	c = 'Nyuyo_1'.b;
	e = 'AkaPygmy_07_flute'.b;
	f = 'NewSeeds_01'.b;
	PlayBuf.ar(c.numChannels, c.bufnum,
		Y(1).range(-1.5, 1.5),
		X(1) > thresh,
		Z(1).range(0, 2) * BufSampleRate.kr(c.bufnum),
		1.0
	).dup * 1 * X(1).exprange(0.01, 1)
	/*	+ 	PlayBuf.ar(d.numChannels, d.bufnum,
		Y(1).range(-1.5, 1.5),
		X(1) > thresh,
		Z(1).range(0, 2) * BufSampleRate.kr(d.bufnum),
		1.0
	).dup * 1 * X(1).exprange(0.01, 1)
	*/
	+	PlayBuf.ar(e.numChannels, e.bufnum,
		Y(1).range(-1.5, 1.5),
		X(1) > (thresh + 0.1),
		Z(1).range(0, 2) * BufSampleRate.kr(e.bufnum),
		1.0
		).dup * 1 * X(1).exprange(0.01, 1)
	+	PlayBuf.ar(f.numChannels, f.bufnum,
		Y(1).range(-1.5, 1.5),
		X(1) > (thresh + 0.2),
		Z(1).range(0, 2) * BufSampleRate.kr(f.bufnum),
		1.0
	).dup // * 1 * X(1).exprange(0.01, 1); // (X(1) > muteThresh);
} +> \p1;
//:As above, but stop after each trigger
{ | thresh = 0.1, muteThresh = 0.01 |
	var b, c, e, f;
	b = 'AkaPygmy_07_flute'.b;
	c = 'Nyuyo_1'.b;
	e = 'AkaPygmy_07_flute'.b;
	f = 'NewSeeds_01'.b;
	(PlayBuf.ar(c.numChannels, c.bufnum,
		Y(1).range(-1.5, 1.5),
		X(1) > thresh,
		Z(1).range(0, 2) * BufSampleRate.kr(c.bufnum),
		1.0
	).dup * Env.perc(releaseTime: 3).kr(
		gate: X(1) > thresh
	)) // * 1 * X(1).exprange(0.01, 1)
	/*	+ 	PlayBuf.ar(d.numChannels, d.bufnum,
		Y(1).range(-1.5, 1.5),
		X(1) > thresh,
		Z(1).range(0, 2) * BufSampleRate.kr(d.bufnum),
		1.0
	).dup * 1 * X(1).exprange(0.01, 1)
	*/
	+	(PlayBuf.ar(e.numChannels, e.bufnum,
		Y(1).range(-1.5, 1.5),
		X(1) > (thresh + 0.1),
		Z(1).range(0, 2) * BufSampleRate.kr(e.bufnum),
		1.0
	).dup * Env.perc(releaseTime: 3).kr(
		gate: X(1) > (thresh + 0.1)
	))//  1 * X(1).exprange(0.01, 1)
	+	(PlayBuf.ar(f.numChannels, f.bufnum,
		Y(1).range(-1.5, 1.5),
		X(1) > (thresh + 0.2),
		Z(1).range(0, 2) * BufSampleRate.kr(f.bufnum),
		1.0
	).dup * Env.perc(releaseTime: 3).kr(
		gate: X(1) > (thresh + 0.2)
	)) // * 1 * X(1).exprange(0.01, 1); // (X(1) > muteThresh);
} +> \p1;

//:As above, but no rate modulation
{ | thresh = 0.1, muteThresh = 0.01 |
	var b, c, e, f;
	b = 'AkaPygmy_07_flute'.b;
	c = 'Nyuyo_1'.b;
	e = 'AkaPygmy_07_flute'.b;
	f = 'NewSeeds_01'.b;
	(PlayBuf.ar(c.numChannels, c.bufnum,
		1, //		Y(1).range(-1.5, 1.5),
		X(1) > thresh,
		Z(1).range(0, 2) * BufSampleRate.kr(c.bufnum),
		1.0
	).dup * Env.perc(releaseTime: 3).kr(
		gate: X(1) > thresh
	)) // * 1 * X(1).exprange(0.01, 1)
	/*	+ 	PlayBuf.ar(d.numChannels, d.bufnum,
		Y(1).range(-1.5, 1.5),
		X(1) > thresh,
		Z(1).range(0, 2) * BufSampleRate.kr(d.bufnum),
		1.0
	).dup * 1 * X(1).exprange(0.01, 1)
	*/
	+	(PlayBuf.ar(e.numChannels, e.bufnum,
		1, // Y(1).range(-1.5, 1.5),
		X(1) > (thresh + 0.1),
		Z(1).range(0, 2) * BufSampleRate.kr(e.bufnum),
		1.0
	).dup * 5 * Env.perc(releaseTime: 3).kr(
		gate: X(1) > (thresh + 0.1)
	))//  1 * X(1).exprange(0.01, 1)
	+	(PlayBuf.ar(f.numChannels, f.bufnum,
		1, // Y(1).range(-1.5, 1.5),
		X(1) > (thresh + 0.2),
		Z(1).range(0, 2) * BufSampleRate.kr(f.bufnum),
		1.0
	).dup * 5 * Env.perc(releaseTime: 3).kr(
		gate: X(1) > (thresh + 0.2)
	)) // * 1 * X(1).exprange(0.01, 1); // (X(1) > muteThresh);
} +> \p1;

//:start data reception
SenseBus.mute.activate.scope;
//:
SenseServer.record;
//:
SenseServer.stopRecording;