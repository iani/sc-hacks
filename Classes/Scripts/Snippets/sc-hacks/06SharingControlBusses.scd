//:play kr source in bus in environment "modulator"
{ [LFNoise0, LFNoise2].choose.kr(2 + 5.0.rand).range(200 + 200.rand, 500 + 1000.rand) } +> \modulator;
// play ar source with default synthdef
\default +> \test;
// put bus of kr source in parameter of ar envir
\freq <+.test \modulator;
//:play new ar source in different environment
{ LFSaw.ar(\freq.kr(400) * 0.25, 0, LFPulse.kr(10, mul: 0.03) ).stereo } +> \test2;
// connect new ar source to freq paremeter in environment "modulator"
\freq <+.test2 \modulator;
//:stop first source
\test.stop;
//:restart first source
\test.start;