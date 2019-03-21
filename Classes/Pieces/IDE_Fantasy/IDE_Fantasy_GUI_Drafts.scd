
IDE_Fantasy.window({ | w |
	w.view.layout = VLayout(
		*({ Slider() } ! 10)
	)
});

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