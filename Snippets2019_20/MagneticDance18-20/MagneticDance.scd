// Notes for Magnetic dance
//:server (boot server for sound)
// This snippet is empty. It is here to boot the server when starting other snippets
//:preload include synthdefs01 allwk
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
//:gyroscope -> simplesound
\default +> \default;
\default.v(
	\x.slider([-50, 50]),
	\y.slider([-50, 50]),
	\y.slider([-50, 50])
);
\default.watch(\x, { | val |
	\freq <+ [100, 5000, \exp].asSpec.map([-50, 50].asSpec.unmap(val))
});
Registry(\oscfuncs, \gyroscope, {
	OSCFunc({ | msg |
		\x <+ msg[1];
	}, \gyroscope)
}).enable;
//:Send messages to self to test OSC reception
{
	var me;
	me = NetAddr.localAddr;
	postf("Will send messages to: %\n", me);
	1.wait;
	10 do: { | i |
		me.sendMsg(\testing, i);
		0.2.wait;
	}
}.fork;
//:check environment
currentEnvironment.postln;
//:osc messages to listen to
/*
'/temperature'
'/acceleration'
'/magnetometer'
'/gyroscope'
*/

//:first test with gyroscope
\testing <+ '/gyroscope'.osc(0, [-50, 50], [200, 5000]);
//:test mysterymetals synthdef
\mysterymetals +> \mysterymetals
//:change a parameter in mysterymetals
\pulse <+.mysterymetals 0.3;
//:change spulse in mysterymetals
\spulse <+.mysterymetals 5;
//:start simple sound: default
\default +>.default \default;
//:change frequency with gyroscope x
// test only: \freq <+ 100;
\freq <+ '/gyroscope'.osc(0, [-50, 50], [200, 5000]);
//:test with GrainBuf
//: GrainBuf: Duty scrolls through buffer
{
	var duty;
	duty = Duty.kr(
		\period.kr(1),
		0,
		Dseq((0..100), inf) / 100
	);
	GrainBuf.ar(1,
		Changed.kr(duty),
		\dur.kr(1),
		\allwk.bufnum,
		\rate.kr(1),
		\pos.kr(0) // duty, // \pos.kr(0)
	)
} +> \grainbuf;
//:
\grainbuf.v(
	\period.slider([0.05, 2]),
	\dur.slider([0.05, 2]),
	\rate.slider([0.1, 10]),
	\pos.slider([0, 3.5])
);

// \period <+ 0.1;
// \dur <+ 0.25;
\rate <+.grainbuf '/gyroscope'.osc(0, [-40, 40], [0.1, 2]);
\dur <+.grainbuf '/magnetometer'.osc(0, [-0.5, 0.5], [0.1, 2.5]);
// \period <+.grainbuf '/gyroscope'.osc(2, [-40, 40], [0.1, 2.5]);
\pos <+.grainbuf '/acceleration'.osc(0, [-10, 10], [0, 3.5]);
//: allwk .b play
\allwk.b.play;
