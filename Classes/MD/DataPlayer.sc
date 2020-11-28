/* 28 Nov 2020 03:50
Load and play back recorded osc data from file.
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

OSCDataFile {
	var <path; // path of the file which contains the data
	var <file; // file containing the data
	var <data; // the data interpreted as arrays.

	// "/home/iani/.local/share/SuperCollider/MD/201117_153721.txt"
	
	
}

DataPlayer : {}