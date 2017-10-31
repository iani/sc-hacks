//  6 Oct 2017 20:05
// Shortcuts for binding midi to Nenvir parameters (and other stuff, maybe)

MIDI {
	// proxy for creating MIDIfuncs with operators
	var <spec, <type, <chan, <num, <srcID, <func;

	*new { | spec, type = \cc, chan = 0, num = 0, srcID, func |
		^this.newCopyArgs(spec.asSpec, type, chan, num, srcID, func ?? { | ... args |
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
		//		^MIDIFunc.perform(type, func, num, chan, srcID); 
		// This works also for touch, bend, and program MIDIFunc types:
		^MIDIFunc(func, num, chan, type, srcID);
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

	putSpec { | param, prototype |
		this.put_(\specs, param, prototype.asSpec);
	}

	getSpec { | param |
		^this.at_(\specs, param) ?? {
			// If none is found, a new one is stored for defaults here.
			// But this can be overwritten at any time later, by:
			// ControSpec.put_(\specs, param, <new spec>);
			ControlSpec.get_(\specs, param, {
				param.asSpec ?? { \unipolar.asSpec }
			}) 
		};
	}

}

+ Object {
	cc { | num, chan = 0, srcID, func | ^MIDI(\control, chan, num, func) }
	noteOn { | num, chan = 0, srcID, func | ^MIDI(thisMethod.name, chan, num, srcID, func) }
	noteOff { | num, chan = 0, srcID, func | ^MIDI(thisMethod.name, chan, num, srcID, func) }
	polytouch { | num, chan = 0, srcID, func | ^MIDI(thisMethod.name, chan, num, srcID, func) }
	touch { | chan = 0, srcID, func | ^MIDI(thisMethod.name, chan, nil, srcID, func) }
	bend { | chan = 0, srcID, func | ^MIDI(thisMethod.name, chan, nil, srcID, func) }
	program { | chan = 0, srcID, func | ^MIDI(thisMethod.name, chan, nil, srcID, func) }
}
