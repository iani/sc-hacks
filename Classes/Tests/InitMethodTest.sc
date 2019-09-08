
TestSuperClass {
	var <argTestVar;
	
	*new { | argTestVar |
		^this.newCopyArgs(argTestVar).init;
	}

	init {
		"this is the superclass init method called".postln;
	}
}

TestSubClass : TestSuperClass {
	*new { | argTestVar |
		^super.new(argTestVar)
	}

	init {
		"This is the SUBCLASS init method called".postln;
	}

}