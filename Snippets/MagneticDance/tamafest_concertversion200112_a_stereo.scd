//: setup script

(PathName(Document.current.path).pathOnly +/+ "tama200112_setup_stereo.scd").load;
//: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ======== RECORD ======== !!!!
Time().reset.gui;
"tamafest201012".record(60 * 15, 2);
//: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//: ================================================================ JUN 1
Pbuf2({ // start jun - prologue on p1
	~startpos = 809;
	~buffer = \prologue;
	~rate = 0.25; // 2 octaves lower
}, \p1);
// ====================== add brick wall fx1
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.0000001, 0.5));
}, true) +> \fx1;
// ================ connect fx1 thresh to x1
{ \x1.kr(0).linexp(0.0000001, 0.395) } @@>.fx1 \thresh; // brickwall jun mapping
// ================ connect fx1 pan to y1
{ \y1.kr(0).urange(-1, 1) } @@>.fx1 \pos; // pan pos jun
//: ================================================================ JUN 2
Pbuf2({ // start jun - prologue on p3
	~startpos = 0;
	~buffer = \prologue;
	~rate = 0.5; // 1 octave lower?
}, \p3);

// ====================== add brick wall fx3
PV({ | c |
	PV_BrickWall(c, \thresh.kr(0.0000001, 0.5));
}, true) +> \fx3;
// ================ connect fx3 thresh to x3
{ \x3.kr(0).linexp(0.0000001, 0.295) } @@>.fx3 \thresh; // brickwall jun mapping
// ================ connect fx3 pan to y3
{ \y3.kr(0).urange(-1, 1) } @@>.fx3 \pos; // pan pos jun
//: ================================================================ ASAYO 1
Pbuf2({ // start asayo - lamento on p2
	~startpos = -10;
	~buffer = \lamentodellaninfa; // \prologue???????
	//	~buffer = \prologue;  /// ???????
	~rate = 1;
}, \p2, { | in | Resonz.ar(in * 5, \freq.kr(500, 0.5), 0.1)});
// ====================== add magbelow fx2
PV({ | c |
	PV_MagBelow(c, \thresh.kr(0.000001, 0.5));
}, true,
	// { | in | LPF.ar(in, 3000) }
	// { | in | Ringz.ar(in * 0.1, LFDNoise1.kr(5).range(100, 2000), 0.01) }
) +> \fx2;
// ================ connect fx2 x2 thresh, y2 pos, z2 freq 
{ \x2.kr(0).linexp(0.0001, 15.0) } @@>.fx2 \thresh; // magbelow asayo
{ \y2.kr(0).urange(-1, 1) } @@>.fx2 \pos; // pan pos asayo
{ \z2.kr(0).linexp(100, 10000) } @@>.p2 \freq; // pan pos asayo
