/* 24 Dec 2019 14:44
Snippets adapted for use with EMACSDocuments.
*/

ESnippets {
	classvar <all;
	var <snippets;

	*fromEmacsDoc {
		var snippets, currentSnippetIndex = 0, esnippets;
		Document.current.thisdoc.string(returnFunc: { | string |
			// string.findAllRegexp("^//:").postln;
			Emacs.evalLispExpression(['point'].asLispString, { | point |
				var separators;
				postf("the text is % chars big.  You are at char no %\n",
					string.size,
					point
				);
				separators = string.findAllRegexp("^//:");
				if(separators[0] != 0) { separators = [0] ++ separators };
				separators do: { | s, i |
					if (point >= s) { currentSnippetIndex = i };
				};
				postf("current point % is at snippet no %\n", point,
					currentSnippetIndex);
				postf("snippet start: %, snippet end: %\n\n\n",
					separators[currentSnippetIndex],
					separators[currentSnippetIndex + 1] ?? { string.size }
				);
				"the snippet is:".postln;
				string.copyRange(separators[currentSnippetIndex],
					separators[currentSnippetIndex + 1] ?? { string.size }
				).postln;
				separators do: { | from, i |
					esnippets = esnippets.add(
						ESnippet.newCopyArgs(string.copyRange(
							from, separators[i + 1] ?? { string.size }
						));
					)
				};
				all = this.newCopyArgs(esnippets);
				this.changed(\newFromEmacs);
			})
		});
	}
}

ESnippet {
	var <string;
	
}