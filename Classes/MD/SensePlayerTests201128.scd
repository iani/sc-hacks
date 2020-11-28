SenseServer.postInput;
SensePlayer.read("/home/iani/.local/share/SuperCollider/MD/201117_153721.txt");
SensePlayer.play;
// SenseBus.activate;
SenseBus.mute.activate.scope;
//:
//:+building the playback algorithm
SensePlayer.read("/home/iani/.local/share/SuperCollider/MD/201117_153721.txt");
~data = SensePlayer.data[..4];
~size = ~data.size;
~times = ~data.flop.first.differentiate[0] = 0;
~convertedData = ~data.flop.put(0, ~times).flop;
~convertedData do: { | row, count |
}