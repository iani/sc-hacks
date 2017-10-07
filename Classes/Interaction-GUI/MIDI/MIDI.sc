//  6 Oct 2017 20:05
// Shortcuts for binding midi to Nenvir parameters (and other stuff, maybe)

MIDI {
	// proxy for creating MIDIfuncs with operators
	var <type, <chan, <num, <srcID, <func;

	*new { | type = \cc, chan = 0, num = 0, srcID, func |
		^this.newCopyArgs(type, chan, num, srcID, func ?? { | ... args |
			postf("empty midi func: type: %, chan: %, num: %, received: %\n",
				type, chan, num, args
			);
		});
	}

	setParameter { | paramName, envir |
		// called by Symbol <+ midi.
		^envir.e.setMIDIparam(paramName, this);
	}

	asMIDIFunc { | argFunc |
		// Create MIDIFunc setting paramName in envir.
		// Use spec to map input midi values to target values
		argFunc !? { func = argFunc };
		^MIDIFunc.perform(type, func, num, chan, srcID);
	}
}

+ Nevent {
	setMIDIparam { | paramName, midi |
		// Limitation of this implementation:
		// Only one MIDIFunc allowed per parameter name and Nevent.
		var spec;
		this.at_(\midi, paramName).free;
		spec = this.getSpec(paramName);
		this.put_(\midi, paramName, midi asMIDIFunc: { | val |
			this.put(paramName, spec.map(val / 127));			
		});
	}
	
}

+ Integer {
	cc { | chan = 0, srcID, func |
		^MIDI(\cc, chan, this, srcID, func);
	}
}
