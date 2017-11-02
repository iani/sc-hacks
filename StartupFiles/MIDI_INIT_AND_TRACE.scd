// 29 Sep 2017 11:10
// Testing MIDI input
//: Trying with LIVID instruments CODE 2, and U-Control UC-33.
/* 
	IMPORTANT: To test input Run all 3 in the order listed below
	MIDIClient.init, MIDIIn.connectAll, MIDIFunc.trace(true);

	Here we run these in a routine, allowing 2 seconds between each statement,
	in order to leave time for the hardware to respond.
*/
{
	MIDIClient.init;
	1.wait;
	MIDIIn.connectAll;
	1.wait;
	MIDIFunc.trace(true);
}.fork(AppClock);
