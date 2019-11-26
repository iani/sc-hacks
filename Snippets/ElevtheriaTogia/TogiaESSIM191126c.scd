//:List of PV_Mag effects
/*
1. MagAbove
2. MagBelow
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
//:PHRASE 1 MAGBELOW
\cauche1 *> \magbelow;
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		// \trig.kr(1),
		\startpos.kr(809) + 10 * 44100, 1);
} +> \cauche1;
// //:magbelow
{
	var src, fx;
	var chain;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagBelow(chain, \thresh.kr(1).linexp(0.1, 50));
	fx = IFFT(chain);
	Mix([src * \srcvol.kr(0.5), fx * \fxvol.kr(0.5)]).stereo;
} +> \magbelow;
//:
\period <+.magbelow 120;
\srcvol <+.magbelow 0.0;
\fxvol <+.magbelow 1.0;
//:
\thresh <+.magbelow 0.0;
//:
\thresh <+.magbelow 1.0;
//:PHRASE 2 MAGABOVE
\cauche2 *> \magabove;
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(0.75, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		// \trig.kr(1),
		\startpos.kr(809) + 10 * 44100, 1);
} +> \cauche2;
// //:magabove
{
	var src, fx;
	var chain;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagAbove(chain, \thresh.kr(1).linexp(0.001, 25));
	fx = IFFT(chain);
	Mix([src * \srcvol.kr(0.5), fx * \fxvol.kr(0.5)]).stereo;
} +> \magabove;
//:
\period <+.magabove 120;
\srcvol <+.magabove 0.0;
\fxvol <+.magabove 1.0;
//:
\thresh <+.magabove 0.0;
\thresh <+.magabove 0.5;
\thresh <+.magabove 0.75;
//:
\thresh <+.magabove 1.0;
//:PHRASE 3
\cauche2 *> \magabove;
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(0.75, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		// \trig.kr(1),
		\startpos.kr(809) + 10 * 44100, 1);
} +> \cauche2;
// //:magabove
{
	var src, fx;
	var chain;
	src = Inp.ar;
	chain = FFT(LocalBuf(2048, 1), src);
	chain = PV_MagAbove(chain, \thresh.kr(1).linexp(0.001, 25));
	fx = IFFT(chain);
	Mix([src * \srcvol.kr(0.5), fx * \fxvol.kr(0.5)]).stereo;
} +> \magabove;
//:
\period <+.magabove 120;
\srcvol <+.magabove 0.0;
\fxvol <+.magabove 1.0;
//:
\thresh <+.magabove 0.0;
\thresh <+.magabove 0.5;
\thresh <+.magabove 0.75;
//:
\thresh <+.magabove 1.0;
