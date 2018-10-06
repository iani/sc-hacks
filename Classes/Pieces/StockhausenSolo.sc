/*
Gui and functionality for playing Stockhausen Solo Nr. 19 for instrumentalist and electronics.
 4 Oct 2018 15:19
*/

StockhausenSolo {
	*initClass {
		StartUp add: {
			LPMini.gui;
			LPD8.gui;
			Server.default.options.numOutputBusChannels_(4);
			Server.default.boot;
			Server.default.meter;
		};
	}

	*formschemaI {
		^StockhausenSoloFormschema(
			[  // numperiods, duration per period
				[11, 6],
				[8, 14.2],
				[7, 19],
				[6, 25.3],
				[9, 10.6],
				[10, 8]
			], thisMethod.name.asString
		)
		.loadPeriodStates(
"
X__X__XXX__|XXXXXXX_|X__X___|X__X__|_X_X_X___|X_X__X_X__
_XX_XX__XXX|XXXXXXX_|XXX_XXX|_XX___|XXXXX_XX_|_X__X_X_X_
_XXXX__XXXX|_XXXXXXX|_X__XXX|_X__XX|__XX__XX_|_XXXXX__X_
__X__XX__XX|_XXXXXX_|_XX__XX|__X___|_XXXXXXXX|__X____XX_
_XX_XX__XX_|_XXX_XXX|XXX_XX_|_XX_XX|X_XXX_XXX|_X_XX_X_XX
__XX__XX__X|_X_XXX_X|___X_XX|__XX__|_X___X__X|X_XX_X_XXX
"	
		);
	}

		*formschemaII {
		^StockhausenSoloFormschema(
			[  // numperiods, duration per period
				[9, 12],
				[7, 24],
				[11, 6],
				[10, 8.5],
				[6, 30.4],
				[8, 17.1]
			], thisMethod.name.asString
		)
			.loadPeriodStates(
"
_XX_XX_X_|XXXXX_X|X_X_XX_X_X_|_XX_XX_XX_|X____X|__X___X_
X__X__X_X|XXXXXX_|_X_X__X_X_X|X__X_____X|_XXXX_|X___X___
__X__X__X|_XXXXXX|_XXXXX__XXX|__XXXX__XX|_XXXXX|XX_X____
_X__X__XX|_XXXXXX|__XXXXX__XX|_XXXXXXXXX|__XXXX|_X___X__
__XX_XX_X|_XXXXXX|XXXXXXX_XXX|X_XX_XX_XX|XXXXXX|___XX__X
_XX_XX_XX|_XXXXXX|X_XXXX_X_XX|XXX_X_XX_X|X_X__X|XXX__XX_
"
				/*
"
X__X__XXX__|XXXXXXX_|X__X___|X__X__|_X_X_X___|X_X__X_X__
_XX_XX__XXX|XXXXXXX_|XXX_XXX|_XX___|XXXXX_XX_|_X__X_X_X_
_XXXX__XXXX|_XXXXXXX|_X__XXX|_X__XX|__XX__XX_|_XXXXX__X_
__X__XX__XX|_XXXXXX_|_XX__XX|__X___|_XXXXXXXX|__X____XX_
_XX_XX__XX_|_XXX_XXX|XXX_XX_|_XX_XX|X_XXX_XXX|_X_XX_X_XX
__XX__XX__X|_X_XXX_X|___X_XX|__XX__|_X___X__X|X_XX_X_XXX
"	
				*/
		);
		}

		*formschemaIII {
		^StockhausenSoloFormschema(
			[  // numperiods, duration per period
				[7, 30.4],
				[10, 9],
				[8, 20.25],
				[9, 13.5],
				[11, 6],
				[6, 45.6]
			], thisMethod.name.asString
		)
		.loadPeriodStates(
"
X______|XXX___XX__|X__X_XXX|X__XXXXXX|_XXXXXXXXXX|_XXXXX
_XXXXXX|XXXXXXXXXX|_X___X__|X____X___|X______XXXX|_XXXXX
_XXXXXX|_XXXXX_X__|_X__X_XX|XX___XXXX|X_XXXXXXXXX|_XXXXX
__XXXXX|__XXXXXXXX|__XX__XX|_XX___X__|_XXXXXXXXXX|_XXXXX
_XXXXXX|XXXX_XXXX_|__X_XXX_|XXX_XXX_X|_XXX__X____|X_X_X_
__X____|X____X____|X_XXXXXX|XXXX__XX_|_XX_XXXXXXX|X____X
"	
		);
		}

		*formschemaIV {
		^StockhausenSoloFormschema(
			[  // numperiods, duration per period
				[6, 45.6],
				[11, 6],
				[9, 13.5],
				[8, 20.25],
				[10, 9],
				[7, 30.4]
			], thisMethod.name.asString
		)
		.loadPeriodStates(
"
_X_XXX|X_X_X__X_XX|_XXXXXXX_|X_XXXXX_|X__X__X_X_|X__X_X_
XXXXXX|_X___XX_X__|X___X_X_X|_X______|_X__X__X_X|_XX_X__
____XX|_XX__X____X|__XXXXXXX|_XXXXXXX|_X__X__X_X|_XXX___
_XXXXX|__XXXXXXX__|_XXXXXXXX|__XXXXXX|__X__X__XX|__X__X_
__X_XX|XXXX_XX_X_X|__X_X_X_X|_X__X__X|XXX_XX_XX_|XXXXX__
_X_X__|X__XXXXX_X_|_XXXXXXXX|__XXXXXX|X__X__X__X|X_XX_X_
"	
		);
	}

		*formschemaV {
		^StockhausenSoloFormschema(
			[  // numperiods, duration per period
				[8, 22.8],
				[6, 45.6],
				[10, 11.4],
				[11, 8],
				[7, 32],
				[9, 16]
			], thisMethod.name.asString
		)
		.loadPeriodStates(
"
_X__XXXX|X_X_X_|__X____X__|XXXXXXXXXX_|X_XX_XX|X_X_X_X__
X_XX_XXX|_X_X__|XX_XXXXXX_|X_X_X_X_X_X|_X__X__|_X_X_____
__XXXXXX|_____X|___XXXXXXX|_XXXXXXXXXX|_XXX__X|_XXXX__X_
_XXX__XX|____XX|_XXXXXXXXX|_XXXXXXXXXX|__XXXXX|__XXXXXX_
__XX_X__|XX_X_X|___XXXXXXX|X_X_X_X_X_X|_XX_X_X|XX_X_X_XX
_XXXX_X_|X_X_X_|_XX_XX___X|XX_X_X_X_X_|__XX_X_|X_X_XXX_X
"	
		);
		}

		*formschemaVI {
		^StockhausenSoloFormschema(
			[  // numperiods, duration per period
				[10, 14.2],
				[9, 19],
				[6, 45.6],
				[7, 34.2],
				[8, 25.3],
				[11, 10.6]
			], thisMethod.name.asString
		)
		.loadPeriodStates(
"
XXXXXXXXX_|_X_X___XX|_X___X|X____XX|X__X__X_|_X_X__X_XX_
XX________|X_X_X_XXX|X___XX|_X____X|_XX____X|XXX_XX_X___
_XXXXXXXXX|__XXXXXXX|__XXXX|_XXXXXX|_XXXXXXX|____XXXXXX_
_XXXXXXXXX|_XXXX__XX|_XXXXX|__XXXXX|__XXXXXX|_XXXXXXXXX_
_X_XXXXXXX|__XXX_X__|X_XXXX|_X_X_X_|XXX_XX_X|X_X_XXXXXXX
__X_X_X_X_|_XXXXX_X_|XXX_X_|__X_X_X|X_XXX_X_|XX___XX__XX
"	
		);
	}
}


