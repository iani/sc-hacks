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
/*
//: Rate calculation
var spec;
spec = ControlSpec(0.1, 1.5);
(0, 0.1 .. 1) do: { | i |
	[i, spec.map(i)].postln;
};
//:
*/
//:summary of phrases:
/*
1. 0
2. 750
3. 767
4. 744
5. 809
*/

Pvs {
	*new { | f, pinit, fxinit, player = \cauche1, effect = \pv1,
		srcvol = 0, fxvol = 1, startpos = 809 |
		// renew values of environment from eventual previous call:
		effect.put(\srcvol, srcvol);
		effect.put(\fxvol, fxvol);
		player.put(\startpos, startpos);
		player.use(pinit);
		effect.use(fxinit);
		player *> effect;
		{
			PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.25, 1.5),
				Impulse.kr(\period.kr(9e10).reciprocal),
				\startpos.kr(startpos) + 10 * 44100, 1);
		} +> player;
		{
			var src, fx, out;
			var chain;
			src = Inp.ar;
			chain = FFT(LocalBuf(2048, 1), src);
			chain = f.(chain);
			fx = IFFT(chain);
			Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]).stereo;
			/*
				out = Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]).stereo;
				PanAz(8, out, \pos.kr(0));
			*/
		} +> effect;
	}
}

PFX {
		*new { | f, fxinit, effect = \pv1, srcvol = 0, fxvol = 1 |
		// renew values of environment from eventual previous call:
		effect.put(\srcvol, srcvol);
		effect.put(\fxvol, fxvol);
		effect.use(fxinit);
		{
			var src, fx, out;
			var chain;
			src = Inp.ar;
			chain = FFT(LocalBuf(2048, 1), src);
			chain = f.(chain);
			fx = IFFT(chain);
			Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]).stereo;
			/*
				out = Mix([src * \srcvol.kr(srcvol), fx * \fxvol.kr(fxvol)]).stereo;
				PanAz(8, out, \pos.kr(0));
			*/
		} +> effect;
	}
	
}