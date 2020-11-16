/* 11 Nov 2020 06:41
Receive OSC messages from sensestage sensors and pass these on to dependants. 

Note: dependant mechanism is overwritten here, for efficiency, since notifying dependants is the main functionality of the SenseServer and since this usually happens many times a second. 

SenseServer.test;

SenseServer.named(\testing, '/adifferent/message').test;

SenseServer.all do: { | i | i.name.postln; };

SenseServer.defaultMessage = '/status.reply';
SenseServer.default;

*/

SenseServer : NamedSingleton {
	classvar <>defaultMessage = '/minibee/data'; // default OSC message to listen to
	var <dependants; // use these instead of default dependant mechanism
	var oscFunc, <message;

	*recordXbee {
		defaultMessage = '/minibee/data';
	}

	*recordScsynth {
		defaultMessage = '/status.reply';
	}
	
	init { | argName, argMessage |
		super.init(argName);
		message = argMessage ? defaultMessage;
		oscFunc = OSCFunc({ | ... data |
			// postf("% name: !!! % !!!, data: %\n", this, name, data);
			this.changed(*data);
		}, message).fix;
	}

	changed { | data, time |
		//		postf("testing %, data %, time %\n", this, data, time);
		/* postf("% testing changed. dependants: %, this.dependants: %\n",
			this, dependants, this.dependants
			); */
		dependants do: _.update(data, time);
	}

	test {
		postf("testing %. My name is: %\n", this, name);	
	}

	enable { oscFunc.enable }
	disable { oscFunc.disable }

	// overwriting default dependence mechanism.
	*addDependant { | dependant |
		^this.default.addDependant(dependant)
	}

	*removeDependant { | dependant |
		^this.default.removeDependant(dependant)
	}

	
	addDependant { | dependant |
		// postf("% adding dependant %. dependants before are: %\n", this, dependant, dependants);
		dependants ?? { dependants = Set() };
		dependants add: dependant;
		// postf("% adding dependant %. dependants after are: %\n", this, dependant, dependants);
		// postf("addDependant CONFIRMING: THIS.DEPENDANTS ARE: %\n", this.dependants);
	}

	removeDependant { | dependant |
		// postf("% removing dependant %. dependants before are: %\n", this, dependant, dependants);
		dependants !? { dependants.remove(dependant); };
		// postf("% removing dependant %. dependants after are: %\n", this, dependant, dependants);
		// postf("removeDependant CONFIRMING: THIS.DEPENDANTS ARE: %\n", this.dependants);
		if (dependants.size == 0) { dependants = nil }; // be clean
	}

	postInput { // start posting input
		PostSenseData.named(name).activate(name);
	}
	muteInput { // stop posting input
		PostSenseData.named(name).deactivate(name);
	}

	record { // start posting input
		SenseRecorder.named(name).activate(name);
	}

	stopRecording { // stop posting input
		SenseRecorder.named(name).deactivate(name);
	}
}
