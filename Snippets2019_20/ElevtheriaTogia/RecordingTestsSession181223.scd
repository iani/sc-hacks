//Session 23 Dec 2018 13:18
//:Stereo sound check
{ WhiteNoise.ar(0.01) * LFPulse.kr(1, [0, 0.5]) } +> \sound;
//:Input sound check
{ In.ar(2, 1) * LFPulse.kr(1, [0, 0.5]) } +> \sound;
//:simple recorder
\recorder.v(
	["start recording", {
		Server.default.record(numChannels: 3);
		"started recording!\nRecording is now ON".postln;
	},
		"stop recording", {
			Server.default.stopRecording;
			"stopped recording!\nRecording is now OFF".postln;
		}].button
);
//:simple recorder with filename
var namefield;
\recorder.v(
	HLayout(
		StaticText().string_("filename: "),
		namefield = TextField().string_("myrecording")
	),
	["start recording", {
		namefield.string.postln;
		Server.default.record(
			path: thisProcess.platform.recordingsDir +/+  Date.localtime.stamp
			++ "_" ++ namefield.string ++ "." ++ Server.default.recHeaderFormat,
			numChannels: 3);
		"started recording!\nRecording is now ON".postln;
	},
		"stop recording", {
			Server.default.stopRecording;
			"stopped recording!\nRecording is now OFF".postln;
		}].button
);
//:
Date().timestamp;

Server.killAll;