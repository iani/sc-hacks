/* 23 Aug 2020 07:53
Play a buffer at a certain beat in a cycle.
Uses SD to find the buffer and Cyc to determine the beat via Notification.
*/

SDC {
	var <buffer, <>cycle = 12, <>offset = 0;
	var <>defname;
	var <>args; // args for Synth(defname, args);
	var <>verbose = false;
	var <listening = false;

	*new { | buffer, cycle = 12, offset = 0 |
		^this.newCopyArgs(buffer, cycle, offset).init;	
	}

	init {
		defname = format("buf%", buffer.numChannels);
	}

	buffer_ { | argBuffer |
		buffer = argBuffer;
		this.init;
	}

	toggle {
		if (listening) { this.remove } { this.add }
	}
	
	add { // start listening to beats from Cyc
		this.addNotifier(Cyc, \beat, { | beat |
			if (beat + offset % cycle == 0) {
				this.play;
			};
			if (verbose) {
				postf("% - % - %\n",
					beat,
					beat + offset % cycle,
					beat + offset % cycle == 0
				);
			};
		});
		listening = true;
		SD.changed(\players);
	}
	
	remove { // stop listening to beats from Cyc
		this.removeNotifier(Cyc, \beat);
		listening = false;
		SD.changed(\players);
	}
	
	play {
		Synth(defname, [bufnum: buffer.bufnum] ++ args);
	}

	asItem {
		^format("% %", this.bufname,
			if (listening) { "***" } { "" }
		);
	}

	bufname { ^buffer.bufname }

}