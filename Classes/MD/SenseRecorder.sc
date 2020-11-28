/* 28 Nov 2020 04:04
Record data from SenseStage as well as audio from performance
on files contained in Platform.userAppSupportDir +/+ "MD"
named with a timestamp created when the recording starts.

The data can be played back with SensePlayer.

examples, testing:

SenseServer.defaultMessage = '/status.reply';

SenseServer.recordScsynth;
SenseServer.record;
SenseServer.stopRecording;
SenseServer.defaultMessage;
SenseServer.postInput;
SenseServer.muteInput;

*/

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
