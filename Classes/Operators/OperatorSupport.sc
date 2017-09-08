// 23 Jun 2017 21:36 under review

+ Object {
	=> { | param, envir |
		envir.asEnvironment (false) [param] = this;
	}

	push {
		^this.asEnvironment (true);
	}
}

+ Nil {
	asEnvironment { | doPush = true |
		var nevent;
		if (currentEnvironment.isKindOf (Nevent)) {
			nevent = currentEnvironment;
		}{
			nevent = \envir.asEnvironment (false);
		};
		if (doPush) {
			nevent.doPush;
		};
		^nevent;
	}
}

+ Integer {
	asEnvironment { | doPush = true |
		^Nevent.at (this)
		.perform ([\null, \doPush] [doPush.binaryValue])
	}
}

+ Symbol {

	asEnvironment { | doPush = true |
		^Registry (\environments, this, { Nevent.pop })
		.perform ([\null, \doPush] [doPush.binaryValue])
	}

	// ================ All items of one category in an environment
	synths { ^Registry.at (this.asEnvironment (false), \synths) }
	patterns { ^Registry.at (this.asEnvironment (false), \patterns) }
	routines { ^Registry.at (this.asEnvironment (false), \routines) }
	windows { ^Registry.at (this.asEnvironment (false), \windows) }

	// ================ Individual named elements in an envir
	// Create element if not found
	// Do not push the environment.
	window { | envir | ^Nevent.wget (envir, this) }
}

+ Function {
	+> { | playerName, envir |
		^playerName.splay (this, envir.asEnvironment (true));
	}
	// TODO: Needs rewriting with Nevent.rplay
	// Also: should be operator: *> 
	rout { | envir, name = \routine, clock |
		
	}
}

+ Symbol {
	/*
	play { | pattern, envir |
		^(Registry (envir.asEnvironment, \patterns, this, {
			EventPattern(pattern ?? { () }).play
		})).play
	}

	player { | envir |
		^Registry.at (envir.asEnvironment, \patterns, this);
	}
	*/
}

+ Object {
	/*
	+> { | symbol, adverb |
	   	^symbol.play.addKey (adverb, this);
	}
	*/
}

+ Event {
	// these 2 need revisiting - to make consistent with Symbol:play
	//	+> { | symbol, envir | ^symbol.play ().addEvent (this) }
	// +!> { | symbol, envir | ^symbol.play.setEvent (this) }
}

+ EventStreamPlayer {
	addKey { | key, object | stream.event [key] = object.asStream }

	addEvent { | argEvent |
		var prEvent;
		prEvent = stream.event;
		argEvent keysValuesDo: { | key, value |
			prEvent [key] = value.asStream;
		}
	}

	setEvent { | argEvent |
		var prEvent;
		prEvent = stream.event;
		prEvent.clear;
		argEvent keysValuesDo: { | key, value |
			prEvent [key] = value.asStream;
		}
	}
}