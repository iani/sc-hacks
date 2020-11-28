SenseDependant : NamedSingleton {
	
	activate { | serverName = \default |
		SenseServer.named(serverName).addDependant(this);
	}

	deactivate { | serverName = \default |
		SenseServer.named(serverName).removeDependant(this);
	}
	
}

// a very simple example class for posting data received from SenseServer
PostSenseData : SenseDependant {
	update { | data, time |
		postf("%:% received: % at %\n", this, name, data, time);
	}	
}

/* 
	// examples, testing

	// SenseServer.defaultMessage = '/status.reply';

SenseServer.recordScsynth;
SenseServer.record;
SenseServer.stopRecording;
SenseServer.defaultMessage;
SenseServer.postInput;
SenseServer.muteInput;

SenseServer.default.dependants;

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