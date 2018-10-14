// 12 Oct 2017 13:26
// Support methods for LoadFiles and its subclasses

+ Nil {

	b {
		"nil.b: returning empty buffer".postln;
		^'___empty___'.b;
	}
}

+ String {
	asName { ^PathName(this).fileNameWithoutExtension.asSymbol }

	previewCode {
		// only load file code. Do not store in StartupFiles.
		"Code preview: Loading without adding to startup".postln;
		this.doIfExists {
			postf("Loading code: %\n", this);
			this.load;
		}{
			postf("Could not find path: %\n", this);
		}
	}
	
	addCode {
		// Only add file path to StartupFiles, if it exists.
		this.doIfExists {
			postf("Adding to startup: %\n", this);
			FileItemList.add(this, \startup);
		}{
			postf("Could not find path: %\n", this);
		}
	}

	previewBuffer {
		// Only load and play the buffer, if it exists.
		this.loadBuffer({ | b |
			postf("playing %\n", b);
			b.play;
		})
	}

	loadBuffers {
		// Load all audio files contained in folder and store them under their filenames
		var standardized;
		standardized = this.standardizePath;
		(standardized +/+ "*.wav").pathMatch do: { | p |
			PathName(p).fileNameWithoutExtension.asSymbol.loadBuffer(p);
		};
		(standardized +/+ "*.aif").pathMatch do: { | p |
			PathName(p).fileNameWithoutExtension.asSymbol.loadBuffer(p);
		};
		(standardized +/+ "*.aiff").pathMatch do: { | p |
			PathName(p).fileNameWithoutExtension.asSymbol.loadBuffer(p);
		}
	}
}

+ Buffer {
	storeInLibrary { | notify = true |
		var name;
		if (path.notNil) {
			Library.put(\buffers, path.asName, this);
			if (notify) { AudioFiles.default.changed(\all) };
		}
	}

	*put { | name, buffer |
		Library.put(\buffers, name, buffer);
		this.changed(\buffers);
	}

	*names {
		^Library.at(\buffers).keys.asArray.sort;
	}

	*toggle { | name |
		var buf, numChans, player;
		buf = name.b;
		numChans = buf.numChannels;
		player = Player.named(name);
		if (player.isNil) {
			player = { PlayBuf.ar(numChans, buf, doneAction: 2) } +> name;
			player.addNotifier(player, \started, { | notification |
				Buffer.changed(\buffers);
			});
			player.addNotifier(player, \stopped, { | notification |
				Buffer.changed(\buffers);
			});
		}{
			player.addNotifier(player, \started, { | notification |
				Buffer.changed(\buffers);
			});
			player.addNotifier(player, \stopped, { | notification |
				Buffer.changed(\buffers);
			});
			player.toggle
		}
	}
}

+ Symbol {
	////////////////////////////////////////////////////////////////
	// Bus support
	////////////////////////////////////////////////////////////////
	bus { | numChannels = 1 |
		// get bus named by symbol
		^Registry(\busses, this, {
			Bus.control(Server.default, numChannels)
		})
	}

	////////////////////////////////////////////////////////////////
	// Buffer support
	////////////////////////////////////////////////////////////////
	*initClass {
		ServerQuit add: {
			Library.put(\buffers, IdentityDictionary());
		}		
	}
	
	bn { | seconds = 1, numChannels = 1 |
		// shortcut for bufnum
		^this.bufnum(seconds, numChannels);
	}
	bufnum { | seconds = 1, numChannels = 1 |
		// return the index of the associated buffer 
		^this.b(seconds, numChannels).bufnum;
	}
	
	// 20 Jul 2018 22:31 reimplementing this with registry.
	b { | seconds = 1, numChannels = 1 |
		^Registry(\buffers, this, {
			// mutate to loadBuffer if given string argument
			if (seconds isKindOf: String) {
				seconds = seconds.standardizePath;
				seconds.doIfExists({
					Buffer.read(Server.default, seconds);
				},{
					Buffer.alloc(Server.default,
						1 * Server.default.sampleRate,
						numChannels,			
					).path_(this.asString)
				})
			}{
				Buffer.alloc(Server.default,
					seconds * Server.default.sampleRate,
					numChannels,			
				).path_(this.asString)
			}
		});
	}

	bframes { | numFrames = 44100, numChannels = 1 |
		^Registry(\buffers, this, {
			Buffer.alloc(Server.default,
				numFrames,
				numChannels,			
			)
		})
	}
	
	free {
		// free buffer and remove from registry
		var buffer;
		buffer = this.b;
		buffer.free;
		buffer.objectClosed;
	}

	loadBuffer { | path |
		path = path.standardizePath;
		^Registry(\buffers, this, {
			path.doIfExists({
				Buffer.read(Server.default, path, action: {
					// Defer to enable updates of gui items
					{ Buffer.changed(\loaded, Registry.at(\buffers)) }.defer;
				});
			},{
				postf("could not find file:\n%\n", path);
				"Allocating empty buffer of 1 second".postln;
				Buffer.alloc(Server.default, 1 * Server.default.sampleRate, 1,)
				.path_(this.asString)
			})
		});
	}
	
	toggleBuf { | bufferName, eventName |
		// like toggle, but use as source a PlayBuf func with appropriate number of channels.
		var buffer, numChans, bufnum;
		bufferName ?? { bufferName = this };
		buffer = bufferName.b;
		if (buffer.isNil) {
			postf("could not find buffer named %\n", bufferName);
		}{
			numChans = buffer.numChannels;
			bufnum = buffer.bufnum;
			this.toggle({
				PlayBuf.ar(numChans, \bufnum.kr(bufnum),
					\rate.kr(1),
					\trigger.kr(1),
					\startPos.kr(0),
					\loop.kr(1),
					2 // doneAction: free synth when done
				);
			}, eventName);
		}
	}
}
