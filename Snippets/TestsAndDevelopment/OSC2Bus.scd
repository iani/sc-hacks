//connect osc input to bus 13 May 2019 10:21
//set bus to numeric value obtained from input array at given index position
//:starting point: current osc usage syntax
// example from Dan Duo:
// parameter <+.envir 'oscmessagename'.osc(arrayindex, ...);
//:create gui to check stuff
\bufplay.v(
	\per.slider(\freq, \bufplay);
);
//:test Symbol:setParam
\per.setParam(800 rrand: 4000, \bufplay.e);
\bufplay.e[\per]
//:test Bus:setParam
// \per.bus;
\per.bus.setParam(400 rrand: 700);
//:
\per.bus.get;
//:test symbol osc binding
\per <+.bufplay '/pi1'.osc(3, [-20, 40], \freq);
//:test bus osc binding
\per.bus <+.bufplay '/pi1'.osc(3, [-20, 40], \freq);
//:study implementation to prepare extension for buses
NetAddr.localAddr.sendMsg(\pi1, 1, 2, 3, -20 rrand: 40, 5);
//:test port number!
NetAddr("127.0.0.1", 57120).sendMsg(\test, 1);
//:Be careful : LOcaladdr can sometimes have port 57121
NetAddr.localAddr;
//:test connecting bus, parameter, both
//connect param
\myparam <+.bufplay '/paramexample'.osc(3, [-20, 40], \freq);
//connect bus only
\mybus.bus <+.bufplay '/busexample'.osc(3, [-20, 40], \freq);
//connect parameter + bus
\myboth <+.bufplay '/bothexample'.osc(3, [-20, 40], \freq);
\myboth.bus <+.bufplay '/bothexample'.osc(3, [-20, 40], \freq);
//:+
10 do: {
	var envir, addr, val, mybusval, mybothbusval;
	envir = \bufplay.e;
	addr = NetAddr.localAddr;
	[\paramexample, \busexample, \bothexample] do: { | who |
		val = -20 rrand: 40;
		postf("\n\ntesting %, sending val: %\n", who, val);
		addr.sendMsg(who, 1, 2, 3, val, 5);
		1.wait;
		\mybus.bus.get({ | argval | mybusval = argval });
		\myboth.bus.get({ | argval | mybothbusval = argval });
		1.wait;
		postf("myparam param value is:: %\n", envir[\myparam]);
		postf("mybus bus value is: %\n", mybusval);
		postf("myboth param value is: %\n", envir[\myboth]);
		postf("myboth bus value is: %\n", mybothbusval);
		1.wait;
	}	
};
//:debugging param set 1: connect
\myparam <+.debug '/paramexample'.osc(3, [-20, 40], \freq);
//:debugging param set 2: set
NetAddr.localAddr.sendMsg('/paramexample', 1, 2, 3, 5, 5, 6);
//:debugging param set 3: check
\debug.e;
//:debugging bus set 4: connect bus
\myparam.bus <+.debug '/paramexample'.osc(3, [-20, 40], \freq);
//:debugging bus set 6: get + post bus value
\myparam.bus.get({ | val | postf("value is: %\n", val )});
//: ================================================================
//:Testing sound
() +> \sound;
