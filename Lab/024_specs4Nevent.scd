//  6 Oct 2017 11:47
// Prepare adding specs to Nevents
\default.e.put_(\specs, \rq, [0.01, 1, \exp, 0, 0.2].asSpec);
//:
\default.e.get_(\specs, \rq);
//:
\default.e.getSpec(\freq);
//:
\default.e.getSpec(\ringTime);
//:
\default.e.getSpec(\test_error);
//:
ControlSpec.specs.keys;
\unipolar.asSpec;
//:
ControlSpec.specs[\freq]
//:
