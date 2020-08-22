/* 23 Aug 2020 07:29
Load superdirt samples, 
Store them in dictionaries,
Prepare synthdefs for playing them.
*/

SD {
	classvar <allsamples;
	classvar <samplegroups;

	var <buffer, <defname;

	*init {
		// boot server and load all samples;
		//		"SD is initing now ... - testing before implementation".postln;
		
	}

	*loadDefs {
		// load synthdefs for playing buffers: mono and stereo
		SynthDef("buf1", {
			
			
		}).load;
		SynthDef("buf2", {
			
			
		}).load;
	}
	
}

