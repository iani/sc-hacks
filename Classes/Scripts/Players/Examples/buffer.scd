// Examples for playing buffers
//:preload include /buffers default lindrum
/* This snippet loads buffers when the server boots.
It does not play a sound, it only loads buffers for other snippets.
It does however also open the BufferGUI to show which buffers are loaded.
*/
BufferGUI();
nil; // this line prevents the results of the snippet from being sent to the player.
//:Play a buffer one shot
{ PlayBuf.ar(1, \tomll.b).stereo }
//:Play a buffer, looping
{ PlayBuf.ar(1, \tomll.b, loop: 1).stereo }
//:Play a buffer, triggering at random intervals
{ PlayBuf.ar(1, \kick.b, trigger: Dust.kr([0.3, 0.3]), loop: 0) }
//:Play a buffer, triggering at regular intervals
{ PlayBuf.ar(1, \kick.b, trigger: Impulse.kr([3, 4]), loop: 0) }
