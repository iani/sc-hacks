PersistentBusProxy {
	/* Created by symbol @.adverb symbol.
	Helps player bus links with extra specs provided by @, when using *>, *< operators. */
	var <>envir, <>param, <>adverb, <>numChannels = 1;

	*new { arg envir, param, numChannels = 1;
		// Get envir, but do not make bus.
		^this.newCopyArgs(envir.e, param, numChannels)
	}

	/*
		addReader: the receiver is a writer.  The argument will get the bus of the receiver.
		If the argument already has a bus, then its previous writers are lost, 
		and it is added to the readers of the writer.
		The argument/reader loses its previous writers, and the receiver/writer gets one more reader.

		The writer/receiver must be moved to a group before the group of the reader/argument,
		but only if the group of the writer is not already before the group of the reader.

		addWriter: The receiver is a reader.  The argument/writer will get the bus of the receiver.
		The writer loses its previous readers and the reader gets one more writer.

		The writer/receiver must be moved to a group before the group of the reader/argument,
		but only if the group of the writer is not already before the group of the reader.
	*/
	addReader { | readerBusProxy |
		/*
		addReader: the receiver is a writer.  The argument will get the bus of the receiver.
		If the argument already has a bus, then its previous writers are lost, 
		and it is added to the readers of the writer.
		The argument/reader loses its previous writers, and the receiver/writer gets one more reader.

		The writer/receiver must be moved to a group before the group of the reader/argument,
		but only if the group of the writer is not already before the group of the reader.
		*/
		readerBusProxy.addAudioBus(envir.getAudioBus(param, numChannels));
		envir.moveBefore(readerBusProxy.envir);
	}

	addAudioBus { | persistentBus |
		envir.addAudioBus(param, persistentBus);
	}	

	addWriter { | writerBusProxy |
		/*
		addWriter: The receiver is a reader.  The argument/writer will get the bus of the receiver.
		The writer loses its previous readers and the reader gets one more writer.

		The writer/receiver must be moved to a group before the group of the reader/argument,
		but only if the group of the writer is not already before the group of the reader.
		*/
		writerBusProxy.addAudioBus(envir.getAudioBus(param, numChannels));
		writerBusProxy.envir.moveBefore(envir);
	}

	asPeristentBusProxy { ^this }

	printOn { arg stream;
		stream << "(" << envir << " @." << adverb << " " << param << ")";
	}
	storeOn { arg stream;
		stream << "(" << envir << " @." << adverb << " " << param << ")";
	}
}
