/* 
    Eproxy: an event that notifies whenever any value is set.

	New approach  3 Jul 2017 20:39: 
	To automatically update the ~target group on server reboot, 
	create all environments at start time and store them in an array, 
	keeping the order of the groups.  Then obtain new instances from 
	this array, ensuring the given order of groups.

	================================================================
	
	TODO: New approach  8 Aug 2017 22:29
	use Notification attached to each new group + Envir in order to 
	assign group to envir as soon as it is created anew.
	This enables one to assign many different envirs to the same group!

	One may then change the group of an environment at any point, and
	even propagate the new group to any synths in that envir, even while they are running.

*/
Eproxy : EnvironmentRedirect {
	classvar <index = 0; // stored in Nevent and used to get Group
	classvar <all, <stack; // all environments: index access, stack access
	classvar <>numEnvirs = 10; 

	*at { | index = 0 |
		// access by integer index.
		// In reverse order: smaller index -> earlier Group
		^all [all.size - index - 1 max: 0]
	}
	
	*initClass {
		Class.initClassTree (Notification);
		// this.makeEvents; // make all Nevents in fixed order at start time
		// Unless this is done at startup, sometimes pushed Nevents disappear:
		StartUp add: {
			ServerBoot add: {
				// this.makeBusses; // replaced by bus-specific actions
				// this.loadBuffers; // TODO!
			};
			ServerTree add: {
				this.makeGroups;
			}
		}
	}
	
	*makeEvents {
		/* Create all Nevents for this session.
			Add notifications to update their targets when server boots.
			Store in stack for getting new instances.
			Store in reverse order in all, for indexed access. 
		*/
		all = { this.new } ! numEnvirs;
		stack = all.copy; // 
	}

	*makeGroups {
		// use with all.oopy.reverse to make small number groups first:
		// all do: { | me, index | me [\target] = Group (addAction: \addToTail) };
		// all do: { | me, index | me [\target] = Group () };
	}

	addSharedBus { | envir, inParam = \in, outParam = \out, numChannels = 1, rate = \audio |
		var bus; // only make bus if not already present:
		bus = envir.busses.get (inParam, { this.makeBus (numChannels, rate) });
		envir.setBus (inParam, bus);
		this.setBus (outParam, bus);
		this.addNotifier (Server.default, \doOnServerBoot, {
			bus = this.makeBus (numChannels, rate);
			envir.setBus (inParam, bus);
			this.setBus (outParam, bus);
		});
	}

	busses { ^this.get (\busses, { IdentityDictionary () }) }

	get { | key, func |
		var val;
		val = envir [key];
		val ?? {
			val = func.value;
			envir [key] = val; // does not notify
		};
		^val;
	}

	makeBus { | numChannels = 1, rate = \audio |
		^switch (rate,
			\audio, { Bus.audio (numChannels: numChannels) },
			\control, { Bus.control (numChannels: numChannels) }
		);
	}

	setBus { | param = \in, bus |
		var busses;
		busses = this.busses;
		busses [param] = bus;
		this [param] = bus.index;
	}

	// Access to pre-constructed instances
	*pop { ^stack.pop }
	
	put { | key, value |
		super.put (key, value);
		this.changed (key, value);
	}

	asEnvironment { ^this }

	null {} // do nothing. Used by Symbol:asEnvironment
	
	doPush {
		/* // cancelled because so far we need to initially push Nevent anyway:
			// If currentEnvironment is not a Nevent, then inherit its values.
			// Useful to use values set before any Nevent-using methods are called.
			
			if (currentEnvironment.isKindOf (this.class).not) {
			this putAll: currentEnvironment
			};
		*/
		if (this !== currentEnvironment) {
			this.push;
			this.class.changed (\currentEnvironment, this);
		}
	}

	// Busses
	addBus { | param = \out, numChannels = 1, rate = \audio |
		// Create new bus from specs, if not present.
		// Add it to your busses, and update parameters
	}

	putBus { | bus |
		
	}
	
	// ================ Introspection ================
	// basic
	*envirs { ^Library.at (\environments) }
	name { ^this.class.envirs findKeyForValue: this }

	// ==== accessing related instances
	// groups: return all instrances 
	synths { ^this.name.synths; }
	// patterns { ^this.name.patterns; }
	// routines { ^this.name.routines; }
	windows { ^this.name.windows; }

	// items: creating related named instances
	// Always create if needed
	// Push envir only if no Nevent has been pushed yet.
	*get { | envir, category, name, constructor |
		^Registry (envir.asEnvironment (
			currentEnvironment.isKindOf (Nevent).not
		), category, name, constructor);
	}

	/*
	*sget { | envir, name | // create new synthplayer if needed
		^this.get (envir, \synths, name, { SynthPlayer (envir, name) } );
	}

	*pget { | envir, name, event |
		^this.get (envir, \patterns, name, { PatternPlayer (envir, name, event) });
	}

	*rget { | envir, name, func, clock |
		^this.get (envir, \routines, name, {
			RoutinePlayer (envir, name, func, clock)
		});
	}

	*wget { | envir, name |
		^this.get (envir, \windows, name, {
			Window ().onClose_ ({ | me | me.objectClosed })
		});
	}

	// ================================================================
	// experimental

	*windows {
		^(all collect: Registry.at(_, \windows)
		select: _.notNil
		collect: _.values).flat;
	}

	*arrangeWindows {
		WindowArranger.arrange(this.windows);
		
	}
	*/
}
/*
// Utility
+ Registry {
	*envirs { ^Nevent.envirs }
}
*/