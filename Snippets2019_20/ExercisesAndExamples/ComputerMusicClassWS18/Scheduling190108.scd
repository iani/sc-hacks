// Basics and different approaches to scheduling
//:Run a function at some time point (absolute)
var timeNow, timeIn4Seconds;
timeNow = thisThread.seconds;
timeIn4Seconds = timeNow + 4;
postf("Time now is: %\n", timeNow);
postf("Will schedule function to run 4 seconds later, at:%\n", timeIn4Seconds);

SystemClock.schedAbs(
	timeIn4Seconds,
	{ "hello, from 4 seconds later".postln }
);

//:Run a function after one second (relative to now)
SystemClock.sched (1, { "Hello world".postln });
//:numeric return value reschedules n seconds later
SystemClock.sched (1, { postf("Hello world at %\n", thisThread.seconds); 0.25 });
//:to stop the sheduler, type Command-.
CmdPeriod.run;
//:repeat n times
// Use a closure to store the variable just for the function
var stream; // declare the variable outside of the function.
// // must be assignd outside of the function
stream = Pn(0.25, 5).asStream;
// The function created here inherits the variable from the closure
SystemClock.sched (stream.next, { "Hello world x 5".postln;
	stream.next; // stream variable inherited from closure
}); // the scheduler stops when the stream returns nil!
//:add counting variable to closure
var stream, count = 0;
stream = Pn(0.25, 5).asStream;
SystemClock.sched (stream.next, {
	count = count + 1;
	postf("counting % times\n", count);
	stream.next;
});
//:scheduling with a routine: wait
{
	"starting".postln;
	1.wait;
	"hello world after 1 second".postln;
	0.5.yield;
	"yield with numeric argument is same as wait".postln;
}.fork; // fork creates the routine

//:scheduling with a routine: loop
{
	loop {
		postf("posting at: %\n", thisThread.seconds);
		4.reciprocal.wait; // 4 reciprocal is 1/4
	};
}.fork;
//:Command-. stops all routines and sounds
CmdPeriod.run;

//:store a routine in a variable to send it the stop message afterward
r = {
	loop {
		"posting every 1/4 seconds".postln;
		4.reciprocal.wait; // 4 reciprocal is 1/4
	};	
}.fork;
//:send stop to the routine to stop it
r.stop;
//:repeat n times with do
{
	"starting in 1 second".postln;
	5 do: { | i | // do method passes the counter to the argument
		"posting every 1/4 seconds, 5 times".postln;
		postf("the count now is %\n", i);
		4.reciprocal.wait; // 4 reciprocal is 1/4
	};
	"done".postln;
	
}.fork;
//:repeat while a condition is true
c = true;
{
	while { c } {
		 postf("Repeating while c is true. The value of c is: %\n", c);
		4.reciprocal.wait; // 4 reciprocal is 1/4
	};
	"done".postln;
}.fork;
//:set c to false to stop
c = false;
//:error if c is not a boolean!
c = 1;
//:controlling a routine from a GUI
var duration = 0.25, isOn = true;

