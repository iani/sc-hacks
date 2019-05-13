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
//:connect parameter only
\paramexample <+.bufplay '/pi1'.osc(3, [-20, 40], \freq);
//:connect bus only
\busexample.bus <+.bufplay '/pi1'.osc(3, [-20, 40], \freq);
//:connect parameter + bus
\bothexample <+.bufplay '/pi1'.osc(3, [-20, 40], \freq);
\bothexample.bus <+.bufplay '/pi1'.osc(3, [-20, 40], \freq);
