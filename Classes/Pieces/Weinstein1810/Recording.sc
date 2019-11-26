
Recording {
	*gui {
		\directInput.window({ | window |
			window.view.layout = VLayout(
				Button().states_([["start recording"]])
				.action_({
					Recording.startRecording;

					"debugging start recording".postln;
				}),
				Button().states_([["stop recording"]])
				.action_({ Recording.stop })
			)
		})
	}

	*startRecording {
		/* {
			var in;
			in = In.ar(4);
			Out.ar(10, in);
			// Out.ar(11, In.ar(0));
			Out.ar(11, SinOsc.ar(100, 0, 0.1));
			// Out.ar(12, In.ar(1));
			Out.ar(12, SinOsc.ar(200, 0, 0.1));
			Out.ar(13, In.ar(4));
			Out.ar(14, In.ar(5));
			Silent.ar;
		} +> \directInput;
		*/
		Server.default.record(bus: 0, numChannels: 5, duration: 20 * 60);
		"RECORDING STARTED".postln;
	}

	*stop {
		Server.default.stopRecording;
		"RECORDING STOPPED".postln;		
	}
}