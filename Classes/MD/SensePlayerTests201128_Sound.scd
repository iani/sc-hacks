SenseServer.postInput;
SensePlayer.read("/home/iani/.local/share/SuperCollider/MD/201117_153721.txt");
SensePlayer.play;
// SenseBus.activate;
SenseBus.mute.activate.scope;
//:Accessing the X busses
\x1.bus.get;
\x2.bus;
//:First sound test;
{ SinOsc.ar(1000, 0, 0.5).dup } +> \test;
//:
{ SinOsc.ar(X(1).exprange(400, 2000), 0, 0.5).dup } +> \test;


//:+building the playback algorithm
SensePlayer.read("/home/iani/.local/share/SuperCollider/MD/201117_153721.txt");
~data = SensePlayer.data[..4];
~size = ~data.size;
~times = ~data.flop.first.differentiate[0] = 0;
~convertedData = ~data.flop.put(0, ~times).flop;
~convertedData do: { | row, count |
}