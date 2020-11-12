package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function rgb2lab(rgb : Vector.<Number>) : Vector.<Number> {
	rgb.length = 3;
	rgb = numCheck(rgb, 0, 255);

	/*var
	r : Number = rgb[0] / 255.000,
	g : Number = rgb[1] / 255.000,
	b : Number = rgb[2] / 255.000;
	r = r > 0.04045 ? Math.pow(( r + 0.055 ) / 1.055, 2.4) : r / 12.92;
	g = g > 0.04045 ? Math.pow(( g + 0.055 ) / 1.055, 2.4) : g / 12.92;
	b = b > 0.04045 ? Math.pow(( b + 0.055 ) / 1.055, 2.4) : b / 12.92;
	var
	X : Number = r * 0.436052025 + g * 0.385081593 + b * 0.143087414,
	Y : Number = r * 0.222491598 + g * 0.716886060 + b * 0.060621486,
	Z : Number = r * 0.013929122 + g * 0.097097002 + b * 0.714185470;
	X = X * 100.000;
	Y = Y * 100.000;
	Z = Z * 100.000;
	var
	ref_X : Number = 96.4221,
	ref_Y : Number = 100.000,
	ref_Z : Number = 82.5211;
	X = X / ref_X;
	Y = Y / ref_Y;
	Z = Z / ref_Z;
	X = X > 0.008856 ? Math.pow(X, 1 / 3.000) : ( 7.787 * X ) + ( 16 / 116.000 );
	Y = Y > 0.008856 ? Math.pow(Y, 1 / 3.000) : ( 7.787 * Y ) + ( 16 / 116.000 );
	Z = Z > 0.008856 ? Math.pow(Z, 1 / 3.000) : ( 7.787 * Z ) + ( 16 / 116.000 );

	var
	lab_L : Number = ( 116.000 * Y ) - 16.000,
	lab_A : Number = 500.000 * ( X - Y ),
	lab_B : Number = 200.000 * ( Y - Z );

	return Vector.<Number>([lab_L, lab_A, lab_B]);*/

	var
	r : Number = rgb[0] / 255,
	g : Number = rgb[1] / 255,
	b : Number = rgb[2] / 255,
	x : Number,y : Number,z : Number;

	r = (r > 0.04045) ? Math.pow((r + 0.055) / 1.055, 2.4) : r / 12.92;
	g = (g > 0.04045) ? Math.pow((g + 0.055) / 1.055, 2.4) : g / 12.92;
	b = (b > 0.04045) ? Math.pow((b + 0.055) / 1.055, 2.4) : b / 12.92;

	x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047;
	y = (r * 0.2126 + g * 0.7152 + b * 0.0722);
	z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883;

	x = (x > 0.008856) ? Math.pow(x, 1 / 3) : (7.787 * x) + 16 / 116;
	y = (y > 0.008856) ? Math.pow(y, 1 / 3) : (7.787 * y) + 16 / 116;
	z = (z > 0.008856) ? Math.pow(z, 1 / 3) : (7.787 * z) + 16 / 116;

	return Vector.<Number>([(116 * y) - 16, 500 * (x - y), 200 * (y - z)]);
}
}