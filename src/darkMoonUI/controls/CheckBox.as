package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.functions.parentAddChilds;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.text.TextField;
import flash.text.TextFormat;

public class CheckBox extends DarkMoonUIControl implements DMUI_PUB_LABEL {
	public var onChange : Function;
	private var
	selMC : Shape = new Shape(),
	_label : TextField = new TextField(),
	checkedMC : Shape = new Shape(),
	_checked : Boolean = false,
	_autoSize : Boolean = true,
	_selecedMC : Shape = new Shape(),
	ttf : TextFormat = setTF(textColorArr[0]),
	bgMC : Shape = new Shape(),
	_showFocus : Boolean = true;

	public function CheckBox(lab:String=ControlType.COMBO_BOX, ched:Boolean=false) : void {
		super();
		_type = ControlType.CHECK_BOX;

		_label.wordWrap = _selecedMC.visible = checkedMC.visible = false;
		selMC.alpha = .0;
		fill(bgMC.graphics, 15, 15, bgColorArr[1]);
		fill(selMC.graphics, 100, 15, 0);
		fill(_selecedMC.graphics, 15, 2, bgColorArr[2]);
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		_label.selectable = false;
		_label.x = 20;
		_label.width = 100;
		_label.height = 23;

		checkedMC.graphics.lineStyle(0, textColorArr[4], 1, true);
		checkedMC.graphics.lineTo(4, 3);
		checkedMC.graphics.lineTo(9, -7);

		parentAddChilds(mc, Vector.<DisplayObject>([
			bgMC, checkedMC, _label, selMC, _selecedMC
		]));

		create(0, 0, lab, ched);
	}

	/** @private */
	protected override function _size_get() : Array {
		return [_label.width + 20, _label.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		var w : uint = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _label.width + 20;
		var h : uint = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _label.height;
		if (_autoSize) {
			_label.autoSize = "left";
			_label.width = w - 20;
			_label.height = h;
			//w = _label.width + 20;
			//h = _label.height;
		} else {
			_label.autoSize = "none";
			w = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _label.width + 20;
			h = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _label.height;
			var labW : uint = Number(w - 20) >= 0 ? int(w - 20) : 0;
			_label.width = labW;
			_label.height = h;
		}
		w = _label.width;
		h = _label.height;
		selMC.width = w + 20;
		selMC.height = h > 15 ? h : 15;
		boxBound();
		_SizeValue = Vector.<uint>(_size_get());
	}
	/** @private */
	protected override function _focus_out() : void {
		_selecedMC.visible = false;
	}
	/** @private */
	protected override function _focus_in() : void {
		_selecedMC.visible = _showFocus;
	}
	/** @private */
	protected override function _mouseOver() : void {
		fill(bgMC.graphics, 15, 15, bgColorArr[0]);
	}
	/** @private */
	protected override function _mouseOut() : void {
		fill(bgMC.graphics, 15, 15, bgColorArr[1]);
	}
	/** @private */
	protected override function _keyDown() : void {
		if (_KeyboardEvent.keyCode == 13) {
			fill(bgMC.graphics, 15, 15, bgColorArr[0]);
		}
	}
	/** @private */
	protected override function _keyUp() : void {
		if (_KeyboardEvent.keyCode == 13) {
			fill(bgMC.graphics, 15, 15, bgColorArr[1]);
			checked = !checked;
			if(onChange != null){
				onChange();
			}
		}
	}
	/** @private */
	protected override function _mouseClick() : void {
		checked = !checked;
		//onChange();
	}

	public function copy() : CheckBox {
		var newDMUI : CheckBox = new CheckBox();
		var sz : Array = size;
		newDMUI.create(x, y, _label.text, checked, _autoSize, sz[0], sz[1]);
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(x : int = 0, y : int = 0, lab:String=ControlType.CHECK_BOX, ched : Boolean = false, au : Boolean = true, w : uint = 100, h : uint = 23) : void {
		this.x = x;
		this.y = y;

		_label.text = lab;

		checked = ched;
		_autoSize = au;
		size = [h, w];
		enabled = _enabled;
	}

	public function set checked(boo : Boolean) : void {
		var old:Boolean = _checked;
		_checked = boo;
		checkedMC.visible = _checked;
		if(old != boo && onChange != null){
			onChange();
		}
	}

	public function get checked() : Boolean {
		return _checked;
	}

	public function get font() : String {
		return ttf.font;
	}

	public function set font(f : String) : void {
		ttf.font = f;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function get wordWrap() : Boolean {
		return _label.wordWrap;
	}

	public function set wordWrap(boo : Boolean) : void {
		_label.wordWrap = boo;
		size = [];
	}

	public function get multiline() : Boolean {
		return _label.multiline;
	}

	public function set multiline(boo : Boolean) : void {
		_label.multiline = boo;
		size = [];
	}

	public function get fontSize() : uint {
		return int(ttf.size);
	}

	public function set fontSize(sz : uint) : void {
		ttf.size = sz;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function get bold() : Boolean {
		return ttf.bold;
	}

	public function set bold(boo : Boolean) : void {
		ttf.bold = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function set color(col : Object) : void {
		if(col == null){
			col = textColorArr[1];
		}
		ttf.color = col;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get color() : Object {
		return "0x" + uint(ttf.color).toString(16);
	}

	public function set label(str : String) : void {
		_label.text = str;
		size = [];
	}

	public function get label() : String {
		return _label.text;
	}

	public function set italic(boo : Boolean) : void {
		ttf.italic = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get italic() : Boolean {
		return ttf.italic;
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		if (_autoSize) {
			_label.autoSize = "left";
		} else {
			_label.autoSize = ttf.align;
		}
		size = [];
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	private function boxBound() : void {
		_label.y = selMC.y;
		_label.x = selMC.x + selMC.width - _label.width;
		_selecedMC.x = bgMC.x = selMC.x;
		bgMC.y = _label.y + (_label.height - 15) / 2;
		checkedMC.x = bgMC.x + 2;
		checkedMC.y = bgMC.y + 9;
		_selecedMC.y = bgMC.y + 14;
	}
}
}
