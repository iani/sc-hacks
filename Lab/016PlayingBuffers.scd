// 27 Sep 2017 22:38
\bell.bufnum;
'Construction_Mixer_Small'.bufnum;
\cabasa.bufnum;
\cabasa.b.play;
'Construction_Mixer_Small'.b.play;
//:
{ PlayBuf.ar(1, \bufnum.kr (\bell.bufnum), loop: 1) } +> \loop;
//:
\bufnum <+ \cabasa;
\bufnum <+ \bell;