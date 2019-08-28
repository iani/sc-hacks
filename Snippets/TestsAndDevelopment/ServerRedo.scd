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
CmdPeriod add: { CmdPeriod.changed(\cmdperiod) };
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