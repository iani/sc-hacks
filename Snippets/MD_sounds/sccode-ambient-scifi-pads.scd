// been listening to a lot of vangelis/wendy carlos recently
// largely modified from the cs80_mh in synthdefpool 

(
var scale,fund;

scale = [0,3,7];

fork{
	loop{
		var t = [16,32].choose;
		fund = 26+[0,3,7,10,14].choose;
		fund.postln;
		t.wait;
	};
};

fork{			
	loop{
		var t = 1/2;
		var a,d,s,r,fa,fd,fs,fr,ratio,dtune,freq,
			ffreq,vibrate,vibdepth,cutoff,amp;
 		freq = (scale.choose+fund+(12*(0..3).choose)).midicps;
 		vibrate = t/(1..10).choose;
 		vibdepth = (90..500).choose.reciprocal;
		dtune = 1e-3; LFNoise0.kr(t,0.02,1);
		cutoff = freq * (1.1,1.2..4).choose;
 		ratio = (0.99,0.991..1.01).choose;	
 		amp = 1/3;
		
 		a = 3.0.rand/t;		
 		s = 3.0.rand/t;
 		r = 3.0.rand/t;
 		fa = 3.0.rand/t;
 		fs = 3.0.rand/t;
 		fr = 3.0.rand/t;
		
		play{
			var env, fenv, sig, gate, vib;
			gate = Line.kr(1,0,t);
			env = EnvGen.kr(Env.linen(a,s,r),doneAction:2);
			fenv = EnvGen.kr(Env.linen(fa,fs,fr));
			freq = Line.kr(freq,freq*ratio,t);
			vib = SinOsc.kr(vibrate).range(vibdepth.neg,vibdepth)+1;
			freq = vib*freq;			
			//freq = freq.lag(t);
			sig = Select.ar(2.rand,[
				Pulse.ar([freq,freq*(1+dtune),freq*(1-dtune)],
					LFNoise2.kr(t,0.5,0.5), 0.1).sum,
				Saw.ar([freq,freq*(1+dtune),freq*(1-dtune)]).sum
			]);
			sig = sig.tanh * env;
			ffreq = max(fenv*freq*12,cutoff)+100;
			sig = MoogFF.ar(sig,ffreq,LFNoise2.kr(1/t,1.4,1.5)).tanh;
			sig = RLPF.ar(sig,1e4,0.9).tanh;
			Pan2.ar(sig*amp,LFNoise2.kr(t.rand));
			};
		t.wait;
		};
	};

// this was inspired by http://sccode.org/1-4EG 
// good way to get the reverb out of the loop... 
// thanks rukano ;)
{
	var in = In.ar(0,2);
	in = in * 0.25;
	in = Compander.ar(in,in,0.75,1,0.75,0.1,0.4);
	in = (in*0.2) + GVerb.ar(HPF.ar(in,100), 20, 20, mul:0.6).tanh;
	in = Limiter.ar(LeakDC.ar(in));		
	ReplaceOut.ar(0, in)
}.play(addAction:\addToTail);
)