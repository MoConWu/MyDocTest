package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function rgb2hsv(rgb : Vector.<Number>) : Vector.<Number> {
	// r,g,b范围为[0,255],转换成h范围为[0,360]
	// s,v为百分比形式，范围是[0,100],可根据需求做相应调整
	rgb.length = 3;
	rgb = numCheck(rgb, 0, 255);
	var
	r : Number = rgb[0] / 255,
	g : Number = rgb[1] / 255,
	b : Number = rgb[2] / 255,
	h : Number, s : Number, v : Number;
	var min : Number = Math.min(r, g, b);
	var max : Number = v = Math.max(r, g, b);
	var difference : Number = max - min;
	if (max == min) {
		h = 0;
	} else {
		switch (max) {
			case r:
				h = (g - b) / difference + (g < b ? 6 : 0);
				break;
			case g:
				h = 2.0 + (b - r) / difference;
				break;
			case b:
				h = 4.0 + (r - g) / difference;
				break;
		}
		h = Math.round(h * 60);
	}
	if (max == 0) {
		s = 0;
	} else {
		s = 1 - min / max;
	}
	s = Math.round(s * 100);
	v = Math.round(v * 100);
	return Vector.<Number>([h, s, v]);
}
}