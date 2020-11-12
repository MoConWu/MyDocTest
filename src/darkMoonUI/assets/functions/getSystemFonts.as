package darkMoonUI.assets.functions {
import flash.text.Font;
/**
 * @author moconwu
 */
public function getSystemFonts() : Array {
	var fontArr : Array = [];
	var arr : Array = Font.enumerateFonts(true);
	arr.sortOn("fontName", Array.CASEINSENSITIVE);

	for (var k : uint = 0; k < arr.length; k++) {
		var str : String = (arr[k] as Font).fontName;
		fontArr.push(str);
	}
	return fontArr;
}
}