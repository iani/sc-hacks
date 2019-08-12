/* Try executing any snippets below in any order

*/
//:preload buffers
(Hacks.homedir ++ "Sounds/lindrum/").loadBuffers;
//:list loaded buffers
(Library.at(\buffers) ? ()).keys.postln;
//:look at one buffer
Library.at(\buffers).keys.asArray.first.b.postln;
//:play one buffer
Library.at(\buffers).keys.asArray.first.b.play;
//:play all buffers
{
	Library.at(\buffers).keys.asArray do: { | k |
		k.b.postln.play;
		(k.b.numFrames / 44100 + 0.1).wait;
	};
	"DONE".postln;
}.fork;
// ================================================================
//:
"~/sounds/*.WAV".pathMatch;
//:recurse subfolders
var canRecurseP;
canRecurseP = { | p | (p +/+ "*").pathMatch.size > 0 };

"~/sounds/*".pathMatch do: { | p |
	postf("% ---- % ---- %\n", p,p.last === $/, canRecurseP.(p));
};
//:
Hacks.loadAudioFilesRecursively;
//:
ServerBoot.add({ "loading file 1".postln; }, S.default);
ServerBoot.add({ "loading file 2".postln; }, S.default);
//:alternative using Notification
// Uses modified ServerStatusWatcher::prFinalizeBoot
\ccc.addNotifier(S.default, \booted, { | n | postf("% BOOT RECEIPT\n", n.listener)});
//:Test load of folder with Hacks
Hacks.loadAudioFiles;
//:
\CB.b.play;
'001_AMENCUT_002'.b.postln.play;
'002_AMENCUT_003'.b.play;
'003_AMENCUT_004'.b.play;

'031_AMENCUT_032'.b.plot;

'031_AMENCUT_032'.b.play;

'023_AMENCUT_024'.b.play;
//:window tests - tmp
\e.window;
\x.window;
\y.window;