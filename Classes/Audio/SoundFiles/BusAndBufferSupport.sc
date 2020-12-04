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

	// backup copy while exploring new version of method loadBuffers :
	loadBuffersOLD {
		// Load all audio files contained in folder.
		// Store them under their filenames.
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

	allwaysLoadBuffers {
		ServerBoot add: { this.loadBuffers };
		Server.default.doWhenBooted( { this.loadBuffers });
	}

	loadBuffers {
		// Load all audio files contained in folder.
		// Store them under their filenames.
		// Use new method stolen from SuperDirt,
		// to ensure buffers load even when loading very many of them at once.
		var standardized;
		standardized = this.standardizePath;
		"\n================================================================".postln;
		postf("\nLOADING BUFFERS FROM: %\n\n", standardized);
		["wav", "aif", "aiff"] do: { | type |
			(standardized +/+ format("*.%", type)).pathMatch do: { | p |
				PathName(p).fileNameWithoutExtension.asSymbol.loadBuffer(p);
			}
		};
		"\n================================================================".postln;
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

+ Bus {
	bus { ^this }
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

	// synonym !!!
	buf {  | seconds = 1, numChannels = 1, func |
		^this.b(seconds, numChannels, func);
	}

	// 20 Jul 2018 22:31 reimplementing this with registry.
	b { | seconds = 1, numChannels = 1, func |
		// See also newer variant in Hacks class
		// allocate if needed.
		// use func as completion function.
		^Registry(\buffers, this, {
			// mutate to loadBuffer if given string argument
			if (seconds isKindOf: String) {
				seconds = seconds.standardizePath;
				seconds.doIfExists({
					Buffer.read(Server.default, seconds, action: func);
				},{
					postf("Could not find audio file:\n  %\n", seconds);
					"=== Allocating empty buffer of 1 second duration ===".postln;
					Buffer.alloc(Server.default,
						1 * Server.default.sampleRate,
						numChannels,
						completionMessage: func
					).path_(this.asString)
				})
			}{
				Buffer.alloc(Server.default,
					seconds * Server.default.sampleRate,
					numChannels,
					completionMessage: func
				).path_(this.asString)
			}
		});
	}

	bframes { | numFrames = 44100, numChannels = 1, func |
		^Registry(\buffers, this, {
			Buffer.alloc(Server.default,
				numFrames,
				numChannels,
				completionMessage: func
			)
		})
	}

	free {
		// free buffer and remove from registry
		var buffer;
		buffer = this.b;
		buffer.free;
		buffer.objectClosed;
		this.removeMessage(\booted); // do not reload on server reboot
	}

	// bus shortcuts
	freeBus {
		// free bus and remove from registry
		var bus;
		bus = this.bus;
		bus.free;
		bus.objectClosed;
	}

	get { | func |
		^this.bus.get(func); // use value in func if provided.
	}

	// Baackup of old code while testing new version
	loadBufferOLD { | path |
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

	loadBuffer { | path |
		var buffer;
		path = path.standardizePath;
		buffer = path.doIfExists({
				buffer = path.readBuffer(Server.default);
				// Defer to enable updates of gui items
				buffer;
			},{
				postf("could not find file:\n%\n", path);
				"Allocating empty buffer of 1 second".postln;
				Buffer.alloc(Server.default, 1 * Server.default.sampleRate, 1,)
				.path_(this.asString)
			});
		postf("% is: %\n", this, buffer);
		Registry.put(\buffers, this, buffer);
		{ Buffer.changed(\loaded, buffer) }.defer;
		^buffer;
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

+ Buffer {
	*all { ^Library.at(\buffers) }
	*allNames { ^this.all.keys.asArray }
	*loadFromResourceDir {
		(Platform.resourceDir +/+ "sounds/").loadBuffers;
	}

	/* 14 Aug 2020 10:36
Copied from Alex McLean's SuperDirt quark library.

This is safer than Buffer.read when loading a large number of buffers
at once.  Buffer.read sometimes fails to update the info of a buffer,
while readWithInfo guarantees that the buffer will get the info
(sampleRate, number of channels, number of frames), by reading it
from file in sclang, instead of waiting for that info to arrive
from the server.
*/

	*readWithInfo { | server, path, startFrame = 0, numFrames = -1 |
		/*
			This guarantees that buffer info exists before the buffer is on the server.
		*/
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

	*readWithInfoIfNew { | server, path, startFrame = 0, numFrames = -1 |
		/*
			Variant of readWithInfo.
			Avoid loading duplicates, to save space on Server:
			Do not load if a buffer with the same path and size exists.
			Instead, return that buffer which is already loaded.
		*/
		var buffer, failed, alreadyLoaded;
		buffer = this.new(server);
		if(server.serverRunning.not) {
			"server not running - cannot load sound file.".postln;
			this.throw
		};
		SoundFile.use(path, { |file|
			buffer.sampleRate = file.sampleRate;
			buffer.numFrames = file.numFrames;
			buffer.numChannels = file.numChannels;
		});
		failed = buffer.numFrames == 0;
		if(failed) {
			"\n".post; "File reading failed for path: '%'\n\n".format(path).warn;
			buffer.free; // free buffer number
			^nil
		};
		alreadyLoaded = buffer.alreadyLoaded;
		if (alreadyLoaded.isNil) {
			^buffer.allocRead(path, startFrame, numFrames)
		}{
			postf("Buffer wih path \n%\nis already loaded. Returning that\n",
				path;
			);
			buffer.free;
			^alreadyLoaded
		}
	}

	alreadyLoadedp {
		// true if a buffer with the same path and memoryFootPrint is
		// already in Buffer.all.asArray
		^this.alreadyLoaded.notNil;
	}

	alreadyLoaded {
		// reaturn Buffer with same path and memoryFootprint which is
		// already in Buffer.all.asArray, else nil.
		var footPrint;
		footPrint = this.memoryFootprint;
		^Buffer.all.asArray.detect({ | b |
			b.path == path and: { b.memoryFootprint == footPrint };
		});
	}

	// in bytes
	memoryFootprint {
		^numFrames * numChannels * 4
	}
}