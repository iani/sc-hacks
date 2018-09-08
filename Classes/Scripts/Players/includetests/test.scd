/* This file is an example of an include that can be used by other snippets.

It is meant to be used as an include, but NOT as a source for a player, 

*/

(degree: Pseq((0..7)), dur: 0.1) +> \includetest1a;

(degree: Prand((0..7), 8), dur: 0.3) +> \includetest1b;
