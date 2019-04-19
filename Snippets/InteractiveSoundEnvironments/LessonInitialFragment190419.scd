// Starting point: R. Llull, Atlas Eclipticalis
/* Requirements:
- API for acquiring data from locative services
in real time.
Example: Weather station data.
Data.com

Assignment: Find url describing the API
If possible: Find library using the API
Hint: Hight probability it already exists on github.com

*/
/*
Parallel constructive approach: 
Build a model that you can run with fake data.

*/
//:Designing the Model
/*
Prerequisites: What is the form of the domain of the data?

Simple start: Array of xyt (spherical+time) coordinates followed by measuremet data.

Prototype:
*/
a = [
//  x,   y,   t-seconds, value1, value2
	[0.1, 0.5, 1.2345,   100,    100]
	[0.1, 0.5, 2.2345,   100,    100]
	[0.1, 0.5, 2.5345,   100,    100]
];
// PS: See website of Chris Chafe at CCRMA, Stanford