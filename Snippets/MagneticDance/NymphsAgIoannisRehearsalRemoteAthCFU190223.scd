
//:
Nymphs.getClients;
//:
Nymphs.ips;
//:
p = LocalPi('/pi1');
//:
'/pi1'.envir;
//:
{ SinOsc.ar(\ax.kr(400), 0, 0.1) } +> '/pi1';
//:Nikos' pi = '/pi3'
p = RemotePi('/pi3');
//:
'/pi3'.envir;
//:
{ SinOsc.ar(\ax.kr(400), 0, 0.1) } +> '/pi3';