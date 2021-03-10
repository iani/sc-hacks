
//:
(
c = ConditionTimeout(1);
{
	c.hang(5); // continue when unhang is called, or after 5 seconds
	"I woke up".postln;
}.fork;
{ c.unhang }.defer(1); // continue after 1 second
)
//:
c.unhang;