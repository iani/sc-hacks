//:
Env([60, 67, 64, 65].midicps.dup(3).flat ++ [100], 0.1 ! 13, [\lin, \sine, 3].stutter(4) ++ [\lin]).plot;