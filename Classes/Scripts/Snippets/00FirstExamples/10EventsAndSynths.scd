/*  8 Aug 2018 22:49
Explaining basic concepts: 
Synths as sound events.
Events as templates for synths with musical parameters.
*/
//:Play an empty event
/* Even though the event is empty,
SuperCollider provides defaults.
These defaults are stored in the definition
of the Event class.
The are used to provide parameter values necessary to play the event. 
Look at the output on the post window.
It shows the default parameters that were provided by the Event Class. 
*/
().play;
//:Modify scale degree of an event:
(degree: 1).play; // plays note "D"
//:Note: Degree must have an integer value
// does not have the expected result:
(degree: 0.5).play; // plays frequency 220.
//:You can also provide chromatic degrees with midi:
(midinote: 60).play;
//:In this case you can use decimals
(midinote: 60.5).play;
//:Finally you can also provide frequency directly
(freq: 660).play;
//:Modify transposition of scale of an event:
// ctranspose = chromatic transpose
(ctranspose: 1).play; // plays note "C#"
//:Modify transposition of scale of an event:
// ctranspose = chromatic transpose
(ctranspose: 1).play; // plays note "C#"
//:Duration 1: a very long note
(dur: 20).play; // in seconds
//:Play a chord. Watch: There are 3 synths!
(dur: 20, degree: [0, 2, 4]).play;
//:Play a chord. Watch: There are 4 synths!
(mtranspose: -3, dur: 20, degree: [0, 2, 4, 6]).play;
//:Play C7 chord:
(ctranspose: -6, dur: 20, degree: [4, 6, 8, 10]).play;
//:It is useful to add to a chord using +
(ctranspose: -6, dur: 20, degree: [0, 2, 4, 6] + 4).play;
//:With sc-hacks you can play events as (melodic) patterns
(degree: Prand([0, 1, [-1, 3], 4], inf), dur: 0.2) +> \melody;
//:With sc-hacks you can play events as (melodic) patterns
(degree: Prand([0, 1, [-1, 3], 4], inf), dur: 0.1,
mtranspose: Pstutter(12, Prand([0, -3, 3], inf))
) +> \melody;
//:With sc-hacks you can play events as (melodic) patterns
(degree: Prand([0, 1, [-1, 3], 4], inf), dur: Prand([0.1, 0.2], inf),
mtranspose: Pstutter(12, Prand([0, -3, 3], inf))
) +> \melody;