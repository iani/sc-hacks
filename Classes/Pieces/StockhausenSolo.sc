/*
Gui and functionality for playing Stockhausen Solo Nr. 19 for instrumentalist and electronics.
 4 Oct 2018 15:19
*/

StockhausenSolo {
	var <cycles;
	var runTask, stream;
	*initClass {
		StartUp add: {
			Server.default.boot;
			 { this.gui }.defer(1)
		}
	}

	*gui {
		this.default.gui;
	}

	*default {
		^Registry(this, \default, { this.new });
	}

	*new { | cycleSpecs |
		^super.new.init(cycleSpecs ?? { this.defaultSpecs })
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

	init { | cycleSpecs |
		cycles = cycleSpecs collect: { | cs, i | StockhausenSoloCycle(*(cs add: (i + 1) add: this)) };
	}
	
	gui {
		this.window({ | w |
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
			Button().states_([["stopped"], ["running"]]),
			StaticText().string_("Cycle Num:"),
			NumberBox().maxWidth_(30),
			StaticText().string_("Period Num:"),
			NumberBox().maxWidth_(30),
			StaticText().string_("Time Now:"),
			NumberBox().maxWidth_(50),
			StaticText().string_("Total Duration:"),
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

	play { | speed = 10 |
		if (this.isPlaying) {
			postf("% is already playing\n", this);
		}{
			this.startAudio;
			this.runTask(speed).play;
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
			playback = \playback.kr(1) * // default on
			PlayBuf.ar(1, buffer, trigger: trigger, startPos: 0);
			RecordBuf.ar( // record + feedback
				(
					\input.kr(1) * In.ar(2) // default on
				) +
				(
					\feedback.kr(0) * // default off
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
	
	runTask { | speed = 10 |
		^runTask ?? {
			runTask = Task({
				var period;
				stream = this.asStream;
				while {
					(period = stream.next).notNil;
				}{
					this.changed(\period, period.absNum);
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
	}
}

StockhausenSoloCycle {
	var <numPeriods = 10, <periodDuration = 6, <num, <solo;
	var <periods;
	var <name;

	*new { | numPeriods = 10, periodDuration = 6, num = 0, solo |
		^this.newCopyArgs(numPeriods, periodDuration, num, solo).init;
	}

	init {
		name = (64 + num).asAscii.asString;
		periods = { | i |
			StockhausenSoloPeriod(periodDuration, i + 1, this)
		} ! numPeriods
	}

	gui {
		^VLayout(
			StaticText()
			.background_(Color.rand(0.7, 1.0))
			.string_(name),
			*( {HLayout(
				*({
					CheckBox()
				} ! numPeriods
				)
			)} ! 6
			)
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
	
}

StockhausenSoloPeriod {
	var <duration = 6, <num = 0, <cycle;

	*new { | duration = 6, num = 0, cycle |
		^this.newCopyArgs(duration, num, cycle).init;
	}

	absNum {
		^num + cycle.periodsBefore;
	}
	
	init {
		// ???
		
	}
}