(
~drawCogs= {|radius= 100, numCogs= 7, outer= 0.8, inner= 0.6, center= 0.3,
	cogOutsideShape= #[-0.2, 0.2], cogInsideShape= #[-0.1, 0.1], offset= 0|
	var cogs= [
		Point(1, cogOutsideShape[0])*outer,
		Point(1, cogOutsideShape[1])*outer,
		Point(1, cogInsideShape[0])*inner,
		Point(1, cogInsideShape[1])*inner
	]*radius;
	Pen.strokeOval(Rect.aboutPoint(Point(0, 0), center*radius, center*radius));
	numCogs.do{
		Pen.moveTo(cogs[0]);
		Pen.lineTo(cogs[1]);
		cogs= cogs.collect{|p| p.rotate(pi/numCogs+offset)};
		Pen.lineTo(cogs[2]);
		Pen.lineTo(cogs[3]);
		cogs= cogs.collect{|p| p.rotate(pi/numCogs+offset)};
		Pen.lineTo(cogs[0]);
		Pen.lineTo(cogs[1]);
		Pen.stroke;
	};
};
)
//:

//--used as a button 'settings' icon
(
var size= Size(22, 22);
var button;
Window().front.view.layout_(
	StackLayout(
		UserView().drawFunc_{|usr|
			Pen.strokeColor= Color.black;
			Pen.width= 1;
			Pen.translate(size.width/2, size.height/2);
			~drawCogs.value(size.height/2, 8);
		}.acceptsMouse_(false).fixedSize_(size),
		button= Button().states_([]).fixedSize_(size)
	).mode_(\stackAll)
);
button.action= {|view|
	"bang".postln;
};
)

//:
//--explorer
(
var win= Window("cog wheel generator", Rect(100, 100, 500, 500));
var usr;
var penWidthSlider, penWidthSpec= ControlSpec(0.1, 100, 'exp', 0, 10);
var numCogsSlider, numCogsSpec= ControlSpec(0, 20, 'lin', 1, 7);
var outerSlider, outerSpec= ControlSpec(0, 1, 'lin', 0, 0.8);
var innerSlider, innerSpec= ControlSpec(0, 1, 'lin', 0, 0.6);
var centerSlider, centerSpec= ControlSpec(0, 1, 'lin', 0, 0.3);
var outsideSlider, outsideSpec= ControlSpec(-1, 1, 'lin', 0, 0.2);
var insideSlider, insideSpec= ControlSpec(-1, 1, 'lin', 0, 0.1);
var offsetSlider, offsetSpec= ControlSpec(0, 2pi, 'lin', 0, 0);
var penJoinPopup, postButton, automateButton, autoRoutine;
win.view.layout_(VLayout(
	usr= UserView().fixedSize_(win.bounds.width, win.bounds.height*0.5).background_(Color.grey(0.9)),
	HLayout(penWidthSlider= Slider().orientation_(\horizontal), StaticText().string_("penWidth")),
	HLayout(numCogsSlider= Slider().orientation_(\horizontal), StaticText().string_("numCogs")),
	HLayout(outerSlider= Slider().orientation_(\horizontal), StaticText().string_("outerRadius")),
	HLayout(innerSlider= Slider().orientation_(\horizontal), StaticText().string_("innerRadius")),
	HLayout(centerSlider= Slider().orientation_(\horizontal), StaticText().string_("centerRadius")),
	HLayout(outsideSlider= RangeSlider().orientation_(\horizontal), StaticText().string_("outsideShape")),
	HLayout(insideSlider= RangeSlider().orientation_(\horizontal), StaticText().string_("insideShape")),
	HLayout(offsetSlider= Slider().orientation_(\horizontal), StaticText().string_("offset")),
	HLayout(penJoinPopup= PopUpMenu().items_(["miter", "round", "bevel"]), StaticText().string_("penJoin")),
	HLayout(
		postButton= Button().states_([["post", Color.black]]),
		automateButton= Button().states_([["auto", Color.black], ["auto", Color.black, Color.white]])
	)
));
usr.drawFunc= {|usr|
	Pen.width= penWidthSpec.map(penWidthSlider.value);
	Pen.joinStyle= penJoinPopup.value;  //0, 1 or 2
	Pen.strokeColor= Color.black;
	Pen.translate(usr.bounds.width*0.5, usr.bounds.height*0.5);
	~drawCogs.value(
		usr.bounds.height*0.5,
		numCogsSpec.map(numCogsSlider.value),
		outerSpec.map(outerSlider.value),
		innerSpec.map(innerSlider.value),
		centerSpec.map(centerSlider.value),
		[outsideSpec.map(outsideSlider.lo), outsideSpec.map(outsideSlider.hi)],
		[insideSpec.map(insideSlider.lo), insideSpec.map(insideSlider.hi)],
		offsetSpec.map(offsetSlider.value)
	);
};
win.view.allChildren.do{|view|
	if([Slider, RangeSlider, PopUpMenu].includes(view.class), {
		view.action_{usr.refresh}.fixedWidth_(win.bounds.width*0.8);
	});
};
penJoinPopup.value= 1;
penWidthSlider.value= penWidthSpec.unmap(penWidthSpec.default);
numCogsSlider.value= numCogsSpec.unmap(numCogsSpec.default);
outerSlider.value= outerSpec.unmap(outerSpec.default);
innerSlider.value= innerSpec.unmap(innerSpec.default);
centerSlider.value= centerSpec.unmap(centerSpec.default);
outsideSlider.setSpan(*outsideSpec.unmap(outsideSpec.default*#[-1, 1]));
insideSlider.setSpan(*insideSpec.unmap(insideSpec.default*#[-1, 1]));
postButton.action= {
	"settings...".postln;
	[
		[\penJoin, penJoinPopup.value],
		[\penWidth, penWidthSpec.map(penWidthSlider.value)],
		[\numCogs, numCogsSpec.map(numCogsSlider.value)],
		[\outer, outerSpec.map(outerSlider.value)],
		[\inner, innerSpec.map(innerSlider.value)],
		[\center, centerSpec.map(centerSlider.value)],
		[\outside, outsideSpec.map([outsideSlider.lo, outsideSlider.hi])],
		[\inside, insideSpec.map([insideSlider.lo, insideSlider.hi])],
		[\offset, offsetSpec.map(offsetSlider.value)],
	].do{|x| x.postln};
};
automateButton.action= {|view|
	if(view.value==1, {
		autoRoutine= Routine({
			usr.animate= true;
			inf.do{|i|
				penWidthSlider.value= sin(i*0.01)/3+0.5;
				if(0.001.coin, {numCogsSlider.value= 1.0.linrand});
				outerSlider.value= sin(i*0.024)/3+0.5;
				innerSlider.value= sin(i*0.021)/3+0.4;
				centerSlider.value= sin(i*0.0019)/3+0.3;
				outsideSlider.setSpan(sin(i*0.0017), sin(i*0.0015));
				insideSlider.setSpan(sin(i*0.0014), sin(i*0.0013));
				60.reciprocal.wait;
			};
		}).play(AppClock);
	}, {
		usr.animate= false;
		autoRoutine.stop;
	});
};
CmdPeriod.doOnce({win.close});
win.front;
)