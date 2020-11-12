package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function cmyk2rgb(cmyk : Vector.<Number>) : Vector.<Number> {
	cmyk.length = 4;
	cmyk = numCheck(cmyk, 0, 100);
	var
	r : Number,g : Number,b : Number,
	c : Number = cmyk[0] / 100,
	m : Number = cmyk[1] / 100,
	y : Number = cmyk[2] / 100,
	k : Number = cmyk[3] / 100;

	r = 1 - Math.min(1, c * ( 1 - k ) + k);
	g = 1 - Math.min(1, m * ( 1 - k ) + k);
	b = 1 - Math.min(1, y * ( 1 - k ) + k);

	r = Math.round(r * 255);
	g = Math.round(g * 255);
	b = Math.round(b * 255);

	return Vector.<Number>([r, g, b]);
}
}