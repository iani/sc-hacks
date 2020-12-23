//:  4 Dec 2020 11:14
/* demonstrate use of button shortcuts
*/
//:Function with a button
\test.v(
	{ "hello".postln; }.button;
);
//:Function with a button and a name
\test.v(
	{ "hello".postln; }.button("I have a name");
);
//:Button with many states (labels) and actions
/*
To create a button with many labels and actions, 
use an array with the labels and actions in pairs like this:
["label1", { \action1}, "label2", { \action2 } ].button;
*/
\test.v(
	// state (label)    action
	["hello",          { "hello printing".postln; },
		"there",       { "printing there".postln; },
		"more stuff",  { "printing more stuff".postln; }
	].button
);
//:Array of labels-functions -> Array of buttons
\test.v(
	// state (label)    action
	*(["hello",          { "hello printing".postln; },
		"there",       { "printing there".postln; },
		"more stuff",  { "printing more stuff".postln; }
	].buttons)
);
//:window with buttons stacked vertically
//:Array of labels-functions -> Array of buttons
\test.buttons(
	// state (label)    action
	"hello",          { "hello printing".postln; },
	"there",       { "printing there".postln; },
	"more stuff",  { "printing more stuff".postln; }
);
//:any object can create a window with buttons
Hacks.buttons(
	// state (label)    action
	"hello",          { "hello printing".postln; },
	"there",       { "printing there".postln; },
	"more stuff",  { "printing more stuff".postln; },
	"receiver?", { postf("the receiver is %\n", this) }
);
//:PS: something about the receiver inside a class and outside of it
Hacks.menu;