//:alternative coding and interesting pv alternative for asayo  6 Jan 2020 02:56
\lamentodellaninfa.pb.pv({ | c |
	PV_LocalMax(c, 0.301)
}).fx({ | in |
	Resonz.ar(in * 5,
		LFNoise1.kr(0.02).range(50, 800),
		0.5
	)
}).stereo +> \pbuf;
\fxvol <+ 1;
\srcvol <+ 0;

