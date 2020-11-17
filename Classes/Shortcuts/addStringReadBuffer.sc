/* 22 Aug 2020 18:03
Treat string as path to a sound file.
If it point to a valid sound file, then read a new buffer and return it.
Else return nil.
Read and update sound file info from file, thereby ensuring that it is 
there without having to wait to receive info from the server.
This is based on a similar method found in SuperDirt.
It is modified to avoid allocating a new buffer and then freing it if the 
file is not valid. 

This method does not check if the server is booted.
To ensure that the server is booted, use with sync method like this: 
{ aString.readBuffer }.sync;

*/


+ String {
	readBuffer { | server |
		server ?? { server = Server.default };
		^SoundFile.use(this, { | file |
			var buffer;
			if (file.numFrames == 0) {
				postf("This is not an audio file: %\n", file.path);
			}{
				buffer = Buffer(Server.default);
				buffer.allocRead(file.path, 0, -1);
				buffer.sampleRate = file.sampleRate;
				buffer.numFrames = file.numFrames;
				buffer.numChannels = file.numChannels;
			};
			buffer;
		})
	}
	
}