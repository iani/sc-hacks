//:phrase beginnings in buffer (in seconds)
/*
1. 0
2. 750
3. 767
4. 744
5. 809
*/
//:Effects selected
1. MagClip
2. MagAbove
3. LocalMax
4. MagSmear
5. BinShift

//Pvs arguments:
// player, effect, scvol, fxvol, startpos
// ================ PIECE STARTS HERE ================
//:+ player = \cauche1, effect = \pv1,
\viola *> \violafx;
\violafx *> \violapan;
{ SoundIn.ar(0) } +> \viola;
{
	var src, fx, out, srcvol = 0, fxvol = 1;
	var chain, f;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	f = { | ch |
		//	PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 55))
		PV_BinShift(ch,
			\stretch.kr(0).urange(0.0001, 1.5),
			\shift.kr(0).urange(-5.0, 3.0)
		);
	};
	chain = f.(chain);
	fx = IFFT(chain);
	Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]).stereo;
	/*
		out = Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]).stereo;
		PanAz(8, out, \pos.kr(0));
	*/
} +> \violafx;
{ Inp.ar.stereo } +> \violapan;
\fxvol <+.violafx 1;
\srcvol <+.violafx 0;
\stretch <+.violafx 0.1;
\shift <+.violafx 0.1;
\violafx.map(\stretch, \x1);
\violafx.map(\shift, \y1);
Pvs({ | ch |
	PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 25))
}, {
	~startpos = 809;
	~rate = 0.6;
}, {
	~thresh = 0.1;
	~fxvol = 0;
	~srcvol = 1;
});
20.wait;
{ XLine.kr(1, 0.0001, 20) }.map(\pv1, \srcvol);
{ XLine.kr(0.0001, 1, 5) }.map(\pv1, \fxvol);
\pv1.map(\thresh, \z1);
30.wait;
Pvs({ | ch |
	// PV_MagBelow(ch, \thresh2.kr(1).linexp(0.1, 25))
 	PV_BinShift(ch,
		\stretch.kr(0).urange(0.001, 4),
		\shift.kr(0).urange(-5.0, 4.0)
	)
}, { ~startpos = 809; ~rate = 0.75 }, { ~stretch = 0.1; ~shift = 0.1; },
	\cauche2, \pv2
);
70.wait;
\pv2.map(\stretch, \x1);
\pv2.map(\shift, \y1);
//: at minute 4 the opening theme starts: NEXT MILESTONE
//:
PFX({ | ch |
	//	PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 25))
	PV_MagAbove(ch, \thresh.kr(1).linexp(0.01, 65))
}, { ~fxvol = 0; ~srcvol = 1 }, \pv2);
//:
\cauche1 *> \pv2;
//:
\thresh <+.pv2 0.65;
//:
20.wait;
{ XLine.kr(1, 0.0001, 20) }.map(\pv1, \srcvol);
{ XLine.kr(0.0001, 1, 5) }.map(\pv1, \fxvol);
\pv1.map(\thresh, \z1);
30.wait;
//:
{
	var src, fx, out, srcvol = 1, fxvol = 0;
	var chain, f;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	f = { | ch |
		//	PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 55))
		/*		PV_BinShift(ch,
			\stretch.kr(1).urange(0.001, 5),
			\shift.kr(1).urange(-5.0, 5.0)
		);
		*/
		PV_MagAbove(ch, \thresh.kr(1).linexp(0.01, 65))
	
	};
	chain = f.(chain);
	fx = IFFT(chain);
	Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]).stereo;
	/*
		out = Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]).stereo;
		PanAz(8, out, \pos.kr(0));
	*/
} +> \pv1;
//:
\default +> \pv1;
//:
\stretch <+ 0.5;
\shift <+ 0.5;
//:
// \cauche1.map(\rate, \y1);
40.wait;
Pvs({ | ch |
	// PV_MagBelow(ch, \thresh2.kr(1).linexp(0.1, 25))
 	PV_BinShift(ch,
		\stretch.kr(0).urange(0.001, 5),
		\shift.kr(0).urange(-5.0, 5.0)
	)
}, { ~startpos = 0; ~rate = 0.75 }, { ~stretch = 0; ~shift = 0; },
	\cauche2, \pv2);
20.wait;
\pv2.map(\stretch, \x1, \shift, \z1);
40.wait;
10.wait;
//:

//: Magabove new Pvs version
Pvs({ | ch |
	PV_MagAbove(ch, \thresh.kr(1).linexp(0.001, 25))
}, { ~startpos = 155 }, { ~thresh = 0.0090 });
//:
\pv1.map(\thresh, \thresh);
//:
\thresh.bus.set(0.0);
//:
{ Out.kr(\thresh.bus, Line.kr(0, 1, 60)) } +> \threshnoise;
//: MagBelow
Pvs({ | ch |
	PV_MagBelow(ch, \thresh.kr(1).linexp(0.1, 25))
});
//: MagClip
Pvs({ | ch |
	PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 25))
});
\pv1.map(\thresh, \x1);
10.wait;
\cauche1.map(\rate, \y1);
//: LocalMax
Pvs({ | ch |
	PV_LocalMax(ch, \thresh.kr(1).linexp(0.001, 5.0));
});
//:
\thresh <+ 0.9;
// \pv1.map(\thresh, \z1);
//: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//: MagSmear !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Pvs({ | ch |
	PV_MagSmear(ch, \thresh.kr(1).urange(0.1, 20))
});
//:
\fxvol <+ 1;
\srcvol <+ 0;
\thresh <+ 0.1;
//: BinShift
Pvs({ | ch |
 	PV_BinShift(ch,
		\stretch.kr(0).urange(0.001, 5),
		\shift.kr(0).urange(-5.0, 5.0)
	)
});
//:
\stretch <+.pv1 0;
\stretch <+.pv1 0.1;
\stretch <+.pv1 0.3;
\stretch <+.pv1 0.5;
\stretch <+.pv1 0.7;
\stretch <+.pv1 0.97;
\shift <+.pv1 0;
\shift <+.pv1 0.1;
\shift <+.pv1 0.3;
\shift <+.pv1 0.5;
\shift <+.pv1 0.7;
012\shift <+.pv1 0.97;
//:magshift
Pvs({ | ch |
	PV_MagShift(ch,
		\stretch.kr(0).urange(0.0001, 5),
		\shift.kr(0).urange(-5.0, 5.0)
	)
});
//:magsquared
Pvs({ | ch |
	PV_MagSquared(ch)
});
//:MagNoise
Pvs({ | ch |
	PV_MagNoise(ch)
});
//:Phaseshift90
Pvs({ | ch |
	PV_PhaseShift90(ch)
});
//:Phaseshift270
Pvs({ | ch |
	PV_PhaseShift270(ch)
});
//:PhaseShift
Pvs({ | ch |
	PV_PhaseShift(ch, \shift.kr(0).urange(-5.0, 5.0), 1)
});

//:BrickWall
Pvs({ | ch |
	PV_BrickWall(ch, \shift.kr(0).linexp(0.0001, 0.5), 1)
});
//:BinWipe requires two buffers
/*
Pvs({ | ch |
	PV_BinWipe(ch, \shift.kr(0).linexp(0.0001, 0.5), 1)
});
*/
//:RandComb
Pvs({ | ch |
	PV_RandComb(ch, \wipe.kr(0).linexp(0.0001, 0.9),
		Dust.kr(1))
});
//:
\wipe <+.pv1 1.015;
\wipe <+.pv1 1;
\fxvol <+.pv1 2;