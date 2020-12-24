//: 24 Dec 2020 04:10
/* 

*/
//:
\test.listView;
{ 
   loop {
   10 do: { | i |
	i.postln;
	1.wait;
	\test.items = (i..(i+ 5 + i)).squared.postln;
	2.wait;
   }
	}
}.fork
