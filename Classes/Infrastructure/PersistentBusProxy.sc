PersistentBusProxy {
	/* Created by symbol @.adverb symbol.
	Helps player bus links with extra specs provided by @, when using *>, *< operators. */
	var <>envir, <>param, <>adverb, <>numChannels = 1;

	*new { arg envir, param, numChannels = 1;
		// Get envir, but do not make bus.
		^this.newCopyArgs(envir.e, param, numChannels)
	}

	linkTo { | persistentBusProxy |
		// makeAudio creates bus.  addAudio2Envir adds it to the second envir.
		^envir.getAudioBus(param, numChannels).addAudio2Envir(
			persistentBusProxy.envir, persistentBusProxy.param);
	}

	asPeristentBusProxy { ^this }

	printOn { arg stream;
		stream << "(" << envir << " @." << adverb << " " << param << ")";
	}
	storeOn { arg stream;
		stream << "(" << envir << " @." << adverb << " " << param << ")";
	}
}
