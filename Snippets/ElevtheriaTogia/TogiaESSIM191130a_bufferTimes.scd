//:Timing buffer starts again.
Pbuf(); // Start of piece
//:
Time();
Pbuf(809); // START OF SEMITONE GLISSANDO
//:
Time();
Pbuf(171.75); // START OF 3 x 2 heartbeats 1st time
//:
Time();
Pbuf(222.2);  // start of 3 x 2 heartbeats 2nd time
//:
//:260.2 +5x2 heartbeats. Total duration: 8.217412992999 seconds
//:perhaps alternate wit 60.2 in middle phrases of piece.
Time();
Pbuf(60.2, init: {
	~rate = 1;
	~period = 8.4217412992999 / ~rate;
});  // start of 5 x 2 heartbeats 1st time
// \period <+.pbuf 8.217412992999;
//:
