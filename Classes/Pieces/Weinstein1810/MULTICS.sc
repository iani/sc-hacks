/*


*/
MULTICS {
	classvar <delayRoutine, <channels;
	
	*initClassDisabled {
		StartUp add: {
			LPD8.gui;
			Server.default.options.numOutputBusChannels_(4);
			Server.default.boot;
			Server.default.meter;
			this.midi;

			{ this.gui }.defer(1)
		}
	}
	
	*midi {
		LPD8(\knoba1, { | val |
			\level <+.channel1 val;
		});
		LPD8(\knoba2, { | val |
			\level <+.channel2 val;
		});
		LPD8(\knoba3, { | val |
			\level <+.channel3 val;
		});
		LPD8(\knoba4, { | val |
			\level <+.channel4 val;
		});
	}

	*gui {
		\ricercare.v(
			HLayout(
				Button().states_([["start rec"]])
				.action_({
					this.startRecording;
				}),
				Button().states_([["stop rec"]])
				.action_({
					this.stopRecording;
				}),
				Button().states_([["start delays"], ["stop delays"]])
				.action_({ | me |
					[{ this.stopDelays }, { this.startDelays }][me.value].value;
				}),
				Button().states_([["start transp"], ["stop transp"]])
				.action_({ | me |
					[{ this.stopTransDelays }, { this.startTransDelays }][me.value].value;
				}),
				
			),
			\level.slider([0, 1], \channel1, "chan 1 level"),
			\level.slider([0, 1], \channel2, "chan 2 level"),
			\level.slider([0, 1], \channel3, "chan 3 level"),
			\level.slider([0, 1], \channel4, "chan 4 level"),
		)
	}

	*startRecording {
		{
			var in;
			in = In.ar(4);
			Out.ar(0, in * \level.kr(0.01))

		} +> \direct;
		\level <+.direct 0.1;
		\direct.v(
			\level.slider([0, 1])
		);
		{		
			\ricercare.free;
			0.1.wait;
			\ricercare.b(600);
			0.1.wait;
			{
				RecordBuf.ar(In.ar(4), \ricercare.b.bufnum, 0,
					\level.kr(1), loop: 0, doneAction: 2
				);
				Silent.ar;
			} +> \ricercare;
			"Recording started".postln;
		}.fork;
	}

	*stopRecording {
		\ricercare.stop;
		"Recording stopped".postln;
	}

	*startDelays {
		channels = [\channel1, \channel2, \channel3, \channel4];
		delayRoutine = {
			channels do: { | channelName, channelNum |
				// \out <+.channelName channelNum;
				channelName.ev[\out] = channelNum;
				channelName.ev[\rate] = 1;
				[\channelNum, channelNum].postln;
				{ | out = 0, rate = 1 |
					Out.ar(out, 
						PlayBuf.ar(1, \ricercare.b.bufnum, rate, doneAction: 2) * \level.kr(1)
						* EnvGen.kr(Env.adsr(), \gate.kr(1), doneAction: 2)
					)
				} +> channelName;
				/*				
				\channel1.ppp.set(\out, 3);
				
				channelName.ev[\out].postln;
				channelName.ev.pp.postln;
				*/
				3.wait;
			};
		}.fork;
	}

	*stopDelays { | delaytime = 0.5 |
		delayRoutine !? {
			delayRoutine.stop;
			channels do: { | player | player.ppp release: delaytime };			
		}
	}

	*startTransDelays {
		delayRoutine = {
			this.startRecording;
			// 6, 18, 42, 90 sec
			6.wait;
			"start channel 1 at 1 octave lower".postln;
			\channel1.ev[\rate] = 2.reciprocal;
			\channel1.start;
			13.wait;
			"start channel 2 at 2 octaves lower".postln;
			\channel2.ev[\rate] = 4.reciprocal;
			\channel2.start;
			24.wait;
			"start channel 3 at 3 octaves lower".postln;
			\channel3.ev[\rate] = 8.reciprocal;
			\channel3.start;
			48.wait;
			"start channel 4 at 4 octaves lower".postln;
			\channel4.ev[\rate] = 16.reciprocal;
			\channel4.start;
		}.fork;
	}

	*stopTransDelays { | delaytime = 12 |
		delayRoutine !? {
			delayRoutine.stop;
			channels do: { | player | player.ppp release: delaytime };			
		}	
	}
	
}