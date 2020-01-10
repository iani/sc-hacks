//: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ======== RECORD ======== !!!!
Time().reset.gui;
"asayojun201005c".record(60 * 5);
//: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//: ================================================================ JUN 1
Pbuf2({ // start jun - prologue on p1
	~startpos = 809;
	~buffer = \prologue;
	~rate = 0.25; // 2 octaves lower
}, \p1);
// ====================== add brick wall fx1
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.0000001, 0.5));
}, true) +> \fx1;
// ================ connect fx1 thresh to x1
{ \x1.kr(0).linexp(0.0000001, 0.295) } @@>.fx1 \thresh; // brickwall jun
// ================ connect fx1 pan to y1
{ \y1.kr(0).urange(-1, 1) } @@>.fx1 \pos; // pan pos jun
//: ================================================================ JUN 2
Pbuf2({ // start jun - prologue on p3
	~startpos = 0;
	~buffer = \prologue;
	~rate = 0.5; // 1 octave lower
}, \p3);
// ====================== add brick wall fx3
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.0000001, 0.5));
}, true) +> \fx3;
// ================ connect fx3 thresh to x3
{ \x3.kr(0).linexp(0.0000001, 0.295) } @@>.fx3 \thresh; // brickwall jun
// ================ connect fx3 pan to y3
{ \y3.kr(0).urange(-1, 1) } @@>.fx3 \pos; // pan pos jun
//: ================================================================ ASAYO 1
Pbuf2({ // start asayo - lamento on p2
	~startpos = -10;
	~buffer = \lamentodellaninfa; // \prologue???????
	//	~buffer = \prologue;  /// ???????
	~rate = 1;
}, \p2, { | in | Resonz.ar(in * 5, \freq.kr(500), 0.1)});
// ====================== add magabove fx2
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.000001, 0.5));
}, true,
	// { | in | LPF.ar(in, 3000) }
	// { | in | Ringz.ar(in * 0.1, LFDNoise1.kr(5).range(100, 2000), 0.01) }
) +> \fx2;
// ================ connect fx1 thresh to x1
{ \x2.kr(0).linexp(0.01, 15.0) } @@>.fx2 \thresh; // magbelow asayo
{ \y2.kr(0).urange(-1, 1) } @@>.fx2 \pos; // pan pos asayo
{ \z2.kr(0).linexp(100, 10000) } @@>.fx2 \freq; // pan pos asayo

//: ================================================================ ASAYO 2
Pbuf2({ // start asayo - lamento on p4
	~startpos = -10;
	~buffer = \lamentodellaninfa; // \prologue???????
	//	~buffer = \prologue;  /// ???????
	~rate = 1;
}, \p4, { | in | Resonz.ar(in * 5, \freq.kr(500), 0.1)});
// ====================== add magabove fx2
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.000001, 0.5));
}, true,
	// { | in | LPF.ar(in, 3000) }
	// { | in | Ringz.ar(in * 0.1, LFDNoise1.kr(5).range(100, 2000), 0.01) }
) +> \fx4;
// ================ connect fx1 thresh to x1
{ \x4.kr(0).linexp(0.01, 15.0) } @@>.fx4 \thresh; // magbelow asayo
{ \y4.kr(0).urange(-1, 1) } @@>.fx4 \pos; // pan pos asayo
{ \z4.kr(0).linexp(100, 10000) } @@>.fx4 \freq; // pan pos asayo

//: =============== ASAYO 1b: PV_LocalMax, fx2
PV({ | c |
	PV_LocalMax(c, \thresh.kr(0.000001, 0.5));
}, true,
) +> \fx2;
// ================ connect fx1 thresh to x1
{ \x2.kr(0).linexp(1, 15.0) } @@>.fx2 \thresh; // brickwall asayo
{ \y2.kr(0).urange(-1, 1) } @@>.fx2 \pos; // pan pos asayo

//;================ OLDER STUFF ================

