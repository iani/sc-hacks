//:setup sensors
BusOsc.watch1(\thisissensestagetest, '/minibee/data',
	[\testbus1_x, 1, 0.47, 0.53, 1],
	[\testbus1_y, 2, 0.47, 0.53, 1],
	[\testbus1_z, 3, 0.47, 0.53, 1],
	[\testbus2_x, 1, 0.47, 0.53, 3], // using sensor module 3
	[\testbus2_y, 2, 0.47, 0.53, 3],
	[\testbus3_z, 3, 0.47, 0.53, 3]
);
//:
\freq <+.test1 0.0;
{ SinOsc.ar(\freq.kr(0.0).urange(100, 1000), 0, 0.1).stereo } +> \test1;
\testbus1_x @>.test1 \freq;
//:
\freq <+.test1 0.0;
{ SinOsc.ar(\freq.kr(0.0).urange(100, 1000), 0,
	\amp.kr(0.5).urange(0.001, 0.3)).stereo } +> \test1;
\testbus2_x @>.test1 \freq;
\testbus1_y @>.test1 \amp;
//:2 sounds, 2 hands, 4 parameters
\freq <+.test1 0.0;
{ SinOsc.ar(\freq.kr(0.0).urange(100, 1000), 0,
	\amp.kr(0.5).urange(0.001, 0.3)).stereo } +> \test1;
\testbus2_x @>.test1 \freq;
\testbus1_y @>.test1 \amp;
{ SinOsc.ar(\freq.kr(0.0).urange(100, 1000), 0,
	\amp.kr(0.5).urange(0.001, 0.3)).stereo } +> \test2;
\testbus1_x @>.test1 \freq;
\testbus1_y @>.test1 \amp;
\testbus2_x @>.test2 \freq;
\testbus2_y @>.test2 \amp;
//:add pulse rate to 2 sounds, 2 hands, 4 parameters
\freq <+.test1 0.0;
{ SinOsc.ar(\freq.kr(0.0).urange(100, 1000), 0,
	\amp.kr(0.5).urange(0.001, 0.3)).stereo
	* 2 * Decay2.kr(Impulse.kr(\rate.kr(1).urange(0.5, 10), 0.01, 0.1))

} +> \test1;
\testbus2_x @>.test1 \freq;
\testbus1_y @>.test1 \amp;
{ SinOsc.ar(\freq.kr(0.0).urange(100, 1000), 0,
	\amp.kr(0.5).urange(0.001, 0.3)).stereo
	* 2 * Decay2.kr(Impulse.kr(\rate.kr(1).urange(0.5, 10), 0.01, 0.1))
} +> \test2;
\testbus1_x @>.test1 \freq;
\testbus1_y @>.test1 \amp;
\testbus1_z @>.test1 \rate;
\testbus2_x @>.test2 \freq;
\testbus2_z @>.test2 \rate;

//:

