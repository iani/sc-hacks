// Operator overview
//:Function +> (play function in player)
{ WhiteNoise.ar(0.1) } +> \test;
//:Event +> (play event in player)
(dur:0.1, degree: Pbrown(-5, 5, 2)) +> \test;
//:nil +> (stop player)
nil+>\test;
//:symbol +> play synthdef
\default +>\test2;
//:symbol <+ number (set parameter)
\freq <+ 600;
//:symbol <+ function (map parameter to control synth)
\freq <+ { LFNoise0.kr(6).range(200, 2000) };
//:symbol <+ envelope (map envelope into parameter)
\freq <+ Env([400, 1000, 200], [5, 5]);
//:symbol <+ nil (unmap parameter and set to nil)
\freq <+ nil;
//: