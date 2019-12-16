//:testing Time again
Time.verbose = true; // post details on alternate ways to calculate dt
"start of piece at 0 seconds".postln;
1.abswait;
"at 1 seconds now ".postln;
5.abswait;
"at 5 seconds now".postln;
15.abswait;
"at 15 seconds now".postln;
postf("code done at % seconds\n", Time().elapsedTime);
//:It is possible to include n.wait (relative time) statements - at own risk
Time.verbose = true; // post details on alternate ways to calculate dt
"start of piece at 0 seconds".postln;
1.abswait;
"at 1 seconds now ".postln;
5.abswait;
"at 5 seconds now".postln;
5.wait;
"I waited 5 seconds relatively - but abswait will still work".postln;
15.abswait;
"should be at about 15 seconds now".postln;
postf("code done at % seconds\n", Time().elapsedTime);