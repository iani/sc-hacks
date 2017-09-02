SynthPlayer : SHPlayer {
	var <def, <controlNames, <hasGate = false;

	def_ { | argDef |
		var parName;
		def = argDef;
		controlNames = def.allControlNames reject: { | a |
			if (a.name === \gate) { // gate supplied by makeSynthArgs!
				hasGate = true;
			}{
				a.rate === \scalar
			};
		} collect: { | cn |
			parName = cn.name;
			// only set value if no other synth has set it before.
			// avoid changing other synths parameters with your defaults:
			(envir [parName]) ?? {
				// storing params here is useful if a gui is opened later:
				// but could be replaced by getting the gui defaults from
				// customized specs stored for each def. (TODO:!)
				envir [parName] = cn.defaultValue;
				// envir.changed(parName, cn.defaultValue)
			};
			parName;
		};
		// hasGate = controlNames includes: 'gate';
		// def.add; // done separately in makeSynth
	}

	makeSynthArgs {
		// create array of arguments to initialize new synth, from environment.
		var args, busses, numCtls, val;
		numCtls = controlNames.size + 1 * 2;
		args = Array.new(numCtls);
		busses = Array.new(numCtls);
		controlNames do: { | name |
			val = envir[name];
			switch(val.class,
				Nil, { },
                Bus, { busses add: name; busses add: val },
                { args add: name; args add: val }
            );
		};
		args add: \gate;
		if (busses.size > 0) {
			args add: 0
		}{
			args add: 1
		};
		^[args, busses];
		
	}

	stop { | releaseTime |
		synth ?? { ^this };
		synth.objectClosed;
		if (hasGate) {
			synth release: (releaseTime ? envir [\fadeTime] ? 0.02);
		}{
			synth.free;
		};
		synth = nil;
	}

	// mainly for calls via EventPattern:
	tie {
		// Do not change synth status.  Param changes effect legato
	}

	null { // synonym of tie
		// Do not change synth status.  Param changes effect legato
	}
	
	mute {
		
	}

	unmute {
		
	}

	trigger {
		
	}

	release {
		
	}

	clear { // ? just use remove instead?
		
	}

	remove { // clear and remove from Registry
		
	}

	// ================================================================
	// GUI - experimental
	gui { | specs |
		// create gui for this player.
		/* // simple usage example: 
			\default +> \testgui1 gui: [\freq, \amp]; // uses current envir
			\default +>.env2 \testgui1 gui: [\freq, \amp]; // uses env2 as envir
		*/
		if (specs.size == 0) {
			name.sliders(*controlNames.collect(this.getGuiSpec(_)));
		}{
			name.sliders(*specs);
		};
	}

	getGuiSpec { | argName |
		var spec;
		spec = Registry.at(\synthPlayers, this, \specs, argName);
		spec ?? { spec = argName.asSpec ?? { \amp.asSpec }};
		^[argName, spec.storeArgs];
	}
}