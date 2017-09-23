/* 14 Aug 2017 21:25

- Symbol +> *> <+ <* @
- Function: +> *>
- Event +> *>

-------+------------+------------+--------------------------------------|
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
	e { ^Nevent(this) }
	push { ^this.e.push }
	p { | eventName | ^Nevent(eventName ? this).player(this) }
	pp { | eventName | ^this.p(eventName).sourcePlayer }
	ppp { | eventName | ^this.p(eventName).process }
	stop { | eventName | ^this.p(eventName).stop }
	newIn { | param = \in, numChannels = 1 |
		/* give this event a private newly-allocated bus.
			This prevents synths using Fin from feedbacking on the 0 bus,
			without having to link them to any other event. */
		var event;
		event = Nevent(this);
		PersistentBus.makeAudio(event, param, numChannels);
		// ^this.asPlayer; // return this. Will work with *>
	}
	play { | source, eventName |
		^this.p(eventName).play(source);
	}
	clear { | eventName |
		// empty process of PatternPlayer
		^this.p(eventName).clear;
	}
	asPlayer { | envir |
		^Nevent(envir ? this).player(this);
	}

	asPeristentBusProxy { | param = \out |
		^PersistentBusProxy(this, param);
	}

	+> { | player, envir |
		// play named SynthDef in player.
		// Push environment before playing. See optional 4th argument in Nevent:play for push.
		^player.asPlayer(envir).play(this); // accept non-symbol player arg
	}

	//	player { | envir | ^(envir ? this) }
	
	*> { | reader, param = \out |
		// the argument/reader gets one more writer.
		// result: several sources/writers to one effect/reader configuration.
		^PersistentBusProxy(this, param) *> reader.asPeristentBusProxy(\in);
	}

	*< { | reader, param = \out |
		// the receiver/writer gets one more reader.
		// result: one source/writer to several effects/writers configuration.
		^PersistentBusProxy(this, param) *< reader.asPeristentBusProxy(\in);
	}

	<+ { | player, envir |
		// bind kr synth-function to parameter
		
	}

	<* { | player, envir |
		// play function as routine

		}

	@ { | param, numChannels = 1 |
		// Create PersistentBusProxy. Useful for linking enirs with busses.
		^PersistentBusProxy(this, param, numChannels);
	}
}

+ Function {
	+> { | player, envir |
		// play function as SynthPlayer
		^player.asPlayer(envir).play(this); // accept non-symbol player arg	
	}

	*> { | player, envir |
		// play function as routine

	}


}

+ Event {
	+> { | player, envir |
		// play Event as PatternPlayer
		^player.asPlayer(envir).play(this); // accept non-symbol player arg	
	}
	p {
		^EventPattern(this).play;
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
		// argument as reader                                 receiver as writer
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