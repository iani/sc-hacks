/*
 5 Oct 2018 10:57

Jonathan Harvey: Ricercare una melodia.

Contents of info patcher README:

REQUIREMENTS: allocated min. 16Mb. Soundcard with four outputs.

OUTPUTS: The routing of outputs 1-4 depends on the particular system configuration (requires a 4-channel audio card). You can change the output channels number with the four number boxes, bottom left, near the dac object.
The outputs 1 to 4 correspond to the loudspeakers like this :
														1				3
														2				4
LEVELS: Input and four outputs from processing are monitored graphically in the MSP patch. They are best controlled at the audio mixer during performance. However, graphic controls are provided for the control of individual output levels for the third sequence, of general output for the first sequence and of general output.
MEMORY: All the user settings are stored automatically when you close the patch (or by pressing the "store settings" button), in a max text file called "mmemory" and located in the same folder than the application ricercare. So, all is preserved when you close and re-open the application (dac output channels, midi settings, levels, play mode).

How to use it?

First time :

pedal settings : set the input controller OMS name, controller number, pedal polarity. It may be useful to open "p infoctlin" to monitor the midi input messages your computer receives.

DSP settings : double-click on the dac~  object opens the dsp status window, where you can choose the sound driver, etc.
The four number boxes above the dac~ object lets you change the names or orders of the outputs : for instance, when in rehearsal, you can output on "1 2 1 2" if you've got only two output channels.

Level settings. It's always better to let the master out level at the maximum;
Part one has one fader, because the output signals are exactly the same in the four loudspeakers (but delayed)
Part three has four faders, corresponding to the four transpositions, or to the four sounds, and to the four loudspeakers.
Play:
clicking on "reset" open the dac, pedal reception, initializes patchers and cues;
makes it ready to play from the beginning.
For the rehearsal, clik and drag on the number box "Next Cue" : the patch wait for a pedal trigger or space bar to play that cue.
"enter" stops the event being played and re-position at the beginning of this cue (waiting for pedal trigger or space bar).

What happens? :
1. 	incoming signal is delayed 3 sec in channel 1, and 6, 9, 12 sec respectively in channels 2, 3, 4.
2. 	Start automatic fader play
3. 	Fade out
4. 	close the delay lines
5. 	after 6, 18, 42, 90 sec, with the same durations the incoming signal is transposed, delayed and feds the channels 1, 2, 3, 4 
6. 	stops the recording of the buffer for transpositions
7.	12 sec fade out
*/
HarveyRicercare {
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
	*start {
		LPD8.gui;
		Server.default.options.numOutputBusChannels_(4);
		Server.default.boot;
		Server.default.meter;
		this.midi;
		{ this.gui }.defer(1)
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
			Out.ar(0, (in * \level.kr(0.01)).dup(4))

		} +> \direct;
		/* NOTE: Adjust default level according to venue 
		*/
		\level <+.direct 0.09; // edit default level!
		\direct.v(
			\level.slider([0, 1])
		);
		{		
			\ricercare.free;
			0.1.wait;
			\ricercare.b(600);
			0.1.wait;

			{
				\direct.v(
					\level.slider([0, 1])
				);
			}.defer;
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
				channelName.e[\out] = channelNum;
				channelName.e[\rate] = 1;
				[\channelNum, channelNum].postln;
				{ | out = 0, rate = 1 |
					Out.ar(out, 
						PlayBuf.ar(1, \ricercare.b.bufnum, rate, doneAction: 2) * \level.kr(1)
						* EnvGen.kr(Env.adsr(), \gate.kr(1), doneAction: 2)
					)
				} +> channelName;
				/*				
				\channel1.ppp.set(\out, 3);
				
				channelName.e[\out].postln;
				channelName.e.pp.postln;
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
		this.startRecording;
		delayRoutine = {
			// 6, 18, 42, 90 sec
			6.wait;
			"start channel 1 at 1 octave lower".postln;
			\channel1.e[\rate] = 2.reciprocal;
			\channel1.start;
			13.wait;
			"start channel 2 at 2 octaves lower".postln;
			\channel2.e[\rate] = 4.reciprocal;
			\channel2.start;
			24.wait;
			"start channel 3 at 3 octaves lower".postln;
			\channel3.e[\rate] = 8.reciprocal;
			\channel3.start;
			48.wait;
			"start channel 4 at 4 octaves lower".postln;
			\channel4.e[\rate] = 16.reciprocal;
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