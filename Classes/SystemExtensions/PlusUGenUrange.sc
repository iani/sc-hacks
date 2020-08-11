+ UGen {
	urange { | lo = 0, hi = 1 |
		// explicitly map from range 0-1 to target range
		// adapted from UGen::range
		var mul, add;
		mul = (hi - lo);
		add = lo;
		^MulAdd(this, mul, add);
	}

	/* // removed  9 Mar 2020 12:32
	linexp { | lo = 1.0, hi = 2 |
		// shortcut for linexp of sources whose range is 0-1
		if (rate == \audio) {
			^LinExp.ar(this, 0, 1, lo, hi);
		}{
			^LinExp.kr(this, 0, 1, lo, hi);
		}
	}
	*/
}

/*
LinExp : PureUGen {
	checkInputs { ^this.checkSameRateAsFirstInput }
	*ar { arg in=0.0, srclo = 0.0, srchi = 1.0, dstlo = 1.0, dsthi = 2.0;
		^this.multiNew('audio', in, srclo, srchi, dstlo, dsthi)
	}
	*kr { arg in=0.0, srclo = 0.0, srchi = 1.0, dstlo = 1.0, dsthi = 2.0;
		^this.multiNew('control',  in, srclo, srchi, dstlo, dsthi)
	}
}
*/
	
