//: Testing PV shortcut;
\p1 *> \fx1;
{ Inp.ar.stereo } +> \fx1;
Pbuf2({ ~startpos = 809; }, \p1);
//:
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.1, 0.5));
}) +> \fx1;
//:
\thresh <+.fx1 10;
//:
\srcvol <+.fx1 0;
//:
\fxvol <+.fx1  1;
//:
\thresh <+.fx1 0.01;
//:
\fx1.e;