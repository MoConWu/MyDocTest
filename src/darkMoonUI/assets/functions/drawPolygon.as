package darkMoonUI.assets.functions {
import flash.geom.Point;
import flash.display.Graphics;

public function drawPolygon(grap : Graphics, verticies : Vector.<Point>, color : uint = 0,lineColor:int = -1, lineThickness : uint = 0) : void {
	grap.clear();
	if (lineColor != -1) {
		grap.lineStyle(lineThickness, lineColor, 1, true);
		for(var i : uint = 0; i < verticies.length; i++){
			var p : Point = verticies[i];
			grap.lineTo(p.x, p.y);
		}
		p = verticies[0];
		grap.lineTo(p.x, p.y);
	}
	grap.beginFill(color);
	var v : Vector.<Point> = new Vector.<Point>();
	for (i = 0; i < verticies.length; i++) {
		v.push(verticies[i]);
	}
	p = v.shift();
	grap.moveTo(p.x, p.y);
	for (i = 0; i < verticies.length; i++) {
		p = verticies[i];
		grap.lineTo(p.x, p.y);
	}
	grap.endFill();
}
}