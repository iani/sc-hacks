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
	PlayBuf.ar(b.numChannels, b.bufnum, \rate.kr(1),
		X(1) > thresh,
		\startPos.kr(0) * BufSampleRate.kr(b.bufnum)
	).dup * 5;
} +> \p1;
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

