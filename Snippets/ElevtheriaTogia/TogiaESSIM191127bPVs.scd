//:Using shortcut class to try out different PV ugens
/* // list:
1. MagAbove [+]
2. MagBelow [+]
3. MagClip 
4. LocalMax
5. MagSmear
6. BinShift
7. MagShift
8. MagSquared
9. MagNoise
10. PhaseShift90
11. PhaseShift270
12. Phaseshift
13. BrickWall
14. BinWipe
---------- these involve 2 buffers (2 sources)
15. MagMul
16. CopyPhase
17. Copy
18. Max
19. Min
20. Mul
21. Div
22. Add
23. MagDiv
----------
24. RandComb
25. RectComb
26. RectComb2
27. RandWibe
28. Diffuser
29. MagFreeze
30. BinScramble
*/
//:summary of phrases:
/*
1. 0
2. 750
3. 767
4. 744
5. 809
*/
//Pvs arguments:
// player, effect, scvol, fxvol, startpos
//:+ player = \cauche1, effect = \pv1,
Pvs({ | ch |
	PV_MagClip(ch, \thresh.kr(1).linexp(0.1, 25))
	// PV_MagAbove(ch, \thresh.kr(1).linexp(0.01, 65))
}, { ~startpos = 809 }, { ~thresh = 25 });
30.wait;
\pv1.map(\thresh, \z1);
30.wait;
Pvs({ | ch |
	// PV_MagBelow(ch, \thresh2.kr(1).linexp(0.1, 25))
 	PV_BinShift(ch,
		\stretch.kr(0).urange(0.001, 5),
		\shift.kr(0).urange(-5.0, 5.0)
	)
}, { ~startpos = 809; ~rate = 0.75 }, { ~stretch = 0; ~shift = 0; },
	\cauche2, \pv2);
10.wait;
\pv2.map(\stretch, \x1, \shift, \z1);
40.wait;
\cauche1.map(\rate, \y1);
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
	PV_LocalMax(ch, \thresh.kr(1).linexp(0.001, 3.5))
});
\pv1.map(\thresh, \z1);
//: MagSmear
Pvs({ | ch |
	PV_MagSmear(ch, \thresh.kr(1).urange(0.1, 20))
});
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