
//: 16 Nov 2020 21:40
/* 
first tests for sound with data from XBee using new method for 
setting data in busses.
*/
//:Start: Activate Bus setter
SenseBus.activate;
//:mute posting from SenseBus after checking that data is received
SenseBus.mute;
//:open scope to watch control busses
Server.default.scope(12, rate: \control);
