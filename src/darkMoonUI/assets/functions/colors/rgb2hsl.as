package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function rgb2hsl(rgb : Vector.<Number>) : Vector.<Number> {
	// r,g,b范围为[0,255],转换成h范围为[0,360]
	// s,l为百分比形式，范围是[0,100],可根据需求做相应调整
	rgb.length = 3;
	rgb = numCheck(rgb, 0, 255);
	var
	r : Number = rgb[0] / 255,
	g : Number = rgb[1] / 255,
	b : Number = rgb[2] / 255,
	h : Number, s : Number, l : Number;

	var min : Number = Math.min(r, g, b);
	var max : Number = Math.max(r, g, b);
	l = (min + max) / 2;
	var difference : Number = max - min;
	if (max == min) {
		h = 0;
		s = 0;
	} else {
		s = l > 0.5 ? difference / (2.0 - max - min) : difference / (max + min);
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
	s = Math.round(s * 100);
	l = Math.round(l * 100);
	return Vector.<Number>([h, s, l]);
}
}