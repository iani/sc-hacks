//: 13 Nov 2020 11:42 mapping busses - continued
//:================================================================
//:tests of recent stuff
//:testing fixing
\test.fix;
//:
\default +> \test;
//:
\test.unfix;
//:================================================================
//:Testing new version of Function:@>
{ SinOsc.kr(3) } @> \bus1;
//:Note that one can change the output bus in the usual manner:
\out <+.bus1 1;
//:
\bus1.unfix;
//:
\bus1 <@ 0;
//:set bus by index
1 <@ -0.5;
//:* Open scope (Control bus view!) to watch changing value of bus
1 <@ -0.9.rrand(0.9);
0.5.wait
//:================================================================
//:Multiple control functions - in sequence and in parallel
{ SinOsc.kr(2) } @> \bus1;
//:
{ LFSaw.kr(2) } @> \bus1;
//:
{ LFTri.kr(2) } @> \bus1;
//:
{ LFPulse.kr(2).range(-0.1, 0.1) } @> \bus1;
//:
{ SinOsc.kr(0.2).range(-0.5, 0.5) } @>.sinbus1 \bus1;
//:
Player.unfix;
//:
play