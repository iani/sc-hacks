Nevent : EnvironmentRedirect {
	classvar <libRoot = \environments;
	var <name, <players, busses;
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
			.maybePush(doPush)
		})
	}

	makeDispatch { | dispatcherEvent |
		dispatch = Dispatch.newCopyArgs(this, dispatcherEvent);
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
	setGroup { | orderedGroup |
		this.put(\target, orderedGroup.group);
		this.addNotifier(orderedGroup, \group, { | group |
			this.put(\target, group);
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
}