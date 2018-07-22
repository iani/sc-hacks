/* 21 Jul 2018 08:26
Create gui from snippet text
select snippet from list of snippets, type return to evaluate snippet.
*/

//:test1
Document.current.path;
//:test2
var lines, snippets;
lines = File.readAllString (Document.current.path;).split($
);
// lines collect: { | l | "^//:" matchRegexp: l }
lines do: { | l |
	if ("^//:" matchRegexp: l) {
		snippets = snippets add: (
			name: l[3..],
			code: ""
		);
	}{
		var snippet, code;
		snippet = (snippets ? []).last ?? { (name: "-", code: "")};
		code = snippet[\code];
		snippet[\code] = code ++ l ++ "\n";
	}
};
snippets.last;
//:test3
Snippet.readAll(Document.current.path) do: { | s | s.code.postln; };
//:test4
SnippetList(Document.current.path).all  do: { | s | s.name.postln; };
//:test4
SnippetList(Document.current.path).gui;
//:the end