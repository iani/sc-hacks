//:Stuff to develop in addition to last rehearsal's results
//Granulate source
//:
{
	GrainBuf.ar(1,
		Impulse.kr(\ppm.kr(5)),
		\dur.kr(0.2),
		\lamentodellaninfa.b,
		\rate.kr(1),
		\pos.kr(0.5)
	)
} +> \p1;
//:
{
	GrainBuf.ar(1,
		Impulse.kr(\ppm.kr(5)),
		\dur.kr(0.2),
		\prologue.b,
		// LFDNoise3.kr(0.5).range(0.7, 1.2), // rate
		\rate.kr(1),
		// LFDNoise3.kr(0.2).range(0.0, 0.99) // pos
		\pos.kr(0.5)
	)
} +> \p1;
//:
{
	GrainBuf.ar(1,
		Impulse.kr(\ppm.kr(5)),
		\dur.kr(0.2),
		\lamentodellaninfa.b,
		// LFDNoise3.kr(0.5).range(0.7, 1.2), // rate
		\rate.kr(1),
		// LFDNoise3.kr(0.2).range(0.0, 0.99) // pos
		\pos.kr(0.5)
		//	LFSaw.kr(0.01)
	)
} +> \p1;
//:
\y1 @>.p1_ppm \y1;
{ \y1.kr(0).linexp(0.5, 15) } @>.p1 \ppm; // BRICKWALL
//: this is good
\y1 @>.p1_rate \y1;
{ \y1.kr(0).linexp(0.25, 2) } @>.p1 \rate; // BRICKWALL
//:
\z1 @>.p1_dur \z1;
{ \z1.kr(0).urange(0.05, 2.5) } @>.p1 \dur; // BRICKWALL
//: this iis good
\z1 @>.p1_pos \z1;
{ \z1.kr(0).urange(0.00, 0.99) } @>.p1 \pos; // BRICKWALL
//:
\x2 @>.p1_rate \x2;
{ \x2.kr(0).urange(0.05, 1.05) } @>.p1 \rate; // BRICKWALL
//:
\y2 @>.p1_pos \y2;
{ \y2.kr(0).urange(0.0, 0.99) } @>.p1 \pos; // BRICKWALL
//:
\pos <+.p1 0.251;
//:
\dur <+.p1 1.3;

//:
//: ================================================================
// REJECTED: NO RATE CHANGE POSSIBILITY
//  GrainIn.ar(numChannels: 1, trigger: 0, dur: 1, in, pan: 0,
//  envbufnum: -1, maxGrains: 512, mul: 1, add: 0)
{
	GrainIn.ar(
		2,
		Impulse.kr(\ppm.kr(5)),
		\dur.kr(1),
		Inp.ar(),
	)
} +> \fx1;
//:
\ppm <+ 2.5;
//:
\fxvol <+.fx2 0;
//:
{
	WhiteNoise.ar(Decay2.kr(Impulse.kr(1))).stereo * 0.1
} +> \stereocheck;
//:
\pos <+ -1;