/*
21 Oct 2020 09:52
Initial decoding test.
from http://doc.sccode.org/Classes/BFDecode1.html

Zoom H3-VR records in AmbiX, on 4 tracks of audio.  
Assuming that BFDecode1 decodes from ambix.

This is indicated by the channel variable names order in the examples 
below:

    #w, x, y, z = BFEncode1.ar(p, MouseX.kr(-0.5pi, 0.5pi), 0, 1);




    B-format (FuMa) lists the channels in order: W, X, Y, Z. The W channel also has a -3 dB gain applied.
    The ambiX convention lists the channels using the Ambisonics Channel Number (ACN) ordering: W, Y, Z, X. The channels also use SN3D normalisation (which for first order Ambisonics simply means that the four channels have a uniform gain normalisation).



*/

// s.boot;

// .ar method
(
{
    var w, x, y, z, p, a, b, c, d;

    p = PinkNoise.ar; // source

    // B-format encode
    #w, x, y, z = BFEncode1.ar(p, MouseX.kr(-pi, pi), MouseY.kr(0.25pi, -0.25pi), 1);

    // B-format decode to cube / quad ([lfh, rfh, rrh, lrh, lfl, rfl, rrl, lrl])
    // lfl = left fron high, lfl = left front low etc...
    BFDecode1.ar(w, x, y, z,
        [-0.25pi, 0.25pi, 0.75pi, 1.25pi,-0.25pi, 0.25pi, 0.75pi, 1.25pi],
        [0.25pi,0.25pi,0.25pi,0.25pi,-0.25pi,-0.25pi,-0.25pi,-0.25pi,]);

}.scope(8);
)
//:
// .ar1 method
(
{
    var w, x, y, z, p;

    p = PinkNoise.ar(1) * LFSaw.kr(2, pi, -0.2, 0.2); // source

    // B-format encode
    #w, x, y, z = BFEncode1.ar(p, MouseX.kr(-0.5pi, 0.5pi), 0, 1);

    // B-format decode to stereo with speakers at different distances
    BFDecode1.ar1(w, x, y, z, [-0.25pi, 0.25pi], 0, 10, [MouseY.kr(5, 10), 10]);

}.scope(2);
)