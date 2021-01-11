//: 10 Jan 2021 13:35
/* Utility: Return files under this dir that match *.aiff, *.aif, *.wav, *.WAV. 

Note: overwriting prFlat here for String.
There is a possibility that this breaks code in other libraries.

*/

+ String {
	prFlat { | list |
		^list add: this
	}

	audioFiles { | ... types |
		if (types.size == 0) {
			types = ["aiff", "aif", "wav", "WAV"];
		};
		^types.collect({ | type | (this +/+ format("*.%", type)).pathMatch }).flat;
	}
}