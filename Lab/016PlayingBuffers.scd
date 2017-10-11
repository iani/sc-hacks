// 27 Sep 2017 22:38
\bell.bufnum;
'Construction_Mixer_Small'.bufnum;
\cabasa.bufnum;
\cabasa.b.play;
'Construction_Mixer_Small'.b.play;
//:
{ PlayBuf.ar(1, \bufnum.kr (\bell.bufnum), \rate.kr, loop: 1) } +> \loop;
//:
\bufnum <+ \cabasa;
\bufnum <+ \bell;
\bufnum <+ 'Construction_Mixer_Small';
//:
\rate <+ 1.2;
//:
currentEnvironment;
//:
\rate <+ { LFNoise0.kr(10).range(0.2, 5) };
//:
(dur: 1, rate: Pwhite(0.1, 10, inf)) *> \x;