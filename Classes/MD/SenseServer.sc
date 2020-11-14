/* 11 Nov 2020 06:41
Receive OSC messages from sensestage sensors and pass these on to dependants. 

Note: dependant mechanism is overwritten here, for efficiency, since notifying dependants is the main functionality of the SenseServer and since this usually happens many times a second. 

SenseServer.test;

SenseServer.named(\testing, '/adifferent/message').test;

SenseServer.all do: { | i | i.name.postln; };

SenseServer.defaultMessage = '/status.reply';
SenseServer.default;




*/

NamedSingleton : Singleton {
	var <name;

	init { | argName |
		name = argName;
	}
}
  

SenseServer : NamedSingleton {
	classvar <>defaultMessage = '/minibee/data'; // default OSC message to listen to
	var <dependants; // use these instead of default dependant mechanism
	var oscFunc, <message;

	init { | argName, argMessage |
		super.init(argName);
		message = argMessage ? defaultMessage;
		oscFunc = OSCFunc({ | ... data |
			// postf("% name: !!! % !!!, data: %\n", this, name, data);
			dependants do: _.update(data[0], data[1]);
		}, message).fix;
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
	}

	removeDependant { | dependant |
		dependants !? { dependants.remove(dependant); };
		if (dependants.size == 0) { dependants = nil }; // be clean
	}

	postInput { // start posting input
		PostSenseData.named(name).activate(name);
	}
	muteInput { // stop posting input
		PostSenseData.named(name).deactivate(name);
	}

	record { // start posting input
		RecordSenseData.named(name).activate(name);
	}

	stopRecording { // stop posting input
		RecordSenseData.named(name).deactivate(name);
	}
}

SenseDependant : NamedSingleton {
	
	activate { | serverName = \default |
		SenseServer.named(serverName).addDependant(this);
	}

	deactivate { | serverName = \ default |
		SenseServer.named(serverName).removeDependant(this);
	}
	
}
// a very simple example class for posting data received from SenseServer
PostSenseData : SenseDependant {
	update { | data, time |
		postf("%:% received: % at %\n", this, name, data, time);
	}	
}

RecordSenseDate : SenseDependant {
	classvar <>recordingsDir;
	var file;
	/*
		// DRAFT! 
	*initClass {
		recordingsDir = Platform...
		
	}
	
	activate { | serverName = \default |
		this.prepareRecording;
		super.activate(serverName)
	}
	*/
	
}

/* 
	// examples, testing

SenseServer.defaultMessage = '/status.reply';
SenseServer.postInput;
qSenseServer.default.dependants;

SenseServer.test;
SenseServer.default;
SenseServer.named('TEST');
SenseServer.addDependant(PostSenseData.default);
SenseServer.addDependant(PostSenseData.named('testestestest'));
SenseServer.removeDependant(PostSenseData.default);

SenseServer.disable;
SenseServer.enable;

SenseServer.default.inspect;
*/