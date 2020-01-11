//:+ ======== prologue 1/4 speed
Time().reset.gui;
"prologue_1_4".record(60 * 15);
1.wait;
Pbuf2({ // start jun - prologue on p1
	~startpos = 809;
	~buffer = \prologue;
	~rate = 0.25; // 2 octaves lower
}, \recording, { | in | in.stereo });
//:+ ======== prologue 1/2 speed
Time().reset.gui;
"prologue_1_2".record(60 * 15);
1.wait;
Pbuf2({ // start jun - prologue on p1
	~startpos = 0;
	~buffer = \prologue;
	~rate = 0.5; // 1 octave lower
}, \recording, { | in | in.stereo });
//:+ ======== lamento 1 speed
Time().reset.gui;
"lamento".record(60 * 5);
1.wait;
Pbuf2({ // start jun - prologue on p1
	~startpos = -10;
	~buffer = \lamentodellaninfa;
	~rate = 1; // original speed
}, \recording, { | in | in.stereo });