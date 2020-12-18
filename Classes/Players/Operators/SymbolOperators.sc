+ Symbol {

	toggle { | source, eventName |
		// if playing, stop. If not playing start.
		//	play in player named by receiver.
		//	Use source as source, if available.
		this.p(eventName).toggle(source);
	}

	use { | func | this.ev.use(func); }

	set { | ... args |
		// set group of event of symbol
		// does not set event variables!
		^this.target.set(*args);
	}

	put { | param, val |
		// set event parameter
		this.ev.put(param, val);
	}

	target { ^this.ev.target }

	ev { ^Nevent(this) }
	push { ^this.ev.push }

	addClock { | clock |
		this.clock_(clock ?? { PlayerClock() })
	}

	clock_ { | clock |
		this.ev[\clock] = clock;
	}
	clock { ^this.ev.clock }

	controls { | eventName |
		// return control inputs of current player's sourcePlayer,
		// if available
		^this.p(eventName).controls;
	}

	p { | eventName | ^Nevent(eventName ? this).player(this) }
	pp { | eventName | ^this.p(eventName).sourcePlayer }
	ppp { | eventName | ^this.p(eventName).process }
	stop { | eventName | ^this.p(eventName).stop }

	playRoutine { | key, func | ^this.ev.playRoutine(key, func)}
	playLoop { | key, func | ^this.ev.playLoop(key, func)}
	playEnvEvent { | key, func | ^this.ev.playEnvEvent(key, func)}

	copyAudio { | reader, numChans = 1, outParam = \out, inParam = \in |
		/* Connect writer with reader via an intermediate player which copies
			the output from the writer's output bus to the reader's input bus.
			numChans only matters if neither the reader nor the writer already have a bus.
		*/
		var writer, writersChans, readersChans, linker;
		writer = this.ev;
		reader = reader.ev;
		writersChans = writer.audioBusChans(outParam);
		readersChans = reader.audioBusChans(inParam);
		/* writers channels overwrite channels if existent.
			otherwise readers channels overwrite channels if existent.
			otherwise numChans argument provides the number of channels. */
		if (writersChans.notNil) {
			numChans = writersChans;
		}{ // if no writersChans were present, try to get these from reader
			readersChans !? { numChans = readersChans }
		};
		// Use buses from writer and reader, if they exist.
		linker = format("_link_%_", UniqueID.next).asSymbol.ev;
		linker.addAudioBus(\in, writer.getAudioBus(outParam, numChans));
		linker.addAudioBus(\out, reader.getAudioBus(inParam, numChans));
		writer addReader: linker;
		linker addReader: reader;
		{ In.ar(\in.kr, numChans) } +> linker.name.persist;
	}
	persist { | eventName |
		// make this player restart whenever groups are re-created.
		^this.p(eventName).persist;
	}
	auto { | eventName |
		// make this player restart whenever Main-run is called
		^this.p(eventName).auto;
	}
	start { | source, eventName |
		^this.play(source, eventName);
	}
	play { | source, eventName |
		^this.p(eventName).play(source);
	}
	clear { | eventName |
		// empty process of PatternPlayer
		^this.p(eventName).clear;
	}
	asPlayer { | envir |
		^Nevent(envir ? this).push.player(this);
	}

	asPersistentBusProxy { | param = \out |
		^PersistentBusProxy(this, param);
	}

	isPlaying { ^this.p.isPlaying }

	<@ { | val | ^this.bus.set(val) }

	@> { | envir, param = \freq |
		// map bus named by me to param in envir
		// debugged 12 Nov 2020 11:20:
		// postf("mapping parameter % of envir % to bus %\n", param, envir, this);
		^envir.map(param, this);
		// ^envir.map(param ? \freq, this);
	}

	map { | ... paramBusPairs |
		// map parameter - bus pairs named by symbols
		var envir;
		envir = this.envir;
		paramBusPairs pairsDo: { | param, bus |
			envir.put(param, bus.bus);
		};
	}

	+> { | player, index = 0 |
		// play named SynthDef in player. (or player as source to fx function!)
		// Push environment before playing.
		// See optional 4th argument in Nevent:play for push.
		// Instead of envir name, adverb is an index of the fx to be added.
		// The index is only used when player is a Function (not a player).
		// accept non-symbol player arg
		^player.asPlayer(this).play(this, index);
	}

	// ================ LINKING PLAYERS ================
	//	player { | envir | ^(envir ? this) }
	*> { | reader, param = \out | // many writers to one reader.
		// Readers bus stays same
		// The new writer gets the reader's bus.
		// Thus a new writer is added to the reader.
	     ^reader.asPersistentBusProxy(\in) linkReadersBus2Writer: (
	           PersistentBusProxy(this, param)
         )
	}

	*< { | reader, param = \out | // many readers to one writer.
		// Writers bus stays same
		// The new reader gets the writer's bus.
		// Thus a new reader is added to the writer.
	     ^reader.asPersistentBusProxy(\in) linkWritersBus2Reader: (
	           PersistentBusProxy(this, param)
         )
	}

	soundIn { | chan = 0 |
		// TODO: play soundin in players envir. Add numChannels argument
		var soundinPlayer;
		soundinPlayer = format("%_%", \soundin, this).asSymbol;
		soundinPlayer *> this;
		{ SoundIn.ar(chan) } +> soundinPlayer;
	}

	// ================================================================
	// different actions depending on argument
	// see also @> for mapping busses
	<+ { | argument, envir |
		// argument interprets this differently according to class
		// See file ArgSetParameter.sc
		argument.setParameter(this, envir.ev);
	}

	/* // ????????????????
	<* { | argument, envir |
		//		argument.
	}
	*/

	@ { | param, numChannels = 1 |
		// Create PersistentBusProxy. Useful for linking envirs with busses.
		^PersistentBusProxy(this, param, numChannels);
	}

	// ================================================================
	// For MIDI, custom messages are needed to construct the MIDI func
	// with the message that sets the parameter receiver as player symbol parameter.

	putSpec { | param, spec, envir |
		this.p(envir).putSpec(param, spec.asSpec);
	}

	getSpec { | param, envir |
		this.p(envir).getSpec(param, param.asSpec)
	}

	playBuf { | playerName, startpos = 0, dur |
		/* Utility. Play buffer for given duration
			Default duration is inf i.e. loop buffer forever.
			with playbuf. */
		{
			PlayBuf.ar(
				this.b.numChannels,
				this.b,
				\rate.kr(1),
				// \trig.kr(1),
				Impulse.kr(\period.kr(9e10).reciprocal),
				\startpos.kr((startpos * this.b.sampleRate)),
				1 // loop on
			) * \amp.kr(1)
		}.playFor(playerName, dur ? inf);
	}

	release {
		//	| fadeTime |
		// ^this.p.release(fadeTime)
		^this.p.release;
	}

	fix { ^this.p.fix }
	unfix { ^this.p.unfix }
	// additions 26 Nov 2020 20:21
	onStart { | action, listener |
		// do an action when my player starts
		var player;
		player = this.p;
		listener = listener ? this;
		listener.addNotifier(player, \started, { | ... args |
			 { action.(*args) }
		})
	}

	onEnd { | action, listener |
		// do an action when my player ends
		var player;
		player = this.p;
		listener = listener ? this;
		listener.addNotifier(player, \stopped, { | ... args |
			{ action.(*args) }
		})
	}
}