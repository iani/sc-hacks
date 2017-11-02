// 12 Oct 2017 13:26
// Support methods for LoadFiles and its subclasses


BufferLoader {
	*initClass {
		StartUp add: {
			ServerBoot add: {
				var files, buffers;
				files = (Platform.userAppSupportDir ++ "/sounds/\*").pathMatch;
				buffers = files collect: { | f |
					Buffer.read(Server.default, f);
				};
				buffers do: { | buffer |
					Registry.put(\buffers, PathName(buffer.path).fileNameWithoutExtension.asSymbol, buffer);
				};				
			};
		}
	}
}

+ Nil {
	containsString { | string | ^false; }
	addUniqueString { | string |
		^[string]
	}

	removeUniqueString { | string |
		^[]
	}
	
}

+ Array {
	containsString { | string | ^this.detect({ | s | s == string }).notNil; }

	addUniqueString { | string |
		if (this containsString: string) {
			postf("prevented adding duplicate string:\n%\n", string);
			^false;
		}{
			^this add: string;
		}		
	}

	removeUniqueString { | string |
		var found;
		found = this.detect({ | s | s == string });
		if (found.isNil) {
			postf("could not remove string because it was not found:\n%\n", string);
		}{
			this remove: found;
		}
	}

	indexOfString { | string |
		var found;
		found = this.detect({ | s | s == string });
		if (found.notNil) { ^this indexOf: found; } { ^nil }
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

	loadBuffer { | action |
		// Load the audio file if it exists, and store in library. 
		this.doIfExists {
			postf("Loading buffer: %\n", this);
			FileItemList.add(FileItem(this), \buffers);
		}{
			postf("Could not find path: %\n", this);
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

	*names {
		^Library.at(\buffers).keys.asArray.sort;
	}

	*buffers {
		
		
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

	b { ^Library.at(\buffers, this) }

	bufnum {
		var buffer;
		buffer = this.b;
		if (buffer.isNil) {
			postf("could not find buffer named '%'. Returning 0\n", this);
			^0;
		} {
			^buffer.bufnum;
		}
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
