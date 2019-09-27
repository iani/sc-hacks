// this is what I write when I didn't sleep last night.. zzzzzz
// easy subsynth with dynklank and simple scale

(

fork{ 
	loop{
		var time;
		time = 5.rand;
		{
			var sound, freqs, envs, rings, numvoices, env;
			numvoices = 40;
			freqs = {(Scale.major(\just).degrees+26+
				(0,12..110).choose).choose}.dup(numvoices).midicps;
			rings = {1.0.rand}.dup(numvoices);
			envs = { EnvGen.kr(Env.linen( time/3.0.rand, 
				time/3.0.rand, time/3.0.rand, 1.0.rand ) ) }.dup(numvoices);
			
			sound = PinkNoise.ar(numvoices.reciprocal!2);
			sound = DynKlank.ar(`[freqs,envs,rings], sound );
			sound = sound * EnvGen.kr(Env.linen(time.rand,time/3,time.rand),doneAction:2);
			
			sound = HPF.ar(sound, 120);
			
			4.do{sound = DelayC.ar(sound, 0.4, [0.4.rand,0.4.rand], 1/8, sound) };
					
			//good call - lets turn this down	
			sound*0.2;
		}.play;
	time.rand.wait;
	}
}
)