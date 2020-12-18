//  6 Oct 2017 11:47
// Prepare adding specs to Nevents
\default.ev.put_(\specs, \rq, [0.01, 1, \exp, 0, 0.2].asSpec);
//:
\default.ev.get_(\specs, \rq);
//:
\default.ev.getSpec(\freq);
//:
\default.ev.getSpec(\ringTime);
//:
\default.ev.getSpec(\test_error);
//:
ControlSpec.specs.keys;
\unipolar.asSpec;
//:
ControlSpec.specs[\freq]
//:
