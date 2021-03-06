/* 22 Aug 2020 16:14

bufname: Ad hoc simple scheme for generating a name for a buffer from its path.
Concat folder with file name.
Avoids duplicate names in most cases.

ar, fx, pv: construct UGen graph and return OutputProxy. 
Can be used to create synthdef or inside { ... }.play.

bufplay, fxplay, pvplay: use the above methods ar, fx, and pv in a function and 
play that function, creating a Synth.

Synth:trig: concat args with \trig, UniqueID.next, thereby guaranteing 
triggering of PlayBuf to restart from startPos.

*/

+ String {
	bufname {
		// folderName, _, fileNameWithoutExtension of receiver
		// and return result as symbol. 
		var p;
		p = PathName(this);
		^(p.folderName ++ "_" ++ p.fileNameWithoutExtension).asSymbol;
	}
}

+ Symbol {
	load { | path, server |
		// Read buffer from path and store in environment variable
		// Receiver Symbol is the name of the variable.
		currentEnvironment.put(this, Buffer.read(
			server ?? { Server.default },
			path
		))
	}
	
}

+ Buffer {
	bufname { ^this.path.bufname }
	ar { | rate = 1, startPos = 0, loop = 1 |
		// access bufnum and numChans is given as instance variables.
		var buf; // control for changing the bufnum while synth is running
		buf = \bufnum.kr(bufnum); // initialize with current buffer's bufnum
		^PlayBuf.ar(numChannels, buf,
			\rate.kr(rate),
			Changed.kr(\trig.kr(1)),
			\startPos.kr(startPos) * BufSampleRate.kr(buf),
			\loop.kr(loop),
			Done.freeSelf
		)
		
	}

	pv { | func |
		// pass fft of the ar to func and convert fft output of func to audio
		
	}

	fft {
		// create an fft of the ar and return its chain localbuf
	}

	bufplay {
		^{ this.ar }.play;
	}

	fxplay { | func |
		// pass playbuf ugen as input to an fx func and play that func
		
	}

	pvplay { | func |
		// ??? 
	}
}	


	+ Synth {
	trig { | ... args |
		// append \trig to args, setting \trig to new UniqueID.
		// If the synth uses Changed.kr(\trig.kr(1));
		// then this resets BufPlay to startPos.
		this.set(*(args ++ [\trig, UniqueID.next]));
	}

		/*
			fx { | func |
			// Superfluous.  Shorter to inline this.ar inside Func code.
			// pass ar ugen output as input to func
			^func.(this.ar);
			}
		*/
}