package darkMoonUI.assets {
import flash.display.Shape;
import flash.text.TextField;
import flash.display.Sprite;

import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.functions.fill;

/** @private */
public class BoxHeadItem extends Sprite {
	public var ID : int = new int();
	public var reSort : Boolean = true;
	private var _label : TextField = new TextField();
	private var _sz : Array = [100, 25];
	private const _type : String = "box_headItem";

	public function BoxHeadItem() : void {
		_label.setTextFormat(setTF(textColorArr[1], "", true));
		_label.selectable = _label.multiline = _label.wordWrap = false;
		_label.y = 2;
		addChild(_label);
	}

	public function get label() : String {
		return _label.text;
	}

	public function set label(str : String) : void {
		_label.text = str;
		_label.setTextFormat(setTF(textColorArr[1], "", true));
		_label.height = _sz[1] - 2;
	}

	public function get type() : String {
		return _type;
	}

	public function get size() : Array {
		return _sz;
	}

	public function set size(sz : Array) : void {
		var w : Number = Number(sz[0]) ? Number(sz[0]) : _sz[0];
		var h : Number = Number(sz[1]) ? Number(sz[1]) : _sz[1];
		_sz[0] = w;
		_sz[1] = h;
		_label.width = w;
		_label.height = h;
		fill(this.graphics, w, h, bgColorArr[3], bgColorArr[1]);
	}
}
}