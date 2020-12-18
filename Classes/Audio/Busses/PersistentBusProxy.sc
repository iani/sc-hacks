PersistentBusProxy {
	/* Created by symbol @.adverb symbol.
	Helps player bus links with extra specs provided by @, when using *>, *< operators. */
	var <>envir, <>param, <>numChannels = 1;
	var <>adverb;

	*new { arg envir, param, numChannels = 1;
		// Get envir, but do not make bus.
		^this.newCopyArgs(envir.ev, param, numChannels)
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
	// obsolete version. See new version: linkWritersBus2Reader
	addReader { | readerBusProxy |  // CREATE ONE-TO-MANY CONNECTIONS BY ADDING READERS.
		// Pass the bus of the writer to the reader, thereby adding one more reader to the writer.
		/*
		addReader: the receiver is a writer.  The argument(reader!) will get the bus of the receiver.
		If the argument/reader already has a bus, then its previous writers are lost, 
		and it is added to the readers of the writer.
		The argument/reader loses its previous writers, and the receiver/writer gets one more reader.

		The writer/receiver must be moved to a group before the group of the reader/argument,
		but only if the group of the writer is not already before the group of the reader.
		*/
		readerBusProxy.addAudioBus(envir.getAudioBus(param, numChannels));
		envir.addReader(readerBusProxy.envir);
	}

	addAudioBus { | persistentBus |
		envir.addAudioBus(param, persistentBus);
	}	

	// new version
	linkReadersBus2Writer { | writerBusProxy |
		// CREATE MANY-TO-ONE CONNECTIONS BY ADDING WRITERS.
		/*
		addWriter: The receiver is a reader.  The argument/writer will get the bus of 
			the receiver.
		The writer loses its previous readers and the reader gets one more writer.

		The writer/receiver must be moved to a group before the group of the reader/argument,
		but only if the group of the writer is not already before the group of the reader.
		*/
		// first get bus from own envir (i.e. reader's bus),
		// then add reader envir to he writer envir bus via the proxy
		writerBusProxy.addAudioBus(envir.getAudioBus(param, numChannels));
		writerBusProxy.envir.addReaderEnvir(envir);
	}

	// new version
	linkWritersBus2Reader { | writerBusProxy |
		// CREATE MANY-TO-ONE CONNECTIONS BY ADDING WRITERS.
		/*
		addWriter: The receiver is a reader.  The argument/writer will get the bus of 
			the receiver.
		The writer loses its previous readers and the reader gets one more writer.

		The writer/receiver must be moved to a group before the group of the reader/argument,
		but only if the group of the writer is not already before the group of the reader.
		*/
		// first get bus from envir of writerBusProxy
		// then add it to the readers bus
		this.addAudioBus(
			writerBusProxy.envir.getAudioBus(
				writerBusProxy.param,
				writerBusProxy.numChannels
			)
		);
		writerBusProxy.envir.addReaderEnvir(envir);
	}

	asPeristentBusProxy { ^this }

	printOn { arg stream;
		stream << "(" << envir << " @." << numChannels << " " << param << ")";
	}
	storeOn { arg stream;
		stream << "(" << envir << " @." << numChannels << " " << param << ")";
	}

	// utility method for building IO links
	getBus {
		^envir.getAudioBus(param, numChannels);
	}
}
