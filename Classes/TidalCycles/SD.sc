/* 23 Aug 2020 07:29
Load superdirt samples, 
Store them in dictionaries,
Prepare synthdefs for playing them.
*/

SD {
	classvar <buffers;
	classvar <buffergroups;
	classvar <namespaths;

	var <buffer, <defname;

	*init {
		// boot server and load all samples;
		//		"SD is initing now ... - testing before implementation".postln;
		this.getNamesPaths;
		Server.default.quit;
		Server.default.options.numBuffers = namespaths.size + 100;
		Server.default.waitForBoot({
			this.loadDefs;
			this.loadBuffers;
		});
	}

	*loadDefs {
		// load synthdefs for playing buffers: mono and stereo
		SynthDef("buf1", { | out = 0, bufnum = 0, rate = 1, amp = 0.5, pos = 0 |
			var src;
			src = PlayBuf.ar(1, bufnum,
				BufRateScale.kr(bufnum) * rate,
				doneAction: Done.freeSelf
			);
			Out.ar(out, Pan2.ar(src, pos, amp);)
		}).load;
		SynthDef("buf2", { | out = 0, bufnum = 0, rate = 1, amp = 0.5 |
				var src;
				src = PlayBuf.ar(2, bufnum,
					BufRateScale.kr(bufnum) * rate,
					doneAction: Done.freeSelf
				);
				Out.ar(out, src * amp)
			}	
		).load;
	}

	*getNamesPaths {
		namespaths = List();		
		(Quarks.folder +/+ "Dirt-Samples" +/+ "*").pathMatch do:
		{ | folder |
			postf("adding files from folder: %\n", folder);
			(folder +/+ "*").pathMatch do:
			{ | path |
				namespaths add: [path.bufname, path];
			};
		}
	}

	*loadBuffers {
		var buf, name, path;
		buffers = IdentityDictionary();
		// "Initialized empty samples - loadBuffers not yet implemented".postln;
		namespaths do: { | pn, i |
			#name, path = pn;
			postf("% ", i);
			if (i % 17 == 0) { "".postln; };
			buf = path.readbuffer;
			buf !? { buffers[name] = buf };
		};
		postf("\nLoaded % buffers\n", buffers.size);
		this.groupBuffers;
	}

	*groupBuffers {
		buffergroups = MultiLevelIdentityDictionary();
		
	}

	// utility
	*first {
		^buffers[buffers.keys.asArray.sort.first];
	}

	//: Testing gui
	*gui {
		\buffers.window({ | w |
			w.bounds = Rect(1400, 0, 1400, 1800);
			w.layout = HLayout(
				this.bufferList,
				this.playerList
			)
		});
	}

	*playerList {
		var players;
		if (currentEnvironment[\players].isNil) {
			currentEnvironment[\players] = 
			{
				SDC(this.first)
			} ! 26
		};
		players = currentEnvironment[\players];
		players do: { | p, i |
			currentEnvironment[(i + 97).asAscii.asSymbol] = p;
		};
		currentEnvironment[\cp] = players.first;
		^VLayout(
			ListView()
			.font_(Font("Helvetica", 24))
			.items_(players collect: { | p, i |
				format("% :: %", (i + 97).asAscii, p.asItem)
			})
			.action_({ | me |
				currentEnvironment[\cp] = players[me.value];
			})
			.keyDownAction_({ | me, key |
				// [doc, key].postln;
				var p;
				p = players[me.value];
				switch (key
					$ , { p.toggle },
					$j, { p.incCycle },
					$k, { p.decCycle },
					$h, { p.incOffset },
					$l, { p.decOffset },
					$1, { p.cycle = 1 },
					$2, { p.cycle = 2 },
					$3, { p.cycle = 3 },
					$4, { p.cycle = 4 },
					$5, { p.cycle = 5 },
					$6, { p.cycle = 6 },
					$7, { p.cycle = 7 },
					$8, { p.cycle = 8 },
					$9, { p.cycle = 9 },
  					$!, { p.offset = 1 },
					$@, { p.offset = 2 },
					$#, { p.offset = 3 },
					$$, { p.offset = 4 },
					$%, { p.offset = 5 },
					$^, { p.offset = 6 },
					$&, { p.offset = 7 },
					$*, { p.offset = 8 },
					$(, { p.offset = 9 },
					
					
				)
				if (key === $ ) 
			})
			.addNotifier(this, \players, { | n |
				n.listener.items = players collect: { | p, i |
				format("% :: %", (i + 97).asAscii, p.asItem)
				}
			})
		)
	}
	
	*bufferList {
		^VLayout(
			ListView()
			//		Menu() // not suitable for that many items anyway
			.font_(Font("Helvetica", 24))
			.items_(buffers.keys.asArray.sort)
			.action_({ | me |
				me.item.postln;
				// buffers[me.item.asSymbol].play;
				currentEnvironment[\cp].buffer = buffers[me.item];
				this.changed(\players);
			})
		)	
	}
}

