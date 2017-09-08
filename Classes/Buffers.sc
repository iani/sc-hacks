// 19 Jul 2017 10:07
// Handle loading and playing of audio buffers.

Buffers {
	*load { | path, play = false |
		Library.put (
			'buffers', PathName (path).fileNameWithoutExtension.asSymbol,
			Buffer.read (Server.default, path, action: { | b |
				if (play) {
					b.play;
				}{
					b.postln;
				}
			})
		)
	}

	*paths {
		// return paths of all buffers.
		^Library.at('buffers').values collect: _.path;
	}
}