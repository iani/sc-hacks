//: 22 Dec 2020 14:02
/* An attempt to understand how event:play works

*/
//:keys, parent, proto of an empty event;
e = ();
postf("()'s keys are: \n%\n", e.keys);
postf("()'s parent is: \n%\n", e.parent);
postf("()'s proto is: \n%\n", e.proto);
\_;
//:keys, parent, proto of an empty event, after playing it;
e = ();
e.play;
"Now inspecting event after playing:".postln;
postf("()'s keys are: \n%\n", e.keys);
postf("()'s parent is: \n%\n", e.parent);
postf("()'s proto is: \n%\n", e.proto);
\_;
//:Exploring parent's type and keys
e = ();
e.play;
"Now inspecting event after playing:".postln;
postf("()'s parents' type is: %\n", e.parent.type);
postf("()'s parents' keys are: \n");
e.parent.keys.asArray.sort do: ({ | k, i |
	postf("(%:) %\n", i, k);
});
\_;
//: