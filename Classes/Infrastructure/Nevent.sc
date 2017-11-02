Nevent : EnvironmentRedirect {
	classvar <libRoot = \environments;
	var <name, <players, busses, <writers, routines;

	/* // not needed? Check?
	e {
		// return self.
		//	Used in PersistentBusProxy in conjunction with *> and newIn
	}
	*/

	*all {
		// return array with all environments (Nevent instances).
		^Registry.at(libRoot).values;
	}
	
	*initClass {
		StartUp add: {
			ControlSpec.makeMoreDefaults; // method defined in sc-hacks
			this.new (\default, true); // pushes \default to current environment
		}; 
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
				},
				Bus, { | key, object |
					[\mapBus, key, object]
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
		if (doPush) { this.push };
	}

	push { // Avoid pushing if already current.
		if (currentEnvironment === this) {} {
			// let listeners switch listening from old to new environment:
			Nevent.changed(\oldEnvir, currentEnvironment); // GUIs remove old envir
			super.push;
			Nevent.changed(\newEnvir, this); // dependent GUIs start listening to new envir updates
		}
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

	audioBusChans { | param |
		// return the number of channels of the bus stored at param, or nil if no such bus is found.
		var bus;
		bus = this.busses[param];
		if (bus.isNil) { ^nil } { ^bus.numChannels };
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
		this.put(param, busIndex);
		// Now update players:
		// SynthPlayers update per default through their connectPlayer notification method.
		// But PatternPlayers need to update their source or process manually,
		// because they do not have connectPlayer, because they set their streams per explicit separate code.
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

	addReader { | readerEnvir |
		if (this.allWriters(Set()) includes: readerEnvir) {
			postf("cannot move % before %: cycles not permitted\n", this, readerEnvir);			
		}{
			readerEnvir.writers add: this;
			this moveGroupBefore: readerEnvir[\target];
		}
	}

	allWriters { | set |
		// Collect yourself, and all your writers, and all your writers writers etc. into set.
		// Return set.
		writers do: _.allWriters(set);
		^set add: this;
	}

	moveGroupBefore { | argGroup |
		// set the group of this environment to be before argGroup in Server order of execution.
		var myGroup, newGroup;
		myGroup = this[\target];
		newGroup = myGroup getGroupBefore: argGroup;
		writers do: _.moveGroupBefore(newGroup);
		if (newGroup !== myGroup) { this setGroup: newGroup };
	}

	setGroup { | orderedGroup |
		this[\target] = orderedGroup;
		players do: _.setTarget(orderedGroup);
	}

	atFail { | key, action |
		^envir.atFail(key, action);
	}

	routines {
		routines ?? { routines = () };
		^routines;
	}

	routine { | key |
		^this.routines[key];
	}

	playRoutine { | key, func |
		var oldRoutine;
		oldRoutine = this.routine(key);
		oldRoutine !? { oldRoutine.stop };
		this.push;
		this.routines[key] = func.fork;
	}

	playLoop { | key, func |
		this.playRoutine(key, { func.loop })
	}

	toggle {
		// If any players are playing, stop them.
		// If no players are playing, play all players.
		if (players.select(_.isPlaying).size == 0) {
			players do: _.play;
		}{
			players do: _.stop;
		}
	}
}