// test 12 Aug 2018 13:40
//:server
// server boot is needed
//:preload include synthdefs01
//:test synthdef preload
Synth(\mysterymetals);
//:default +> d
\default +> \d;
//:modulate freq parameter
(freq: Pbrown(100, 2000, 100, inf), dur: 0.1) *> \f;
//:modulate pan parameter
(pan: Prand([-1, 1, 0], inf), dur: 1) *> \p;
//:play d
(degree: 1) +> \e;
//:play c, f
(degree: [0, 2]) +> \e;
//:play brownian triad
(degree: [0, 2, 3] + Pbrown(-10, 40, 10)) +> \e;
//:
(dur: 10.5) +> \e;
//:
(degree: Prand([[0, 2], 1, \pause], inf) + Pbrown(-10, 20, 1)) +> \e;
//:
(degree: Prand([[0, 2], 1, \pause], inf) + Pbrown(-10, 20, 1), \ctranspose: Prand([0, 12], inf) ) +> \e;
//:
\e.stop;
//: ================================================================
//: \mysterymetals pulse: 3, spulse: 4s
\mysterymetals +> \mys1;
//:
\pulse <+.mys1 200;
//:
\pulse <+.mys1 200;
//:
\spulse <+.mys1 2;
//:
\spulse <+.mys1 0.1s;
\amp <+.mys1 0.09125351;
//:
\mys1.stop;
//: \mysterymetals pulse: 3, spulse: 4s
\mysterymetals +> \mys2;
//:
\pulse <+.mys2 50;
//:
\pulse <+.mys2 20;
//:
\spulse <+.mys2 0.15s;
\amp <+.mys2 0.0091;
//:
\mys2.stop;
//: \mysterymetals pulse: 3, spulse: 4s
\mysterymetals +> \mys3;
//:
\pulse <+.mys3 0.11;
//:
\pulse <+.mys3 200;
//:
\spulse <+.mys3 1.940s;
//:

\mys3.stop;
//: \boombah \pfreq 53, \mystery 329, dutyRate 1, \d1 5 \d2 5 \d3, 5, d4, 7, mystery2 334
\amp <+.boom1 0.000529125;
\boombah +> \boom1;
//:
\pfreq <+.boom1 1.2;
\mystery <+.boom1 2;
\dutyRate <+.boom1 6;
\d1 <+.boom1 50;
\d2 <+.boom1 150;
\d3 <+.boom1 150;
\d4 <+.boom1 2;
\mystery2 <+ 100;
\mystery2 <+ 200;
\d1 <+.boom1 1.91;
\d2 <+.boom1 3.92;
\d3 <+.boom1 4.91;
\d4 <+.boom1 5.91;

//:
()


//: \boombah \pfreq 53, \mystery 329, dutyRate 1, \d1 5 \d2 5 \d3, 5, d4, 7, mystery2 334
\amp <+.boom1 0.051;
\boombah +> \boom1;
\pfreq <+.boom1 300;
\mystery <+.boom1 400;
\dutyRate <+.boom1 30;
\d1 <+.boom1 15;
\d2 <+.boom1 15;
\d3 <+.boom1 15;
\d4 <+.boom1 15;
\mystery2 <+.boom1 300;
\mystery2 <+.boom1 1000;
\boom1.stop;
//: \boombah \pfreq 53, \mystery 329, dutyRate 1, \d1 5 \d2 5 \d3, 5, d4, 7, mystery2 334
\amp <+.boom3 0.00011;
\boombah +> \boom3;
\pfreq <+.boom3 300;
\mystery <+.boom3 400;
\dutyRate <+.boom3 30;
\d1 <+.boom3 15;
\d2 <+.boom3 15;
\d3 <+.boom3 15;
\d4 <+.boom3 15;
\mystery2 <+.boom3 300;
\mystery2 <+.boom3 1000;
\boombh.stop;
//: \boombah \pfreq 53, \mystery 329, dutyRate 1, \d1 5 \d2 5 \d3, 5, d4, 7, mystery2 334
\amp <+.booom2 0.2351;
\boombah +> \booom2;
\pfreq <+.booom2 30;
\mystery <+.booom2 400;
\dutyRate <+.booom2 30;
\d1 <+.booom2 15;
\d2 <+.booom2 15;
\d3 <+.booom2 15;
\d4 <+.booom2 15;
\mystery2 <+.booom2 300;
\mystery2 <+.booom2 1000;

//: \gardellino \stepper 5 \sweep 1/9 \sweep2 2 lo 1e3 hi 4e3 form1 0.01 form2 1/99 
\gardellino +> \gar;
//:
\stepper <+.gar 20;
//:
\stepper <+.gar 0.91;
//:
\sweep <+.gar 10/90;
//:
\sweep2 <+.gar 0.1;
//:
\sweep2 <+.gar 0.001;
//:
\amp <+.gar 1.71;
//:
\amp <+.gar 0.271;

\gar.stop;
//: \gardellino \stepper 5 \sweep 1/9 \sweep2 2 lo 1e3 hi 4e3 form1 0.01 form2 1/99 
\gardellino +> \gar2;
//:
\stepper <+.gar2 1;
//:
\stepper <+.gar2 0.1;
//:
\sweep <+.gar2 10/90;
//:
\sweep2 <+.gar2 0.1;
//:
\sweep2 <+.gar2 0.01;
//:
\amp <+.gar2 1.71;
//:
\amp <+.gar2 0.15971;
\gar2.stop;

//: \gardellino \stepper 5 \sweep 1/9 \sweep2 2 lo 1e3 hi 4e3 form1 0.01 form2 1/99 
\gardellino +> \gar3;
//:
\stepper <+.gar3 10;
//:
\stepper <+.gar3 0.1;
//:
\sweep <+.gar3 10/90;
//:
\sweep2 <+.gar3 0.1;
//:
\sweep2 <+.gar3 0.01;
//:
\amp <+.gar3 1.71;
//:
\amp <+.gar3 0.00171;
\gar3.stop;