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
\fxvol <+.fx2  20; // jun needs larger amplitude
//:start timer with gui
Time().gui;
//:start source playback
Pbuf2({ ~startpos = 809; ~buffer = \lamentodellaninfa }, \p1);
//:
Pbuf2({
	~startpos = 0;
	~buffer = \prologue;
	~rate = 0.25; // 2 octaves lower
}, \p2);
//:add brick wall fx1
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx1;
//:PV_MagBelow fx2
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.1, 0.5));
}, true) +> \fx2;
//:connect input control busses to fx parameters
\x1 @>.fx1_thresh \x1;
\x4 @>.fx2_thresh \x1;
//:change mapping range to fit MagBelow linexp 0.01, 7 is good
{ \x1.kr(0).linexp(0.0000001, 0.4129515975) } @>.fx1 \thresh; // BRICKWALL
{ \x1.kr(0).linexp(0.01, 25) } @>.fx2 \thresh; // MAGBELOW
