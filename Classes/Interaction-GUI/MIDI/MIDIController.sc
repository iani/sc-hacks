/*
	6 Oct 2018 14:44
	GUI + for Novation Launchpad Mini


	LPMini.gui;

	midifunc.trace(true);
	midiin.connectall

LPMini addDependant: { | ... args | args.postln; }

\test.addNotifier(LPMini, \lp11on, { "testing".postln; Synth(\default)});

LPMini(\p11on, { \default +> \test });
LPMini(\p11off, { \test.stop; });

*/

MIDIController {
	*init {
		// init midi client
		MIDIClient.init;
		/* 
			MIDIFunc.trace(true);
		*/
		MIDIIn.connectAll;
	}

	*new { | key, func, listener |
		(listener ? this).addNotifier(this, key, func);
	}
}

LPMini : MIDIController {

	*gui {
		// TOGGLE MODE!
		this.window({ | w |
			this.init;
			w.bounds = Rect(0, 605, 100, 100);
			w.view.layout = VLayout(
				*({ | row |
					HLayout(*({ | column |
						var c, toggle = 0, keys;
						keys = ["p%%off", "p%%on"] collect: { | fs |
							format(fs, column + 1, row + 1).asSymbol;
						};
						c = CheckBox();
						MIDIFunc.noteOn({
							toggle = 1 - toggle;
							this.changed(keys[toggle]);
						}, 16 * row + column);
						keys do: { | key, val |
							this.new(key, {
								{ c.value = val }.defer;	
							}, c);
						};
						c;
					}) ! 8)
				} ! 8)
			)
		})		
	}	
}

// AKAI LPD8
// Expects the pads to be in program change mode.
// Press the PROG CHNG button at the botom left to select this.
/*
Top pads from left to right: prog change, chan 0, nums 4, 5, 6, 7
Bottom pads from left to right: prog change, chan 0, nums 0, 1, 2, 3

Top knobs from left to right: cc chan 0 nums 1, 2, 3, 4
Bottom knobs from left to right: cc chan 0 nums 5, 6, 7, 8
*/
LPD8 : MIDIController {
	classvar <envir;
	*gui {
		// TOGGLE MODE!
		envir = \lpd8.e;
		this.window({ | w |
			this.init;
			w.bounds =  Rect(0, 820, 300, 20); //  Rect(300, 300, 300, 20);
			w.view.layout = HLayout(
				VLayout(
					HLayout(
						*({ | i |
							var c, keys, toggle = 0;
							c = CheckBox();
							// i = i + 4;
							keys = ["pada%off", "pada%on"] collect: { | key |
								format(key, i + 1).asSymbol;
							};
							keys do: { | key, val |
								this.new(key, {
									{ c.value = val; }.defer;
								}, c);
							};
							i = i + 4;
							MIDIFunc.program({
								toggle = 1 - toggle;
								//	postf("toggling this: %, %, %\n",
								//									keys[toggle],
								//	toggle,
								//	i
								// toggle = 1 - toggle;
								this.changed(keys[toggle]);
							}, 0, nil, i);
							c;
						} ! 4)
					),
					HLayout(
						*({ | i |
							var c, keys, toggle = 0;
							c = CheckBox();
							// i = i + 4;
							keys = ["padb%off", "padb%on"] collect: { | key |
								format(key, i + 1).asSymbol;
							};
							keys do: { | key, val |
								this.new(key, {
									{ c.value = val; }.defer;
								}, c);
							};
							MIDIFunc.program({
								toggle = 1 - toggle;
								// postf("toggling this: %, %, %\n",
								//	keys[toggle],
								//	toggle,
								//	i

								this.changed(keys[toggle]);
							}, 0, nil, i);
							c;
						} ! 4)
					)
				),
				VLayout(
					HLayout(
						*({ | i |
							var c, key;
							i = i + 1;
							key = format("knoba%", i).asSymbol;
							c = Knob();
							this.new(key, { | val |			
								{ c.value = val; }.defer;
							}, c);
							MIDIFunc.cc({ | num, other1, other2 |
								// ["debugging cc", key, num, other1, other2].postln;
								this.changed(key, num / 127);
								envir.put(key, num / 127);
							}, i, 0);
							c
						} ! 4)
					),
					HLayout(
						*({ | i |
							var c, key;
							// i = i + 1;
							key = format("knobb%", i + 1).asSymbol;
							c = Knob();
							this.new(key, { | val |
								{ c.value = val }.defer;
							}, c);
							MIDIFunc.cc({ | num, other1, other2 |
								// ["debugging cc", key, num, other1, other2].postln;
								// postf("debugging key %\n", key);
								this.changed(key, num / 127);
								envir.put(key, num / 120);
							}, i + 5, 0);
							c
						} ! 4)
					)
				)
			);
		})
	}
}