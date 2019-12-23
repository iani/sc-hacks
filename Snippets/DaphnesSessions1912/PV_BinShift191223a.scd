//:sound check
\default +> \soundcheck;
//:setup sensors
BusOsc.watch1(\sense_stage_test, '/minibee/data',
	[\x1, 1, 0.47, 0.53, 1],
	[\y1, 2, 0.47, 0.53, 1],
	[\z1, 3, 0.47, 0.53, 1],
	[\x2, 1, 0.47, 0.53, 3], // using sensor module 3
	[\y2, 2, 0.47, 0.53, 3],
	[\z2, 3, 0.47, 0.53, 3]
);
//:recording // start this with a timer!
"riadaphne191223b".record(60 * 10, 5);
//:Start playback on glissando
\p1 *> \fx1;
\p2 *> \fx2;
// { Inp.ar.stereo } +> \fx1;
Pbuf2({ ~startpos = 809; }, \p2);
//:add brick wall
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx2;
\srcvol <+.fx2 0;
\fxvol <+.fx2 2;

//:map x1 to range 0 - 0.3 and connect to thresh on fx1 
{ \x1.kr(0).urange(0.0, 0.3) } @>.fx2 \thresh; //
//:connect x3 bus to x1 parameter on mapper synth
\x2 @>.fx2_thresh \x1;

//:start viola input as source
{ DelayC.ar(In.ar(2), 1, 1) } +> \p1;
// =============================================
// ================ PV_MagShift ================ 
//:PV_MagShift
PV({ | c |
	PV_MagShift(c,
		\stretch.kr(0.1, 0.5),
		\shift.kr(0.1, 0.5)
	);
}, true) +> \fx1;
//:
\srcvol <+.fx1 0;
//:
\fxvol <+.fx1 0.5;
//:
//connect control busses to fx parameters
\x1 @>.fx1_stretch \x1;
\y1 @>.fx1_shift \y1;
//change mapping range to fit MagShift
{ \x1.kr(0).urange(0.1, 5) } @>.fx1 \stretch;
{ \y1.kr(0).urange(-25, 25) } @>.fx1 \shift;
//:================================================================
