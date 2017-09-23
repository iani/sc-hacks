Nevent : EnvironmentRedirect {
	classvar <libRoot = \environments;
	var <name, <players, busses, <writers;

	/* // not needed? Check?
	e {
		// return self.
		//	Used in PersistentBusProxy in conjunction with *> and newIn
	}
	*/
	*all {
		^Registry.at(libRoot).values;
	}

	*play { | envirName, playerName, source, doPush = true |
		// Get player for environment by name and play source.
		^this.new(envirName, doPush).player(playerName).play(source);
	}
	
	*new { | name, doPush = false |
		^Registry(libRoot, name, {
			this.newCopyArgs((), nil, name, ())
			.makeDispatch(() putPairs: [
				Integer, { | key, object |
					[key, object]
				},
				Float, { | key, object |
					[key, object]
				}
			])
			.init
			.maybePush(doPush)
		})
	}

	makeDispatch { | dispatcherEvent |
		dispatch = Dispatch.newCopyArgs(this, dispatcherEvent);
	}

	init {
		this[\target] = OrderedGroup.last;
 		writers = Set();
	}

	maybePush { | doPush = false |
		if (doPush and: { currentEnvironment !== this}) { this.push };
	}

	player { | playerName |
		// return player corresponding to playerName
		var player;
		^players.atFail(playerName, {
			player = Player(this, playerName);
			players[playerName] = player;
			player;
		});
	}

	getAudioBus { | param = \in, numChannels = 1 |
		/* get an audio bus. If not present create one, store it under busses,
			and set param's value to busses index in event. */
		^this.busses.atFail(
			param, { PersistentBus.makeAudio(this, param, numChannels) }
		)
	}

	addAudioBus { | param = \out, persistentBus |
		persistentBus.addAudio2Envir(this, param);
	}

	updateBusIndex { | param, busIndex |
		// make sure all players update their processes or settings with the new index.
		this.put[param, busIndex];
		// SynthPlayers immediately respond to this through their connectPlayer notification method.
		// PatternPlayers update their source or process.
		players do: _.put(param, busIndex); // only PatternPlayers respond to this.
	}

	getControlBus { | param = \in, numChannels = 1 |
		/* get an control rate bus. If not present create one, store it in event.
			and set param's value to bus in event. */
		var bus;
		^envir.atFail(
			param,
			{
				bus = PersistentBus.mapParam(this, param, numChannels);
				envir[param] = bus;
				bus;
			}
		)		
	}

	busses {
		busses ?? { busses = ( ) };
		^busses;
	}

	printOn { | stream |
		if (stream.atLimit) { ^this };
		stream << name << "[ " ;
		envir.printItemsOn(stream);
		stream << " ]" ;
	}

	moveBefore { | readerEnvir |
		if (this.allWriters(Set()) includes: readerEnvir) {
			postf("cannot move % before %: cycles not permitted\n", this, readerEnvir);			
		}{
			this moveGroupBefore: readerEnvir[\target];
		};		
	}

	moveGroupBefore { | argGroup |
		var myGroup, newGroup;
		myGroup = this[\target];
		newGroup = myGroup getGroupBefore: argGroup;
		writers do: _.moveBefore(newGroup);
		if (newGroup !== myGroup) { this setGroup: newGroup };
	}

	setGroup { | orderedGroup |
		this[\target] = orderedGroup;
		players do: _.setTarget(orderedGroup);
		"INCOMPLETE!:".postln;
		postf("% does not know how to inform that it has set group to %\n", this, orderedGroup);
	}
	
	allWriters { | set |
		// Collect yourself, and all your writers, and all your writers writers etc. into set.
		//	Return set.
		writers do: _.allWriters(set);
		^set add: this;
	}

}