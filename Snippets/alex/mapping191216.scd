//:first step receiver

OSCFunc({ |msg|
	msg.postln;
	
}, '/minibee/data', argTemplate: [1]) //listen only sensor one

//:get x, y, z vector

OSCFunc({ |msg|
	var x, y, z;
	#x, y, z = msg[2..];
	postf("x is: %, y is: %, z is: % \n", x, y, z);	
}, '/minibee/data', argTemplate: [1]) //listen only sensor one

//:mapping x,y,z values

OSCFunc({ |msg|
	var x, y, z;
	#x, y, z = msg[2..];
	postf("x is: %, y is: %, z is: % \n", x, y, z);	
}, '/minibee/data', argTemplate: [1]) //listen only sensor one

//:
OSCFunc.trace(true)