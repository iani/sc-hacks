// 13 Aug 2017 11:21
// A bus that reallocates on server boot, and notifies dependants to update.

PersistentBus {
	var <numChannels, <bus;

	*audio { | numChannels = 1 |
		^this.newCopyArgs(numChannels).makeAudioBus.init;
	}

	makeAudioBus {
		bus = Bus.audio(Server.default, numChannels);
		this.changed(\init);
	}

	init {
		ServerBoot add: { this.makeAudioBus; }
	}
}