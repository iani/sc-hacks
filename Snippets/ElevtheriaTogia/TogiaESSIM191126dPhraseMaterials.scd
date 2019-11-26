//:summary of phrases:
/*
1. 0
2. 750
3. 767
4. 744
5. 809
*/
//:================================================================
//:various phrases from the recording
//:phrase1 slow ascending glissando loop
\rate <+.phrase 0.5;
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(0.25, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		\startpos.kr(809) + 10 * 44100, 1);
} +> \phrase
//:phrase2 beginning of piece
\rate <+.phrase 0.5;
\startpos <+.phrase 0.0;
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		\startpos.kr(0) + 10 * 44100, 1);
} +> \phrase
//:phrase3 extreme scratching
\rate <+.phrase 0.5;
\startpos <+.phrase 744;
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		// \trig.kr(1),
		\startpos.kr(750) + 10 * 44100, 1);
} +> \phrase
//:phrase4 low scratching
\rate <+.phrase 0.5;
\startpos <+.phrase 767;
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		// \trig.kr(1),
		\startpos.kr(809) + 10 * 44100, 1);
} +> \phrase
//:phrase5
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		// \trig.kr(1),
		\startpos.kr(809) + 10 * 44100, 1);
} +> \phrase
//:phrase6
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		// \trig.kr(1),
		\startpos.kr(809) + 10 * 44100, 1);
} +> \phrase
//:phrase7
{
	PlayBuf.ar(1, \prologue.b, \rate.kr(0.5, 1).urange(0.5, 1.5),
		Impulse.kr(\period.kr(9e10).reciprocal),
		// \trig.kr(1),
		\startpos.kr(809) + 10 * 44100, 1);
} +> \phrase
//:


//:


//:












