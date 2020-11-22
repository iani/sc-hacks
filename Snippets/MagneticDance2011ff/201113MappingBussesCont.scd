//: 13 Nov 2020 11:42 / 22 Nov 2020 20:11
// mapping busses - continued
//:================================================================
//: Function @> \bus: Play a control function into a player
/* NOTE 1: This [creates or] accesses a control bus with the same name as the player.
NOTE 2: @> also fixes the player, so it auto-restarts after cmdPeriod.
*/
{ SinOsc.kr(3) } @> \player1;
//:
\player1.bus;
//:Change the output bus index manually
\out <+.player1 1;
//:Set the control bus value
\player1 <@ 0;
//:set bus value by index (rather than name)
0 <@ -0.5;
//:* Set value by index - example in a loop
1 <@ -0.9.rrand(0.9);
0.25.wait
//:Unfix player1 so that cmdPeriod stops it
\player1.unfix;
//:================================================================
//:Multiple control functions - in sequence and in parallel
//:A. In sequence: Start a control function playing into bus1
{ SinOsc.kr(2) } @> \bus1;
//:Play another control function into bus1 - the function before it stops
{ LFSaw.kr(2) } @> \bus1;
//:More tests of the same thing.
{ LFTri.kr(2) } @> \bus1;
//:B. In Parallel: Control functions add their output to the same bus
//:Start a test player outputing on bus1
{ LFPulse.kr(5, width: 0.1).range(-0.05, 0.05) } @> \bus1;
//:Add a new player, named sinbus1, outputting on bus1
/* The new player adds its output to bus1.
It does not replace the previous player, bus1, because it has a new name.
We now have 2 players outputting on \bus1.
Player 1: \bus1
Player 2: \sinbus1
*/
{ SinOsc.kr(0.1).range(-0.5, 0.5) } @>.sinbus1 \bus1;
//:Unfix all players so cmdPeriod stops them:
Player.unfix;
//:
