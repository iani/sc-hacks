//:
{ WhiteNoise.ar(0.1).stereo } +> \soundcheck;
//:
1.hash;
//:
{ WhiteNoise.ar(0.1).stereo }.hash;
//:
{ WhiteNoise.ar(0.1).stereo }.hash;
//:
"{ WhiteNoise.ar(0.1).stereo }".hash;
//:
"{ WhiteNoise.ar(0.1).stereo }".hash;
//:
"{ WhiteNoise.ar(0.1).stereo }1".hash;
//:
"alphagexkalphabrexalbreabalphaddd".findAllRegexp("^alpha");
//
"alphagexkalphabr
exalbreab
alphaddd".findAllRegexp("^alpha")
//:
Document.current.currentString.findAllRegexp("^//:");
Document.current.text;
