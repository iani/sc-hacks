// This is a test only also. It is test2;
Include.server;
Include("meter");
Include("scope");
//: 2 seconds delay. TESTING
/*
{
	var in;
	in = In.ar(2);
	DelayN.ar(in, 2, 2, 1, in) } +> \delay;
*/
//: 10 seconds delay.
{
	var in;
	in = In.ar(2);
	DelayN.ar(in, 10, 10, 1, in) } +> \delay;
//:
{ CombN.ar(In.ar(2), 2, 2) } +> \delay;
