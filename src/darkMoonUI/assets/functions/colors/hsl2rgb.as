package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function hsl2rgb(hsl : Vector.<Number>) : Vector.<Number> {
	// 输入的h范围为[0,360],s,l为百分比形式的数值,范围是[0,100]
	// 输出r,g,b范围为[0,255],可根据需求做相应调整
	hsl.length = 3;
	var
	h : Number = numCheck(hsl[0], 0, 360) / 360,
	s : Number = numCheck(hsl[1], 0, 100) / 100,
	l : Number = numCheck(hsl[2], 0, 100) / 100;
	var rgb : Array = [];
	if (s == 0) {
		rgb = [Math.round(l * 255), Math.round(l * 255), Math.round(l * 255)];
	} else {
		var q : Number = l >= 0.5 ? (l + s - l * s) : (l * (1 + s));
		var p : Number = 2 * l - q;
		for (var i : uint = 0; i < rgb.length; i++) {
			var tc : Number = rgb[i];
			if (tc < 0) {
				tc = tc + 1;
			} else if (tc > 1) {
				tc = tc - 1;
			}
			switch (true) {
				case (tc < (1 / 6)):
					tc = p + (q - p) * 6 * tc;
					break;
				case ((1 / 6) <= tc && tc < 0.5):
					tc = q;
					break;
				case (0.5 <= tc && tc < (2 / 3)):
					tc = p + (q - p) * (4 - 6 * tc);
					break;
				default:
					tc = p;
					break;
			}
			rgb[i] = Math.round(tc * 255);
		}
	}

	return Vector.<Number>(rgb);
}
}