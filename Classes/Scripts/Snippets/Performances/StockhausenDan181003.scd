
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
";
//:
StockhausenSolo.formschemaI.gui;

StockhausenSolo.formschemaII.gui;
//:
["I", "II", "III", "IV", "V", "VI"] do: { | coda |
	format("StockhausenSolo.formschema%.gui", coda).interpret;
};

//: formschema II template
"
_XX_XX_X_|XXXXX_X|X_X_XX_X_X_|_XX_XX_XX_|X____X|__X___X_
X__X__X_X|XXXXXX_|_X_X__X_X_X|X__X_____X|_XXXX_|X___X___
__X__X__X|_XXXXXX|_XXXXX__XXX|__XXXX__XX|_XXXXX|XX_X____
_X__X__XX|_XXXXXX|__XXXXX__XX|_XXXXXXXXX|__XXXX|_X___X__
__XX_XX_X|_XXXXXX|XXXXXXX_XXX|X_XX_XX_XX|XXXXXX|___XX__X
_XX_XX_XX|_XXXXXX|X_XXXX_X_XX|XXX_X_XX_X|X_X__X|XXX__XX_
"
//: formschema III template
"
X______|XXX___XX__|X__X_XXX|X__XXXXXX|_XXXXXXXXXX|_XXXXX
_XXXXXX|XXXXXXXXXX|_X___X__|X____X___|X______XXXX|_XXXXX
_XXXXXX|_XXXXX_X__|_X__X_XX|XX___XXXX|X_XXXXXXXXX|_XXXXX
__XXXXX|__XXXXXXXX|__XX__XX|_XX___X__|_XXXXXXXXXX|_XXXXX
_XXXXXX|XXXX_XXXX_|__X_XXX_|XXX_XXX_X|_XXX__X____|X_X_X_
__X____|X____X____|X_XXXXXX|XXXX__XX_|_XX_XXXXXXX|X____X
"
//: formschema IV template
"
_X_XXX|X_X_X__X_XX|_XXXXXXX_|X_XXXXX_|X__X__X_X_|X__X_X_
XXXXXX|_X___XX_X__|X___X_X_X|_X______|_X__X__X_X|_XX_X__
____XX|_XX__X____X|__XXXXXXX|_XXXXXXX|_X__X__X_X|_XXX___
_XXXXX|__XXXXXXX__|_XXXXXXXX|__XXXXXX|__X__X__XX|__X__X_
__X_XX|XXXX_XX_X_X|__X_X_X_X|_X__X__X|XXX_XX_XX_|XXXXX__
_X_X__|X__XXXXX_X_|_XXXXXXXX|__XXXXXX|X__X__X__X|X_XX_X_
"
//: formschema V template
"
_X__XXXX|X_X_X_|__X____X__|XXXXXXXXXX_|X_XX_XX|X_X_X_X__
X_XX_XXX|_X_X__|XX_XXXXXX_|X_X_X_X_X_X|_X__X__|_X_X_____
__XXXXXX|_____X|___XXXXXXX|_XXXXXXXXXX|_XXX__X|_XXXX__X_
_XXX__XX|____XX|_XXXXXXXXX|_XXXXXXXXXX|__XXXXX|__XXXXXX_
__XX_X__|XX_X_X|___XXXXXXX|X_X_X_X_X_X|_XX_X_X|XX_X_X_XX
_XXXX_X_|X_X_X_|_XX_XX___X|XX_X_X_X_X_|__XX_X_|X_X_XXX_X
"
//: formschema VI template
"
XXXXXXXXX_|_X_X___XX|_X___X|X____XX|X__X__X_|_X_X__X_XX_
XX________|X_X_X_XXX|X___XX|_X____X|_XX____X|XXX_XX_X___
_XXXXXXXXX|__XXXXXXX|__XXXX|_XXXXXX|_XXXXXXX|____XXXXXX_
_XXXXXXXXX|_XXXX__XX|_XXXXX|__XXXXX|__XXXXXX|_XXXXXXXXX_
_X_XXXXXXX|__XXX_X__|X_XXXX|_X_X_X_|XXX_XX_X|X_X_XXXXXXX
__X_X_X_X_|_XXXXX_X_|XXX_X_|__X_X_X|X_XXX_X_|XX___XX__XX
"