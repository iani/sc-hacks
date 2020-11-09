+ String {
	userPath {
		// convert to userAppSupportDir path
		^Platform.userAppSupportDir +/+ this;
	}
	matchType { | type = "aiff" |
		format("%/*.%", this, type).postln;
		^format("%/*.%", this, type).pathMatch;
	}
	
	playAudioFile {
		var buf, soundFile, numChannels;
		soundFile = SoundFile.openRead(this);
		numChannels = soundFile.numChannels;
		postf("% channels in file %\n", numChannels);
		buf = Buffer.cueSoundFile(Server.default, this, 0, numChannels);
		postf("testing buffer:\nnumChannels: %, buffer: %\n", buf.numChannels, buf);
		{ DiskIn.ar(numChannels, buf.bufnum) } +> \diskplayback;
	}
}