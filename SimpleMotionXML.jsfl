var dom = fl.getDocumentDOM();
var tl = dom.getTimeline();
var tLayer = tl.layers[0];
var frame;
var layout = <motion/>;

for( var i = 0; i < tLayer.frames.length; i++ )
{
	tl.setSelectedFrames(0,i+1,0);
	frame = tLayer.frames[1]; 
	var el = frame.elements[0];	
	layout.appendChild(<element />);
	layout.element[i].@frame = i;	
	layout.element[i].@x = el.x;
	layout.element[i].@y = el.y;
}

fl.clipCopyString(layout);