// 29 Sep 2017 20:54
/* 
Implement Event *> Symbol in manner similar to Function *> Symbol.
Here *> plays a pattern of with eventType \envEvent.
This type does not play events as synths, but sets the current environment's keys.
It can thus be used as a controller for any Player currently playing in the event.
This is more compact than writing routine loops to set environment vars.
*/

//: This must be done at StartUp to initialize the envEvent event type.
