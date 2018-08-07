+ Symbol {
	envir { ^Nevent(this) }
	before { | envir |
		envir = envir.envir;
		^this.envir.setGroup(OrderedGroup before: envir[\target]);
	}
	value { | envir |
		// return value of self as parameter in envir
		^envir.e[this];
	}
}