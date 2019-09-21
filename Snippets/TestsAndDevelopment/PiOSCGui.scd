//: GUI for configuring osc reception of RPI data via OSC
//  12 Sep 2019 21:46
/*
Design specs / draft proposal

One class per pi: Handles one OSCFunction listening to one pi, and all 9 parameters received.

One class per parameter: Handles specs "from range "and "to range", and parameter and envir where these are sent.  Must also have index of which parameter it is hnadling and the name of that parameter (ax/y/z, mx/y/z, gx/y/z).

Additional utility functions: 

- Display if data are being received from this pi. 
- Switch OSCFunction trace on/off. 
- Record incoming data.
*/

OSCFuncRecorder {
	classvar <>all;

	var <path, <oscFunc, <data;
	var <>recordingp = false

	*new { | path |
		all = all ?? { IdentityDictionary.new };
		
	}

	*record { | path |

	}
	
	*stopRecording { | path |
		this.new(path)
		
	}

	makeOSCFunc {
		
		
	}
	
	doOsc {
		/* method to execute upon receiving osc data */
		
	}
	stopRecording {
		
		
	}

	save {
		/* save recorded data to file. Use sctxar text format 
			save to path userAppDirectory/data/pi<n><timestamp>.sctxar

		*/
		
	}

	load {
		/* Load recorded data from file 
		*/
	}

	plot {
		
		
	}
}


PiFunc : OSCFuncRecorder {
	/* Specialized in handling messages from RPI */

	func {
		// generate function for OSCFunc
		
	}
	
}