StockhausenSoloFormschema {
	var <cycles;
	var <name;
	var runTask, stream;
	var <cycleOnsets;
	var <>speed = 1 ; // play speed;
	*initClass {
		StartUp add: {
			//			 { this.gui }.defer(1)
		}
	}

	*gui { this.default.gui; }

	*default {
		^Registry(this, \default, { this.new });
	}

	*new { | cycleSpecs, name |
		^super.new.init(cycleSpecs ?? { this.defaultSpecs }, name)
	}

	*defaultSpecs {
		// specs for FORMSCHEMA A
		^[  // numperiods, duration per period
			[11, 6],
			[8, 14.2],
			[7, 19],
			[6, 25.3],
			[9, 10.6],
			[10, 8]
		]
	}

	init { | cycleSpecs, argName |
		cycleOnsets = [0] ++ cycleSpecs.collect(_.product).integrate;
		cycles = cycleSpecs collect: { | cs, i |
			StockhausenSoloCycle(*(cs add: (i + 1) add: this))
		};
		name = argName;
	}

	loadPeriodStates { | specString |
		var convertedData;
		convertedData = specString.split(Char.nl)
		.select({ | s | s.size > 0})
		.collect({ | s | s.split($|)})
		.flop
		.collect({ | s |
			s.collect (_.ascii).flop
			.collect({ | a | a.collect({ | b | (b == 88).binaryValue })});
		});
		/*
		"Just parsed the data successfully".postln;
		"Here is a preliminary check. Here come the data".postln;

		convertedData.do( { | cycle, index |
			postf("We are now loading cycle number: %\n", index + 1);
			cycle do: _.postln;});
		*/
		convertedData do: { | cycle, index |
			cycles[index].loadPeriodStates(cycle); 
		}
		
	}
	
	gui {
		name.asSymbol.window({ | w |
			w.bounds = Window.availableBounds.width_(100).height_(100);
			w.view.layout = VLayout(
				this.headerGui,
				this.cyclesGui,
				this.progressGui,
			);
		});
		this.changed(\duration, this.duration);
	}

	headerGui {
		^HLayout(
			Button().states_([["save"]]).action_({ this.save }),
			Button().states_([["load"]]).action_({ this.load }),
			Button().states_([["start"], ["stop"]])
			.action_({ | me |
				[{
					this.stop;
				},{
					this.play;
				}][me.value].value;
			})
			.addNotifier(this, \play, { | n |
				n.listener.value = 1;
			})
			.addNotifier(this, \stop, { | n |
				n.listener.value = 0;
			}),
			Button().states_([["Reset"]])
			.action_({ this.reset; }),
			ActionMenu("Jump to:...",
				"A", {},
				"B", {},
				"C", {},
				"D", {},
				"E", {},
				"F", {},
			),
			StaticText().string_("Status:"),
			Button().states_([["stopped"], ["running"]])
			.addNotifier(this, \play, { | n |
				n.listener.value = 1;
			})
			.addNotifier(this, \stop, { | n |
				n.listener.value = 0;
			}),
			StaticText().string_("Cycle:"),
			NumberBox().maxWidth_(30),
			StaticText().string_("Period:"),
			NumberBox().maxWidth_(30),
			StaticText().string_("Time:") ,
			NumberBox().maxWidth_(50)
			.addNotifier(this, \time, { | time, n |
				{ n.listener.value = time / 60 }.defer;
			}),
			StaticText().string_("Total Dur.:"),
			NumberBox().maxWidth_(30)
			.addNotifier(this, \duration, { | dur, n |
				n.listener.value = (dur / 60).floor.asInteger;
			}),
			NumberBox().maxWidth_(30)
			.addNotifier(this, \duration, { | dur, n |
				n.listener.value = (dur % 60).floor(1).asInteger;
			})
		)
	}
	cyclesGui {
		^HLayout(*(cycles.collect(_.gui)));
	}

	progressGui {
		^Slider()
		.orientation_(\horizontal)
		.addNotifier(this, \period, { | periodNum, n |
			{ n.listener.value = periodNum - 1 / this.numPeriods; }.defer;
		});
	}
	
	duration { ^cycles.collect(_.duration).sum }

	asStream {
		^Pseq(cycles collect: _.asStream).asStream;
	}

	numPeriods {
		^cycles.collect(_.numPeriods).sum;
	}

	play {
		if (this.isPlaying) {
			postf("% is already playing\n", this);
		}{
			this.startAudio;
			this.runTask.play;
			this.changed(\play);
		};
	}

	isPlaying {
		^this.runTask.isPlaying;
	}
	startAudio {
		var func;
		"Starting audio".postln;
		\buffer1.b(25.3);
		\buffer2.b(25.3);

		\stockhausen.v(
			\input.slider([0, 1.0], \stock1, "add 1"),
			\feedback.slider([0, 1.0], \stock1, "keep 1"),
			\playback.slider([0, 1.0], \stock1, "play 1"),
			\input.slider([0, 1.0], \stock2, "add 2"),
			\feedback.slider([0, 1.0], \stock2, "keep 2"),
			\playback.slider([0, 1.0], \stock2, "play 2"),
		);

		func = { | out = 0, buffer = 0 |
			var dt, trigger, playback;
			dt = \dt.kr(6); // Formschema 1 A
			trigger = Impulse.kr(dt.reciprocal) + Changed.kr(dt);
			// playback _BEFORE_ recording
			playback = Lag.kr(\playback.kr(0), 0.2) * // default on
			PlayBuf.ar(1, buffer, trigger: trigger, startPos: 0);
			RecordBuf.ar( // record + feedback
				(
					Lag.kr(\input.kr(1), 0.2) * In.ar(4) // default on
				) +
				(
					Lag.kr(\feedback.kr(0), 0.2) * // default off
					PlayBuf.ar(1, buffer, trigger: trigger, startPos: 0)
				),
				buffer, offset: 0, loop: 1, trigger: trigger);
			Out.ar (out, playback); // playback before recording
		};

		\out <+.stock1 0;
		\out <+.stock2 1;
		\buffer <+.stock1 \buffer1.b.bufnum;
		\buffer <+.stock2 \buffer2.b.bufnum;

		func +> \stock1;
		func +> \stock2;
		
	}
	
	runTask {
		^runTask ?? {
			runTask = Task({
				var period, duration = 0;
				stream = this.asStream;
				while {
					(period = stream.next).notNil;
				}{
					if (period.duration != duration) {
						duration = period.duration;
						\dt <+.stock1 duration;
						\dt <+.stock2 duration;
					};
					period.play(this);
					(period.duration / speed).wait;
				}
			})
		}
	}

	stop {
		this.runTask.stop;
		this.changed(\stop);
	}

	reset {
		this.stop;
		stream = this.asStream;
		this.changed(\period, 0);
		this.changed(\time, 0);
		StockhausenSoloPeriod.resetAudioParameters;
	}

	save {
		cycles.collect(_.periods);
		
	}

	load {
		Dialog.openPanel({ | p |
			p.postln;
			
		})
		
	}
}


