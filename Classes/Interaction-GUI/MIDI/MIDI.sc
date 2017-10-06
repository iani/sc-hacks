//  6 Oct 2017 20:05
// Shortcuts for binding midi to Nenvir parameters (and other stuff, maybe)

MIDI {
	// proxy for creating MIDIfuncs with operators
	var <type, <chan, <num, <srcID, <func;

	*new { | type = \cc, chan = 0, num = 0, srcID, func |
		^this.newCopyArgs(type, chan, num, srcID, func);
	}

	setParameter { | paramName, envir |
		// called by Symbol <+ midi.
		^envir.e.setMIDIparam(paramName, this);
	}

	asMIDIFunc { | envir, paramName, spec |
		// Create MIDIFunc setting paramName in envir.
		// Use spec to map input midi values to target values
		if (func.isNil) {
			func = { | ... args |
				args.postln;
			};
		};
		^MIDIFunc.perform(type, func, num, chan, srcID);
	}
}

+ Nevent {
	setMIDIparam { | paramName, midi |
		// Limitation of this implementation:
		// Only one MIDIFunc allowed per parameter name and Nevent.
		var midiFunc;
		midiFunc = this.at_(\midi, paramName);
		midiFunc !? { midiFunc.free };
		this.put_(\midi, paramName, midi.asMIDIFunc);
	}
	
}