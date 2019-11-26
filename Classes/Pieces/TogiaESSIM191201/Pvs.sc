// Shortcut for trying out many pvs
/* template:
//:PHRASE 1 MAGBELOW
var func;
func = { | f |
	\thresh <+.magbelow 0.25;
	\cauche1 *> \magbelow;
	{
		PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.5, 1.5),
			Impulse.kr(\period.kr(9e10).reciprocal),
			\startpos.kr(809) + 10 * 44100, 1);
	} +> \cauche1;
	{
		var src, fx;
		var chain;
		src = Inp.ar;
		chain = FFT(LocalBuf(2048, 1), src);
		chain = f.(chain);
		fx = IFFT(chain);
		Mix([src * \srcvol.kr(0.5), fx * \fxvol.kr(0.5)]).stereo;
	} +> \magbelow;
};
func.({ | ch |
	PV_MagAbove(ch, \thresh.kr(1).linexp(0.1, 50))
});
*/
// use example:
/*
//:
Pvs({ | ch |
	PV_MagAbove(ch, \thresh.kr(1).linexp(0.1, 50))
});
//:
*/

Pvs {
	*new { | f, player = \cauche1, effect = \pv1 |
		player *> effect;
		{
			PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.5, 1.5),
				Impulse.kr(\period.kr(9e10).reciprocal),
				\startpos.kr(809) + 10 * 44100, 1);
		} +> player;
		{
			var src, fx;
			var chain;
			src = Inp.ar;
			chain = FFT(LocalBuf(2048, 1), src);
			chain = f.(chain);
			fx = IFFT(chain);
			Mix([src * \srcvol.kr(0.5), fx * \fxvol.kr(0.5)]).stereo;
		} +> effect;
	}
}