//: 22 Dec 2020 23:57
/* add an event type

*/
//:add an event type
//:
Event.addEventType(\rate, {
	"fundamental is %.\n".postf(~fund);
	"rate is: %.\n".postf(~rate.value);
}, (fund: 60.midicps,
	rate: { ~freq.value / ~fund }
))
//:
(type: \rate, degree: 4).play;
//:
1.5.asFraction;
//:
1.521.asFraction;
//:
(8/7).postln.asFraction;

//:
(7.0001/6).postln.asFraction;
