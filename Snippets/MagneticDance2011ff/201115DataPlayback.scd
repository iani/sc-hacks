//:15 Nov 2020 09:28 preparing read of saved osc data, for playback
//:read the data from file
a = File.readAllString("/home/iani/.local/share/SuperCollider/MD/201115_081712.txt");
//:convert the data from string to original array.
b = a.split($\n);
d = b collect: _.interpret; // Done!
//:previous tests:
c = b.first.interpret;
c.first;
b[0].first;

