//:setup sensors
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\x1, 1, 0.47, 0.53, 1],
	[\y1, 2, 0.47, 0.53, 1],
	[\z1, 3, 0.47, 0.53, 1],
	[\x2, 1, 0.47, 0.53, 2], // using sensor module 3
	[\y2, 2, 0.47, 0.53, 2],
	[\z2, 3, 0.47, 0.53, 2],
	[\x3, 1, 0.47, 0.53, 3],
	[\y3, 2, 0.47, 0.53, 3],
	[\z3, 3, 0.47, 0.53, 3],
	[\x4, 1, 0.47, 0.53, 4], // using sensor module 3
	[\y4, 2, 0.47, 0.53, 4],
	[\z4, 3, 0.47, 0.53, 4]
);
//:player - fx setup
\p1 *> \fx1;
\p2 *> \fx2;
//:listen to fx (not src)
\srcvol <+.fx1 0;
\fxvol <+.fx1  2;
\srcvol <+.fx2 0;
\fxvol <+.fx2  2; // jun needs larger amplitude
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
