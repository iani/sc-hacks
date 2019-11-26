IDE_Fantasy start: \stanford;
//:
\lsm1.v(
	\freq.slider(\freq, \lsm1),
	\amp.slider(\amp, \lsm1),
	\rate.slider([0.2, 5], \lsm1)
);
//:
\freq <+.lsm1 '/pi5'.osc(0, [-40, 40], \freq);
\amp <+.lsm1 '/gyroscope1'.osc(1, [-40, 40], \amp);
\rate <+.lsm1 '/gyroscope1'.osc(2, [-40, 40], [0.2, 5]);
//:
//: initial tests
\ide addDependant: { | ... args | args. postln; };
//:
\ide.releaseDependants;
//:


// ================================================================
//: old stuff

\ide.window({ | w |
	var widget, busnames;
	busnames = IDE_Fantasy.busnames;
	w.view.layout = VLayout(
		widget = NumberBox();
		widget.addNotifier(\ide, \stanford1ax, { | val |
			{ widget.value = val }.defer;
		});
		widget;
	);
})

//:
IDE_Fantasy.pollRate;
//:
IDE_Fantasy.default.pollRate;
//:
IDE_Fantasy.pollRate = 1.0.rand max: 0.1;
//:
IDE_Fantasy() === IDE_Fantasy();
//:
a = Registry(\testing, { IDE_Fantasy.newCopyArgs });
//:
b = Registry(\testing, { IDE_Fantasy.newCopyArgs });
//:
a === b;
//:
IDE_Fantasy start: \stanford;
//:
IDE_Fantasy().pollRate;
//:
IDE_Fantasy.default === IDE_Fantasy.default;
//:
IDE_Fantasy.default.addDependant({ | ... args | args.postln; })
//:
IDE_Fantasy.default.releaseDependants;
