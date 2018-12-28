//:Button for oscfunc trace on/off
\osctrace.v(
	Button()
	.states_([["OSC Trace on"], ["OSC Trace off"]])
	.action_({ | me |
		OSCFunc.trace([true, false][me.value]);
		\tracestate <+ me.value;
	})
	.value_(\tracestate.value ? 1)
)