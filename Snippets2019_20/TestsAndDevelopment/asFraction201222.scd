//: 23 Dec 2020 10:01
/* asFraction seems to work with 4 digits of accuracy, i.e.
0.0001.

*/
//:================================================================
1.5.asFraction;
//:
1.521.asFraction;
//:
(8/7).postln.asFraction;

//:
(7.0001/6).postln.asFraction;

(7.0001/6).rational;    // (11668/10001)
(7.00001/6).rational;   // (7/6)
(7.0005/6).rational;    // (2330/1997)



