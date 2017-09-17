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
			.setGroup(OrderedGroup.last)
			.initWriters
			.maybePush(doPush)
		})
	}

	makeDispatch { | dispatcherEvent |
		dispatch = Dispatch.newCopyArgs(this, dispatcherEvent);
	}

	initWriters { writers = Set() }

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

	addWriter { | writer |
		if (this canAddWriter: writer) {
			writers add: writer;
			writer.setGroup(OrderedGroup.before(this[\target]));
		}{
			postf("cannot add % as writer: cycles not permitted\n", writer);
		}
	}
	
	canAddWriter { | writer |
		^writer.allWriters(Set()).includes(this).not;
	}

	allWriters { | set |
		/* help method for canAddWriter.
			Collect yourself, and all your writers, and all your writers writers etc. into set.
			Return set. */
		writers do: _.allWriters(set);
		^set add: this;
	}

	setGroup { | group |
		// First set groups of your writers, then your own group.
		// This moves your writers before you, preventing any signal fallouts.
		var beforeGroup;
		if (writers.size > 0) {
			beforeGroup = OrderedGroup.before(group);
			writers do: _.setGroup(beforeGroup);			
		};
		this[\target] = group;  // SynthPlayers move their Synth to the head of this group
	}
}