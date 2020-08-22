/* 23 Aug 2020 07:53
Play a buffer at a certain beat in a cycle.
Uses SD to find the buffer and Cyc to determine the beat via Notification.
*/

SDC {
	var <buffer, <>cyclelength = 12, <>beatoffset = 0;
	var <>defname;
	var <>args; // args for Synth(defname, args);

	*new { | buffer, cyclelength = 12, beatoffset = 0 |
		^this.newCopyArgs(buffer, cyclelength, beatoffset).init;	
	}

	init {
		defname = format("buf%", buffer.numChannels);
	}

	add { // start listening to beats from Cyc
		this.addNotifier(Cyc, \beat, { | beat |
			if (beat + beatoffset % cyclelength == 0) {
				this.play;
			}
		});
	}

	remove { // stop listening to beats from Cyc
		this.removeNotifier(Cyc, \beat);
	}
	
	play {
		Synth(defname, args);
	}
}