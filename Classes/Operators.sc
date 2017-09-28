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
	b { ^AudioFiles.buffers[this] }
	bufnum {
		var buffer;
		buffer = this.b;
		if (buffer.isNil) {
			postf("could not find buffer named '%'. Returning 0\n", this);
			^0;
		} {
			^buffer.bufnum;
		}
	}

	toggle { | source, eventName |
		// if playing, stop. If not playing start.
		//	play in player named by receiver.
		//	Use source as source, if available. 
		var player;
		player = this.p(eventName);
		if (player.isPlaying) { player.stop} { player.push.play(source) };
	}

	toggleBuf { | bufferName, eventName |
		// like toggle, but use as source a PlayBuf func with appropriate number of channels.
		var buffer, numChans, bufnum;
		bufferName ?? { bufferName = this };
		buffer = bufferName.b;
		if (buffer.isNil) {
			postf("could not find buffer named %\n", bufferName);
		}{
			numChans = buffer.numChannels;
			bufnum = buffer.bufnum;
			this.toggle({
				PlayBuf.ar(numChans, \bufnum.kr(bufnum),
					\rate.kr(1),
					\trigger.kr(1),
					\startPos.kr(0),
					\loop.kr(1),
					2 // doneAction: free synth when done
				);
			}, eventName);
		}
	}
	
	e { ^Nevent(this) }
	push { ^this.e.push }
	p { | eventName | ^Nevent(eventName ? this).player(this) }
	pp { | eventName | ^this.p(eventName).sourcePlayer }
	ppp { | eventName | ^this.p(eventName).process }
	stop { | eventName | ^this.p(eventName).stop }
	
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

	<+ { | argument, envir |
		// argument interprets this differently according to class
		// See file ArgSetParameter.sc
		argument.setParameter(this, envir);
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