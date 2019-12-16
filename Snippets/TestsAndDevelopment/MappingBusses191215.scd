//: 15 Dec 2019 14:43
// Revisit bus mapping mechanism to make it more flexible.
/* NOTE: TODO: the urange using kr func with \lo and \hi parameters
could be generated via shortcut:

\aplayer.umap(\parameter);

Example:

\urangetest.umap(\freq, lo, hi);

lo and hi are the initial values for lo and hi controls.

Then a second shortcut could be used to set the lo and hi parameter
values for each parameter using a urange func.

\aplayer.setLo(param value);
\aplayer.setHi(param value);

Example (see bottom of present file): 

\urangetest.setLo(\freq, 500);
\urangetest.setHi(\freq, 1000);

*/
//:Initial tries with functions playing to busses.
{ SinOsc.ar(\freq.kr(1000), 0, 0.1).stereo } +> \maptest;
// \freqbus.bus.set(2000);
// this is not the right way to do the indirectio:
// \maptest.map(\freq, \freqbus);
// Instead we map a function to freq directly.
// 
{ SinOsc.kr(\x1.kr(1)).range(1000, 2000) }.map(\maptest, \freq);
//The question is how do I set \x1 in the kr function above?
\maptest_freq.isPlaying;
\x1 <+.maptest_notfreq 10; // countertest
\x1 <+.maptest_freq 10;    // works!
//:try mapping the x1 control of the buscontrol kr player
\x1bus.bus.set(5);
\maptest_freq.map(\x1, \x1bus);
\x1bus.bus.set(0.1);
//:test urange dynamic changes with mapping
{ SinOsc.ar(\freq.kr(1200), 0, 0.5).stereo } +> \freqtest;
{ \myfreq.kr(0).urange(1000, 2000) }.map(\freqtest, \freq);
//:
\freqtest_freq.map(\myfreq, \x1);
//:
\x1.bus.set(0.9);
//:Try changing the range of urange dynamically with control parameters
{ LFSaw.ar(\freq.kr(1200), 0, 0.1).stereo } +> \urangetest;
{ \myfreq.kr(0).urange(\lo.kr(1000), \hi.kr(2000)) }.map(\urangetest, \freq);
//:
\urangetest_freq.map(\myfreq, \x1);
//:
\x1.bus.set(0.7);
//:
\x1.bus.set(0.0);
//:
\lo <+.urangetest_freq 800;
//:
\lo <+.urangetest_freq 500;
//:
\hi <+.urangetest_freq 1500;
//:
\x1.bus.set(1.0);
//:
\x1.bus.set(0.1);
//:
\x1.bus.set(0.0);