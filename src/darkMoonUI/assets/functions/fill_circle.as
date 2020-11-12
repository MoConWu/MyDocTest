package darkMoonUI.assets.functions {
import flash.display.Graphics;

public function fill_circle(grp : Graphics, sz : uint = 10, color : uint = 0x000000, x : int = 0, y : int = 0) : void {
	grp.clear();
	grp.beginFill(color);
	grp.drawCircle(x, y, sz);
	grp.endFill();
}
}