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
		// The left argument gives its bus to the right argument.
		// Link receiver to argument via bus with default parameter order \out, \in.
		// Param defines the param name of the receiver.
		// Use proxy to permit fuller specs via @ composition.
		var bus;
		// bus = 
		^PersistentBusProxy(this, param).addReader(reader.asPeristentBusProxy(\in))
	}

	*< { | reader, param = \out |
		// the reader should give its bus to the writer.
		postf("*<: writer is: %,\n reader is: %\n",
			this.e, reader.e
		);
		"*< Must be redesigned. Please wait for next version".postln;
		// writer 
		^PersistentBusProxy(reader, \in).addReader(this.asPeristentBusProxy(param));
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
		^this linkTo:  envirOrProxy.asPeristentBusProxy(inParam);
	}
	*< { | envirOrProxy, outParam = \out |
		^envirOrProxy.asPeristentBusProxy(outParam) linkTo: this;
	}
}