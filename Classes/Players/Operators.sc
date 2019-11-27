/* 14 Aug 2017 21:25

- Symbol +> *> <+ <* @
- Function: +> *>
- Event +> *>

|------------+------------+------------+--------------------------------------|
| *receiver* | *operator* | *argument* | *action*                             |
|------------+------------+------------+--------------------------------------|
| Symbol     | =+>=       | Symbol     | Play Synthdef                        |
| Symbol     | =*>=       | Symbol     | Link Players                         |
| Symbol     | =<+=       | Number     | Set parameter                        |
| Symbol     | =<+=       | Function   | Map parameter                        |
| Symbol     | =<+=       | Env        | Map parameter                        |
| Symbol     | =<*=       | Symbol     | Set bufnum                           |
| Symbol     | =<*=       | MIDI       | Bind MIDIFunc                        |
| Symbol     | =<*=       | OSC        | Bind OSCFunc                         |
| Symbol     | =<*=       | Widget     | Bind GUI Widget                      |
| Function   | =+>=       | Symbol     | Play Synth                           |
| Function   | =*>=       | Symbol     | Play Routine                         |
| Event      | =+>=       | Symbol     | Play Pattern in Player               |
| Event      | =*>=       | Symbol     | Play Pattern in Player's Environment |
| UGen       | =<+=       | Symbol     | Read input from Player's Output      |

*/

