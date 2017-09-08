/*
 6 Jun 2017 15:45

Methods for using windows attached to symbols, using Registry.
*/

+ Window {
	closeChildren {
		this.view.closeChildren;
	}
}

+ TopView {
	closeChildren {
		this.allChildren do: { | view |
			if (view != this) { view.close }
		}
	}
}

+ Symbol {

	layout {
		^this.window.view.layout;
	}
	
	layout_ { | layout |
		^this.window.closeChildren.layout = layout;
	}

	vlayout { | ... elements |
		^this.layout = VLayout (*elements)
	}

	hlayout { | ... elements |
		^this.layout = HLayout (*elements)
	}
}

+ Slider {
	*horizontal {
		^this.new.orientation_(\horizontal);
	}

	*vertical {
		^this.new.orientation_(\vertical);
	}
}

+ Button {
	*actions_ { | pairs |
		var states, actions;
		#states, actions = pairs.clump (2).flop;
		^Button ()
		.states_ (states.clump (1))
		.action_{ | me |
			actions [me.value - 1 % states.size].(me);
		};
	}
}