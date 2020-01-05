//:sound check
\default +> \soundcheck;
//;buffer check
\lamentodellaninfa.b.play;
//:buffer check with Pbuf2
Pbuf2({ ~startpos = 809; ~buffer = \prologue }, \p1);
Pbuf2({ ~startpos = 809; ~buffer = \lamentodellaninfa }, \p1);
Pbuf2({ ~startpos = 0; ~buffer = \lamentodellaninfa }, \p2);
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
//:Start playback on glissando
\p1 *> \fx1;
\p2 *> \fx2;
{ Inp.ar.stereo } +> \fx1;
Pbuf2({ ~startpos = 809; }, \p1);
//:add brick wall
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:Set threshold to 0 = no wall at all
\thresh <+.fx1 0;
//:listen to fx (not src)
\srcvol <+.fx1 0;
\fxvol <+.fx1  1;
\srcvol <+.fx2 0;
\fxvol <+.fx2  0;

//:open fx slightly
\thresh <+.fx1 0.01;
//:open fx more (max...)
\thresh <+.fx1 0.13;
//:map x1 to range 0 - 0.3 and connect to thresh on fx1 
{ \x1.kr(0).urange(0.0, 0.3) } @>.fx1 \thresh; //
//: alternative: linexp !!!!!!!
{ \x1.kr(0).linexp(0.01, 2.975) } @>.fx1 \thresh; //
//:connect x1 bus to x1 parameter on mapper synth
\x1 @>.fx1_thresh \x1;
//:more volume
\level <+.fx1 2;
// =============================================
// ================ PV_MagAbove ================ 
//:PV_Magabove
PV({ | c |
	PV_MagAbove(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:change mapping range to fit MagAbove
{ \x1.kr(0).urange(0.0, 7) } @>.fx1 \thresh; //
//:test range of thresh in magabove
\thresh <+.fx1 10;
//:test range of thresh in magabove
\thresh <+.fx1 0.1;
// =============================================
// ================ PV_MagBelow ================ 
//:PV_Magabove
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:change mapping range to fit MagBelow
{ \x1.kr(0).urange(0.01, 7) } @>.fx1 \thresh; //
// =============================================
// ================ PV_MagShift ================ 
//:PV_MagShift fx1
PV({ | c |
	PV_MagShift(c,
		\stretch.kr(0.1, 0.5),
		\shift.kr(0.1, 0.5)
	);
}, true) +> \fx1;
//:PV_MagShift fx2
PV({ | c |
	PV_MagShift(c,
		\stretch.kr(0.1, 0.5),
		\shift.kr(0.1, 0.5)
	);
}, true) +> \fx2;
//:connect control busses to fx parameters
\x1 @>.fx1_stretch \x1;
\y1 @>.fx1_shift \y1;
\x4 @>.fx2_stretch \x1;
\y4 @>.fx2_shift \y1;

//:change mapping range to fit MagShift
{ \x1.kr(0).urange(0.5, 2) } @>.fx1 \stretch;
{ \y1.kr(0).urange(-5, 5) } @>.fx1 \shift;
{ \x2.kr(0).urange(0.1, 5) } @>.fx2 \stretch;
{ \y2.kr(0).urange(-25, 25) } @>.fx2 \shift;

