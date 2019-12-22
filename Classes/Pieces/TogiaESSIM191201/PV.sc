/*  December 2019
Shortcut for PV_ spectral UGens.
Based on earlier drafts, Pvs etc.
*/

PV {
	*new { | func, stereo = false |
		^{
			var src, fx, finalout;
			var chain;
			src = Inp.ar;
			chain = FFT(LocalBuf(2048, 1), src);
			chain = func.(chain);
			fx = IFFT(chain);
			finalout = (\amp.kr(1) *
				Mix([src * \srcvol.kr(1), fx * \fxvol.kr(0)])
			);
			if (stereo) { finalout.stereo } { finalout }
		}
	}
}