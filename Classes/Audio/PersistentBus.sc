// 13 Aug 2017 11:21
// A bus that reallocates on server boot, and notifies dependants to update.
/*
PersistentBus holds a bus and re-allocates it when the server boots.
When it re-allocates, it emits a changed message, so that any environments that are connected can
update.  

PersistentBus defines instance creation methods for audio and control busses. The audio instance creation method =makeAudio= stores the instance in "busses" instance variable of Nevent and sets the parameter key of event of Nevent to the index of the bus.  The control instance method =makeControl= stores the bus itself in the envir of the player under the provided parameter as key.  

- Audio busses just set the parameter (key/environment variable) of the environment to the index of the bus. Any synths of SynthPlayers will set their corresponding parameters like for any other parameters and also the SynthPlayer uses the index as initial parameter value when creating new synths.

- Control busses set the parameter (key/environment variable) of the environment to the bus itself.  The Dispatch of Nevent maps the corresponding parameters to the bus, and also the SynthPlayer maps new synths to the bus as soon as they start.

Additionally, both audio and control busses update the contents of their Environments when the server boots, as follows: 

- Audio busses: Create new audio bus and store its index in the environment.
- Control bus: Send =objectClosed= to the PersistentBus to remove all dependants, and set the values of the corresponding parameters in all environments to nil (i.e. remove the bus.)

*/

PersistentBus {
	var <numChannels, <bus;

	*makeAudio { | envir, param = \out, numChannels = 1 |
		// create audio bus and store it in Nenvir's players.
		// sets nvirs param to the audio bus index.
		^this.newCopyArgs(numChannels).initAudio.addAudio2Envir(envir, param);
	}

	initAudio {
		this.makeAudio;
		ServerBoot add: { this.makeAudio.changed(\audioBus) };
	}

	makeAudio { bus = Bus.audio(this.server, numChannels) }

	addAudio2Envir { | envir, param |
		// Store self in envir's busses.
		// Immediately update contents and any playing synths or patterns.
		// If previous bus in same param existed, remove self from its dependants.
		// Add envir to be notified when bus is reallocated on server boot:
		// any envirs sharing this bus will set their param keys to the new bus index.
		// Besides setting the param key in the environment, the envirs must also
		// notify any playing processes of their players to change their parameters accordingly.
		// This is done as follows: 
		/*
			When a new bus is set in the middle of things (while players are possibly playing):
			
			Any playing SynthPlayers must set their synth's params to change outputs/outputs controls.
			Any non-playing SynthPlayers will use the environment to start with the proper i/o indices.
			Any playing PatternPlayers must set both the EventPatterns events keys and the StreamPlayers 
                   events keys.
			Any non-playing PatternPlayers set only the EventPatterns envents keys.

			When a bus gets a new index after server reboot (no players are playing yet):
			SynthPlayers do nothing, since they are not playing yet.  The updated key values
			of the envir will take effect when the SynthPlayers start.
			PatternPlayers must set their patterns events keys to new indices, in case they restart,
			for example by receiving the message play.
		*/
		/*
		var previousBus;
		previousBus = this.busses[param];
		previousBus !? {
			// TODO: Remove dependencies from previous bus.
			"INCOMPLETE:".postln;
			postf("I should remove dependencies of %\nfrom bus %\n", this, previousBus);
		};
		persistentBus.addAudio2Envir(this, param);
		*/
		var previousBus;
		previousBus = envir.busses[param];
		previousBus !? {
			this.removeNotifier(previousBus, \audioBus);
		};
		envir.busses[param] = this;
		envir.updateBusIndex(param, this.index);
		envir.addNotifier(this, \audioBus, {
			envir.updateAudioBus(param, this);
			/*
			envir.put(param, bus.index);
			envir.changed(\busChanged, param, bus.index);
			*/
		});
	}
	
	*makeControl { | envir, param = \amp, numChannels = 1 |
		// create audio bus and store it in Nenvir's players.
		// sets nenvirs param to the audio bus index.
		^this.newCopyArgs(param, numChannels).initControl.addControl2Envir(envir, param);
	}
	
	initControl {
		bus = Bus.control(this.server, numChannels);
		ServerBoot add: { this.makeAudio.changed(\audioBus) };
	}

	addControl2Envir { | envir, param |	
		envir.put(param, bus);
		envir.addNotifier(this, \audioBus, { envir.put(param, nil) });
	}
	
	server { ^Server.default }
	index { ^bus.index }
}