StockhausenSoloCycle {
	var <numPeriods = 10, <periodDuration = 6, <num, <solo;
	var <periods;
	var <name;
	var <onset;  // onset dt from start of performance

	*new { | numPeriods = 10, periodDuration = 6, num = 0, solo |
		^this.newCopyArgs(numPeriods, periodDuration, num, solo).init;
	}

	init {
		name = (64 + num).asAscii.asString;
		onset = solo.cycleOnsets[num - 1];
		periods = { | i |
			StockhausenSoloPeriod(periodDuration, i + 1, this)
		} ! numPeriods;
	}

	gui {
		^VLayout(
			StaticText()
			.background_(Color.rand(0.7, 1.0))
			.string_(name),
			*periods.collect(_.widgets).flop.collect(HLayout(*_));
			/*
				{HLayout(
				*({
				CheckBox()
				} ! numPeriods
				)
				)} ! 6
			*/
		)
	}
	duration { ^(periodDuration * numPeriods) }

	asStream {
		^Pseq(periods).asStream;
	}

	periodsBefore {
		var result = 0;
		solo.cycles do: { | c |
			if (c === this) {
				^result;
			}{
				result = result + c.numPeriods;
			}
		};
		^result;
	}

	loadPeriodStates { | argPeriods |
		argPeriods do: { | periodStates, i |
			periods[i] loadPeriodStates: periodStates;
		}
	}
}

