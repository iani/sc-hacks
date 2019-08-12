// 12 Aug 2019 09:22
// Transferred from Hacks class

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