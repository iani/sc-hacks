//:  4 Dec 2020 10:15
/*
testing tr control TrigControl - undocumented in help files.

*/
//:+Triggering manually. Only triggers the first time
{
	PinkNoise.ar(Env.perc(level: 0.1).kr(gate: \trig.kr(0)))
} +> \trigtest;
loop {
	0.25.wait;
	\trig <+.trigtest 1;
};
//:+Triggering manually. Still Only triggers the first time
{
	PinkNoise.ar(Env.perc(level: 0.1).kr(gate: \trig.kr(0)))
} +> \trigtest;
loop {
	0.25.wait;
	\trig <+.trigtest 1;
	\trig <+.trigtest 0;
};
//:+Triggering manually. Introduce delay to force resetting the trigger
{
	PinkNoise.ar(Env.perc(level: 0.1).kr(gate: \trig.kr(0)))
} +> \trigtest;
loop {
	0.25.wait;
	\trig <+.trigtest 1;
	0.1.wait;
	\trig <+.trigtest 0;
};
//:+Trick: Use Changed to ensure retriggering
/* NOTE: The control waits for us to set trig in order to trigger.
This may be the desired behavior (instead of triggering right at the 
beginning)!
*/
{
	PinkNoise.ar(Env.perc(level: 0.1).kr(gate: Changed.kr(\trig.kr(0))))
} +> \trigtest;
loop {
	1.wait;
	\trig <+.trigtest UniqueID.next;
};
//:+Built-in shortcut: Create a control that resets after 1 control cycle
/* NOTE: the control triggers once immediately at the start of the synth.
This is not always what we want.
*/
{
	PinkNoise.ar(Env.perc(level: 0.1).kr(gate: \t_trig.kr(0))).dup
} +> \trigtest;
loop {
	1.wait;
	\t_trig <+.trigtest 1;
};
//:+Test undocumented .tr method for TrigControl
// NOTE: This is the same as using \t_trig.kr (!?)
{
	PinkNoise.ar(Env.perc(level: 0.1).kr(gate: \trig.tr(0))).dup
} +> \trigtest;
loop {
	1.wait;
	\trig <+.trigtest 1;
};