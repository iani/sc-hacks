/*  4 Dec 2020 22:36
Adding asPlayer
*/
+ Function {
	asPlayer { | name |
		//  4 Dec 2020 22:13 : play functions as fx synths.
		// link them as fx after another player
		// create NPlayer, which accepts play message to make the link
		// this function becomes the synth source for the player at index
		^NPlayer.named(name); //.getPlayerAt(index).setSource(this);
	}
	!> { | player, envir |
		// under development 26 Nov 2020 18:58
		// Remove all keys from envir which correspond to your controls,
		// with the exception of \in and \out.
		// Then play self in player
		// Removal of keys will set their values to your defaults
		// Just before the new synth starts.
		// TODO ....
	}
	+> { | player, envir |
		// play function as SynthPlayer
		^player.asPlayer(envir).play(this); // accept non-symbol player arg
	}

	*> { | key, envir |
		// play function as routine. Note different argumnent+adverb convention:
		// name: name where the routine will be stored.
		// envir: The (name of the) envir to play the routine in. If nil, defaults to currentEnvir.
		(envir ? currentEnvironment).playRoutine(key, this);
	}

	++> { | envir | envir.use(this) }

	**> { | key, envir |
		/* play function as routine, wrapping it in a loop statement, i.e
			{ function.loop }.fork;
		Note different argumnent+adverb convention:
		 name: name where the routine will be stored.
		 envir: The (name of the) envir to play the routine in. If nil, defaults to currentEnvir.
		*/
		(envir ? currentEnvironment).playLoop(key, this);
	}

	/// fix this !!!!!!!!!!!
	/*
		// fixing this (12 Nov 2020 12:11)
	@> { | envir, param |
		postf("mapping bus: % to param % of envir %\n", this, param, envir);
		this.map(envir ?? { envir.ev }, param);
	}
	*/

	@> { | bus, player |
		// Play kr function into bus.
		// Store in player.  Fix player.
		var out;
		player = (player ? bus).p;
		player.fix;
		bus = bus.bus;
		out = bus.index;
		player.envir.put(\out, out);
		player.play({ | out = 0 | Out.kr(out, this.value) });
	}
	/*
		// 13 Nov 2020 11:53:
		// Obsolete. New implementation of @> allows more fine
		// grained control of which synths are replaced or added.
	@+> { | bus |
		// Like @> but do not release previous synths
		var synth;
		bus = bus.bus;
		// bus.changed(\kr); // DO NOT FREE PREVIOUS SYNTHS
		synth = { Out.kr(\out.kr(bus.index), this.value) }.play;
		synth.addNotifier(bus, \kr, { synth.free });
	}
	*/
	// new shortcut 12 Nov 2020 12:20 - EXPERIMENTAL - UNDER EVALUATION
	/*
		Play kr function into bus with same name as param to be controlled,
		then map that bus to the parameter in envir.
	*/
	@@> { | envir, param = \freq |
		this @> param;
		envir.map(param, param);
	}

	// 12 Nov 2020 12:15 this needs revisiting
	// bus name construction is not a good solution.
	map { | envir, param, controlplayer |
		/*
			Play control rate function into bus
			controlplayer: optional name of player playing the func
		*/
		var busname;
		busname = format("%_%", envir, param).asSymbol;
		controlplayer ?? { controlplayer = busname };
		postf(
			"mapping controlplayer % to param % of envir % using bus %\n",
			controlplayer,
			param,
			envir,
			busname
		);
		envir.map(param, busname);
		{ Out.kr(busname.bus.index, this.value) } +> controlplayer;
		^controlplayer;
	}

	playFor { | playerName, dur = 1 |
		/* Utility. Play in player for given duration.
			DONE: Enable time-overlapping calls to playFor
			on the same player:
			stop the previous routine if a new playFor
			is sent while the routine is still playing.
		*/
		var routine;
		playerName.changed(\playFor);
		// "!!!!!!!!!!!!!!!!!! OUTSIDE !!!!!!!!!!!!!!!!!!!".postln;
		// currentEnvironment.postln;
		routine = {
			this +> playerName;
			//	"!!!!!!!!!!!!!!!!!! INSIDE !!!!!!!!!!!!!!!!!!!".postln;
			// currentEnvironment.postln;
			dur.wait;
			playerName.stop;
			routine.removeNotifier(playerName, \playFor);
		}.fork;
		playerName.push;
		routine.addNotifier(playerName, \playFor, { | n |
			n.listener.stop;
		});
	}
}