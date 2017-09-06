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
	p { | eventName | ^Nevent(eventName ? this).player(this) }
	pp { | eventName | ^this.p(eventName).sourcePlayer }
	ppp { | eventName | ^this.p(eventName).process }
	
	+> { | player, envir |
		// play named SynthDef in player.
		// Push environment before playing. See optional 4th argument in Nevent:play for push.
		^Nevent.play(envir ? player, player, this);
	}

	//	player { | envir | ^(envir ? this) }
	
	*> { | player, param |
		// link receiver to argument via bus

	}

	<+ { | player, envir |
		// bind kr synth-function to parameter
		
	}

	<* { | player, envir |
		// play function as routine

		}

	@ { | player, envir |
		// play function as routine

	}
}

+ Function {
	+> { | player, envir |
		// play function as SynthPlayer
		^Nevent.play(envir ? player, player, this)
	}

	*> { | player, envir |
		// play function as routine

	}


}

+ Event {
	+> { | player, envir |
		// play function as PatternPlayer
		^Nevent.play(envir ? player, player, this)
	}
	p {
		^EventPattern(this).play;
	}
}