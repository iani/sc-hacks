// Introduction
//:The file gui
//:Opening a file in your editor from the gui
//:Executing the code of a file
//:Snippets
//:Running a snippet
// Select the snippet in the snippet list and press enter.
{ WhiteNoise.ar(0.005) * Decay2.kr(Dust.kr(5.dup), 0.1, 0.3) } +> \default;
//:Includes
//:Server snippets
//:server : ensure server is booted before running any snippet in this file.
//:Preload snippets
//:User folders