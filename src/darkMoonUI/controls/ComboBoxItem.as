package darkMoonUI.controls {
import darkMoonUI.types.ControlItemType;

import flash.display.Bitmap;
import flash.filesystem.File;

/**
 * @author moconwu
 */
public class ComboBoxItem extends Object {
	public var value : *;
	public var label : String = "";
	public var font : String;
	public var fontSize : uint = 12;
	public var fontColor : Object;
	public var italic : Boolean = false;
	public var wordWrap : Boolean = false;
	public var bold : Boolean = false;
	public var icon : Bitmap;
	public var url : String;
	public var file : File;
	private var _id : int = -1;
	private static const _type : String = ControlItemType.COMBO_BOX_ITEM;

	public function ComboBoxItem(lab:String = null, val:* = null):void{
		label = lab;
		value = val;
	}

	public function copy() : ComboBoxItem {
		var newItem : ComboBoxItem = new ComboBoxItem();
		newItem.value = value;
		newItem.label = label;
		newItem.font = font;
		newItem.fontSize = fontSize;
		newItem.fontColor = fontColor;
		newItem.wordWrap = wordWrap;
		newItem.bold = bold;
		newItem.icon = icon;
		newItem.url = url;
		newItem.file = file;
		newItem.italic = italic;
		return newItem;
	}

	internal function setId(i : int) : void {
		_id = i;
	}

	public function get id() : int {
		return _id;
	}

	public static function get type() : String {
		return _type;
	}
}
}
