/*  9 Jun 2017 12:17

Additional TODO's for Function:eplay: 

- Store the resulting synth in envir under =[\synths, synthName]= (default for =synthName=: =synth=).
- If previous synth exists under =[\synths, synthName]= path, then free/release it.
- When a synth ends, remove it from its path in envir.
- Make sure that when a synth =previousSynth= is released by replacing it through a new synth created through =Function:eplay=, the =previousSynth= ending does not remove the new synth that has already been stored in the same path.
- When a new synth starts or when an old synth is removed, it should emit notifications so that GUIS that depend on it update their status.  Such guis may be:
  - Start-stop buttons
  - Guis with widgets for controlling the synths parameters.  When a new synth starts, then the old gui should be replaced with a new one with widgets corresponding to the new synth's control parameters.
  Note: Possibly the notification should be emitted from the =\synthName= under which the synth is stored.  The messages may be:
  - =\started=
  - =\stopped=
  - =\replaced=
    The above is subject to testing. 

Notes:

- When this is done, it should be possible to create multiple gui windows for multiple synths running in the same environment. However, parameters under the same name will control the parameters under that name for all synths in that environment.
- To develop the right code for this, do it with a plain function, adding the functionalities one-by-one.
*/

/* This is the original code for Function:eplay. TODO:
- Deconstruct it, 
- reconstruct it step by step within a single function, adding the features noted above
- Test
- re-code as method
- Test
- Provide examples and doc
- Publish on web.
*/

/*
+ Function {
	eplay { | envir |
		var synth;
		envir = envir.asEnvironment;
		envir use: {
			var argNames, args;
			argNames = this.def.argNames;
			args = argNames.collect ({ | name |
				[name, envir[name]]
			}).select ({ | pair |
				pair [1].notNil;
			});
			//  arg target, outbus = 0, fadeTime = 0.02, addAction=\addToHead, args;
			synth = this.play (
				~target.asTarget, ~outbus ? 0, ~fadeTime ? 0.02,
				~addAction ? \addToHead, (args ? []).flat
			);
			argNames do: { | param |
				synth.addNotifier (envir, param, { | val |
					synth.set (param, val);
				});
			};
		};
		// This is done by addNotifier anyway:
		//		synth.onEnd (this, { synth.objectClosed });
		^synth;
	}
}
*/
//:
~eplay = { | name = \synth, func, envir |
	var synth;
	envir = envir.asEnvironment;
	func ?? {
		func = { | freq = 440 |
			SinOsc.ar (freq, 0, 0.1)
		}
	};
	Registry.doIfFound (envir, \synths, name, { | oldSynth |
			oldSynth.objectClosed; // prevent removal of successor on end
			oldSynth.release;
		});
	envir use: {
		var argNames, args;
		argNames = func.def.argNames;
		args = argNames.collect ({ | name |
			[name, envir[name]]
		}).select ({ | pair |
			pair [1].notNil;
		});
		//  arg target, outbus = 0, fadeTime = 0.02, addAction=\addToHead, args;
		// Ensure removal from lib on end:
		synth = Registry (envir, \synths, name, {
			func.play (
				~target.asTarget, ~outbus ? 0, ~fadeTime ? 0.02,
				~addAction ? \addToHead, (args ? []).flat
			)
		});
		synth.postln;
		argNames do: { | param |
			synth.addNotifier (envir, param, { | val |
				synth.set (param, val);
			});
		};
	};
	synth.onEnd (this, { synth.objectClosed }); // in case no func args
	^synth;
}
//:

~eplay.value;
//:
~eplay.(\synth, func: { | freq = 1000 | SinOsc.ar (freq, 0, 0.1)});
~eplay.(\synth2, func: { | freq = 1000 | SinOsc.ar (freq * 8 / 7, 0, 0.1)});

~eplay.(\synth2, func: { | freq = 1000 | SinOsc.ar (freq * 5 / 4, 0, 0.1)});
//:
{ SinOsc.ar (400 * 8 / 7, 0, 0.1) }.eplay;

//
nil.asArray.flat;
//:
{
	loop {
		~freq = 400 + 400.rand;
		0.5.wait;
	}
}.rout
//:
Server.default.scope;
//: Testing again:

{ | freq = 400 | SinOsc.ar (freq, 0, 0.1) }.eplay;
//:
~freq = 1000;
//:

{ | freq = 400, gate = 0 |
	var env;
	env = Env.adsr ();
	SinOsc.ar (freq, 0, 0.1)
	* EnvGen.kr (env, gate: gate, doneAction: 0)
}.eplay;


//:
~gate = 1;
//:
~gate = 0;
//:
{
	inf do: { | i |
		~gate = i % 2;
		~freq = 300 rrand: 3000;
		0.9.rand.wait;
	}
}.rout;
//:
{
	inf do: { | i |
		~gate = i % 2;
		if (~gate != 0) { ~freq = (70..90).choose.midicps};
		0.25.rrand (1).wait;
	}
}.rout;
//:
{
	inf do: { | i |
		~gate = i % 2;
		if (~gate != 0) { ~freq = 300 rrand: 3000};
		0.01.rrand (0.1).wait;
	}
}.rout;
//: