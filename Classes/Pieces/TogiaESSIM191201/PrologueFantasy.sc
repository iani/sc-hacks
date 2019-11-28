
PrologueFantasy {
	*setup {
		// Server.default.options.numOutputBusChannels = 8;
		ServerBoot add: {
			{
				Hacks.loadAudioFiles;
				//            name of window ,     osc message monitored
				BusOsc.watch1(\thisissensestagetest, '/minibee/data',
					// bus name, data index, min, max, sensor id
					[\x1, 1, 0.47, 0.53, 1],
					[\y1, 2, 0.47, 0.53, 1],
					[\z1, 3, 0.47, 0.53, 1],
					[\x2, 1, 0.47, 0.53, 2],
					[\y2, 2, 0.47, 0.53, 2],
					[\z2, 3, 0.47, 0.53, 2]
				);
			}.defer(1);
		};
		Server.default.boot;	
	}
	*playCauche1 {
		{
			PlayBuf.ar(1, \prologue.b, \rate.kr(1, 1).urange(0.5, 1.5),
				Impulse.kr(\period.kr(9e10).reciprocal),
				// \trig.kr(1),
				\startpos.kr(0) + 10 * 44100, 1);
		} +> \cauche1;
	}
	*phrase1 {
		// \phrase1src *> \phrase1fx;
		{
			var input, fxlevel, fx;
			var src, chain;
			input = PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.5, 1.5),
				Impulse.kr(\period.kr(9e10).reciprocal),
				// \trig.kr(1),
				\startpos.kr(809) + 10 * 44100, 1);
			fxlevel = \fxlevel.kr(0, 1);
			src = input;
			chain = FFT(LocalBuf(2048, 1), src);
			chain = PV_MagBelow(chain, \thresh.kr(1).urange(0.001, 500));
			// Pan2.ar(IFFT(chain), \pan.kr(0)) * 5;
			fx = IFFT(chain);
			// [input * (1 - fxlevel), fx * fxlevel];
			// input.stereo;
			fx;
		}.playFor(\phrase1src, 120);
		/*
		{
			var input, fxlevel, fx;
			var src, chain;
			fxlevel = \fxlevel.kr(0, 1);
			input = Inp.ar;
			src = input;
			chain = FFT(LocalBuf(2048, 1), src);
			chain = PV_MagBelow(chain, \thresh.kr(1).urange(0.001, 500));
			// Pan2.ar(IFFT(chain), \pan.kr(0)) * 5;
			fx = IFFT(chain);
			[input * (1 - fxlevel), fx * fxlevel];
		}.playFor(\phrase1fx, 120)
		*/
	}

	*phrase2 {
		{
			PlayBuf.ar(1, \prologue.b, \rate.kr(0.75, 1).urange(0.5, 1.5),
				Impulse.kr(\period.kr(9e10).reciprocal),
				// \trig.kr(1),
				\startpos.kr(809) + 10 * 44100, 1);
		}.playFor(\phrase2, 120);
	}
}