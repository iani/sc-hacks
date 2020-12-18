+ Symbol {
	envir { ^Nevent(this) }
	before { | envir |
		envir = envir.envir;
		^this.envir.setGroup(OrderedGroup before: envir[\target]);
	}
	// error when used as instrument in pattern
	/*
	value { | envir |
		// return value of self as parameter in envir
		^envir.ev[this];
	}
	*/
}