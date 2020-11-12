package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_DEF;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;

import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * @author moconwu
 */
public class SimpleLabel extends DarkMoonUIControl implements DMUI_PUB_LABEL, DMUI_PUB_DEF {
	private var
	_label : TextField = new TextField(),
	ttf : TextFormat = setTF(textColorArr[1]),
	_autoSize : Boolean = true;

	public function SimpleLabel(lab:String=ControlType.SIMPLE_LABEL) : void {
		super();
		_type = ControlType.SIMPLE_LABEL;

		_label.selectable = false;
		_label.autoSize = TextFieldAutoSize.LEFT;
		_label.antiAliasType = AntiAliasType.ADVANCED;

		mc.addChild(_label);
		create(0, 0, lab);
	}

	public function create(_x:int=0, _y:int=0, lab:String=ControlType.SIMPLE_LABEL, auto:Boolean=true, b:Boolean=false, ww:Boolean=false, col:Object=0xD4D4D4, w:uint=100, h:uint=23) : void {
		x = _x;
		y = _y;

		ttf.color = col;
		ttf.bold = b;

		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		_label.text = lab;
		_label.wordWrap = ww;

		_autoSize = auto;
		size = [w, h];
		enabled = _enabled;
	}
	/** @private */
	protected override function _size_get() : Array {
		return [_label.width, _label.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _label.width;
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _label.height;
		_label.width = _SizeValue[0];
		_label.height = _SizeValue[1];
		_SizeValue = Vector.<uint>([_label.width, _label.height]);
	}
	/** @private */
	protected override function _mouseClick() : void {
	}
	/** @private */
	protected override function _enabled_set() : void {
		tabEnabled = false;
	}
	public override function get showFocus() : Boolean {
		return false;
	}

	public override function set showFocus(boo : Boolean) : void {
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

	public function set color(col : Object) : void {
		if(col==null){
			col = textColorArr[1];
		}
		ttf.color = col;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get color() : Object {
		return "0x" + uint(ttf.color).toString(16);
	}

	public function set fontSize(num : uint) : void {
		ttf.size = num;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function get fontSize() : uint {
		return ttf.size as uint;
	}

	public function set italic(boo : Boolean) : void {
		ttf.italic = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get italic() : Boolean {
		return ttf.italic;
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public function set wordWrap(boo : Boolean) : void {
		_label.wordWrap = boo;
	}

	public function set multiline(boo : Boolean) : void {
		_label.multiline = boo;
	}

	public function get wordWrap() : Boolean {
		return _label.wordWrap;
	}

	public function get multiline() : Boolean {
		return _label.multiline;
	}

	public function get bold() : Boolean {
		return ttf.bold;
	}

	public function set bold(boo : Boolean) : void {
		ttf.bold = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get label() : String {
		return _label.text;
	}

	public function set label(lab : String) : void {
		if(_label.text == lab){
			return;
		}
		if(lab == null){
			lab = "";
		}
		_label.text = lab;
		size = [];
	}

	public function set backgroundColor(col : Object) : void {
		_label.backgroundColor = uint(col);
	}

	public function set background(boo : Boolean) : void {
		_label.background = boo;
	}

	public function get backgroundColor() : Object {
		return _label.backgroundColor;
	}

	public function get background() : Boolean {
		return _label.background;
	}
}
}
