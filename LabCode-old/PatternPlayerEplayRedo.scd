// 24 Jun 2017 15:29
\t splay: \default;
//:
~freq = 1000;
//:
// \p pplay: (type: \envEvent, degree: Pbrown (0, 7, 2, inf), dur: 0.1);
//:

// \q pplay: (degree: Pseq ((0..7), inf), dur: 0.1, type: \note);
//:
\p.pattern;
//:
\p.pattern.event;
//:
\p.pattern.etype;
//:
\p.pplay;
//:
\p.pplay ((freq: Pbrown (10, 200, 10, inf) * 10));
//:
\p.pplay ((degree: Pbrown (1, 20, 3, inf)));
//:
\p.addKey (\dur, 0.1);
//:
\p addEvent: (ctranspose: Pstutter (20, Pbrown (-6, 6, 1, inf)), legato: Pseq ([0.2, 0.1, 0.2, 4], inf));
//:
\p setEvent: (freq: Pwhite (300, 3000, inf), dur: Pseq ([0.1, 0.3], inf), legato: 0.1);