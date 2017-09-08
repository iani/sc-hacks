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
		envir.busses[param] = this;
		envir.put(param, bus.index);
		envir.addNotifier(this, \audioBus, { envir.put(param, bus.index) });
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

