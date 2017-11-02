// 27 Sep 2017 12:19
// Step by step.
//: Test array unique string add/remove
a = nil addUniqueString: "asdf";
//:
a = a addUniqueString: "asdf";
//:
a = a addUniqueString: "asdfa";
//:
a = a removeUniqueString: "asdfa";
//:
a = a removeUniqueString: "asdf";
//:
AudioFiles.save;
StartupFiles.save;
//:
AudioFiles.loadDialog;
//:
\boat.b.play;
\bell.b.play;