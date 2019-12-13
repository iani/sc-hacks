//:phrase beginnings in buffer (in seconds)
/*
1. 0
2. 750
3. 767
4. 744
5. 809
*/
//:
{ Out.ar(0, WhiteNoise.ar(0.3).stereo)} +> \test;
//:
{
	var src;
	src = WhiteNoise.ar(0.05);
	PanAz.ar(8, src, LFSaw.kr(0.125), 4)
} +> \test;

//:TEST RECORDING ================================================================
Server.default.record(numChannels: 9, duration: 10); // 9th channel: direct in
//:===================== SET UP ============
//: volume setup
(1..4) do: { | i |
format("pv%", i).asSymbol.put(\amp, 1);
};
//:
// \violapan.put(\amp, 1);
//:preliminary playback test
Pvs({ | ch |
	// PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 150))
	PV_BinShift(ch, \stretch.kr(1).linexp(0.01, 5)
		\shift.kr(1).urange(-5, 5)
	)
}, {
	~startpos = 809;
	~rate = 0.6;
}, {
	~thresh = 0.1;
	~fxvol = 10;
	~srcvol = 0;
});
//:
\pv1.map(\thresh, \z1);
//:
\pv1.map(\stretch, \z1);
\pv1.map(\shift, \x1);
//:preliminary viola input test
{ SoundIn.ar(0) * \amp.kr(1) } +> \violapan; // violapan is linked to amp control gui
//:mixer setup
//Pvs arguments:
// player, effect, scvol, fxvol, startpos

// ================================================================
//:+ ================ PIECE STARTS HERE ================
// ================================================================
// START RECORDING ( 9th channel: direct in)  20 MINUTES  
Server.default.record(numChannels: 9, duration: (20 * 60));
// 0.1.wait;
// VIOLA ================================================================
Time(); // time start of initial motiv in playback:
// seconds: 241.05669888001, min:secs: 4:1.057
// bind panaz to x2, y2, z2 sensor input from second glove;
\violapan.map(\pan, \x2);
\p1.map(\pan, \y2);
\p2.map(\pan, \z2);
\viola *> \violafx;
\violafx *> \violapan;
{ SoundIn.ar(0) } +> \viola;
\srcvol <+.violafx 0;
\fxvol <+.violafx 5;
{
	var src, fx, finalout, srcvol = 0, fxvol = 1;
	var chain, f;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	f = { | ch |
		// PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 55))
		PV_BinShift(ch,
			\stretch.kr(0).urange(0.0001, 1.5),
			\shift.kr(0).urange(-5.0, 3.0)
		);
	};
	chain = f.(chain);
	fx = IFFT(chain);
	// Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]).stereo;
	finalout = Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]);
} +> \violafx;
{
	PanAz.ar(8, Inp.ar, \pan.kr(0).urange(-1.0, 1.0));
	// Inp.ar.stereo;
} +> \violapan;
\violapan.map(\pan, \z2);
// \fxvol <+.violafx 5;
// \srcvol <+.violafx 0;
\stretch <+.violafx 0.1;
\shift <+.violafx 0.1;
\violafx.map(\stretch, \x1);
\violafx.map(\shift, \y1);
// CAUCHE 1 pv1 ================================================================
Pvs({ | ch |
	PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 25))
}, {
	~startpos = 809;
	~rate = 0.6;\
}, {
	~thresh = 0.1;
	~fxvol = 0;
	~srcvol = 1;
});
20.abswait;
{ XLine.kr(1, 0.0001, 20) }.map(\pv1, \srcvol);
{ XLine.kr(0.0001, 1, 5) }.map(\pv1, \fxvol);
/*
\z1.bus.set(0.51);
*/
\pv1.map(\thresh, \z1);
[0, 50].abswait;
// CAUCHE 2 pv2 ================================================================
Pvs({ | ch |
	// PV_MagBelow(ch, \thresh2.kr(1).linexp(0.1, 25))
 	PV_BinShift(ch,
		\stretch.kr(0).urange(0.001, 4),
		\shift.kr(0).urange(-5.0, 4.0)
	)
}, { ~startpos = 809; ~rate = 0.75 }, { ~stretch = 0.1; ~shift = 0.1; },
	\cauche2, \pv2
);
[3, 0].abswait;
\pv2.map(\stretch, \x1);
\pv2.map(\shift, \y1);
// at minute 4 the opening theme starts: NEXT MILESTONE
[3, 50].abswait;
// fade out effects, fade in source sound in cauche 1 pv1
{ XLine.kr(0.0001, 1.0, 10) }.map(\pv1, \srcvol);
{ XLine.kr(1.0, 0.00001, 15) }.map(\pv1, \fxvol);
// fade out effects, fade in source sound in cauche 1 pv1
{ XLine.kr(0.0001, 1.0, 10) }.map(\pv2, \srcvol);
{ XLine.kr(1.0, 0.00001, 15) }.map(\pv2, \fxvol);
[5, 0].abswait;
//crossfade to higher BinShift range
\fadeTime <+.violafx 5;
{
	var src, fx, out, srcvol = 0, fxvol = 1;
	var chain, f;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	f = { | ch |
		//	PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 55))
		PV_BinShift(ch,
			\stretch.kr(0).urange(0.0001, 1.5),
			\shift.kr(0).urange(-1.0, 3.0)
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
[5, 30].abswait;
// FADE !!!!OUT!!!! EFFECTS FROM pv2 CAUCHE 2
{ XLine.kr(0.0001, 1.0, 10) }.map(\pv2, \srcvol);
{ XLine.kr(1.0, 0.00001, 15) }.map(\pv2, \fxvol);
// { XLine.kr(0.0001, 1.0, 10) }.map(\violafx, \srcvol);
// { XLine.kr(1.0, 0.00001, 15) }.map(\violafx, \fxvol);
// viola fx: replace BinShift with MagAbove
[5, 40].abswait;
\thresh <+.violafx 0;
{
	var src, fx, out, srcvol = 0, fxvol = 1;
	var chain, f;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	f = { | ch |
		//	PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 55))
		PV_MagAbove(ch,
			\thresh.kr(0).urange(0.0001, 25));
	};
	chain = f.(chain);
	fx = IFFT(chain);
	Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]);
} +> \violafx;
// raise MagAbove threshold from 0e-4 to 0.5 in 10 seconds
{ XLine.kr(0.0001, 0.5, 15) }.map(\violafx, \thresh);
[6, 0].abswait;
// start controlling viola magabove threshold from z1 sensor
\violafx.map(\thresh, \z1);
[7, 0].abswait;
\fadeTime <+.pv1 3;
// start heartbeat on cauche1
Pbuf(260.2, \cauche1, init: {
    ~rate = 1;
    ~period = 8.4217412992999 / ~rate;
});
[7, 10].abswait;
// start heartbeat on cauche2
Pbuf(260.2, \cauche2, init: {
    ~rate = 1;
    ~period = 8.4217412992999 / ~rate;
});
[7, 15].abswait;
// add localmax to cauche2 = pv2
PFX({ | ch |
	PV_LocalMax(ch, \thresh.kr(1).linexp(0.001, 5.0));
}, { ~thresh = 0 }, \pv2, 1, 0);
// FADE !!!!IN!!!! EFFECTS ON pv2 CAUCHE 2
{ XLine.kr(0.0001, 1.0, 10) }.map(\pv2, \fxvol);
{ XLine.kr(1.0, 0.00001, 15) }.map(\pv2, \srcvol);
// and raise threshold from 0 to 0.7 in 30 seconds
[7, 50].abswait; // control pv2 cauche2 fx thresh with y1
\pv2.map(\thresh, \y1);
[8, 30].abswait; // start scratch on cauche1
Pbuf((12 * 60) + 28, \cauche1, init: {
	~rate = 1;
	~period = 32;
});
[8, 50].abswait; // add binshift to viola, controlled by z1.
{
	var src, fx, finalout, srcvol = 0, fxvol = 1;
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
	// Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]).stereo;
	finalout = Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]);
	PanAz(8, finalout, \pan.kr(0).urange(-1.0, 1.0));
} +> \violafx;
[9, 00].abswait; // start scratch on cauche2
Pbuf((12 * 60) + 28, \cauche2, init: {
	~rate = 1;
	~period = 32;
});
[9, 30].abswait; // add binshift to pv1 and pv2, controlled by x1, y1.

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
			\shift.kr(1).urange(-5.0, 5.0)			);
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
/*	Pvs({ | ch |
	PV_BinWipe(ch, \shift.kr(0).linexp(0.0001, 0.5), 1)	});
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