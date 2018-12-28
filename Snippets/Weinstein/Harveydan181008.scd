/*
	8 Oct 2018 12:30
	Third stint for Ricercare una melodia.
*/


//:
LPD8(\knoba1, { | val |
	val.postln;
	\output <+.channel1 val;
});
LPD8(\knoba2, { | val |
	\output <+.channel2 val;
});
LPD8(\knoba3, { | val |
	\output <+.channel3 val;
});
LPD8(\knoba4, { | val |
	\output <+.channel4 val;
});