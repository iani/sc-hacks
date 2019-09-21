/*  9 Sep 2019 23:34
Draft of model holding list of buffers.

	(
	(this.buffersOrDict.getPairs.asArray.clump(2)
	.collect({ | nameBuffer |
	var name, buffer;
	#name, buffer = nameBuffer;
	format("% (% chan, %)",
	name, buffer.numChannels,
	(buffer.numFrames / buffer.sampleRate).formatTime
	);
	}).sort
	)
	)

*/
/*
BufferListModel {
	var <namedBuffers;

	dict_ { | dictionary |
		namedBuffers = dictionary.asSortedArray collect: NamedBuffer(_);
		this.changed(\buffers);
	}
	
	listItems {
		^buffers.collect({}) ;
	}
}

NamedBuffer {
	var <name, <buffer, <listName;

	*mew { | nameAndBuffer |
		*super.new init: nameAndBuffer
	}

	init { | nameAndBuffer |
		#name, buffer = nameAndBuffer;
		listName = 
	}
	
	play { buffer.play }
	
}
*/