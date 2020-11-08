// Adding voice for second hand for jun
//:sound check
\default +> \check;
//:*sound check - stereo
\pos <+ 0;
{ PinkNoise.ar(0.01).stereo } +> \stereo;
"center".postln;
2.wait;
"left".postln;
\pos <+ -1;
2.wait;
"right".postln;
\pos <+ 1;
2.wait;
