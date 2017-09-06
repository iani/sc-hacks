Nevent : EnvironmentRedirect {
	classvar <libRoot = \environments;
	var <name, <players;
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

}