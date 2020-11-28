/* 28 Nov 2020 04:08
Load and play back OSC data from file. 
To record data, use SenseRecorder.

File for testing: 

"/home/iani/.local/share/SuperCollider/MD/201117_153721.txt"

Template:
//:read the data from file
a = File.readAllString("/home/iani/.local/share/SuperCollider/MD/201117_153721.txt");
//:convert the data from string to original array.
b = a.split($\n);
d = b collect: _.interpret; // Done!
//:previous tests:
c = b.first.interpret;
c.first; // c contains the interpreted data
b[0].first; // b contains the lines as strings

Example of one line of data (single OSC data frame):
[ 13117.75263077, [ /minibee/data, 1, 0.50616532564163, 0.56537663936615, 0.51117080450058 ] ]
Explanation of data format is: 

[
[[timestamp], ['/minibee/data', xbeeid, x, y, z]]
]

*/

SensePlayer : NamedSingleton {
	var <path; // path of the file which contains the data
	var <file; // file containing the data
	var <rawData; // data as single string - as read from file
	var <data; // the data interpreted as arrays.

	read { | argPath |
		path = argPath;
		postf("my path is: %\n", path);
		path.doIfExists({
			file = File(path, "r");
			this.readAndConvertData;
		},{
			postf("Could not find any file at:\n%\n", path);
			"Please try again with a different path".postln;
		})
	}

	readAndConvertData {
		rawData = file.readAllString(file);
		data = this.convertData(rawData);
		postf("data has % entries\n", data.size);
		"Here are the first 5 entries: ".postln;
		data[..4] do: _.postln;
	}

	convertData { | rawData |
		^rawData.split($\n) collect: _.interpret;
	}

	play { | startAt = 0 |
		var startFrame, startTime;
		startFrame = data[startAt];
		startTime = startFrame[0];
		{
			postf("starting at frame %\n", startAt);
			postf("Data at this frame are: %\n", startFrame);
			postf("Absolute start time is: %\n", startTime);
			data do: { | a |
				a.postln;
				0.1.wait;
			}
		}.fork;
	}
}
