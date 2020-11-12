package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function lab2rgb(lab : Vector.<Number>) : Vector.<Number> {
	lab.length = 3;
	var
	y : Number = (numCheck(lab[0], 0.000, 100.000) + 16.000) / 116.000,
	x : Number = numCheck(lab[1], -128.000, 127.000) / 500.000 + y,
	z : Number = y - numCheck(lab[2], -128.000, 127.000) / 200.000,
	r : Number, g : Number, b : Number;

	x = 0.95047 * ((x * x * x > 0.008856) ? x * x * x : (x - 16.000 / 116.000) / 7.787);
	y = ((y * y * y > 0.008856) ? y * y * y : (y - 16.000 / 116.000) / 7.787);
	z = 1.08883 * ((z * z * z > 0.008856) ? z * z * z : (z - 16.000 / 116.000) / 7.787);

	r = x * 3.2406 + y * -1.5372 + z * -0.4986;
	g = x * -0.9689 + y * 1.8758 + z * 0.0415;
	b = x * 0.0557 + y * -0.2040 + z * 1.0570;

	r = (r > 0.0031308) ? (1.055 * Math.pow(r, 1.000 / 2.400) - 0.055) : 12.920 * r;
	g = (g > 0.0031308) ? (1.055 * Math.pow(g, 1.000 / 2.400) - 0.055) : 12.920 * g;
	b = (b > 0.0031308) ? (1.055 * Math.pow(b, 1.000 / 2.400) - 0.055) : 12.920 * b;

	return Vector.<Number>([Math.max(0, Math.min(1, r)) * 255, Math.max(0, Math.min(1, g)) * 255, Math.max(0, Math.min(1, b)) * 255]);
}
}