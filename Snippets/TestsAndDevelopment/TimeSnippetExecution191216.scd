//:testing time again
Time.verbose = true; // post details on alternate ways to calculate dt
"start of piece at 0 seconds".postln;
1.abswait;
"at 1 seconds now ".postln;
5.abswait;
"at 5 seconds now".postln;
15.abswait;
"at 15 seconds now".postln;
postf("code done at % seconds\n", Time().elapsedTime);