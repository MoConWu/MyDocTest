package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.bgColor2OverColor;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;

import flash.display.BlendMode;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class Button extends DarkMoonUIControl implements DMUI_PUB_LABEL {
	private var
	_label : TextField = new TextField(),
	_selectedMC : Shape = new Shape(),
	_ttf : TextFormat = setTF(textColorArr[1], "center"),
	_autoSize : Boolean,
	_sz : Array = [100, 25],
	_showFocus : Boolean = true,
	_bgColor : uint = bgColorArr[1],
	_overColor : uint = 0;

	public function Button(lab:String=ControlType.BUTTON) : void {
		super();
		_type = ControlType.BUTTON;

		fill(_selectedMC.graphics, 10, 2, bgColorArr[2]);
		_label.wordWrap = _label.selectable = false;
		_label.setTextFormat(_ttf);
		_label.defaultTextFormat = _ttf;
		_selectedMC.visible = false;
		_selectedMC.blendMode = BlendMode.SCREEN;
		bgColor = _bgColor;

		mc.addChild(_label);
		mc.addChild(_selectedMC);

		create(0, 0, lab);
	}

	/** @private */
	protected override function _size_get() : Array {
		return _sz;
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _sz[0];
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _sz[1];
		_label.autoSize = TextFieldAutoSize.CENTER;
		if (_autoSize) {
			_label.width = _SizeValue[0];
			_label.height = _SizeValue[1];
			_SizeValue[0] = _label.width;
			_SizeValue[1] = _label.height;
		} else if (_label.width > _SizeValue[0] || _label.height > _SizeValue[1]) {
			_label.autoSize = TextFieldAutoSize.NONE;
		}
		_sz[0] = _selectedMC.width = _label.width = _SizeValue[0];
		_label.height = _sz[1] = _SizeValue[1];
		_selectedMC.y = _sz[1] - 2;
		_label.x = (_sz[0] - _label.width) / 2;
		_label.y = (_sz[1] - _label.height) / 2;
		fill(mc.graphics, _sz[0], _sz[1], _bgColor);
	}
	/** @private */
	protected override function _focus_in() : void {
		_selectedMC.visible = _showFocus;
	}
	/** @private */
	protected override function _focus_out() : void {
		_selectedMC.visible = false;
		_mouseOut();
	}
	/** @private */
	protected override function _mouseOver() : void {
		fill(mc.graphics, _sz[0], _sz[1], _overColor);
	}
	/** @private */
	protected override function _mouseOut() : void {
		_label.setTextFormat(_ttf);
		fill(mc.graphics, _sz[0], _sz[1], _bgColor);
	}
	/** @private */
	protected override function _mouseDown() : void {
		var f : TextFormat = _label.getTextFormat();
		f.color = textColorArr[2];
		_label.setTextFormat(f);
		fill(mc.graphics, _sz[0], _sz[1], 0);
		stage.addEventListener(MouseEvent.MOUSE_UP, UP);
	}
	/** @private */
	protected override function _mouseUp() : void {
		_label.setTextFormat(_ttf);
	}
	/** @private */
	protected override function _keyDown() : void {
		if (_KeyboardEvent.keyCode == 13) {
			fill(mc.graphics, _sz[0], _sz[1], _overColor);
		}
	}
	/** @private */
	protected override function _keyUp() : void {
		if (_KeyboardEvent.keyCode == 13) {
			fill(mc.graphics, _sz[0], _sz[1], _bgColor);
			if(onClick != null){
				onClick();
			}
		}
	}

	public function copy() : Button {
		var newDMUI : Button = new Button();
		var sz : Array = size;
		newDMUI.create(x, y, _label.text, sz[0], sz[1]);
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : int = 0, _y : int = 0, l : String=ControlType.BUTTON, w : uint = 100, h : uint = 24) : void {
		x = _x;
		y = _y;
		_sz[0] = _selectedMC.width = w;
		_sz[1] = h;
		_selectedMC.height = 2;

		_selectedMC.y = h - 2;
		_label.text = l;
		size = [w, h];
		enabled = _enabled;
	}

	private function UP(evt : MouseEvent) : void {
		fill(mc.graphics, _sz[0], _sz[1], _bgColor);
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function get font() : String {
		return _ttf.font;
	}

	public function set font(f : String) : void {
		_ttf.font = f;
		_label.setTextFormat(_ttf);
		_label.defaultTextFormat = _ttf;
		if (_autoSize) {
			size = [];
		} else {
			_SizeValue = Vector.<uint>([]);
			_size_set();
		}
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
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
		if (_autoSize) {
			size = [];
		} else {
			_SizeValue = Vector.<uint>([]);
			_size_set();
		}
	}

	public function get bold() : Boolean {
		return _ttf.bold;
	}

	public function set wordWrap(boo : Boolean) : void {
		_label.wordWrap = boo;
		if (_autoSize) {
			size = [];
		} else {
			_SizeValue = Vector.<uint>([]);
			_size_set();
		}
	}

	public function get wordWrap() : Boolean {
		return _label.wordWrap;
	}

	public function set multiline(boo : Boolean) : void {
		_label.multiline = boo;
		if (_autoSize) {
			size = [];
		} else {
			_SizeValue = Vector.<uint>([]);
			_size_set();
		}
	}

	public function get multiline() : Boolean {
		return _label.multiline;
	}

	public function get label() : String {
		return _label.text;
	}

	public function set label(str : String) : void {
		_label.text = str;
		size = [];
	}

	public function get fontSize() : uint {
		return int(_ttf.size);
	}

	public function set fontSize(sz : uint) : void {
		_ttf.size = sz;
		_label.defaultTextFormat = _ttf;
		_label.setTextFormat(_ttf);
		if (_autoSize) {
			size = [];
		} else {
			_SizeValue = Vector.<uint>([]);
			_size_set();
		}
	}

	public function set bgColor(col : Object) : void {
		_bgColor = int(col);
		fill(mc.graphics, _sz[0], _sz[1], _bgColor);
		_overColor = bgColor2OverColor(_bgColor);
	}

	public function get bgColor() : Object {
		return "0x" + uint(_bgColor).toString(16);
	}
}
}
