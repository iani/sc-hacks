//:setup sensors
BusOsc.watch1(\kumano, '/minibee/data',
	[\x1, 1, 0.47, 0.53, 1],
	[\y1, 2, 0.47, 0.53, 1],
	[\z1, 3, 0.47, 0.53, 1],
	[\x2, 1, 0.47, 0.53, 2],
	[\y2, 2, 0.47, 0.53, 2],
	[\z2, 3, 0.47, 0.53, 2],
	[\x3, 1, 0.47, 0.53, 3],
	[\y3, 2, 0.47, 0.53, 3],
	[\z3, 3, 0.47, 0.53, 3],
	[\x4, 1, 0.47, 0.53, 4],
	[\y4, 2, 0.47, 0.53, 4],
	[\z4, 3, 0.47, 0.53, 4]
);
//:
{ \kumano.window.bounds = \kumano.window.bounds.moveBy(0, 100); }.defer(0.2);
// { \kumano.wshift(0, 100); }.defer(0.1);
//:================ fx controls
\volumes.v(
	\srcvol.slider([0, 10], \fx1, "fx1 src"),
	\fxvol.slider([0, 10], \fx1, "fx1 fx"),
	\thresh.slider([0.00001, 0.5, \exp], \fx1, "fx1 thresh"),
	\srcvol.slider([0, 10], \fx2, "fx2 src"),
	\fxvol.slider([0, 10], \fx2, "fx2 fx"),
	\thresh.slider([0.00001, 0.5, \exp], \fx2, "fx2 thresh"),
);
//:
// { \volumes.wshift(0, 100); }.defer(0.1);
{ \volumes.window.bounds = \volumes.window.bounds.moveBy(0, 100); }.defer(0.2);
//:================ initialize fx config
\p1 *> \fx1; // player - fx setup
\p2 *> \fx2;
\p3 *> \fx3;
\p4 *> \fx4;
\srcvol <+.fx1 0; // listen to fx - not source
\fxvol <+.fx1  3;
\srcvol <+.fx3 0; // listen to fx - not source
\fxvol <+.fx3 3;
\srcvol <+.fx2 0;
\fxvol <+.fx2 1.5; // jun needs larger amplitude
// fadeTime for fx: Smooth transitions when switching fx synths
\fadeTime <+.fx1 2;
\fadeTime <+.fx2 2;
\fadeTime <+.fx3 2;
\fadeTime <+.fx4 2;
