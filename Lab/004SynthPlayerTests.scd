
\test.p; // Player
\test.pp; // Players sourcePlayer;

{ WhiteNoise.ar(0.1) } +> \test;

\test.ppp;

\test.pp.release;

\default +> \test;