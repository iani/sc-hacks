/*
 9 Oct 2018 13:49
*/
LucierJars {
	classvar <delayRoutine, <channels;
	
	*initClassDisabled {
		StartUp add: {
			LPD8.gui;
			Server.default.options.numOutputBusChannels_(4);
			Server.default.boot;
			Server.default.meter;
			this.midi;

			{ this.gui }.defer(1)
		}
	}

	*start {
		{
			var in;
			in = In.ar(4);
			Out.ar(0, (in * \level.kr(0.01)).dup(4))

		} +> \direct;
		/* NOTE: Adjust default level according to venue 
		*/
		\level <+.direct 0.09; // edit default level!
		\direct.v(
			\level.slider([0, 1])
		);
	}
}	