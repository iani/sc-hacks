//:sound check
\default +> \soundcheck;
//;buffer check
\lamentodellaninfa.b.play;
//:buffer check with Pbuf2
\p1 *> \fx1;
\p2 *> \fx2;
Pbuf2({ ~startpos = 809; ~buffer = \lamentodellaninfa }, \p1);
Pbuf2({ ~startpos = 0; ~buffer = \prologue }, \p2);
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
//: SENSOR ALLOTMENTS TO PERSONS:
// asayo = x1 ///jun x4
//:listen to fx (not src)
\srcvol <+.fx1 0;
\fxvol <+.fx1  1;
\srcvol <+.fx2 0;
\fxvol <+.fx2  10; // jun needs much more amplitude!
//:add brick wall fx1
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:
\rate <+.p2 0.25;
//:
//:PV_MagBelow fx2
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx2;
//:connect input control busses to fx parameters
\x1 @>.fx1_thresh \x1;
\x4 @>.fx2_thresh \x1;
//:set range mappers range and type
//:change mapping range to fit MagBelow linexp 0.01, 7 is good
{ \x1.kr(0).urange(0.000001, 0.29515975) } @>.fx1 \thresh; // BRICKWALL
{ \x1.kr(0).linexp(0.01, 25) } @>.fx2 \thresh; // MAGBELOW

// MAIN PART ENDS HERE
//: ================================================================
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ================================================================
// FOLLOWING ARE SOME ADDITIONAL EXPERIMENTS AND TRIES
//:Set threshold to 0 = no wall at all
\thresh <+.fx1 0;

//:open fx slightly
\thresh <+.fx1 0.01;
//:open fx more (max...)
\thresh <+.fx1 0.13;
//:map x1 to range 0 - 0.3 and connect to thresh on fx1 
{ \x1.kr(0).urange(0.0, 0.3) } @>.fx1 \thresh; //
//: alternative: linexp !!!!!!!
//:for brick wall is NOT this: (linexp is not good)
{ \x1.kr(0).linexp(0.00001, 0.515975) } @>.fx1 \thresh; //
//:for brick wall use this (urange - linear)
{ \x1.kr(0).urange(0.00001, 0.29515975) } @>.fx1 \thresh; //
//:for mag above is this
{ \x1.kr(0).linexp(0.01, 0.975) } @>.fx1 \thresh; //
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
{ \x1.kr(0).linexp(0.01, 10.827) } @>.fx1 \thresh; //
//:PV_Magabove x4 fx2
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:PV_Magabove
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:change mapping range to fit MagBelow
{ \x1.kr(0).linexp(0.01, 7) } @>.fx1 \thresh; //
//:PV_Magabove
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:change mapping range to fit MagBelow
{ \x1.kr(0).linexp(0.01, 7) } @>.fx1 \thresh; //
//:PV_Magabove
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:change mapping range to fit MagBelow
{ \x1.kr(0).linexp(0.01, 7) } @>.fx1 \thresh; //
above
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:change mapping range to fit MagBelow
{ \x1.kr(0).linexp(0.01, 7) } @>.fx1 \thresh; //

	PV_MagBelow(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx2;
//:change mapping range to fit MagBelow
{ \x4.kr(0).linexp(0.01, 7) } @>.fx2 \thresh; //

// =============================================
// ================ Pv_MagShift ================ 
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

//:change mapping range to fit MagShift
{ \x1.kr(0).urange(0.5, 2) } @>.fx1 \stretch;
{ \y1.kr(0).urange(-5, 5) } @>.fx1 \shift;
{ \x2.kr(0).urange(0.1, 5) } @>.fx2 \stretch;
{ \y2.kr(0).urange(-25, 25) } @>.fx2 \shift;

//:connect busses to mappers
\x1 @>.fx1_stretch \x1;
\y1 @>.fx1_shift \y1;
\x4 @>.fx2_stretch \x1;
\y4 @>.fx2_shift \y1;
