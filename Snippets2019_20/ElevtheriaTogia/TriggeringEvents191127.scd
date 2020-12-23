//:Trigger events from sensor data
/* Approach: Examine following possibilities: Trigger whenever:
- a (magnitude of) an input value passes a threshold. 
- the sum of (magnitudes) of several values passes a thershold.
- The slope of a value or sum of values passes a threshold
*/
//:triggering an event with sendtrig
//:+Dummy test
{ WhiteNoise.ar(Env.perc.kr(levelScale: 0.1, gate: \amp.kr(0.1, 0.1) > 0.5)).stereo} +> \test;
[0, 0.5001, 0.4, 0.501, 0.45, 0.51, 0.49] do: { | i |
	\amp <+ i;
	i.postln;
	0.5.wait;
}
//:SendTrig?
// from help file

{
    SendTrig.kr(Dust.kr(1.0),0,0.9);
} +> \trig;

// register to receive this message
OSCFunc({ arg msg, time;
    [time, msg].postln;
},'/tr', s.addr);
//:Prepare: Monitor sensor data
{ SinOsc.ar(\freq.kr(0.25).linexp(400, 2000), 0, 0.1).stereo } +> \test;
\test.map(\freq, \z2);
//:test triggering inside 1 synth
{
	SinOsc.ar(\freq.kr(0.25).linexp(400, 2000), 0,
		Decay.kr(Changed.kr(\trig.kr(0) > 0.5))
	).stereo
	
} +> \test;
\test.map(\freq, \z2, \trig, \y2);

//:test triggering with SendTrig and OSCFunc
{
	SendTrig.kr(Changed.kr(\trig.kr(0) > 0.5))
} +> \sendtrig;
\sendtrig.map(\trig, \y2);
OSCFunc({ arg msg, time;
    [time, msg].postln;
	{
		WhiteNoise.ar(Env.perc.kr(2)).stereo;
	} +> \hearthetrig;
},'/tr', s.addr);