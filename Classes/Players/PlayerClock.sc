// 23 Νοέ 2017 16:40
// A Task that runs with a TempoClock and synchronizes the start point of Players.
PlayerClock {
	var <clock, <beatPattern, <timePattern;
	var beatStream, timeStream;
	var <task;
	
	*new { | clock, beatPattern, timePattern |
		^this.newCopyArgs(clock ?? { TempoClock.default })
		.beatPattern_(beatPattern ?? {
			Pn(\beat, inf);			
		})
		.timePattern_(timePattern ? 1)
		.init
	}
	
	init {
		task = Task({
			var beat, dtime;
			while {
				(beat = beatStream.next).notNil and: {
					(dtime = timeStream.next).notNil
				}
			} {
				this.changed(beat, this);
				dtime.wait;
			}
		});
	}

	beatPattern_ { | pattern |
		beatPattern = pattern;
		beatStream = beatPattern.asStream;
	}

	timePattern_ { | pattern |
		timePattern = pattern;
		timeStream = timePattern.asStream;
	}

	play {
		if (this.isPlaying.not) {
			task.play(clock)			
		}
	}

	isPlaying { ^task.isPlaying }

	stop { task.stop }

	reset { task.reset }

}