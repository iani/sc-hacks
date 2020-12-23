// =====================================================================
// SuperCollider Workspace
// =====================================================================


Quarks.install("FoxDot");
FoxDot.start;
1 + 1;
//;
1000.rand;
//:
(1..10) collect: { 10.rand };
//:
Synth(\default);
//:
(degree: 0).play;
//:
var degrees;
degrees = (1..10) collect: { 10.rand };
(degree: degrees.pseq) +> \something;
//:
(dur: 0.5) +> \something;
//:
(dur: 0.15) +> \something;
//:
(amp: [0.1, 0.2].pseq) +> \something;
//:
(legato: 0.5) +> \something;
//:
(amp: [0.01, 0.1].pseq) +> \something;
//:
(amp: [0.01, 0.1, 0.05].pseq) +> \something;
//:
(degree: [-10, -5].pseq, dur: 0.3, amp: 0.01) +> \second;
//:
{ WhiteNoise.ar(0.01) } +> \noise1;
//:
{ WhiteNoise.ar(0.01) * Env.perc.kr } +> \noise1;
//:
{ WhiteNoise.ar(0.01) *
	Env.perc.kr(gate: Impulse.kr(3))
	* LFNoise0.kr(5).range(0.1, 0.5)
} +> \noise1;

//: Buffer
var buffer;
buffer = (1..100) collect: { 0.rrand(1.0) };
buffer.plot;
//:
Hacks.loadAudioFiles;
//:
Registry.at(\buffers).keys.asArray.first.b.play;
//:+
Registry.at(\buffers).keys.asArray do: { | name |
	name.b.postln.play;
	0.5.wait;
};
//:
{ SinOsc.ar(400 * [1, 1.5], 0, 0.1) } +> \sine;
//:
{ SinOsc.ar(400, 0, 0.1).stereo } +> \sine;
//:*
{ SinOsc.ar(\freq.kr(400), 0, 0.1).stereo } +> \sine;
0.1.wait;
\freq <+ 400.rrand(1000);


//:*
{ SinOsc.ar(\freq.kr(400), 0, 0.1).stereo } +> \sine;
0.25.wait;
\freq <+ 60.rrand(70).midicps;
//:*
var melody;
melody = [40, 60, 50, 70];
{ SinOsc.ar(\freq.kr(400), 0, 0.1).stereo } +> \sine;
melody do: { | tone |
	0.25.wait;
	\freq <+ tone.midicps
};





//:*
var melody;
melody = [60, 65, 50, 55].scramble.postln + 10.rand;
{ SinOsc.ar(\freq.kr(400), 0, 0.1).stereo } +> \sine;
4 do: {
	melody do: { | tone |
	0.15.wait;
	\freq <+ tone.midicps
	};
}
//:*
var melody;
melody = [60, 65, 50, 55].scramble.postln + 10.rand;
{ LFSaw.ar(\freq.kr(400), 0, 0.1).stereo } +> \sine;
4 do: {
	melody do: { | tone |
	0.15.wait;
	\freq <+ tone.midicps
	};
}
//:*
var melody;
melody = [60, 65, 50, 55].scramble.postln + 10.rand;
{
	Ringz.ar(
		WhiteNoise.ar(0.01),
		\freq.kr(400),
		LFNoise1.kr(0.5).range(0.05, 2)
	).stereob
 } +> \sine;
4 do: {
	melody do: { | tone |
	[0.15, 0.3].choose.wait;
	\freq <+ tone.midicps
	};
}
//:*
var allBuffers, buffers;
allBuffers = Registry.at(\buffers).keys.asArray;

buffers = allBuffers.select({ | key |
	"arp".asString.matchRegexp(key.asString)
});

buffers = buffers addAll: allBuffers[..7];
buffers.scramble do: { | buffer |
	buffer.b.play;
	[0.1, 0.2, 0.4, 0.8].choose.wait;
};
//:
