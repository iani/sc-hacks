+ UGen {
	urange { | lo = 0, hi = 1 |
		// explicitly map from range 0-1 to target range
		// adapted from UGen::range
		var mul, add;
		mul = (hi - lo) ;
			add = lo;
		^MulAdd(this, mul, add);
	}
}
	