//: ====================== add brick wall fx2
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.000001, 0.5));
}, true,
	// { | in | LPF.ar(in, 3000) }
	// { | in | Ringz.ar(in * 0.1, LFDNoise1.kr(5).range(100, 2000), 0.01) }
) +> \fx2;
// ================ connect fx1 thresh to x1
{ \x2.kr(0).linexp(0.000001, 0.935515975) } @@>.fx2 \thresh; // brickwall asayo
//: ====================== add magabove fx2
PV({ | c |
	PV_MagAbove(c, \thresh.kr(0.000001, 0.5));
}, true,
	// { | in | LPF.ar(in, 3000) }
	// { | in | Ringz.ar(in * 0.1, LFDNoise1.kr(5).range(100, 2000), 0.01) }
) +> \fx2;
// ================ connect fx1 thresh to x1
{ \x2.kr(0).linexp(1, 15.0) } @@>.fx2 \thresh; // brickwall asayo
{ \y2.kr(0).urange(-1, 1) } @@>.fx2 \pos; // pan pos asayo
//:================ use grains for asayo
{
	GrainBuf.ar(1,
		Impulse.kr(\ppm.kr(2)),
		\dur.kr(1),
		\lamentodellaninfa.b,
		\rate.kr(1),
		\pos.kr(0.519) * BufSampleRate.kr(\lamentodellaninfa.b)
	)
} +> \p2;
//:
\pos <+.p2 29.05;
\dur <+.p2 1.3;
\ppm <+.p2 10;
//:testing triggering through changed
{ PinkNoise.ar(\onoff.kr(1) * \amp.kr(0.01)).stereo } +> \changedstuff;
//:alternative sound for triggering
Pbuf2({ // start asayo - lamento on p2
	~startpos = -10;
	~buffer = \lamentodellaninfa; // \prologue???????
	~rate = 1;
}, \changedstuff, { | in | in.stereo });
//:
{ Decay2.kr(Changed.kr(\z1.kr(1), 0.1), 2) } @@>.changedstuff \level;

// { Amplitude.kr(Changed.kr(\z1.kr(1), 0.1)) } @@>.changedstuff \level;
//:
\changedstuff.controls;
//:
\amp <+.changedstuff 0.1;

// ================================================================ older stuff
//:listen to fx (not src)
//:start timer with gui
Time().gui;
//:start source playback
// Pbuf2({ ~startpos = 809; ~buffer = \lamentodellaninfa }, \p1);
{
	GrainBuf.ar(1,
		Impulse.kr(\ppm.kr(5)),
		\dur.kr(0.2),
		\prologue.b,
		\rate.kr(1),
		\pos.kr(0.5)
	)
} +> \p1;
//:
{
	GrainBuf.ar(1,
		Impulse.kr(\ppm.kr(5)),
		\dur.kr(0.2),
		\lamentodellaninfa.b,
		\rate.kr(1),
		\pos.kr(0.5)
	)
} +> \p2;
//:
\p2 *> \fx2;
//:
\srcvol <+.fx2 1;
\fxvol <+.fx2 1;

//:add brick wall fx1 + fx2
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx2;
//:connect input control busses to fx parameters
//: X1 JUN
\x1 @>.fx1_thresh \x1;
{ \x1.kr(0).linexp(0.0000001, 0.4129515975) } @>.fx1 \thresh; // BRICKWALL
\y1 @>.p1_rate \y1; // GOOD SETTING FOR GRAINS
{ \y1.kr(0).linexp(0.25, 2) } @>.p1 \rate; // GRAIN RATE
\z1 @>.p1_pos \z1;
{ \z1.kr(0).urange(0.00, 0.99) } @>.p1 \pos; // POS IN BUFFER
//: X2 ASAYO
\x2 @>.fx2_thresh \x2;
{ \x2.kr(0).linexp(0.0000001, 0.4129515975) } @>.fx2 \thresh; // BRICKWALL
\y2 @>.p1_rate \y2; // GOOD SETTING FOR GRAINS
{ \y2.kr(0).linexp(0.25, 1.2) } @>.p2 \rate; // GRAIN RATE
\z2 @>.p1_pos \z2;
{ \z2.kr(0).urange(0.00, 0.99) } @>.p2 \pos; // POS IN BUFFER
//:change mapping range to fit MagBelow linexp 0.01, 7 is good
// { \x1.kr(0).linexp(0.01, 25) } @>.fx2 \thresh; // MAGBELOW
\ppm <+.p1 10;
\dur <+.p1 2.5;

\p1.stop;
//:
Hacks.loadAudioFiles;
//:
currentEnvironment.name;
currentEnvironment.target;
//:test shortcut for mapping kr funcs to sensors: 
{ \z2.kr(0).urange(0.00, 0.99) } @@>.p2 \pos;

//:
/*
	@> { | param, envir |
		// map bus named by me to param in envir
		^(envir ?? { envir.e }).map(param, this);
	}
*/
//:
\fx1.controls
//:
\fx3.stop;