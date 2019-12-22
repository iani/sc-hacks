//:+
1.await;
Time().simpleGui;
\test.changed(\time, 425.7954321);
//:
{
\test.tr_(width: 400).v(
	HLayout(
		StaticText()
		.font_(PlatformGuiDefaults.font)
		.string_("mins"),
		NumberBox()
		.font_(PlatformGuiDefaults.font)
		.addNotifier(\time, \time, { | val, n |
			{ n.listener.value = val div: 60; }.defer;
		}),
		StaticText()
		.font_(PlatformGuiDefaults.font)
		.string_("secs"),
		NumberBox()
		.font_(PlatformGuiDefaults.font)
		.addNotifier(\time, \time, { | val, n |
			{ n.listener.value = val % 60; }.defer;
		})
	)
);
}.defer;
5.await;
"somethinlpostln".postln;
//:second test
5.wait;
"blah".postln;
//:
{ WhiteNoise.ar(0.5).stereo } +> \test;
1.wait;
~fadeTime = 7;
\test.release(7);