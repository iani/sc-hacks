// 18 Jul 2017 23:59
// Load a collection to a buffer, but keep the sound file at a given path.

+ Buffer {
	*load2File { arg path, collection, numChannels = 1, action;
		var data, sndfile, bufnum, buffer, server;
		server = Server.default;
		bufnum ?? { bufnum = server.nextBufferNumber(1) };
		if (collection.isKindOf(RawArray).not) { collection = collection.as(FloatArray) };
		sndfile = SoundFile.new;
		sndfile.sampleRate = server.sampleRate;
		sndfile.numChannels = numChannels;
		if (sndfile.openWrite(path)) {
			sndfile.writeData(collection);
			sndfile.close;
			^super.newCopyArgs(server, bufnum)
			.cache.doOnInfo_({ |buf|
				action.value(buf);
			}).allocRead(path, 0, -1, {|buf| ["/b_query", buf.bufnum] })
		}{
			"Failed to write data".warn;
			^nil
		}
	}
}