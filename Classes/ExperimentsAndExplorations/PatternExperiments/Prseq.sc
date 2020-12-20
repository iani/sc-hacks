//: 20 Dec 2020 09:36
/* A Pseq that traverses its list in reverse order.
Note: This is possible with Pseq when inval has key 'reverse' set to true.
However, this is not practical for sequencing Pseqs because one would have
to decide when to set 'reverse' to false or true depending on the length
of the pseq.  e.g.:

Pseq([Pseq((1..5), 2), Pseq((1..5))]);

To reverse the second nest Pseq inside the above Pseq, one would have to play it in a Pbind, which includes the key \reverse(Pseq([Pn(\false, 10), Pn(\true, 5)]))

Note 2: The code is just the reverse branch from the implementation of Pseq 

Prseq((1..5), inf).asStream.nextN(10);

*/

Prseq : Pseq {
	embedInStream {  arg inval;
		var item, offsetValue;
		offsetValue = offset.value(inval);
		repeats.value(inval).do({ arg j;
				list.size.reverseDo({ arg i;
					item = list.wrapAt(i + offsetValue);
					inval = item.embedInStream(inval);
				});
			});
		^inval;
	}
}

/* TODO:
Define Pseq2 (or Pser2) with an additional argument 'step', which enables one to play the Pseq's list at different speeds by skipping elements, or in reverse order.

Would it be better to make this a subclass of Pser?

*/