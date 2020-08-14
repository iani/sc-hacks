/* 14 Aug 2020 11:48
Use changed mechanism to follow and check timing of Queue execution.
*/
//:draft - now added as default to Queue
var startTime;
Queue.watch(\test, // queueWatcher
	{ | time |
		startTime = time;
		postf("started at: %\n", startTime);
	},
	{ | action, result |
		postf("evaluated: %, got: %\n", action, result);
	},
	{ | time |
		postf("stopped at: %\n", time);
		postf("total duration: %\n", time - startTime);
	}
);
//:testing default functionality.
Queue.watch(\test);

{ | i |
	{ Synth(\default, [freq: i * 100 + 1500, amp: 0.2])}.sync;
} ! 5