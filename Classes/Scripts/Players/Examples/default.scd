/* 

================ NOTE: =================

This item is a header item.
PlayerSnippetGui will not run it.

*/

//:Play synthdef 'default' in player 'default'
\default;
//:Play an event
(degree: [-5, 5].pbrown, dur: 0.1)
//:Play a different event
(degree: [-1, 15, 2].pbrown, dur: [0.5, 0.2, 0.05 ! 10].flat.prand)
//:Play a synth function
{ WhiteNoise.ar(0.1) }

