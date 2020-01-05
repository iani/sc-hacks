//:Sound check
\default +> \test;
\freq <+ 2000;
\amp <+ 1;
//:Load sounds
Hacks.loadAudioFiles;
//:test lamentodellaninfa
\lamentodellaninfa.b.postln.play;
//:Play stereo with amplitude control
\amp <+.l 15;

{ PlayBuf.ar(1, \lamentodellaninfa.b.bufnum, doneAction: 2) * \amp.kr(1).dup(2)
} +> \l;
//:grain lamentodellaninfa test
{
	var bnum;
	bnum = \lamentodellaninfa.b.bufnum;
	\amp.kr(0.1) * GrainBuf.ar(2,
		Impulse.kr(\per.kr(1)),
		\dur.kr(1.5),
		bnum,
		\rate.kr(2),
		\pos.kr(0) * BufSampleRate.kr(bnum),
		pan: \pan.kr(0)
	)
} +> \tokyo1;
\amp <+ 50;
//:test param control on tokyo1 player
\tokyo1.v(
	\amp.slider([0.0001, 50, \exp], \tokyo1, \amp),
	\pos.slider([0, 1], \tokyo1, \pos),
	\per.slider([0.2, 20, \exp], \tokyo1, \per),
	\dur.slider([0.1, 5, \exp], \tokyo1, \dur),
	\rate.slider([0.7, 1.2], \tokyo1, \rate),
	\pan.slider([-1, 1], \tokyo1, \pan),
);
//:
\per <+.tokyo1 '/pi1'.osc(3, [-20, 40], [0.9, 10]);
\amp <+.tokyo1 '/pi1'.osc(1, [-10, 40], \amp);
\dur <+.tokyo1 '/pi1'.osc(4, [-10, 10], [0.1, 5]);
\rate <+.tokyo1 '/pi1'.osc(0, [-10, 20], [0.1, 5]);
\pos <+.tokyo1 '/pi1'.osc(6, [-10, 20], [0.7, 1.2]);
\pan <+.tokyo1 '/pi1'.osc(7, [-2, 2], [-1, 1]);
