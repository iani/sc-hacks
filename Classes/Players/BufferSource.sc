/*
27 Nov 2018 16:42 / 28 Nov 2018 08:36

A BufferSource holds specs for allocating buffers  and a source to be sent to a player. 
Its purpose is to allocate new buffers and send the source to the player only exactly after all of the buffers have been allocated.

Usage syntax draft: 

	// example 1: 1 buffer spec
\buffername.cb(3) +> { PlayBuf.ar(\buffename.bufnum) } +> \player;
	// example 2: array of buffer specs
[\buffer1, 2, \buffer2, 5].cb +> 
{ PlayBuf.ar(\buffer1.bufnum) + PlayBuf.ar(\buffer2.bufnum) } +> \player;

symbol or array .cb returns bufferspec.
bufferspec +> source returns BufferSource
BufferSource +> symbol plays BufferSource in player

Note: This solution should be incorporated in a generalized global action load 
to be implemented as class ActionQueue.


*/

BufferStream {
	var <specs, <stream, <action, <isRunning = false;

	*new { | specs |
		^this.newCopyArgs(specs).init;
	}

	init {
		stream = Pseq(specs.clump(2)).asStream;
	}

	play { | argAction |
		action = argAction;
		if (isRunning) { ^postf("% is already loading\n", this) };
		this.loadNext;
	}

	loadNext {
		var spec;
		spec = stream.next;
		if (spec.isNil) {
			action.value;
		}{
			spec[0].free.b(spec[1], { this.loadNext });
		};
	}
	
	+> { | source | // envir argument also here????

	}
}

BufferSource {
	var <bufSpec, <source;

	*new { | bufSpec, source |
		^this.newCopyArgs(bufSpec, source);
	}

	+> { | player, envir |
		// play Event as PatternPlayer
		^this.allocPlay(player.asPlayer(envir));
	}

	allocPlay { | player |
		this.alloc({ player.play(source) });
		^player;
	}

	alloc {
		var stream;
		//		stream = 
		
	}
}