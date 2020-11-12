//:Revisiting mappin busses to players/synths etc.
/*
busname <@ val . set bus busname to value value
busname @>.param envir map parameter param in envir to bus busname
*/
//;setting busses. bottom up try for clarity.
{ SinOsc.ar(\freq.kr(400), 0, 0.01).dup } +> \sound;
\bus <@ 600;
\bus @>.freq \sound;
//:
\sound.e.inspect;
//:
{ LFNoise0.kr(4).range(300, 1200) } @>.freq \sound;
//:parameter name defaults to frequecy
{ LFNoise1.kr(4).range(300, 1200) } @> \sound;
//:Note: Function @> frees other control synths sending to same buses
{ LFNoise0.kr(10).range(1000, 1200) } @>.freq \sound;
//:
{ LFNoise0.kr(1).range(300, 500) } @>.freq \sound;
//:
{ LFNoise1.kr(0.4).range(300, 4200) } @> \sound;
//:================================================================
//: @+> does not free previous kr synths on same bus
//:
{ SinOsc.ar(\freq.kr(400), 0, 0.01).dup } +> \sound2;
//:
\bus2 @> \sound2;
//:
{ LFNoise1.kr(4).range(300, 1200) } @+> \sound2;
//:
{ LFNoise0.kr(10).range(1000, 1200) } @+>.freq \sound2;
//:
{ LFNoise0.kr(1).range(300, 500) } @+>.freq \sound2;
//:
{ LFNoise1.kr(0.4).range(300, 4200) } @+> \sound2;
//:================================================================
/* which busses are set and mapped by these operators?
It is important to know which synths output to which busses
and which busses are mapped to which synth parameters, because
there may be naming conflicts.  Discussion in the examples below.
*/
//:Map bus named mybus to player named \mysound.
\mybus @>.freq \mysound


//:
\sound.e.inspect;
//:
\bus.bus;
\bus.bus.get;
\sound.envir.map(\freq, \bus);
//:
\sound.envir;
//:how do kr functions play? Is their out settable?
a = { SinOsc.kr(0.1, 0, 0.1) }.play;
//: out does not seem settable.
a.set(\out, 1);
//: trying with Out explicitly coded:
// this works!
a = { | out = 0 | Out.kr(out, SinOsc.kr(0.1, 0, 0.1)) }.play;
a.set(\out, 1);
//:this also works
a = { Out.kr(\out.kr(0), SinOsc.kr(0.1, 0, 0.1)) }.play;
a.set(\out, 1);
//:coding this as a wrapper - to be made into Function:kr method
f = { | func, out = 0 |
	{ Out.kr(\out.kr(out), func.value) }.play;
};
a = f.({ LFPulse.kr(2, 0, 0.5, 0.1) });
//:
a.set(\out, 1);
//:
\sound.map(\freq, \bus);
//:Trying new @>, @@> operators:
{ SinOsc.kr(\freq.kr(400), 0, 0.01).dup } +> \sound;
//:
{ SinOsc.kr(5, 0).range(400, 500) } @> \fbus;
//:
\fbus @> \sound;
