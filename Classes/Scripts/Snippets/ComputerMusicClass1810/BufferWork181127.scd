/* 27 Nov 2018 16:01
Buffer record and playback.

Goal: 
- Allocate a clear buffer before starting a player.
- If buffer already exists under given symbol, then free it and allocate a new one.
  Thereby make sure that the buffer will be empty for recording new sounds.
  But: Make sure that the player waits until the new buffer is allocated before starting.

Steps: 

1. See how buffers are allocated from symbols
2. See how buffers are cleared from symbols.
3. See how buffers notify when allocation is complete.
4. Write test code to make a player start after a buffer is allocated.
5. Incorporate this code in a method.

Prototype API:

	// example 1: 1 buffer spec
\buffername.cb(3) +> { PlayBuf.ar(\buffename.bufnum) } +> \player;
	// example 2: array of buffer specs
[\buffer1, 2, \buffer2, 5].cb +> 
{ PlayBuf.ar(\buffer1.bufnum) + PlayBuf.ar(\buffer2.bufnum) } +> \player;

symbol or array .cb returns BufferSpec.
bufferspec +> source returns BufferSource
BufferSource +> symbol plays BufferSource in player.  

aBufferSource.play(aPlayer):
- free all buffers stored in BufferSpec instance stored in bufSpec in aBufferSource.
- allocate new buffers for BufferSpec, sequentially.
- After the last buffer of BufferSpec is done allocating, call aPlayer.play(source),
  with the source stored in BufferSource.

Following is a step by step explanation. 
q
*/

//:Creating or accessing a buffer on a symbol
\buffer.b(5);
//:free existing buffer;
\buffer.free; 
//:recreate buffer, with different duration;
\buffer.b(3); 
//:chain free and create, to guarantee empty buffer: 
\buffer.free.b(5);
//:test notification when new buffer is allocated
Buffer.alloc(Server.default, 100000, completionMessage: { | buf |
	postf("buf % was now allocated\n", buf)
});
//:test modified b method with completion func:
\bufferx.b(4, 1, { | buf | postf("buf % was created\n", buf) });
//:
~a = Pseq([1]).asStream;
//:+
var stream, next;
stream = Pseq((1..10)).asStream;
while { (next = stream.next).notNil } { next.postln.yield };

//:+
var stream, next;
stream = Pseq((1..10)).asStream;
stream do:  { | element | (element / 10).postln; nil.yield };
//:
var stream;
stream = Pseq([1, nil]).asStream;
stream.nextN(4);