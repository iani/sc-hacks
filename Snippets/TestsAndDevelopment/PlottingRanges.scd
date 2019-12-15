//:show how to create some simple number arrays
// and how ranges behave in those sequences.
(1..10).plot;
//:what does sine do?
(1..10).sin.plot;
//:NOT GOOD. Try to smoothe it
(0, 0.01 .. 1).sin.plot; // just part of the circle
//:USE PI!!!!!!!
(0, 0.01 .. pi).sin.plot; // just part of the circle
//:we want the FULL circle: 2pi
(0, 0.01 .. 2pi).sin.plot; 
