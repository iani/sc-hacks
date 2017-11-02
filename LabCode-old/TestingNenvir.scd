/*
Test how Nenvir is pushed when made from a symbol.
*/

currentEnvironment;
//:
~a = 10;
//:
currentEnvironment;
//:
\new.asEnvironment;
//:
~a = ~a * 10;
//:
\old.asEnvironment;

push