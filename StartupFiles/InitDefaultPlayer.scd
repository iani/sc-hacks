//  7 Oct 2017 17:38
// At ServerBoot, initialize default event with default player+source, without starting it.
//: Note: If server has not booted then \default.makeSource results in error.
ServerBoot add: {
	\default.makeSource(\default.p);
}