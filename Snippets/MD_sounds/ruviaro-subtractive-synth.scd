// ************************************
// Subtractive Synthesis Demo (QuNeo)
// Patch 1 - Filtered Noise
// Bruno Ruviaro, 2013-07-26
// ************************************

/*

Pads play "notes" made of filtered white noise.
(midinote becomes center frequency of a BPF).

Long Slider controls filter's bandwidth ('Q').

Vertical Sliders control ADSR envelope.

*/
//:


var padsArray, rqBus, ampAdjustmentBus, att = 0.01, dec = 0.3, sus = 1, rel = 1, quneoChannel;

quneoChannel = 11;
padsArray = Array.newClear(64);
rqBus = Bus.control(s, 1).set(0.001);
ampAdjustmentBus = Bus.control(s, 1).set(20);

// MIDIIn.connectAll;

MIDIdef.freeAll;

~toQuNeo = MIDIOut.newByName("QUNEO-QUNEO MIDI 1", "QUNEO-QUNEO MIDI 1");

MIDIdef.noteOn(
	key: \noteOn,
	func: {arg vel, note;
		var padNumber = note - 36; // starting from 0
		var padNote = padNumber + 60; // middle C for first pad
		padsArray[padNumber] = Synth("noise-quneo", [
			\freq, padNote.midicps,
			\amp, vel/127,
			\rq, rqBus.asMap,
			\ampAdjust, ampAdjustmentBus.asMap,
			\att, att,
			\dec, dec,
			\sus, sus,
			\rel, rel;
		])},
	noteNum: (36..99),
	chan: quneoChannel);

MIDIdef.noteOff(
	key: \noteOff,
	func: {arg vel, note;
		var padNumber = note - 36;
		padsArray[padNumber].release},
	chan: quneoChannel);

MIDIdef.cc(
	key: \adsr,
	func: {arg val, ccnum;
		case
		{ccnum==6} {att = val.linlin(0, 127, 0.01, 4)}
		{ccnum==7} {dec = val.linlin(0, 127, 0.05, 2)}
		{ccnum==8} {sus = val.linlin(0, 127, 0.10, 1)}
		{ccnum==9} {rel = val.linlin(0, 127, 0.05, 4)};
		[att, dec, sus, rel].round(0.01).postln},
	ccNum: (6..9),
	chan: quneoChannel); // Vertical Sliders
~toQuNeo.control(0, 1, 0.3.linlin(0.01, 4, 0, 127));
~toQuNeo.control(0, 2, 0.3.linlin(0.05, 2, 0, 127));
~toQuNeo.control(0, 3, 1.linlin(0.1, 1, 0, 127));
~toQuNeo.control(0, 4, 1.linlin(0.05, 4, 0, 127));

MIDIdef.cc(
	key: \rqslider,
	func: {arg val, ccnum;
		var newVal = val.linexp(0, 127, 0.0001, 0.2);
		rqBus.value = newVal;
		ampAdjustmentBus.value = val.linexp(0, 127, 100, 1);
		("RQ is "++newVal.round(0.0001)).postln},
	ccNum: 10, // Long Slider
	chan: quneoChannel);

~toQuNeo.control(0, 6, 1); // init Long Slider
//:
SynthDef("noise-quneo", {arg freq = 1000, amp = 0.1, rq = 0.001, att = 0.01, dec = 0.3, sus = 1, rel = 1, gate = 1, ampAdjust = 1;
	var snd, env;
	env = EnvGen.kr(Env.adsr(att, dec, sus, rel), gate: gate, doneAction: 2);
	snd = BPF.ar(WhiteNoise.ar(amp), freq, Lag.kr(rq, 1));
	snd = snd * env * Lag.kr(ampAdjust, 1);
	Out.ar(0, [snd, snd]);
}).add;

 // end of block