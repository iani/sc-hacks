// 13 Oct 2017 09:21
w = Window();
ListView(w.view, Rect(0, 0, 100, 200))
.focusColor_(Color(0.2, 0.2, 0.2))
.canFocus_(true);
ListView(w.view, Rect(150, 50, 100, 200))
.focusColor_(  Color(0.2, 0.2, 0.2))
.canFocus_(true)
.focus(true);
w.front;


