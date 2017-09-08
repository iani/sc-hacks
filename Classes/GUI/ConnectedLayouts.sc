/*
Create some layouts and connect their elements to an environment for updates.

 8 Jun 2017 21:57

Starting with a horizontal slider + label + numbox.
*/

CSlider {
	*new { | name, spec, envir |
		envir = envir.asEnvironment;
		if (spec.isNil) {
			spec = name.asSpec;
		}{
			spec = spec.asSpec;
		};
		^HLayout (
			StaticText ().string_ (name),
			Slider.horizontal.connectEnvir (name, envir, spec),
			NumberBox ().connectEnvir (name, envir)
		)
	}
}