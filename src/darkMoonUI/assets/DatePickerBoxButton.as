package darkMoonUI.assets {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.display.Shape;
import flash.text.TextFormat;
import flash.text.TextField;

import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.fill;

/** @private */
public class DatePickerBoxButton extends Sprite {
	public var onClick : Function;
	private var
	overMC : Shape = new Shape(),
	_label : TextField = new TextField(),
	_ttf : TextFormat = setTF(textColorArr[5], "center"),
	_autoSize : Boolean = false,
	bgMC : Shape = new Shape(),
	_bgColor : uint = bgColorArr[9],
	_bgOverColor : uint = bgColorArr[6];

	public function DatePickerBoxButton() : void {
		fill(bgMC.graphics, 10, 10, _bgColor);
		fill(overMC.graphics, 10, 10, _bgOverColor);
		_label.wordWrap = overMC.visible = _label.selectable = false;
		_label.setTextFormat(_ttf);
		_label.defaultTextFormat = _ttf;

		overMC.height = bgMC.height = overMC.width = bgMC.width = 25;

		_label.text = "Label";
		size = [25, 25];

		addEventListener(MouseEvent.MOUSE_DOWN, DOWN);
		addEventListener(MouseEvent.MOUSE_UP, UP);
		addEventListener(MouseEvent.MOUSE_OVER, OVER);
		addEventListener(MouseEvent.MOUSE_OUT, OUT);

		addChild(bgMC);
		addChild(overMC);
		addChild(_label);
	}

	public function DOWN(evt : MouseEvent) : void {
		var f : TextFormat = _label.getTextFormat();
		f.color = textColorArr[3];
		_label.setTextFormat(f);
		if(onClick != null){
			onClick();
		}
	}

	public function UP(evt : MouseEvent) : void {
		_label.setTextFormat(_ttf);
	}

	public function OVER(evt : MouseEvent) : void {
		overMC.visible = true;
	}

	public function OUT(evt : MouseEvent) : void {
		_label.setTextFormat(_ttf);
		overMC.visible = false;
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function set font(f : String) : void {
		_ttf.font = f;
		_label.setTextFormat(_ttf);
		_label.defaultTextFormat = _ttf;
		size = [];
	}

	public function get size() : Array {
		return [bgMC.width, bgMC.height];
	}

	public function set size(sz : Array) : void {
		var w : uint = int(sz[0]) > 0 ? int(sz[0]) : bgMC.width;
		var h : uint = int(sz[1]) > 0 ? int(sz[1]) : bgMC.height;
		_label.autoSize = "center";
		if (_autoSize) {
			_label.width = w;
			_label.height = h;
			w = _label.width;
			h = _label.height;
		} else if (_label.width > w || _label.height > h) {
			_label.autoSize = "none";
		}
		bgMC.width = overMC.width = _label.width = w;
		_label.height = bgMC.height = overMC.height = h;

		overMC.x = bgMC.x;
		overMC.y = bgMC.y;
		//bgMC.y + bgMC.height - 2;
		_label.x = bgMC.x + (bgMC.width - _label.width) / 2;
		_label.y = bgMC.y + (bgMC.height - _label.height) / 2;
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public function set color(col : Object) : void {
		_ttf.color = col;
		_label.setTextFormat(_ttf);
		_label.defaultTextFormat = _ttf;
	}

	public function get color() : Object {
		return "0x" + uint(_ttf.color).toString(16);
	}

	public function set italic(boo : Boolean) : void {
		_ttf.italic = boo;
		_label.setTextFormat(_ttf);
		_label.defaultTextFormat = _ttf;
	}

	public function get italic() : Boolean {
		return _ttf.italic;
	}

	public function set bold(boo : Boolean) : void {
		_ttf.bold = boo;
		_label.setTextFormat(_ttf);
		_label.defaultTextFormat = _ttf;
		size = [];
	}

	public function get bold() : Boolean {
		return _ttf.bold;
	}

	public function set wordWrap(boo : Boolean) : void {
		_label.wordWrap = boo;
		size = [];
	}

	public function get wordWrap() : Boolean {
		return _label.wordWrap;
	}

	public function get label() : String {
		return _label.text;
	}

	public function set label(str : String) : void {
		_label.text = str;
		_label.autoSize = "center";
		var getH : Number = _label.height;
		if (getH > bgMC.height) {
			getH = bgMC.height;
		}
		_label.x = bgMC.x;
		_label.y = bgMC.y + (bgMC.height - getH) / 2;
		_label.width = bgMC.width;
		size = [];
	}

	public function set fontSize(sz : uint) : void {
		_ttf.size = sz;
		_label.setTextFormat(_ttf);
		size = [];
	}

	public function set bgColor(col : Object) : void {
		_bgColor = int(col);
		fill(bgMC.graphics, 10, 10, _bgColor);
	}

	public function set bgOverColor(col : Object) : void {
		_bgOverColor = int(col);
		fill(overMC.graphics, 10, 10, _bgOverColor);
	}
}
}