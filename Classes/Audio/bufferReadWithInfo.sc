/* 14 Aug 2020 10:36
Copied from Alex McLean's SuperDirt quark library.

This is safer than Buffer.read when loading a large number of buffers 
at once.  Buffer.read sometimes fails to update the info of a buffer,
while readWithInfo guarantees that the buffer will get the info
(sampleRate, number of channels, number of frames), by reading it 
from file in sclang, instead of waiting for that info to arrive
from the server. 
*/

+ Buffer {

	/*
	This guarantees that buffer info exists before the buffer is on the server.
	*/

	*readWithInfo { |server, path, startFrame = 0, numFrames = -1|
		var buffer = this.new(server), failed;
		if(server.serverRunning.not) { "server not running - cannot load sound file.".postln; this.throw };
		SoundFile.use(path, { |file|
			buffer.sampleRate = file.sampleRate;
			buffer.numFrames = file.numFrames;
			buffer.numChannels = file.numChannels;
		});
		failed = buffer.numFrames == 0;
		^if(failed) {
			"\n".post; "File reading failed for path: '%'\n\n".format(path).warn;
			buffer.free; // free buffer number
			nil
		} {
			buffer.allocRead(path, startFrame, numFrames)
		}
	}

	// in bytes
	memoryFootprint {
		^numFrames * numChannels * 4
	}

}