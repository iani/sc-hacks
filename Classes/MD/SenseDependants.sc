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

SenseRecorder : SenseDependant {
	classvar <>recordingsDir;
	var path, file, audiopath, recorder;
	
	// DRAFT! 
	*initClass {
		recordingsDir = Platform.userAppSupportDir +/+ "MD";
		File.mkdir(recordingsDir);
	}
	
	activate { | serverName = \default |
		this.prepareRecording;
		super.activate(serverName)
	}

	prepareRecording {
		this.makePaths;
		file = File(path, "w");
		recorder = Recorder(Server.default).record(audiopath, 0, 2);
	}

	makePaths {
		path = recordingsDir +/+ format("%.txt", Date.localtime.stamp);
		audiopath = recordingsDir +/+
		format("%.aiff", Date.localtime.stamp);
	}
	
	deactivate { | serverName = \default |
		super.deactivate(serverName);
		this.endRecording;
	}

	endRecording {
		file.close;
		recorder.stopRecording;
	}

	update { | data, time |
		file.write([time, data].asCompileString ++ "\n");
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