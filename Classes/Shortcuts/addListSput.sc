/*  6 Dec 2020 10:23
Safely put an element at an index in a list.
Grow the list if needed to ensure that the index is within its size.

a = List().sput(1, 10);

a.sput(0, 100);
a.sput(5, 55);
a.sput(3, 21);


a = List();
b = a.array;
b.size;
c = b.growClear(1);
c.put(0, \ex)
*/

+ List {
	sput { | index, element |
		array = array.growClear(index + 1 - array.size max: 0);
		array.put(index, element);
	}
}