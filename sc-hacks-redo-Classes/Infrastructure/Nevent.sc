Nevent : EnvironmentRedirect {
	classvar <libRoot = \environments;
	var <name, <players;
	*all {
		^Registry.at(libRoot).values;
	}

	*play { | envirName, playerName, source |
		// Get player for environment by name and play source.
		^this.new(envirName).player(playerName).play(source);
	}
	
	*new { | name |
		^Registry(libRoot, name, {
			this.newCopyArgs(
				(),
				Dispatch.newCopyArgs(
					this, (
						Integer: { | key, object |
							[key, object]
						},
						Float: { | key, object |
							[key, object]
						}
					)
				),
				name, ()
			).setGroup(OrderedGroup.last);
		})
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