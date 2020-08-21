/*  4 Jan 2020 23:43
Return control names of Player's SynthPlayer - if available.
Used to map controls to sensor inputs.
===== tests: =====
\someNotPlayingPlayer.controls;
{ WhiteNoise.ar(\amp.kr(0.01) ).stereo } +> \ihavecontrols;
\ihavecontrols.controls;
(degree: 30) +> \apattern;
\apattern.controls;
*/

/* // this was already defined in file Operators.sc
+ Symbol {
	controls { | envirName |
		^this.p(envirName).controls;
	}
}
*/

+ Player {
	controls {
		// return control inputs of current sourcePlayer's synthdef
		// if available
			^if (sourcePlayer.isNil) {
				^[]
			}{
				^sourcePlayer.controls;
			}
	}	
}

+ SynthPlayer {
	controls {
		^controlNames;
	}
	
}

+ PatternPlayer {
	// can play many synthdefs - therefore cannot guess controls safely.
	controls {
		^[]
	}
}

+ Function {
	@@> { | param, envir |
		// automatically map controls who are named after busses set by sensors.
		// The names of these busses could be stored in Library/Registry
		// to permit customization:
		var busses = #[\x1, \y1, \z1, \x2, \y2, \z2, \x3, \y3, \z3, \x4, \y4, \z4];
		var envirname, controls, controlplayer;
		envir = envir.e;
		envirname = envir.name;
		controlplayer = this.map(envirname, param); 
		// postf("created this controlplayer: %\n", controlplayer);
		controls = controlplayer.controls; // controls are immediately available!
		// postf("% has these controls: %\n", controlplayer, controls);
		controls do: { | c |
			// postf("testing this control: %\n", c);
			if (busses includes: c) {
				//		postf ("connecting % to sensor of same name!!!\n", c);
				// postf("mapping param % to bus % in envir %\n",
				// 	c, c, controlplayer
				// );
				controlplayer.map(c, c);
			}{
				// postf ("There is nothing that I can do with %\n", c);
			}
		}
	}
}