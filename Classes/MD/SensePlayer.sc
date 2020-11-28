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
	var <addr;

	prInit {
		addr = NetAddr.localAddr;
	}
	
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
		^rawData.split($\n).collect(_.interpret).select(_.notNil);
	}

	play { | startAt = 0 |
		// convert times to dt and insert them in a copy of the data.
		// play that.
		var rows, times, size;
		rows = data[startAt..].flop;
		times = rows[0];
		// times.asCompileString; // .postln;
		times = rows[0].differentiate.put(0, 0);
		rows = rows.put(0, times);
		rows = rows.flop;
		postf("\n\n======= playing % frames ========\n\n", size = rows.size);
		{
			// times.sort.reverse.select({|t| t > 0.1}).asCompileString.postln;
			// 10.wait;
			rows do: { | row, count |
				// row.postln;
				addr.sendMsg(*row[1]);
				if (count % 10 == 0) { postf("%.. ", count + 1); };				
				row[0].wait;
			};
			postf("\n\n===== played % frames ======\n", size);
		}.fork;
	}
}
