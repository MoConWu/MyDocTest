package darkMoonUI.assets.functions.colors {
import darkMoonUI.assets.functions.numCheck;

public function hex2rgb(hex : Object) : Vector.<Number> {
	var r : Number, g : Number, b : Number;
	hex = numCheck(uint(hex), 0, uint(0xFFFFFF));
	var hexs : String = uint(hex).toString(16);
	do {
		if (hexs.length >= 6) {
			break;
		}
		hexs = "0" + hexs;
	} while (true);
	r = uint("0x" + hexs.slice(0, 2));
	g = uint("0x" + hexs.slice(2, 4));
	b = uint("0x" + hexs.slice(4, 6));
	return Vector.<Number>([r, g, b]);
}
}