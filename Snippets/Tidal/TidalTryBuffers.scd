// 25 Dec 2018 04:58
//:start
SuperDirt.start;
//:register all loaded SuperDirt single channel buffers;
~dirt.buffers keysValuesDo: { | name, bufs |
	if (bufs[0].numChannels == 1) {
		Registry(\buffers, name, { bufs[0] });
		bufs do: { | buf, i |
			Registry(\buffers, format("%%", name, i).asSymbol, { buf });
		}
	}
};
//:see one buffer
\baa2.b;
//:play one buffer
\baa2.b.play;
//:play in player one shot.
{ | b = 0 |
	b = \short.b;
	// b.numChannels.postln;
	PlayBuf.ar(b.numChannels, b);
} +> \playbuf;
//:variable channel number synthdef???
SynthDef("buf", { | b = 0, dur = 1, gate = 1 |
	var source, env;
	env = Env.adsr(sustainLevel: 1, releaseTime: 0.1);
	source = PlayBuf.ar(1, b, \rate.kr(1)) * EnvGen.kr(env, gate, doneAction: 2);
	Out.ar(0, source);
})
//:trigger at integer subdivisions of a cycle
{
	var trig;
	trig = Impulse.ar(2, 0, 0.5);
	Decay.ar(trig);
} +> \test;
//:trigger at integer subdivisions of a cycle
{
	var cycle, trig;
	cycle = LFSaw.ar(1).range(0, 2);
	// trig = Impulse.ar(2, 0, 0.5);
	// Decay.ar(trig);
	// [cycle, Decay.ar(1 - ((cycle % 1) > 0.1))];
	// [cycle, Decay.ar(cycle % 1 < 0.01)];
	[cycle, 1 - (cycle % 1.0 > 0.1)];
} +> \test;
//:quant test 1
\quant <+.test 1;
() +> \test;
//:quant test 2
\quant <+.test2 1;
(dur: 0.5, degree: [2, 3].pseq) +> \test2;
//: quant test 3
\quant <+.test3 1;
(dur: 1 / 3, degree: [-3, -5, -2].pseq) +> \test3;
//: quant test 4
\quant <+.test4 1;
(dur: 1 / 4, degree: (2 * (4 .. 4 + 3)).pseq) +> \test4;
//: quant test 5
\quant <+.test5 1;
(dur: 1 / 5, degree: (10 .. 10 + 4).pseq) +> \test5;
//: Tempo 2
TempoClock.default.tempo = 0.2;
//:Was incorporated in play method:
\quant <+.test2 1;
// is now part of PatternPlayer:play method:
TempoClock.default.schedAbs(
	TempoClock.default.beats.ceil - 0.00001, {
		(dur: 0.5, degree: [20, 3].pseq) +> \test2;
	}
);
//:repeating trigger tests
{
	var trig;
	trig = Impulse.kr(5);
	WhiteNoise.ar(Decay.kr(trig));
} +> \trigtest;
//:repeating trigger tests kr
{
	var ramp, trig;
	ramp = LFSaw.kr(1).range(0, 2);
	trig = 1 - (ramp % 1 > 0.1);
	WhiteNoise.ar(Decay.kr(trig));
} +> \trigtest;
//:SuperDirt start and process buffers
// Note: Server gets stuck when repeating
// Redoing sample loading below.
SuperDirt.start;
Server.default.waitForBoot({
	var bufname;
	"booted".postln;
	~dirt.buffers.keysValuesDo({ | name, buffers |
		Registry(\buffers, name, { buffers[0] });
		Registry(\tidalbuffers, name, {
			[buffers[0],
				if (buffers[0].numChannels == 1) {
					'buf1'
				}{
					'buf2'
				}
			]});
		buffers do: { | b, i |
			bufname = format("%%", name, i).asSymbol;
			Registry(\buffers, bufname, { b });
			Registry(\tidalbuffers, bufname, {
			[b,
				if (b.numChannels == 1) {
					'buf1'
				}{
					'buf2'
				}
			]})
		}
	});
})
//:SuperDirt loadbuffers only
Server.default.options.numBuffers = 1024 * 16;
Server.default.waitForBoot({
	var bufname;
	SuperDirt.new.loadSoundFiles.buffers.keysValuesDo({ | name, buffers |
		Registry(\buffers, name, { buffers[0] });
		Registry(\tidalbuffers, name, {
			[buffers[0],
				if (buffers[0].numChannels == 1) {
					'buf1'
				}{
					'buf2'
				}
			]});
		buffers do: { | b, i |
			bufname = format("%%", name, i).asSymbol;
			Registry(\buffers, bufname, { b });
			Registry(\tidalbuffers, bufname, {
			[b,
				if (b.numChannels == 1) {
					'buf1'
				}{
					'buf2'
				}
			]})
		}
	});
});
//:test registry after buffer load
Registry.at(\tidalbuffers, \stab4);
//:test buffer after buffer load
\stab4.b;
//:buf1 sythdef
SynthDef(\buf1, { | buf = 0, rate = 1, amp = 1.0, gate = 1 |
	// mono buffer, stereo output
	var src; // , env;
	src = PlayBuf.ar(1, buf, rate, 1, 0, 0, 0);
	// env = Env.asr(); // Env([1, 1, 0], [1, 0.1], \sine, 1);
	// env = Env([1, 1, 0], [1, 0.1], \sine, 1);
	Out.ar(0, (src * Linen.kr(gate, 0.001, amp, 0.01, 2)).dup);
}).add
//:buf2 sythdef
SynthDef(\buf2, { | buf = 0, rate = 1, amp = 1.0, gate = 1 |
	// stereo buffer, stereo output
	var src; // , env;
	src = PlayBuf.ar(2, buf, rate, 1, 0, 0, 0);
	// env = Env.asr(); // Env([1, 1, 0], [1, 0.1], \sine, 1);
	// env = Env([1, 1, 0], [1, 0.1], \sine, 1);
	Out.ar(0, (src * Linen.kr(gate, 0.001, amp, 0.01, 2)).dup);
}).add
//:test buf1 synthdef
(buf: \stab4.b, instrument: \buf1, rate: [0.5, 1.9].pwhite,
dur: [0.05, 0.15, 0.01].pbrown, amp: [0.2, 0.07, 0.05].pseq) +> \test;
//:find stereo buffernames 
Registry.at(\tidalbuffers).select ({ | b | b[1] === \buf2}).keys;
//:test buf2 synthdef
(buf: [\birds.b, \tabla.b, \alphabet.b].pseq, instrument: \buf2, rate: [0.15, 2.9].pwhite,
dur: 0.15, amp: [0.02, 0.007, 0.005].pseq) +> \test;
//:server kill all
Server.killAll;
//:test env
SynthDef(\env, { | amp = 1.0, gate = 1 |
	var src, env;
	src = WhiteNoise.ar;
	// env = Env.asr(); // Env([1, 1, 0], [1, 0.1], \sine, 1);
	env = Env.adsr; // Env([1, 1, 0], [1, 0.1], \sine, 1);
	Out.ar(0, src * Linen.kr(gate, 0.01, 0.7, 0.3, 2));
}).add;
//:test env pat
(instrument: \env, dur: 1.5, amp: 1) +> \testenv;
//:prepare string +> \pattern.
var string, bufs, instruments;
string = "hh stab4 birds stab4 birds hh4";
#bufs, instruments = string.split($ ).collect { | name |
	Registry.at(\tidalbuffers)[name.asSymbol];
}.flop;
(instrument: instruments.pseq, buf: bufs.pseq, dur: 1.5 / instruments.size, rate: 1.63) +> \test1;
//:test string +> \player
"hh stab4 birds stab4 birds hh4" +> \testenv;
//:test string +> \player
"hh4 hh4 hh4" +> \testenv;
//:test string +> \player
"hh hh hh" +> \testenv;
//:test string +> \player
"hh hh" +> \testenv2;
//:test string +> \player
"hh hh hh hh hh" +> \testenv5;
//:test string +> \player
"hh1" +> \testenv0;
//:test string +> \player
"arpy" +> \testenv0;
//:test string +> \player
"hh2 hh2" +> \testenv2;
//:Change tempo
TempoClock.default.tempo = 2;
//:Change tempo
TempoClock.default.tempo = 0.2;
//:long pattern
"bd sd hh cp mt arpy drum odx bd arpy bass2 feel future" +> \longpat;
//:set tempo back to 1
TempoClock.default.tempo = 1;
//:stop testenv5
\testenv5.stop;
//:stop testen
\testenv.stop;
//:stop testenv2
\testenv2.stop;
//:bufffer list gui?
\buffers1.bl_(height: 500).window.v(ListView());
//:bufffer list gui?
\buffers1.bl_(height: 500).window.v(ListView());
//:
BufferGUI();
//:
Registry.at(\buffers);
//:
\808.b;