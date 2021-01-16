//: 16 Jan 2021 21:15
/*
Devise mechanism for matching triggers sent by named instances of 
triggering players to instances of listening players.

\test.p.hash;
\test2.p.hash;

*/
//:================================================================
//:Use SendTrig to send triggers from server to lang
/* 
Test the basic mechanism for creating an OSCFunc that listens to 
a SendTrig message with custom ID, independently of the Node ID of the 
synth that sends it. 
Create an OSCFunc that matches a '/tr' message sent by SentTrig with a 
given ID. 
*/
//:SendTrig with id controlled by argument.
SynthDef("help-SendTrig",{ | id = 1 |
    SendTrig.kr(Impulse.kr(1.0),id, 0.9);
}).add;

// Match id with value 1. Ignore synth id sent by SentTrig
o = OSCFunc({ arg msg, time;
    [time, msg].postln;
},'/tr', argTemplate: [nil, 1]); // ignore synth id, match trig id
//:Synth for testing
Synth("help-SendTrig");