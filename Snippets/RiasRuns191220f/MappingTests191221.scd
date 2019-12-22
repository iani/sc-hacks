// ================================================================
//:playing some shapes
{ SinOsc.ar(\freq.kr(1440), 0, 0.01).stereo } +> \src;
5.wait;
{ SinOsc.kr(\freq.kr(15)).range(1500, 1600) } @>.src \freq;
5.wait;
{ Line.kr(300, 4000, 10) } @>.src \freq;
10.wait;
{ XLine.kr(3000, 400, 10) } @>.src \freq;
10.wait;
{ XLine.kr(300, 2000, 10) } @>.src \freq;
10.wait;
\freq <+.src_freq 0.2;
{ LFDNoise3.kr(\freq.kr(0.2)).range(100, 300) } @>.src \freq;
