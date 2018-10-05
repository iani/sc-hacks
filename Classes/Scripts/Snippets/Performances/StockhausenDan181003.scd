
//:Complete foundation for channel 1
var func;
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
//:preparing GUI for FORMSCHEMATA
var makeCycle;

makeCycle = { | numPeriods = 10, dur = 6, name = "A" |
	VLayout(
		StaticText()
		.background_(Color.rand(0.7, 1.0))
		.string_(name),
		*( {HLayout(
			*({
				CheckBox()
				.background_(Color.red)
			} ! numPeriods
			)
		)} ! 6
		))
};

'STOCKHAUSEN SOLO'.window({ | w |
	w.bounds = Window.availableBounds.width_(100).height_(100);
	w.view.layout = HLayout(
		*(((0..5) + 65)
			.collect({ | i | i.asAscii.asString })
			.collect({ | n | makeCycle.(10, 6, n)})
		)
		)
})
//: