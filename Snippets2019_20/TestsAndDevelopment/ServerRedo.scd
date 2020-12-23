//:Server as Singleton + Server Redo
// Prototype 11 Aug 2019 18:18
//:
//Registry.put(S, \default, Server.default);
//S.class
S.serverRunning;
//:
S.default;
//:Premise: Variables needed.
/*
	1. Variable isActivated, tracks the most recent action
	quit or boot action by the user. Initially isActivated is false.
	When the user boots the server, isActivated becomes true. 
	When the user quits the server, or the server crashes (!?)
	isActivated becomes false.

	This variable is needed to know whether to restart the 
	routine that polls the server after a CmdPeriod (see below).

	2. Variable isRunning. Is true when server is running
	and false when not.  Is updated by the server status 
	polling routine.

*/
//:Stage 1: Rebuild server watcher routine - status poll
//:Make it restart after command period, as long
// as server has been booted and not quitted by user
//:Fix CmdPeriod
/* 1. Fix CmdPeriod to make it broadcast 'cmdperiod' message
	with changed.  To avoid modifying the code of CmdPeriod class,
	just Add a permanent action to CmdPeriod:
*/
CmdPeriod add: { CmdPeriod.changed(\cmdPeriod) };
//:Track whether server has been booted or quitted by user.
/* Use the above notification from CmdPeriod to restart the 
	polling routine, when CmdPeriod is pressed. 
	Only restart when the server has been booted by the user and not yet quitted.

	To know whether the server has been booted and not quitted, 
	track state in variable "isActivated". (Implement this as instance variable
	or external slot saved in Registry, depending on phase of coding.)

	- Initially the state of "isActivated" is false.
	- When the server is booted by the user, set isActivated to true.
	- When the server is quit by the user, set isActivated to false.
*/
//================================================================
//Redoing the boot process from scratch:
//================================================================
//:get program string to run with unixcmd
Server.program;
//:get program string with options
Server.program ++ Server.default.options.asOptionsString;
// to try on shell terminal:
// exec scsynth -u 57110 -a 1024 -i 2 -o 2 -R 0 -l 1
// then try with wrong string to see what happens
// Need to see how crash behaves
// This one did boot: (-R and -l can be omitted...)
exec scsynth -u 57110 -a 1024 -i 2 -o 2
//:now try from sclang.  First without function for failure:
"exec scsynth -u 57110 -a 1024 -i 2 -o 2 -R 0 -l 1".unixCmd;
//:try again to see how failure shows - when already booted
"exec scsynth -u 57110 -a 1024 -i 2 -o 2 -R 0 -l 1".unixCmd;
/* it says this:
	JackClient::AcquireSelfRealTime error
	JackDriver: connected  system:capture_1 to SuperCollider-01:in_1
	JackDriver: connected  system:capture_2 to SuperCollider-01:in_2
	JackDriver: connected  SuperCollider-01:out_1 to system:playback_1
	JackDriver: connected  SuperCollider-01:out_2 to system:playback_2
	Exception in World_OpenUDP: bind: Address already in use
*/
//:CLEAN UP: Kill all servers
Server.killAll;
//:Now try to see what the error function does
"exec scsynth -u 57110 -a 1024 -i 2 -o 2 -R 0 -l 1".unixCmd({ | exitCode |
	postf("The exit code is: %\n", exitCode)
});
//:Conclusions
/*
	When not booting because already booted, then the exit code is 1
	When exiting because of Server.killAll, then the exit code is 0
	When exiting because of kill <pid> from terminal, then the exit code is 0
*/
//:getting the process id
//It is returned by unixCmd!
"exec scsynth -u 57110 -a 1024 -i 2 -o 2 -R 0 -l 1".unixCmd({ | exitCode |
	postf("The exit code is: %\n", exitCode)
}).postln;
//:to quit, send messge \quit. No pid needed.
{
	"exec scsynth -u 57110 -a 1024 -i 2 -o 2 -R 0 -l 1".unixCmd({ | exitCode |
		postf("The exit code is: %\n", exitCode)
	}).postln;
	(5..0) do: { | i |
		1.wait;
		postf("quitting in %\n", i);
	};
	Server.default.addr.sendMsg(\quit); // this is how you quit
	// exit code is 0
}.fork; 
//:quitting, without the fork;
Server.default.addr.postln.sendMsg(\quit); // this is how you quit
//:================================================================
//:Starting OSC communication attempts with server
/*
	The following are done separately because we want to wait and 
	see that the server has started before sending it a message.
	At a later stage, we will do this through a routine
	that keeps sending the message until it gets a response.
*/
//:1. boot the server
"exec scsynth -u 57110 -a 1024 -i 2 -o 2 -R 0 -l 1".unixCmd({ | exitCode |
	postf("The exit code is: %\n", exitCode)
}).postln;
//:2. turn osc trace on
OSCFunc.trace(true);
//:3. Send status request
Server.default.addr.sendMsg(\status);
//:4. Quit the server before repeating the above process
Server.default.addr.postln.sendMsg(\quit); // this is how you quit
//:5. Repeat the above using a routine to poll the server
OSCFunc.trace(true);
"exec scsynth -u 57110 -a 1024 -i 2 -o 2 -R 0 -l 1".unixCmd({ | exitCode |
	postf("The exit code is: %\n", exitCode)
}).postln;
{
	loop {
		"Sending \\status to server".postln;
		Server.default.addr.sendMsg(\status);
		1.wait;
	}
}.fork;
//:How to know if a routine is running
r = { loop { 10.postln; 1.wait } }.fork;
//:
r.isPlaying;
r;
Main.elapsedTime;
//:Trying out scsynth \sync message
//:start the server
Server.default.boot;
//:Create OSCFunc for synced and for synths
OSCFunc({ | msg | msg.postln; }, 'synced').fix;
OSCFunc({ | msg | msg.postln; }, '/n_go').fix;
//:test the synced oscfunc
Server.default.sendMsg(\sync);
//:test the synced oscfunc with 100 syths created before it
{ Synth(\default, [amp: 0.001]) } ! 100;
Server.default.sendMsg(\sync);
//:test the synced oscfunc twice with 2 groups of 10 syths created 
{ Synth(\default, [amp: 0.001]) } ! 10;
Server.default.sendMsg(\sync, 1);
{ Synth(\default, [amp: 0.001]) } ! 10;
Server.default.sendMsg(\sync, 2);
//:
Synth(\default);
//:
Server.freeAll;
//:before the prototype
var oscFunc;
oscFunc = OSCFunc({ | msg |
	postf("received by 2: %\n", msg);
}, 'synced', argTemplate: [2]);
{ Synth(\default, [amp: 0.001]) } ! 10;
Server.default.sendMsg(\sync, 2);
//:Prototype of syncing custom functions.
var sync;
sync = { | beforeFunc, afterFunc, server |
	var id, oscFunc;
	"HELLO".postln;
	server ?? server = Server.default;
	id = beforeFunc.hash;
	oscFunc = OSCFunc({ | msg |
		postf("I received sync from % and will run next func\n", msg);
		afterFunc.value;
		"Now I will free my self - this OSCFunc will disappear".postln;
		oscFunc.free;		
	}, 'synced', argTemplate: [id.postln]);
	beforeFunc.value;
	server.sendMsg('sync', id);
};
sync.(
	{ Synth(\default); "Sent command New Synth".postln; },
	{ "I am certain that the synth was started now".postln; }
);
//:Benchmarking the prototype with 500 synths.
/* I got:

JackEngine::XRun: client = SuperCollider was not finished, state = Running
JackAudioDriver::ProcessGraphAsyncMaster: Process error

But the server said 500 synths, and the time was 0.0409 ... seconds. 
*/ 
var sync;
sync = { | beforeFunc, afterFunc, server |
	var id, oscFunc, beforeFuncTime;
	"HELLO".postln;
	server ?? server = Server.default;
	id = beforeFunc.hash;
	oscFunc = OSCFunc({ | msg |
		postf("I received sync from % and will run next func\n", msg);
		postf("It took me % seconds.\n", Main.elapsedTime - beforeFuncTime);
		afterFunc.value;
		"Now I will free my self - this OSCFunc will disappear".postln;
		oscFunc.free;
	}, 'synced', argTemplate: [id.postln]);
	beforeFuncTime = Main.elapsedTime;
	beforeFunc.value;
	server.sendMsg('sync', id);
};
sync.(
	{ { Synth(\default) } ! 550; "Sent command New Synth".postln; },
	{ "I am certain that the synth was started now".postln; }
);

