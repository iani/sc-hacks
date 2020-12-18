// 25 Sep 2017 14:06
// Different Responses to Symbol <+ argument.
/*
** TODO 3. Symbol =<+= Number: Set parameter
** TODO 4. Symbol =<+= Function: Map parameter
** TODO 5. Symbol =<+= Env: Map parameter
** TODO 6. Symbol =<+= Symbol: Set bufnum
*/

+ SimpleNumber {
	// if Symbol <+ SimpleNumber, then set symbol as parameter in envir to number.
	/*
	setParameter { | paramName, envir |
		postf("Debuging: envir, %, currentEnvironment %, using: %\n",
			envir, currentEnvironment, if(envir.isNil) { currentEnvironment } { envir.e };
		);
		envir.ev.put(paramName, this);
		// ^(if(envir.isNil) { currentEnvironment } { envir.ev }).put(paramName, this);
	}
	*/

	setParameter { | paramName = \test, envir |
		// currentEnvironment.postln;
		// envir.ev.postln;
		envir.put(paramName, this);
	}
}

+ Function {
	// if Symbol <+ Function, then map symbol as parameter in envir to bus index.
	// Create bus if needed, play function using bus index for outbus,
	// then set parameter to bus.
	// The mapping is done through code in dispatcher of Nevent and in SynthPlayer.
	setParameter { | paramName, adverb |
		var envir, bus, synth, numChannels = 1;
		// (if(envir.isNil) { envir = currentEnvironment } { envir = envir.ev });
		/*
		if (adverb isKindOf: Integer) {
			envir = nil.ev;
			numChannels = adverb;
		}{
			envir = adverb.ev;
		};
		*/
		switch (adverb.class,
			Integer, { numChannels = adverb; },
			Symbol, { envir = adverb.e; }
		);
		envir = envir.ev; // see Nil:ev, Symbol:ev
		bus = envir.at(paramName);
		if (bus isKindOf: Bus) {
			// this releases previous synths.
			bus.changed(\newSource);			
		}{
			bus = Bus.control(Server.default, numChannels);
		};
		synth = this.play(outbus: bus.index);
		synth.onStart(this, { // map the bus only after the source has started.
			// The mapping is done through code in dispatcher of Nevent and in SynthPlayer.
			envir.put(paramName, bus);
			synth.addNotifier(bus, \newSource, {
				synth.free;
				synth.objectClosed;
			});
			synth.addNotifier(envir, paramName, {
				synth.free;
				synth.objectClosed;
			});
		});

		^bus;
	}
}



+ Env {
	// Create function playing env in control EnvGen, and setParameter to it.
	setParameter { | paramName, envir |
		{ EnvGen.kr(this, 1, doneAction: 2) }.setParameter(paramName, envir);
	}
}

+ Symbol {
	// new version:
	// set parameter to bus named by self
	setParameter { | paramName, envir |
		envir.put(paramName, this.bus);
	}

	/* // old version:
	// set parameter to bufnum of buffer.
	setParameter { | paramName, envir |
		var buffer;
		buffer = this.b;
		if (buffer.isNil) {
			postf("Could not find a buffer named '%'\n", this);
		}{
			buffer.bufnum.setParameter(paramName, envir);			
		}		
	}
	*/
}

+ Nil {
	// if function is playing in bus in this parameter,
	// then stop the function and set the parameter to nil.
	// TODO: Do we want to free the bus also? What if other parameters are also listening to the same bus?
	setParameter { | paramName, envir |
		var bus, synth;
		envir = envir.e; // see Nil:e, Symbol:e
		bus = envir.at(paramName);
		if (bus isKindOf: Bus) {
			// this releases previous synths.
			bus.changed(\newSource);
			envir[paramName] = nil;
		};
	}
}