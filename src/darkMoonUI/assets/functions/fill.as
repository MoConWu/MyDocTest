package darkMoonUI.assets.functions {
import flash.display.Graphics;

public function fill(grap : Graphics, w : uint = 10, h : uint = 10, bgColor : int = 0, lineColor : int = -1, lineThickness : uint = 0, clear : Boolean = true) : void {
	if(clear){
		grap.clear();
	}
	if (bgColor != -1) {
		grap.beginFill(bgColor);
		grap.drawRect(0, 0, w, h);
		grap.endFill();
	}
	if (lineColor != -1) {
		grap.lineStyle(lineThickness, lineColor, 1, true);
		grap.lineTo(0, 0);
		grap.lineTo(w, 0);
		grap.lineTo(w, h);
		grap.lineTo(0, h);
		grap.lineTo(0, 0);
	}
}
}