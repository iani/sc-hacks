//:26 Nov 2020 20:52
//:Patterns are played by sending an Event to a symbol
(degree: Pbrown(-5, 5, 2)) +> \p1;
//:Patterns can be modified by sending a different Event
(degree: Pn(Pseries(-5, 1, 10))) +> \p1;
//:More parameters can be added to a pattern in the same way
(dur: [0.1, 0.2].pseq) +> \p1;
//:
(dur: 0.2) +> \p1;
//:
(amp: 0.01) +> \p1;
//:
(mtranspose: 1) +> \p1;
//:
(degree: Pn(Pseries(0, 1, 8))) +> \p1;
//:
(mtranspose: 0) +> \p1;
//:
(mtranspose: 1) +> \p1;
//:
(gtranspose: 1) +> \p1;
//:
(degree: Pn(Pseries(0, 1, 8)), dur: 0.2, amp: 0.01) +> \p2;
//: