//:sound check
\default +> \soundcheck;
//:setup sensors
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\x1, 1, 0.47, 0.53, 1],
	[\y1, 2, 0.47, 0.53, 1],
	[\z1, 3, 0.47, 0.53, 1],
	[\x2, 1, 0.47, 0.53, 3], // using sensor module 3
	[\y2, 2, 0.47, 0.53, 3],
	[\z2, 3, 0.47, 0.53, 3]
);
//:Start playback on glissando
\p1 *> \fx1;
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
//:open fx slightly
\thresh <+.fx1 0.01;
//:open fx more (max...)
\thresh <+.fx1 0.3;
//:map x1 to range 0 - 0.3 and connect to thresh on fx1 
{ \x1.kr(0).urange(0.0, 0.3) } @>.fx1 \thresh; //
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
//:PV_MagShift
PV({ | c |
	PV_MagShift(c,
		\stretch.kr(0.1, 0.5),
		\shift.kr(0.1, 0.5)
	);
}, true) +> \fx1;
//:connect control busses to fx parameters
\x1 @>.fx1_stretch \x1;
\y1 @>.fx1_shift \y1;
//:change mapping range to fit MagShift
{ \x1.kr(0).urange(0.1, 5) } @>.fx1 \stretch;
{ \y1.kr(0).urange(-25, 25) } @>.fx1 \shift;