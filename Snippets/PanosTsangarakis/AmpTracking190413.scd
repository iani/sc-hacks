//: panos tsagkarakis
//:Original synthdef - before correction
SynthDef(\threshTest, {
	arg thresh=(-80.0)  ;
	var sig, amp, trig;
	sig = SoundIn.ar(0);
	amp = Amplitude.kr(sig).ampdb;
	amp = K2A.ar(amp);
	trig = amp >= thresh;
	SendReply.ar(Impulse.ar(50), 'trigVal', [trig]);   }).add;

//:first test

a = Synth(\threshTest);

a.set(\threshTest, -10);
o = OSCFunc({ |msg| msg.postln }, '/trigVal');
//:corrected synthdef

SynthDef(\threshTest, {
	arg thresh=(-80.0);
	var sig, amp, trig;
	sig = SoundIn.ar(0);
	amp = Amplitude.kr(sig).ampdb;
	amp = K2A.ar(amp);
	trig = amp >= thresh;
	SendReply.ar(
		Impulse.ar(50),
		'/trigVal',
		//	[trig]
		[amp, amp >= thresh]
	);
	SendReply.ar(
		// Impulse.ar(50),
		amp >= thresh,
		'/realTrig',
		//	[trig]
		[amp]
	);
}).add;

//:test with corrected synthdef
a = Synth(\threshTest);
a.set(\thresh, -10);

a.set(\thresh, -20);

o = OSCFunc({ |msg| msg.postln }, '/trigVal');
p = OSCFunc({ |msg|
	"!!!!!!!!!!!!!!!! TRIGGER RECEIVED !!!!!!!!!!!!!!!!".postln;
	msg.postln }, '/realTrig');
