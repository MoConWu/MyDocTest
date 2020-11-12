package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function hsv2rgb(hsv : Vector.<Number>) : Vector.<Number> {
	// 输入的h范围为[0,360],s,l为百分比形式的数值,范围是[0,100]
	// 输出r,g,b范围为[0,255],可根据需求做相应调整
	hsv.length = 3;
	var
	h : Number = numCheck(hsv[0], 0, 360),
	s : Number = numCheck(hsv[1], 0, 100) / 100,
	v : Number = numCheck(hsv[2], 0, 100) / 100,
	r : Number, g : Number, b : Number;
	h = h==360?0:h;
	var h1 : Number = Math.floor(h / 60) % 6;
	var f : Number = h / 60 - h1;
	var p : Number = v * (1 - s);
	var q : Number = v * (1 - f * s);
	var t : Number = v * (1 - (1 - f) * s);
	switch (h1) {
		case 0:
			r = v;
			g = t;
			b = p;
			break;
		case 1:
			r = q;
			g = v;
			b = p;
			break;
		case 2:
			r = p;
			g = v;
			b = t;
			break;
		case 3:
			r = p;
			g = q;
			b = v;
			break;
		case 4:
			r = t;
			g = p;
			b = v;
			break;
		case 5:
			r = v;
			g = p;
			b = q;
			break;
	}
	return Vector.<Number>([Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)]);
}
}