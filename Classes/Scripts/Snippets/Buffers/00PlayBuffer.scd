
//:preload default sample once
/* This snippet is *automatically* run once only, 
before running a snippet from this file for the first time. 
*/
\allwk.loadBuffer(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
/*
\s28.loadBuffer("~/Music/sounds/sounds-tetatet/hi/28.wav".standardizePath);
\s12.loadBuffer("~/Music/sounds/sounds-tetatet/hi/12.wav".standardizePath);
\clap.loadBuffer("~/Music/sounds/sounds-lindrum-etc/clap.wav".standardizePath);
*/

(Sch.homedir ++ "Sounds/lindrum/").loadBuffers;

//:play with default method
\allwk.b.play;
//:list all buffers
Library.at(\buffers).keys.asArray.sort.postln;
//:test another sample from buffer
\ride.b.play;
//:Ask number of channels
\allwk.b.numChannels.postln;
//:play with PlayBuf
{
	PlayBuf.ar(\allwk.b.numChannels, \allwk.b, loop: 1);	
} +> \playbuf;
//:play with PlayBuf and controllable bufnum
{ | bufnum = 0 |
	PlayBuf.ar(1, bufnum, loop: 1);	
} +> \playbuf;
//:Manually change bufnum
\bufnum <+ 1;
//:Manually change bufnum back
\bufnum <+ 0;
//:Change bufnum to "allwk" by buffer name
\bufnum <+ \allwk.bn;
//:Change bufnum to "cabasa" by buffer name
\bufnum <+ \cabasa.bufnum; // bufnum = synonym of bn
//:Change bufnum to "ride" by buffer name
\bufnum <+ \ride.bn; // bufnum = synonym of bn
//:play with startPos
{
	PlayBuf.ar(\allwk.b.numChannels,
		\allwk.b,
		trigger: \trig.kr(0),
		startPos: \sp.kr(2.5) * \sp.b.sampleRate,
		loop: 0);	
} +> \playbuf;
//:Prepare trigger: set to 0
\trig <+ 0;
//:Trigger: set trigger to 1
\trig <+ 2;
//:change start position to 1
\sp <+ 1;
//:change start position to 2.5
\sp <+ 2.5;
//:reset start to random point;
\sp <+ 3.0.rand; // must use trigger when starting point changes source below
//:retriggering loop without routine, using Impulse UGen
{ | bufnum = 0 |
	var sp;
	sp = \sp.kr(0);
	PlayBuf.ar(1, // BufChannels.kr(bufnum),
		bufnum,
		trigger: Impulse.kr(\period.kr(1).reciprocal) + Changed.kr(sp),
		startPos: sp * BufSampleRate.kr(bufnum),
		loop: 0);	
} +> \playbuf2;
\playbuf2.v(
	// less than 0.1 delay risks entering perceptible frequency range
	\period.slider([0.1, 3.0]),
	\sp.slider([0.0, 3.0])
);
//:change buffer when changing period
\playbuf2.watch(\period, {
	\bufnum <+ Library.at(\buffers).values.choose.bufnum.postln;
})
//: