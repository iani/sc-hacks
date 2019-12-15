/* 15 Dec 2019 05:09
Treat string as filename, prepending default recording dir, and 
adding .aiff extension.
and record default Server, numchan channels for sec seconds.
*/

+ String {
	record { | duration = 60, numChannels = 2 |
		Server.default.record(this.asRecordingPath,
			numChannels: numChannels, duration: duration);
	}
	
	asRecordingPath {
		// convert to recording path by prepending default recording dir
		^thisProcess.platform.recordingsDir +/+ this ++ ".aiff";
	}
}
