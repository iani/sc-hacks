/*  4 Dec 2018 20:45
	From:

	https://www.jcms.org.uk/article/id/525/

	... there is no reason why it should ever stop”: Large-scale algorithmic composition
	Nick Collins

*/
//:the algorithm

// Content is licensed under a Creative Commons Attibution 4.0 license
// by the University of Huddersfield Press, 2018. Article published 26/11/2018

var lastnote, chooseduration, nextnote, nextdur;

lastnote = [0,1,3,5,6,7,8].choose;
notes = List[[-1, 3], [lastnote, 1]];
barpos = 0;
chooseduration = {
	nextdur = 10.rand;
	if(nextdur<7) {
		nextdur = [1,1,1.5,2,4,0.5,0.5].at(nextdur)
	}{
		nextdur = 4.0 - ( barpos % 4.0 );
	};
	barpos = barpos + nextdur;
	nextdur;
};
//original creates 50 notes, but requiring short-term memory constraint here

while {
	notes.size < 36;
}{
	var test = true;
	while {
		test
	}{
		nextnote = rrand(0,9);
		if( abs(nextnote - lastnote) < 6 ) {
			test = false;
		};
	};
	notes.add([nextnote, chooseduration.()]);
	{
		if ( nextnote == 0 ) {
			nextnote = rrand(1,2);
			notes.add([nextnote,chooseduration.()]);
		};
		if(nextnote == 9 ) {
			nextnote = 5;
			notes.add([5, chooseduration.()])
		};
		lastnote = nextnote;
	};
};
~notes = notes collect: { | note |
	if ( note[0]  != -1) { // notes == -1 become rests
		//Bb rather than B natural here
		[[1,0,2,4,5, 7,9,10,12,6].at(note[0])+60,note[1]]
	}{
		//rest
		[\,note[1]]
		};
};

~notes.postcs;
