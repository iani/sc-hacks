//:Prepare directory and files for recording
Platform.userAppSupportDir;
~mddir = Platform.userAppSupportDir +/+ "MD";
File.exists(Platform.userAppSupportDir);
File.exists(~mddir);
File.mkdir(~mddir);
~oscfilepath = format("%/osc%", ~mddir, Date.localtime.stamp);
~oscfile = File(~oscfilepath, "w");

//:
~oscfile.write("Does this work?\n");
//:
~oscfile.write("Is this thing on?\n");
//:+
~oscfile = File(~oscfilepath, "w");
100 do: { | i | 
	~oscfile.write(format("Does this work? %\n", i));
	0.01.wait;
	~oscfile.write(format("Is this thing on?? %\n", i ** 2));
};
~oscfile.close;
//:+first simulation of data writing -- over large time interval.
~oscfile = File(~oscfilepath, "w");
~startTime = Process.elapsedTime;
~entries = 40000;
~waittime = 0.01;
~oscfile.write(format("Began at: %\n", ~startTime));
~entries do: { | i | 
	~oscfile.write(format("Does this work? %, %\n", i + 1, i.rand));
	~waittime.wait;
	postln(i);
	~oscfile.write(format("Is this thing on?? %, %\n", i + 1 ** 2,
		Process.elapsedTime
	));
};
~endTime = Process.elapsedTime;
~oscfile.write(format("Ended at: %\n", ~endTime));
~oscfile.write(format("Total duration for % entries was: %\n",
	~entries,
	~endTime - ~startTime));
~oscfile.write(format(
	"Average entry duration was: %\n",
	~endTime - ~startTime / ~entries));
~oscfile.write(format(
	"Difference from 0.01 nominal wait time was: %\n",
	(~endTime - ~startTime / ~entries) - ~waittime));
~oscfile.close;
"DONE!".postln;
//:

