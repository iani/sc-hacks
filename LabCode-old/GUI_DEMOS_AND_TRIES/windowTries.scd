
\window.window.front;

\window.window (rect: Rect (100, 100, 400, 200)).front;


//: change layouts:
\anotherWindow.layout_ (VLayout (Slider ())).front;

\anotherWindow.layout_ (VLayout (NumberBox ())).front;

\anotherWindow.vlayout (*({ Slider () } ! 10)).front;

\anotherWindow.hlayout (*({ Slider () } ! 10)).front;

\anotherWindow.hlayout (*({ Slider () } ! 20)).front;

\anotherWindow.vlayout (*({ Slider.horizontal } ! 20)).front;

\anotherWindow.layout.add (TextView ().string_ ("test"));

\anotherWindow.layout.add (StaticText ().string_ ("test"));

//:
\anotherWindow.layout.add (
	HLayout (
		StaticText ().string_ ("test"),
		Slider.horizontal
	)
);
//:
\anotherWindow.layout.add (
	Button ()
	.states_ ([["off"], ["on"]])
	.action_ ({ | me |
		me.states [me.value].postln;
	})
)
//:
\anotherWindow.window.front;
//:
var synth;
\anotherWindow.hlayout (
	Button.actions_ (
		[
			"one", {
				"one".postln;
			},
			"two", {
				"two".postln;
			},
			"three", { "three".postln}
		]
	)
).front;
\anotherWindow.layout.add (
	Button.actions_ ([
		"start", { synth = { WhiteNoise.ar (0.1)}.play },
		"stop", { synth.free }
	]
	)
)