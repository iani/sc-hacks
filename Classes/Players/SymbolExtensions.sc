+ Symbol {
	envir { ^Nevent(this) }
	before { | envir |
		envir = envir.envir;
		^this.envir.setGroup(OrderedGroup before: envir[\target]);
	}
}