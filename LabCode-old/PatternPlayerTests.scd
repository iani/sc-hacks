// 23 Jun 2017 23:36
//:
a = ();
b = EventPattern (a);
c = b.play;
//:
c.addKey (\degree, 5);
//:
c.addKey (\degree, Pwhite (0, 20, inf));
//:
c.addEvent ((legato: Pwhite (0.5, 2.0, inf), dur: Prand ([0.2, 0.4], inf)));
//:
c.addEvent ((mtranspose: Pstutter (20, Pwhite (-5, 5, inf)),
	ctranspose: Pstutter (20, Pwhite (-10, 0, inf))));
//:
c.addKey (\dur, Prand ([0.05 dup: 25, 0.2 dup: 5, 0.5].flat, inf));
//:
c.addKey (\amp, Pbrown (0.01, 0.2, 0.02, inf));
//:
\p.pplay;
//:
\p.addKey (\degree, 5);
//:
\p.addKey (\degree, Pwhite (0, 20, inf));
//:
\p.addEvent ((legato: Pwhite (0.5, 2.0, inf), dur: Prand ([0.2, 0.4], inf)));
//:
\p.addEvent ((mtranspose: Pstutter (20, Pwhite (-5, 5, inf)),
	ctranspose: Pstutter (20, Pwhite (-10, 0, inf))));
//:
\p.addKey (\dur, Prand ([0.05 dup: 25, 0.2 dup: 5, 0.5].flat, inf));
//:
\p.addKey (\amp, Pbrown (0.01, 0.2, 0.02, inf));

//: ================
\q pplay: (degree: Pseq ((0..7), inf));
//: ================
\q pplay: (degree: Pseq ((0..7), inf), dur: 0.1);
//: ================
\q addEvent: (dur: Prand ((2..10).reciprocal, inf));
//: ================
\q addEvent: (degree: Pbrown (0, 7, 2, inf), dur: 0.05, type: Prand ([Pn (\note, 5), \pause], inf));
//: