package darkMoonUI.assets.functions {
import flash.text.TextFormat;
import flash.text.TextField;
/**
 * @author moconwu
 */
public function getStringLength(str:String,size:uint=12,font:String="Microsoft YaHei") : uint {
	var tt:TextField = new TextField();
	var tf:TextFormat = new TextFormat();
	tf.size = size;
	tf.font = font;
	tt.setTextFormat(tf);
	tt.multiline = tt.selectable = tt.wordWrap = false;
	tt.text = str;
	tt.height = 24;
	tt.autoSize = "left";
	return Math.ceil(tt.width)*1.5;
}
}