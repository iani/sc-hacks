// Every player has its own environment
/*
Parameter values are supplied by the default values of 
Control UGens in the current player.
*/
//:currentEnvironment is that of the last player started
//Observe parameters deduced from the Synth function's Control Ugen defaults
currentEnvironment;
//:Start a new player for this part
\default +> \paramsynth;
//:Value of \freq is set to 440; 
currentEnvironment[\freq];
//:Change the freq parameters value:
// This sets the synth's freq parameter
\freq <+ 500;
//:Create a gui control for the freq
//The new value is shown by the gui
\paramsynthGuiExample.v(
	\freq.slider(\freq, \paramsynth)
);
//:substitute a new synth
// freq value persists and is applied to new synth
{ Formant.ar(\freq.kr(200), \form.kr(1760), \bw.kr(880), \amp.kr(0.05)).stereo } +> \paramsynth;
//:Add more parameters to the gui
\paramsynthGuiExample.v(
	\freq.slider(\freq, \paramsynth),
	\form.slider(\freq, \paramsynth),
	\bw.slider(\freq, \paramsynth),
	\amp.slider(\amp, \paramsynth)
);
//:
