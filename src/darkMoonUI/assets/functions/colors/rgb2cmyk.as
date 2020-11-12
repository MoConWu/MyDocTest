package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function rgb2cmyk(rgb : Vector.<Number>) : Vector.<Number> {
	rgb.length = 3;
	rgb = numCheck(rgb, 0, 255);
	var
	c : Number,m : Number,y : Number,k : Number,
	r : Number = rgb[0] / 255,
	g : Number = rgb[1] / 255,
	b : Number = rgb[2] / 255;

	k = Math.min(1 - r, 1 - g, 1 - b);
	var k1:Number = k==1?0.9999:k;
	c = ( 1 - r - k ) / ( 1 - k1 );
	m = ( 1 - g - k ) / ( 1 - k1 );
	y = ( 1 - b - k ) / ( 1 - k1 );

	c = Math.round(c * 100);
	m = Math.round(m * 100);
	y = Math.round(y * 100);
	k = Math.round(k * 100);

	return Vector.<Number>([c, m, y, k]);
}
}