StockhausenSoloPeriod {
	var <duration = 6, <num = 0, <cycle;
	var <onset;  // onset dt from start of performance;
	var <actions;

	*new { | duration = 6, num = 0, cycle |
		^this.newCopyArgs(duration, num, cycle).init;
	}

	absNum {
		^num + cycle.periodsBefore;
	}
	
	init {
		onset = num - 1 * duration + cycle.onset;
		actions = this.class.actions;
	}

	*actions {
		^[
			[\stock1, \input],
			[\stock2, \input],
			[\stock1, \feedback],
			[\stock2, \feedback],
			[\stock1, \playback],
			[\stock2, \playback],
		] collect: StockhausenSoloAction(*_)		
	}

	widgets {
		^actions collect: _.widget;
		
	}

	play { | solo |
		actions do: _.play;
		solo.changed(\period, this.absNum);
		cycle.solo.changed(\time, onset);
	}

	actions_ { | states |
		states do: { | a, i | actions[i].state = a; }
	}

	*resetAudioParameters {
		// reset all audio parameters to 0
		this.actions do: _.play;
	}

	loadPeriodStates { | argActionStates |
		argActionStates do: { | state, i |
			actions[i].state = state;
		}
	}
}

StockhausenSoloAction {
	/* perform a single action according to your state and kind,
		i.e. set a parameter in an environment of the performance */
	var <envirName = \stock1;
	var <param = \input;
	var <state = 0;
	var <envir;

	*new { | envirName, param |
		^this.newCopyArgs(envirName, param).init;
	}
	
	init {
		envir = envirName.e;
	}
	
	widget {
		^CheckBox()
		.value_(state)
		.addNotifier(this, \state, { | state, n |
			n.listener.value = state;
		})
		.action_({ | me | state = me.value.binaryValue });
	}

	state_ { | argState |
		state = argState;
		this.changed(\state, state);
	}
	
	play {
		envir.put(param, state);
	}
	
}
/*
StockhausenSolo.default.writeArchive("/Users/iani/test.sctxar");

Object.readArchive("./test.sctxar").gui;

*/