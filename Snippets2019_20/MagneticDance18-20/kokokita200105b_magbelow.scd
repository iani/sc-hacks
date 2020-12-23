//:sound check
\default +> \check;
//:setup sensors
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\x1, 1, 0.47, 0.53, 1],
	[\y1, 2, 0.47, 0.53, 1],
	[\z1, 3, 0.47, 0.53, 1],
	[\x2, 1, 0.47, 0.53, 2],
	[\y2, 2, 0.47, 0.53, 2],
	[\z2, 3, 0.47, 0.53, 2],
	[\x3, 1, 0.47, 0.53, 3],
	[\y3, 2, 0.47, 0.53, 3],
	[\z3, 3, 0.47, 0.53, 3],
	[\x4, 1, 0.47, 0.53, 4],
	[\y4, 2, 0.47, 0.53, 4],
	[\z4, 3, 0.47, 0.53, 4]
);
//:================ fx volume controls
\volumes.v(
	\srcvol.slider([0, 10], \fx1, "fx1 src"),
	\fxvol.slider([0, 10], \fx1, "fx1 fx"),
	\thresh.slider([0.00001, 10, \exp], \fx1, "fx1 thresh"),
	\srcvol.slider([0, 10], \fx2, "fx2 src"),
	\fxvol.slider([0, 10], \fx2, "fx2 fx"),
	\thresh.slider([0.00001, 10, \exp], \fx2, "fx2 thresh"),
);
//:================ initialize fx config
\p1 *> \fx1; // player - fx setup
\p2 *> \fx2;
\srcvol <+.fx1 0; // listen to fx - not source
\fxvol <+.fx1  2;
\srcvol <+.fx2 0;
\fxvol <+.fx2  2; // jun needs larger amplitude

//: ================================================================ JUN
Pbuf2({ // start jun - prologue on p1
	~startpos = 809;
	~buffer = \prologue;
	~rate = 0.25; // 2 octaves lower
}, \p1);
// ====================== add brick wall fx1
PV({ | c |
	PV_MagBelow(c, \thresh.kr(10, 0.5));
}, true) +> \fx1;
// ================ connect fx1 thresh to x1
{ \x1.kr(0).linexp(0.0000001, 10) } @@>.fx1 \thresh; // brickwall jun

//: ================================================================ ASAYO
Pbuf2({ // start asayo - lamento on p2
	~startpos = -10;
	~buffer = \lamentodellaninfa;
	~rate = 1;
}, \p2);
// ====================== add brick wall fx2
PV({ | c |
	PV_MagBelow(c, \thresh.kr(10, 0.5));
}, true) +> \fx2;
// ================ connect fx1 thresh to x1
{ \x1.kr(0).linexp(0.000001, 10) } @@>.fx1 \thresh; // brickwall asayo


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
hhjjulllll\fxvol <+.fx2 1;

//:add brick wall fx1 + fx2
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.1, 0.5));
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
		^(envir ?? { envir.ev }).map(param, this);
	}
*/