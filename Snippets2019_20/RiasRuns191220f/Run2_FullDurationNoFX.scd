// ================================================================
//:Neutral run through
// "00no_fx".record(10.20.minsec); // record for 10 minutes and 10 seconds
//prepare stereo for both players
\p1 *> \fx1;
{ Inp.ar.stereo } +> \fx1;
\p2 *> \fx2;
{ Inp.ar.stereo } +> \fx2;
// phrase 1 semitone upward glissando, player 1
Pbuf2({ ~startpos = 809; }, \p1); // semitone upward glissando, player 1
[0, 50].await; // phrase 2 semitone upward glissando, player 2
Pbuf2({ ~startpos = 809; }, \p2); // semitone upward glissando, player 2
[7, 0].await;
Pbuf2({ ~startpos = 260.2; }, \p1); // heartbeat, player 1
[7, 10].await;
Pbuf2({ ~startpos = 260.2; }, \p2); // heartbeat, player 2
[8, 30].await;
Pbuf2({ ~startpos = (12 * 60) + 28; }, \p1); // scratch, player 1
[9, 30].await;
Pbuf2({ ~startpos = (12 * 60) + 28; }, \p2); // scratch, player 2
[10, 2].await;
\fadeTime <+.p1 5;
\fadeTime <+.p2 5;
\p1.p.release;
\p2.p.release;
