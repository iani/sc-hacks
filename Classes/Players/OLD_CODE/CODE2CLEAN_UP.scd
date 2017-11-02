PatternPlayer : SHPlayer {
	var <>event;
	var <>player;

	init {
		event ?? { event = () }
	}

	isPlaying { ^player.isPlaying }
	stop { player.stop }

	play { | argEvent |
		event = argEvent ? event;
		if (player.isPlaying) { player.stop };
		player = EventPattern (event).play;
	}

	addKey { | key, object |
		event [key] = object;
		if (player.isPlaying) { player.addKey (key, object) }
	}

	addEvent { | argEvent |
		event putAll: argEvent;
		if (player.isPlaying) { player.addEvent (argEvent) }
	}

	setEvent { | argEvent |
		event = argEvent;
		if (player.isPlaying) { player.setEvent (argEvent) }
	}

	// experimental
	// From Event:eplay
	etype {
		event [\type] = \envEvent;
		event [\envir] = currentEnvironment;
	}
	
}

RoutinePlayer : SHPlayer {
	var <func, <clock;
	var <routine;

	init {
		func ?? {
			func = {
				loop {
					"routine playing default loop here".postln;
					1.wait;
				}
			}
		};
		clock = clock ? SystemClock;
	}	
	
	play { | argFunc, argClock |
		argFunc !? { func = argFunc };
		argClock !? { clock = argClock };
		if (routine.isPlaying) {
			routine.stop;
		};
		routine = func.fork (clock);
	}

	stop { routine.stop }
}