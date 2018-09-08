/* The result of evaluating a snippet in this file is always sent as source to
player named "default". 
*/
//:whitenoise include /includetests *
/*
This snippet illustrates how to use the "include" statement with a wildcard (*) to load several files.
"include /includetests *" means: "load all files found in folder "/includetest",
before running this snippet.

The folder /includetests is a direct subdirectory of the Players folder, 
which contains all player snippet files.

*/
{ WhiteNoise.ar(0.05) * Decay2.kr(Dust.kr(3.dup)) }
//:default
// This snippet sends the synthdef named 'default' to the player named 'default'.
\default
//:c 1 sec
()
//:whitenoise without includes
{ WhiteNoise.ar(0.01).dup }

