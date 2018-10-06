
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
//:preparing load
//  6 Oct 2018 06:09
//:Form schema - from string to array of action states
// correct conversion formula:
"
X__X__XXX__|XXXXXXX_|X__X___|X__X__|_X_X_X___|X_X__X_X__
_XX_XX__XXX|XXXXXXX_|XXX_XXX|_XX___|XXXXX_XX_|_X__X_X_X_
_XXXX__XXXX|_XXXXXXX|_X__XXX|_X__XX|__XX__XX_|_XXXXX__X_
__X__XX__XX|_XXXXXX_|_XX__XX|__X___|_XXXXXXXX|__X____XX_
_XX_XX__XX_|_XXX_XXX|XXX_XX_|_XX_XX|X_XXX_XXX|_X_XX_X_XX
__XX__XX__X|_X_XXX_X|___X_XX|__XX__|_X___X__X|X_XX_X_XXX
".split(Char.nl)
.select({ | s | s.size > 0})
.collect({ | s | s.split($|)})
.flop
.collect({ | s |
	s.collect (_.ascii).flop
	.collect({ | a | a.collect({ | b | (b == 88).binaryValue })});
}).do( { | cycle, index |
	postf("We are now loading cycle number: %\n", index + 1);
	cycle do: _.postln;})
//:Form schema - from string to array of action states
// correct conversion formula:
StockhausenSoloFormschema.default loadPeriodStates: "
X__X__XXX__|XXXXXXX_|X__X___|X__X__|_X_X_X___|X_X__X_X__
_XX_XX__XXX|XXXXXXX_|XXX_XXX|_XX___|XXXXX_XX_|_X__X_X_X_
_XXXX__XXXX|_XXXXXXX|_X__XXX|_X__XX|__XX__XX_|_XXXXX__X_
__X__XX__XX|_XXXXXX_|_XX__XX|__X___|_XXXXXXXX|__X____XX_
_XX_XX__XX_|_XXX_XXX|XXX_XX_|_XX_XX|X_XXX_XXX|_X_XX_X_XX
__XX__XX__X|_X_XXX_X|___X_XX|__XX__|_X___X__X|X_XX_X_XXX
"