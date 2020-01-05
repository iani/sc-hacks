//  5 Jan 2020 23:24
// shortcuts for adding ugen structures to synthdefs:
// fx, pv.

+ Function {
	// could be also called "addfx":
	fx { | func |
		/* pass the ugen output from this function as 
			input to func for further processing.
			This way one can add one or more effects to a function.
			by chaining it through calls to .fx. */
		^{
			// var src;
			// src = this.value;
			// func.(src); // shorter version:
			func.(this.value);
		}
	}

	stereo { // also example of fx use:
		// ^this.fx({ | in | in.stereo });
		// shorter form:
		^this.fx(_.stereo);
	}

	pv { | pvfunc, stereo = false |
		/* wrap a function around the receiver which 
			extracts an fft chain from an input Inp.ar, and 
			then performs IFFT to return the signal.
			This makes it possible to write just the main body
			of the fft processing function (PV_ something) in the receiver:
			{ | c | PB_MagBelow(c, \threshold.kr(1.2)) }.pv;
		*/
		^this fx: { | src |
			var pv, mix, chain;
			chain = FFT(LocalBuf(2048, 1), src);
			chain = this.(chain);
			pv = IFFT(chain);
			mix = (\amp.kr(1) *
				Mix([src * \srcvol.kr(1), pv * \fxvol.kr(0)])
			);
			if (stereo) { mix.stereo } { mix }
		}
	}

	mix { | func |
		// like fx, except provide a mix of the source with 
		// srcvol and fxvol controls (original source / effect amp control)
		^{ 
			var src, fx;
			src = this.value;
			fx = func.(src);
			Mix([src * \srcvol.kr(1), fx * \fxvol.kr(0)])
			* \amp.kr(1)
		}
	}

}

+ Symbol {
	pb { | loopp = 1, doneAction = 2 | // play buffer
		var buffer;
		buffer = this.b;
		^{ 
			var src;
			src = PlayBuf.ar(
				buffer.numChannels,
				buffer, 
				\rate.kr(1),
				Impulse.kr(\period.kr(9e10).reciprocal),
				\startpos.kr(0) * BufSampleRate.kr(buffer),
				\loop.kr(loopp),
				doneAction
			);
		}
	}
}