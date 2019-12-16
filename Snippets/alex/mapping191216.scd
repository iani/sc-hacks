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

//:set the map
Mapper.setSpec(\sensor1, \x, {|val| val.linlin(0.2, 0.8, 0, 10) });
Mapper.setSpec(\sensor1, \z, {|val| val.linlin(0.4, 0.6, 0, 1) });


//:create osc func using map
var addr = NetAddr.new("127.0.0.1", 51000);
OSCFunc({ |msg|
	var x, y, z;
	#x, y, z = msg[2..];
	addr.sendMsg('/sensor1',
		Mapper.map(x, \sensor1, \x),
		Mapper.map(y, \sensor1, \y),
		Mapper.map(z, \sensor1, \z).postln		
		
	)
		//Mapper.map(y, \sensor1, \y))
		// Mapper.map(z, \sensor1, \z))
}, '/minibee/data', argTemplate: [1]) //listen only sensor one

//:
var addr = NetAddr.new("127.0.0.1", 51000);
addr.sendMsg('/sensor1', 1, 2);
//:
OSCFunc.trace(true)