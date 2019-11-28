\viola *> \violafx;
\violafx *> \violapan;
//:
{ WhiteNoise.ar(0.02) } +> \viola;
{ Inp.ar * LFPulse.kr(1, 0, 0.9) } +> \violafx;
{ Inp.ar.stereo } +> \violapan;

{ PanAz.ar(8, Inp.ar, \pos.kr(0) } +> \violapan;

//:
{
	var src;
	src = SoundIn.ar;
	
} +> \viola;
//:
Pvs({ | ch |
	PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 55))
}, { ~startpos = 809 }, {
	~thresh = 1;
	~fxvol = 0;
	~srcvol = 1;
});
20.wait;
{ XLine.kr(1, 0.0001, 10) }.map(\pv1, \srcvol);
{ XLine.kr(0.0001, 1, 10) }.map(\pv1, \fxvol);
10.wait;
\pv1.map(\thresh, \z1);
60.wait; // increased delay by 30 secs relative to prior score
\cauche1.map(\rate, \y1);
40.wait;
Pvs({ | ch |
 	PV_BinShift(ch,
		\stretch.kr(0).urange(0.001, 5),
		\shift.kr(0).urange(-5.0, 5.0)
	)},
	{ ~startpos = 0; ~rate = 0.75 },
	{ ~stretch = 0; ~shift = 0;},
	\cauche2, \pv2
);
20.wait;
\pv2.map(\stretch, \x1, \shift, \z1);
120.wait;
{ XLine.kr(1, 0.0001, 10) }.map(\pv1, \srcvol);
{ XLine.kr(0.0001, 1, 10) }.map(\pv1, \fxvol);
//:
//:test thresh
\thresh <+.pv1 0.01;
\thresh <+.pv1 0.9;
//:test mix
\fxvol <+.pv1 0.0;
\srcvol <+.pv1 1.0;
//:
Pvs({ | ch |
	// PV_MagBelow(ch, \thresh2.kr(1).linexp(0.1, 25))
 	PV_BinShift(ch,
		\stretch.kr(0).urange(0.001, 5),
		\shift.kr(0).urange(-5.0, 5.0)
	)
}, { ~startpos = 0; ~rate = 0.75 }, { ~stretch = 0.06; ~shift = 0.05; },
	\cauche2, \pv2);
//:
currentEnvironment;
//:
~stretch = 0.56;
//:
~shift = 0.99;