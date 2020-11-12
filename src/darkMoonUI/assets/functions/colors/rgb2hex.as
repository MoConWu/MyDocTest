package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function rgb2hex(rgb : Vector.<Number>) : Object {
	// R,G,B 0~255
	rgb.length = 3;
	rgb = numCheck(rgb, 0, 255);
	var
	r : Number = rgb[0],
	g : Number = rgb[1],
	b : Number = rgb[2];
	function col2String(col : Number) : String {
		var cols : String = uint(col).toString(16);
		if (cols.length < 2) {
			cols = "0" + cols;
		}
		return cols;
	}
	var Rs : String = col2String(r);
	var Gs : String = col2String(g);
	var Bs : String = col2String(b);
	return "0x" + Rs + Gs + Bs;
}
}