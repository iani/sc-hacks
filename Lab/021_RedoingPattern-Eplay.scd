// 29 Sep 2017 20:54
/* 
Implement Event *> Symbol in manner similar to Function *> Symbol.
Here *> plays a pattern of with eventType \envEvent.
This type does not play events as synths, but sets the current environment's keys.
It can thus be used as a controller for any Player currently playing in the event.
This is more compact than writing routine loops to set environment vars.
*/

//: This must be done at StartUp to initialize the envEvent event type.
//:
\default +> \default;
//:
EventPattern ((type: \envEvent, dur: 0.1, freq: Pwhite (1000, 2000, inf), envir: currentEnvironment)).play;
//: Trying to package this to implement as method in *> operator

\default +> \default;
//:
(dur: 0.1, freq: Pwhite (1000, 2000, inf)) *>.default \freq;
//: Problem: Random retriggering of synths happens when we add this?
(dur: 0.1, amp: Pn (Pseries (0.1, 0.01, 20), inf)) *>.default \amp;
//: DEBUGGING:
\default +> \default;
//:
(dur: 0.1, degree: Pn (Pseries (1, 1, 10), inf)) *>.default \freq;
//:
(dur: 0.01, degree: Pbrown (1, 10, 1)) *>.default \freq;
//: Retrying after the debugging:
\default  +> \default;
//:
(dur: 0.5, degree: Pn (Pseries (1, 1, 10), inf)) *>.default \freq;
//:
(dur: 2, amp: Pwhite(0.01, 0.9)) *>.default \amp;
//: Redoing again: Player should implement playEnvEvent.
(\freq p: \default).inspect;
//:
(\freq p: currentEnvironment).inspect;
//:
(\freq p: currentEnvironment).envir.name.class;
//:
currentEnvironment.name;
//: Debugging p method for symbols:
\player p: \environment;
//:
\player.p;
//:
\environment.ev;
//:
\environment.ev.name;
//:
\environment.ev.players[\player];
//:
\environment.ev.players[\player].name;
//:
\environment.ev.players[\player].envir;
//:
\environment.ev.players[\player].envir.name;
//:
\environment.ev.players[\player].envir.name.class;
//:
currentEnvironment;
//:
currentEnvironment.name;
//:
currentEnvironment.name.class;
//: Preparing playEnvEvent
\player.p(\environment).play({ WhiteNoise.ar(0.1) });
//:
\player.p(\environment).play({ SinOsc.ar(400, 0, 0.1) });
//:
\player.p(\environment).play((dur: 0.1));
//:
\player.p(\environment).play(\default);
//:
\freqPlayer.p(\environment).playEnvEvent((dur: 0.1, freq: Pwhite(400, 4000)));
//:
\freqPlayer.p(\environment).playEnvEvent((dur: 0.15, freq: Pbrown(400, 4000, 10)));
//:
\ampPlayer.p(\environment).playEnvEvent((dur: 0.01, amp: Pbrown(0.0, 0.4, 0.05)));
//: Conclusion: Prepare *> method code. Prototype:
// Event *>.envir playerName // translates to: 
// playerName.p(envir ? currentEnvironment).playEnvEvent(this)
// ================================================================
// Redoing with p message:
\default +> \default;
//:
(dur: 0.01, freq: Pbrown(100, 1000, 50)) *> \freqPlayer;
//:
(dur: 0.01, freq: Pbrown(100, 1000, 50)) *> \freqPlayer;
//:
(dur: 0.05, degree: Pbrown(-20, 10, 15)) *> \freqPlayer;
//:
(dur: 0.01, freq: Pbrown(400, 1000, 50)) *> \freqPlayer;
//:
(dur: 0.5, amp: Pseq([0.1, 0.5], inf)) *>.default \ampPlayer;
//:
\default +> \default2;
//:
(dur: 0.01, freq: Pbrown(400, 1000, 50)) *>.default2 \freqPlayer;
//:
(dur: 0.5, amp: Pseq([0.1, 0.5], inf)) *>.default2 \ampPlayer;


