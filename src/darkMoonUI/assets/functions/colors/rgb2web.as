package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function rgb2web(rgb : Vector.<Number>) : Vector.<Number> {
	rgb.length = 3;
	rgb = numCheck(rgb, 0, 255);
	for (var i : uint = 0; i < 3; i++) {
		rgb[i] = Math.round(rgb[i] / 51) * 51;
	}
	return rgb;
}
}