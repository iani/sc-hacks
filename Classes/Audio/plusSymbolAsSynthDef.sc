//: 17 Jan 2021 20:14
/*
Used by SynthPlayer to set its source to a valid SynthDef.
See operator Symbol:+>! 

Return def found in SynthDescLib.
If no def is found, this throws an error.  This is preferable to silently
returning default SynthDef
*/

+ Symbol {
	asPlayerSynthDef { | fadeTime, name |
		// fadeTime and name arguments are ignored, but they are
		// defined above to suppress warning when calling from SynthPlayer
		^SynthDescLib.at(this).def;
	}
}