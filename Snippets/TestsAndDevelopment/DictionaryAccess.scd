//:Answering question by Giuseppe Suadoni in SuperCollider FB group
/*
8 Sep 2019 18:23

Unexpected (that is: by me) behaviour.
I generate this simple dictionary: keys are strings in the form "qq"++(a number between 0 and 9)++(another number between 0 and 9)
The keys are assigned to integers, which are the product of the two numbers, so:
qq23 -> 6
qq78 -> 56
and so on.
When accessing the keys, the form
qq["qq"++(i*10+j)].value
isn't the same as
qq["qq"++i++j].value
in that the first returns results as expected (that is: by me), but the second returns nil for keys of the form qq0x
lots of words, but code is self-explanatory:
(
var qq = Dictionary.new;
9.do{|i| 9.do{|j| qq.add("qq"++(i*10+j) -> (i*j)) } };  // from qq00 to qq88

"one at random:".postln;
i = 9.rand; j = 9.rand;
("qq"++i++j++": ").postln;
qq["qq"++(i*10+j)].value.postln;  // everything as expected (that is: by me)
qq["qq"++i++j].value.postln;      // qq30 is 0, but qq03 is nil
)
*/
//:Original Code by Suadoni:
(
var qq = Dictionary.new;
9.do{|i| 9.do{|j| qq.add("qq"++(i*10+j) -> (i*j)) } };  // from qq00 to qq88

"one at random:".postln;
i = 9.rand; j = 9.rand;
("qq"++i++j++": ").postln;
qq["qq"++(i*10+j)].value.postln;  // everything as expected (that is: by me)
qq["qq"++i++j].value.postln;      // qq30 is 0, but qq03 is nil
)
//:Using symbols as keys
(
var qq = Dictionary.new;
9.do{|i| 9.do{|j| qq[("qq"++ i ++ j).asSymbol] = (i*j); }};  // from qq00 to qq88

qq[("qq"++0++3).asSymbol.postln].value.postln;      // qq30 is 0, but qq03 is nil

"\n Testing 0 series \n".postln;

(0..8) do: { | i |
i = format("qq0%", i).asSymbol;
postf("qq at % is %\n", i, qq[i]);
};

"\n Testing 5 series \n".postln;
(0..8) do: { | i |
i = format("qq5%", i).asSymbol;
postf("qq at % is %\n", i, qq[i]);
};
)
//:

