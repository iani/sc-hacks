/* 29 Jul 2018 14:02
Return path of the home directory of sc-hacks library.
In future possibly also perform other global management tasks.
*/

Hacks {

	*initClass {
		StartUp add: {
			var server;
			server = Server.default;
			this.gui;
			if (SuperDirt.isNil) {
				"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
				"Please install SuperDirt Quark to enable sample library + cycle pattern support".postln;
				"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
			}{
				"****************************************************************".postln;
				"*** Sample library from SuperDirt/TidalCycles is available *** ".postln;
				//				"Samples will be loaded when booting the default Server".postln;
				"****************************************************************".postln;
				Server.default.options.numBuffers = 1024 * 16;
				// This can break scsynth because ServerBoot is badly implemented (really).
				
				/*
				ServerTree.add({
					// defer makes it safer, but it is just a dirty workaround
					//	 { this.loadSuperDirtBuffers; }.defer(1);
					// TESTING:
					this.loadSuperDirtBuffers; 
			})
				*/
				
				
				/* // lost this fix...
				this.addNotifier (Server.default, \doOnServerBoot, {
					this.loadSuperDirtBuffers; 
				})
				*/
				
				//				ServerBoot add: {
					// must wait, otherwise the server may not be able
					// to create the root node, and no Synths can be started:
					//					this.loadSuperDirtBuffers;
				//				"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
				//	"Will load SuperDirt buffers in 1 second".postln;
				//	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
					//					Server.default.sync;
					// "Now I Synced so I should load SuperDirt buffers".postln;
				//	"// I will try this without a defer and see what happens".postln;
					// { this.loadSuperDirtBuffers; }.defer(1);
					// "NOW RUNNING THIS: 	SuperDirt.new.loadSoundFiles.buffers.postln".postln;
					// SuperDirt.new.loadSoundFiles.buffers.postln;
					// "What did you seee???????".postln;
					// this.loadSuperDirtBuffers;
				// };
				// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				// Unfortunately this does not work either:
				/*
				OSCFunc({|msg|
					this.loadSuperDirtBuffers;
					//	server.changed(\notified); // this fixes things
					// if(flag) { server.clientID = msg[2] };
					//			failOSCFunc.free;
				}, '/done', server.addr, argTemplate:['/notify', nil]);
				*/
				
			}
			
		}
		
	}

	*loadSuperDirtBuffers {
		var bufname;
		"This is loadSuperDirtBuffers doing SuperDirt.new.loadSoundFiles".postln;
		SuperDirt.new.loadSoundFiles.buffers.keysValuesDo({ | name, buffers |
			Registry(\buffers, name, { buffers[0] });
			Registry(\tidal, name, {
				[buffers[0],
					if (buffers[0].numChannels == 1) {
						'buf1'
					}{
						'buf2'
					}
				]});
			buffers do: { | b, i |
				bufname = format("%%", name, i).asSymbol;
				Registry(\buffers, bufname, { b });
				Registry(\tidal, bufname, {
					[b,
						if (b.numChannels == 1) {
							'buf1'
						}{
							'buf2'
						}
					]})
			};
			Buffer.changed(\loaded, Registry.at(\buffers));
		});
		SynthDef(\buf1, { | buf = 0, rate = 1, amp = 1.0, gate = 1 |
			// mono buffer, stereo output
			var src; // , env;
			src = PlayBuf.ar(1, buf, rate, 1, 0, 0, 0);
			// env = Env.asr(); // Env([1, 1, 0], [1, 0.1], \sine, 1);
			// env = Env([1, 1, 0], [1, 0.1], \sine, 1);
			Out.ar(0, (src * Linen.kr(gate, 0.001, amp, 0.01, 2)).dup);
		}).add;
		SynthDef(\buf2, { | buf = 0, rate = 1, amp = 1.0, gate = 1 |
			// stereo buffer, stereo output
			var src; // , env;
			src = PlayBuf.ar(2, buf, rate, 1, 0, 0, 0);
			// env = Env.asr(); // Env([1, 1, 0], [1, 0.1], \sine, 1);
			// env = Env([1, 1, 0], [1, 0.1], \sine, 1);
			Out.ar(0, (src * Linen.kr(gate, 0.001, amp, 0.01, 2)).dup);
		}).add;
	}

	
	*homedir {
		^PathName(this.filenameSymbol.asString).pathOnly;
	}

	*gui {
		this.br_.v(
			{ SnippetList.gui }.button("Snippet List"),
			{ PlayerSnippetList.gui }.button("Player Snippet List"),
			{ PlayerGui() }.button("Player Gui"),
			{ OSCRecorder.gui }.button("OSC recorder"),
			{ ServerConfig.gui }.button("Configure Server"),
			[
				["Boot Server", Color.black, Color.green], { Server.default.boot },
				["Quit Server", Color.white, Color.red], { Server.default.quit}
			].button.addServerNotifier
		);
	}
}