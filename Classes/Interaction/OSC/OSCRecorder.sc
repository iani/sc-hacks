/* 27 Oct 2018 07:56
Record all incoming osc messages.
Optionally skip messages from server port 57110.
*/

OSCRecorder {
	var <skipServer, <messages, <oscRecvFunc;
	var <pathName;

	*gui {
		this.default.gui;
	}

	*default {
		^Registry(this, \default, { this.new });
	}

	*new { | skipServer = true, messages |
		^this.newCopyArgs(skipServer).init(messages);
	}

	init { | argMessages |
		messages = argMessages ?? { List() };
		oscRecvFunc = { | msg, time, addr, recvPort |
			// postf("RECORDING time %, addr %, recvPort %\n", time, addr, recvPort);
			if (skipServer and: { addr.port == 57110 }) {
				//	"Skipping server".postln;
			}{
				postf("Recording this: %\n", msg);
				messages add: [time, msg, addr];
			};
		};
	}

	gui {
		this.tl_.v(
			[
				"Record", { this.record },
				"Stop Recording", { this.stopRecording },
			].button
		)
		
	}
	
	record {
		thisProcess addOSCRecvFunc: oscRecvFunc;
	}

	stopRecording {
		thisProcess removeOSCRecvFunc: oscRecvFunc;
		this.save;
	}

	save {
		pathName = PathName(
			Platform.userAppSupportDir +/+
			 "OSC_Recording" ++ Date.localtime.stamp ++ ".sctxar";
		);
		messages.writeArchive(pathName.fullPath);
		postf("Saved % osc messages to: %\n", messages.size, pathName.fileName);	
	}

	load {
		
		
	}
	
	play {
		"Playing not implemented".postln;
	}

	stopPlaying {}
	
	
}