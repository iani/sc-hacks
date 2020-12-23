
//:
Nymphs.getClients;
//:
Nymphs.ips;
//:
p = LocalPi('/pi1');
//:
'/pi1'.envir;
//:
{ SinOsc.ar(\ax.kr(400), 0, 0.1) } +> '/pi1';
//:
{ LFNoise2.ar(\ax.kr(400, 0.5), \ay.kr(1, 1)) } +> '/pi3';
//:Nikos' pi = '/pi3'
q = RemotePi('/pi3');
//:
q.outspecs[1] = \amp.asSpec;
//:
q.inspecs[1] = ControlSpec(-10, 10);
//:
'/pi3'.envir;
//:
{ SinOsc.ar(\ax.kr(400), 0, \ay.kr(0) / 20000) } +> '/pi1';
//:
{ SinOsc.ar(\ax.kr(400), 0, \ay.kr(0) / 20000) } +> '/pi1';
//:
{ SinOsc.ar(\ax.kr(400, 0.5) * [1, 1.2], 0, \ay.kr(0, 0.5)) } +> '/pi1';
//:
{ SinOsc.ar(\ax.kr(400, 0.5) * [1, 1.2 * (\az.kr(1, 0.5) / 1000)
], 0, \ay.kr(0, 0.5)) } +> '/pi1';
//:
{ LFSaw.ar(\ax.kr(400, 0.5) * [1, 1.2 * (\az.kr(1, 0.5) / 1000)
], 0, \ay.kr(0, 0.5)) } +> '/pi1';
//:
{ LFNoise2.ar(\ax.kr(400, 0.5) * [1, 1.2 * (\az.kr(1, 0.5) / 1000)
], \ay.kr(0, 0.5)) } +> '/pi1';
//:
{ LFNoise2.ar(\mx.kr(400, 0.5) * [1, 1.2 * (\mz.kr(1, 0.5) / 1000)
], \my.kr(0, 0.5) / 500) } +> '/pi1';
//:
{ LFNoise0.ar(\ax.kr(400, 0.5) * [1, 1.2 * (\az.kr(1, 0.5) / 1000)
], \ay.kr(0, 0.5)) } +> '/pi1';
//:
{
	LFNoise2.ar(\ax.kr(400, 0.5) * [1, 1.2 * (\az.kr(1, 0.5) / 1000)],
		\ay.kr(0, 0.5))
} +> '/pi1';
//:
{ SinOsc.ar(\ax.kr(400, 0.5), 0, 0.1) } +> '/pi1';
//:
{ LFSaw.ar(\ax.kr(400, 0.5) / 8, 0, 0.1) } +> '/pi3';
//:
frv  fff


//:
//:	
	
//:new mapper?
p.outspecs[1] = \amp.asSpec;
//:new outspecmapper
p.outspecs[1] = \amp.asSpec;
//:new inspecmapper
	p.inspecs[1] = ControlSpec(0, 10);
	
	//: