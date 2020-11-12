package darkMoonUI.assets.functions {
import flash.text.TextFormat;

/** @private */
public function setTF(col : uint, al : String = "", bl : Boolean = false, sz:uint = 12) : TextFormat {
	var tf : TextFormat = new TextFormat();
		if (al != "") {
			tf.align = al;
		}
		tf.size = sz;
		tf.color = col;
		tf.bold = bl;
		tf.font = "Microsoft YaHei";
		return tf;
}
}