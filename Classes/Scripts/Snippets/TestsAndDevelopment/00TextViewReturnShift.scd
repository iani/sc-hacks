//:View Keyboard Actions
\window.v(
	TextView()
	.keyDownAction_({ | me ... args |
		args.postln;
		me.defaultKeyUpAction(*args);
	})
)
//:Catch shift+return
\window.v(
	TextView()
	.keyDownAction_({ | me char, modifier ... args |
		if (char === $\r) {
			modifier.postln;
			(modifier === 131072).postln;
		}{
			char
		};
		me.defaultKeyUpAction(char, modifier, *args);
	})
);
