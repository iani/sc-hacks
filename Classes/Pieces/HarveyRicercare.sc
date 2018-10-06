/*
 5 Oct 2018 10:57

Jonathan Harvey: Ricercare una melodia.

*/
HarveyRicercare {
	/*
	*initClass {
		StartUp add: {
			Server.default.options.numOutputBusChannels_(4);
			Server.default.boot;
			Server.default.meter;
			 { this.gui }.defer(1)
		}
	}
	*/

	*gui {
		this.default.gui;
	}

	*default {
		^Registry(this, \default, { this.new });
	}

	gui {
		this.post; " gui not implemented".postln;
	}
}