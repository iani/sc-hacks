// ================================================================
//SYNTHS
//:Start a Synth
{ Formant.ar(\fund.kr(200), \form.kr(1760), \bw.kr(880), \amp.kr(0.1)).stereo } +> \mysound;
//:modify a parameter
\fund <+ 100;
//:stop the sound
\mysound.stop;
//:restart the sound
\mysound.start;
//:+modify several times
(60..72).midicps do:
{ | f |
	\fund <+ f;
	0.15.wait;
};
//:use a gui to control parameters
\mysoundGui.v(
	\fund.slider(\freq, \mysound),
	\form.slider(\freq, \mysound),
	\bw.slider(\freq, \mysound),
);
//:start a sound on a different player in parallel
{ Formant.ar(\fund.kr(200), \form.kr(1760), \bw.kr(880), \amp.kr(0.1)).stereo } +> \anothersound;
//:modify a parameter - current environment is that of last player
\fund <+ 100; 
//:see the current environment
currentEnvironment;
//:open a gui for the second sound
\anothersoundGui.v(
	\fund.slider(\freq, \anothersound),
	\form.slider(\freq, \anothersound),
	\bw.slider(\freq, \anothersound),
);
// ================================================================
// PATTERNS
//:make a synthdef to use with patterns
SimpleDef("form", { | freq = 400 |
	{ Formant.ar(freq, \form.kr(1760), \bw.kr(880)) }
});
//:pattern example
(instrument: \form, dur: 0.1, degree: (0..7).pseq, amp: 0.01) +> \mysound;
//:add formant parameter control to pattern
(form: (40..90).midicps.prand) +> \mysound;
//:variant using pbrown
(form: [10.midicps, 90.midicps, 200].pbrown) +> \mysound;
//:modify duration
(dur: 0.05) +> \mysound; // play faster
//:also modify bw
(bw: [10.midicps, 90.midicps, 200].pbrown) +> \mysound;
