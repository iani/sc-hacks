//: 15 Jan 2021 13:35 Constructing Euclidean Rhythms
/* 
Implementation of algorithm proposed by Godfried Toussaint

https://en.wikipedia.org/wiki/Euclidean_rhythm
http://cgm.cs.mcgill.ca/~godfried/publications/banff.pdf

Supporting studies online with explanations on algorithm implementations:

1. https://medium.com/code-music-noise/euclidean-rhythms-391d879494df
2. https://www.computermusicdesign.com/simplest-euclidean-rhythm-algorithm-explained/
3. https://dev.to/erwald/euclidean-rhythms-and-haskell-5ecj

*/
// ================================================================
//:Bresenham's line algorithm
// https://medium.com/code-music-noise/euclidean-rhythms-391d879494df
/* // swift code: 

func bresenhamEuclidean(onsets: Int, pulses: Int) -> [Int] {
    let slope = Double(onsets) / Double(pulses)
    var result = [Int]()
    var previous: Int? = nil
    for i in 0..<pulses {
        let current = Int(floor(Double(i) * slope))
        result.append(current != previous ? 1 : 0)
        previous = current
    }
    return result
}

*/
//:Implementation 1 (plain)
\br.f = { | o = 1, p = 4 |
	//Note: in SC, the algorithm can be coded in a single line, as follows:
	(o / p * (0..p - 1)).floor.differentiate.asInteger;
	// Note 2: the if (o <= 0) statement covers the case when we want 0 beats
	// in the pattern
};
\br.f(10, 16);
//:Implementation 2 (allow o == 0, o > p)
\br.f = { | o = 1, p = 4 |
	//Note: in SC, the algorithm can be coded in a single line, as follows:
	(o / p * (0..p - 1)).floor.differentiate.asInteger.min(1)[0] = if (o <= 0) { 0 } { 1 };
	// Note 2: the if (o <= 0) statement covers the case when we want 0 beats
	// in the pattern
};
\br.f(10, 16);
//:tests
(0..12) do: { | i |
\br.f(i, 8).postln;
};

//: ================================================================
// ALL OF THE BELOW ARE INCOMPLETE. NO MORE IMPLEMENTATIONS COMPLETED SO FAR.
//: ================================================================
// FROM JAVASCRIPT IMPLEMENTATION :
// https://www.computermusicdesign.com/simplest-euclidean-rhythm-algorithm-explained/
/* original algorithm in javascript:
//calculate a euclidean rhythm
function euclid(steps,  pulses, rotation){
    storedRhythm = []; //empty array which stores the rhythm.
    //the length of the array is equal to the number of steps
    //a value of 1 for each array element indicates a pulse

    var bucket = 0; //out variable to add pulses together for each step

    //fill array with rhythm
    for( var i=0 ; i < steps ; i++){ 
        bucket += pulses; 
            if(bucket >= steps) {
            bucket -= steps;
            storedRhythm.push(1); //'1' indicates a pulse on this beat
        } else {
            storedRhythm.push(0); //'0' indicates no pulse on this beat
        }
    }
}
*/
//:Implementation of above in SC:
// Note Steps = total length of cycle. pulses = number of on-beats in cycle
\js.f = { | steps = 4, pulses = 1 |
	var cycle, bucket = 0;
	cycle = [];
	steps do: { | i |
		bucket = bucket 
	}
	
}

//:
// INCOMPLETE ================================================================
//:Bjorklund - incomplete (without the recursion)
\bjork2.f = { | onsets, pulses |
	var first;
	if (pulses.size <= 1) {
		onsets
	}{
		[onsets collect: { | o, i |
			first = pulses.first;
			pulses = pulses[1..];
			o.asArray ++ first.asArray;
			// o.asArray ++ pulses[i].asArray;
		}, pulses;
		];
	}
};
\bjork.f = { | numonsets = 1, numpulses = 4 |
	var onsets, pulses;
	onsets = 1 ! numonsets;
	pulses = (0 ! (0 max: (numpulses - numonsets)));
	// [onsets, onsets.size, pulses, pulses.size, (onsets ++ pulses).size].postln;
	\bjork2.f(onsets, pulses);
	//	onsets.postln;
	// pulses.clump(onsets.size).postln;
	// ([onsets] ++ pulses.clump(onsets.size)).postln;
	// [onsets, pulses.clump(onsets.size)];
	// ([onsets] ++ pulses.clump(onsets.size)).flop;
};
\bjork.f(3, 16);
// \bjork.f(3, 16).postln;
//:
//:tests
(0..8) do: { | i |
\bjork.f(i, 8).postln;
};
//:
a = (1..10);
//:
a.pop;
//:
a