//:Test above prototype without sending async command.
// This calls the next func immediatly, because there is no async stuff to wait for.
var sync;
sync = { | beforeFunc, afterFunc, server |
	var id, oscFunc;
	"HELLO".postln;
	server ?? server = Server.default;
	id = beforeFunc.hash;
	oscFunc = OSCFunc({ | msg |
		postf("I received sync from % and will run next func\n", msg);
		afterFunc.value;
		"Now I will free my self - this OSCFunc will disappear".postln;
		oscFunc.free;		
	}, 'synced', argTemplate: [id.postln]);
	beforeFunc.value;
	server.sendMsg('sync', id);
};
sync.(
	{ /* Synth(\default); */ "DID NOT SEND command New Synth".postln; },
	{ "there was nothing to sync, so i got called immediately".postln; }
);
//:testing put return stuff
var dict;
dict = IdentityDictionary();
dict.put(Server.default, 1);
//:first test of synclist;
SyncList.sync(
{ "sending synth 1".postln; Synth(\default, [freq: 400 rrand: 4000])},
{ "sending synth 2".postln; Synth(\default)},
{ "SENDING SYNTHS !!! 3".postln;
	{ Synth(\default, [freq: 900 rrand: 9000]) } ! 3 },
{ "SENDING SYNTHS many 4".postln;
	{ Synth(\default, [freq: 900 rrand: 9000]) } ! 20 },
	{ "sending synth 5".postln; Synth(\default, [freq: 400 rrand: 4000])}
)
//:Another test of synclist
var ping;
\test.addNotifier(Server.default, \syncDone, { "Sync DONE".postln; });
\test.addNotifier(Server.default, \syncDoneBetter, { "Sync DONE BETTER".postln; });
ping = {
	{ SinOsc.ar(900 rrand: 9000, [0, 0], Env.perc.kr(2, timeScale: 0.05)) }.play
};
SyncList().sync(*(ping.dup(20000)
	.add({ Server.default.changed(\syncDoneBetter) })));
//:testing notifications before "notify"
Server.default.addr.sendMsg('status');
//:
Server.default.addr.sendMsg('sync');
//:NOTE: The notifications we need are sent even when we do not send
// notify message to the server????
Group();
Server.default.addr.sendMsg('sync');
//:
[
	SyncList().times

	.first, SyncList().times.last];
//:
a = SyncList().times.collect(_.last);
a.last - a.first;