+ Symbol {

	toggle { | source, eventName |
		// if playing, stop. If not playing start.
		//	play in player named by receiver.
		//	Use source as source, if available. 
		this.p(eventName).toggle(source);
	}

	use { | func | this.e.use(func); }

	set { | ... args |
		// set group of event of symbol
		// does not set event variables!
		^this.target.set(*args);
	}

	put { | param, val |
		// set event parameter
		this.e.put(param, val);
	}
	
	target { ^this.e.target }
	
	e { ^Nevent(this) }
	push { ^this.e.push }

	addClock { | clock |
		this.clock_(clock ?? { PlayerClock() })
	}

	clock_ { | clock |
		this.e[\clock] = clock;
	}
	clock { ^this.e.clock }
	
	p { | eventName | ^Nevent(eventName ? this).player(this) }
	pp { | eventName | ^this.p(eventName).sourcePlayer }
	ppp { | eventName | ^this.p(eventName).process }
	stop { | eventName | ^this.p(eventName).stop }

	playRoutine { | key, func | ^this.e.playRoutine(key, func)}
	playLoop { | key, func | ^this.e.playLoop(key, func)}
	playEnvEvent { | key, func | ^this.e.playEnvEvent(key, func)}
	
	copyAudio { | reader, numChans = 1, outParam = \out, inParam = \in |
		/* Connect writer with reader via an intermediate player which copies 
			the output from the writer's output bus to the reader's input bus.
			numChans only matters if neither the reader nor the writer already have a bus.
		*/ 
		var writer, writersChans, readersChans, linker;
		writer = this.e;
		reader = reader.e;
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
		linker = format("_link_%_", UniqueID.next).asSymbol.e;
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

	map { | ... paramBusPairs |
		// map parameter - bus pairs named by symbols
		var envir;
		envir = this.envir;
		paramBusPairs pairsDo: { | param, bus |
			envir.put(param, bus.bus);
		};
	}
	
	+> { | player, envir |
		// play named SynthDef in player.
		// Push environment before playing.
		// See optional 4th argument in Nevent:play for push.
		^player.asPlayer(envir).play(this); // accept non-symbol player arg
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
	<+ { | argument, envir |
		// argument interprets this differently according to class
		// See file ArgSetParameter.sc
		argument.setParameter(this, envir.e);
	}

	/* // ????????????????
	<* { | argument, envir |
		//		argument.
	}
	*/

	@ { | param, numChannels = 1 |
		// Create PersistentBusProxy. Useful for linking enirs with busses.
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
}

+ Function {
	+> { | player, envir |
		// play function as SynthPlayer
		^player.asPlayer(envir).play(this); // accept non-symbol player arg	
	}

	*> { | key, envir |
		// play function as routine. Note different argumnent+adverb convention:
		// name: name where the routine will be stored.
		// envir: The (name of the) envir to play the routine in. If nil, defaults to currentEnvir.
		(envir ? currentEnvironment).playRoutine(key, this);
	}

	++> { | envir | envir.use(this) }

	**> { | key, envir |
		/* play function as routine, wrapping it in a loop statement, i.e
			{ function.loop }.fork;
		Note different argumnent+adverb convention:
		 name: name where the routine will be stored.
		 envir: The (name of the) envir to play the routine in. If nil, defaults to currentEnvir.
		*/
		(envir ? currentEnvironment).playLoop(key, this);
	}

	map { | envir, param, controlplayer |
		/* DRAFT!
			Play control rate function into bus
		*/
		var busname;
		busname = format("%_%", envir, param).asSymbol;
		controlplayer ?? { controlplayer = busname };
		envir.map(param, busname);
		{ Out.kr(busname.bus.index, this.value) } +> controlplayer;
	}

	playFor { | playerName, dur = 1 |
		/* Utility. Play in player for given duration.
			DONE: Enable time-overlapping calls to playFor
			on the same player:
			stop the previous routine if a new playFor
			is sent while the routine is still playing.
		*/
		var routine;
		playerName.changed(\playFor);
		// "!!!!!!!!!!!!!!!!!! OUTSIDE !!!!!!!!!!!!!!!!!!!".postln;
		// currentEnvironment.postln;
		routine = {
			this +> playerName;
			//	"!!!!!!!!!!!!!!!!!! INSIDE !!!!!!!!!!!!!!!!!!!".postln;
			// currentEnvironment.postln;
			dur.wait;
			playerName.stop;
			routine.removeNotifier(playerName, \playFor);
		}.fork;
		playerName.push;
		routine.addNotifier(playerName, \playFor, { | n |
			n.listener.stop;
		});
	}
}

+ Event {
	+> { | player, envir |
		// play Event as PatternPlayer
		^player.asPlayer(envir).play(this); // accept non-symbol player arg	
	}

	*> { | playerName, envir |
		// play Event as PatternPlayer of type \envEvent;
		// playerName: name where the PatternPalayer will be stored.
		// envir: The (name of the) envir to play the routine in. If nil, defaults to currentEnvir.
		//		playerName.p(envir.e).playEnvEvent(this)
		playerName.p(envir.e.name).playEnvEvent(this)
	}
	p {
		^EventPattern(this).play;
	}

	playFunc { | function, rates, prependArgs, outClass=\Out, fadeTime = 0.02, name |
		// play given function as instrument in the event.
		name = name ?? { SystemSynthDefs.generateTempName };
		function.asPlayerSynthDef (rates, prependArgs, outClass, fadeTime, name).add;
		this.put(\instrument, name);
	}
}

+ Player {
	asPlayer { ^this }
}

+ PersistentBusProxy {
	*> { | envirOrProxy, inParam = \in |
		// the argument/reader gets one more writer.
		// result: several sources/writers to one effect/reader configuration.
		// receiver is writer, argument is reader.
		// argument as reader / receiver as writer
		^envirOrProxy.asPeristentBusProxy(inParam) addWriter: this;
	}
	*< { | envirOrProxy, inParam = \in |
		// the receiver/writer gets one more reader.
		// result: one source/writer to several effects/writers configuration.
		// receiver is writer, argument is reader.
		// receiver as writer / argument as reader
		^this addReader: envirOrProxy.asPeristentBusProxy(inParam);
	}
}

+ Nil {
	e { ^currentEnvironment }

	+> { | player, envir |
		// stop envir-player named player in envir
		player.p(envir.e.name).stop;
	}
}

// ================================================================
// new, 11 Feb 2018 11:59: support playing buffers in beat patterns.  Inspired by tidal.
// 18 Jan 2019 11:15 Will be remodeled to work with Beat and Cycle classes
+ String {
	+> { | player, envir |
		var buffers, instruments;
		#buffers, instruments = this.split($ ).collect { | name |
			Registry.at(\tidal)[name.asSymbol];
		}.flop;
		player = player.asPlayer;
		player.postln;
		player.envir.postln;
		player.envir[\quant] ?? {
			player.envir[\quant] = 1;
		};
		player.asPlayer(envir) play: 
		(instrument: instruments.pseq, buf: buffers.pseq, dur: 1 / instruments.size, rate: 1) 
		/* parse the string as a sequence of buffer names from SuperDirt
			tempoClock is the clock for synchronizing the pattern.
			Possible future implementation: use clockPlayer as a name of the kr player
			that generates the beats, where the kr player outputs the beats in a kr bus.
		*/
	}
	
}