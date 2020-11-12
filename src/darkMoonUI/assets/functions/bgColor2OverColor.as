package darkMoonUI.assets.functions {
import darkMoonUI.assets.functions.colors.hsv2rgb;
import darkMoonUI.assets.functions.colors.rgb2hex;
import darkMoonUI.assets.functions.colors.hex2rgb;
import darkMoonUI.assets.functions.colors.rgb2hsv;

/** @private */
public function bgColor2OverColor(col : uint) : uint {
	var hsv : Vector.<Number> = rgb2hsv(hex2rgb(col));
	var num : uint = 12;
	if (hsv[2] <= 10 || hsv[2] > 50 && hsv[2] < 90) {
		hsv[2] += num;
	} else {
		hsv[2] -= num;
	}
	return int(rgb2hex(hsv2rgb(hsv)));
}
}