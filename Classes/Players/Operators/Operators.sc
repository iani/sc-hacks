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

================================================================
New (26 Nov 2020 18:58) - under development:

Function !> Symbol: Set envir's params to my defaults, then play me
in player.
*/

+ Event {
	+> { | player, envir |
		// play Event as PatternPlayer
		^player.asPlayer(envir).play(this); // accept non-symbol player arg
	}

	*> { | playerName, envir |
		// play Event as PatternPlayer of type \envEvent;
		// playerName: name where the PatternPalayer will be stored.
		// envir: The (name of the) envir to play the routine in. If nil, defaults to currentEnvir.
		//		playerName.p(envir.ev).playEnvEvent(this)
		playerName.p(envir.ev.name).playEnvEvent(this)
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
		player.p(envir.ev.name).stop;
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

+ Integer {
	// set control busses by number
	<@ { | value |
		Bus(\control, this, 1).set(value);
	}
}
