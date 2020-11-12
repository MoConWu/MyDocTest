package darkMoonUI.controls {
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.numCheck;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;
import darkMoonUI.functions.parentAddChilds;
import darkMoonUI.types.ControlType;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

/**
 * @author moconwu
 */
public class InputNumber extends DarkMoonUIControl implements DMUI_PUB_LABEL {
	public var onChange : Function;
	public var onChanging : Function;
	private var
	btn : Sprite = new Sprite(),
	_tf : TextFormat = setTF(textColorArr[2]),
	_unitTf : TextFormat = setTF(textColorArr[0]),
	_label : TextField = new TextField(),
	_bg : Shape = new Shape(),
	_unitLab : TextField = new TextField(),
	_unit : String = "",
	_unitLength : Number = 0,
	_focusBg : Shape = new Shape(),
	_focusBg2 : Shape = new Shape(),
	_minValue : Number = NaN,
	_maxValue : Number = NaN,
	_value : Number = 0,
	_defValue : Number = 0,
	_oldStr : String,
	_oldStr0 : String,
	_autoSize : Boolean = false,
	_mouseX : int = 0,
	_showFocus : Boolean = true,
	_moved : Boolean = false;

	public function InputNumber(val : Number = 0, minVal : Number = NaN, maxVal : Number = NaN) {
		super();
		_type = ControlType.INPUT_NUMBER;

		_label.multiline = _unitLab.multiline = _unitLab.selectable = _unitLab.wordWrap = _label.wordWrap = _bg.visible = _focusBg.visible = _focusBg.visible = false;
		_label.setTextFormat(_tf);
		_unitLab.setTextFormat(_unitTf);
		_label.defaultTextFormat = _tf;
		_unitLab.defaultTextFormat = _unitTf;
		_label.autoSize = _unitLab.autoSize = TextFieldAutoSize.LEFT;
		_label.type = TextFieldType.INPUT;
		_label.backgroundColor = bgColorArr[4];
		_label.restrict = "0-9.+,\\-";

		fill(_bg.graphics, 10, 10, bgColorArr[3], bgColorArr[1]);
		fill(_focusBg.graphics, 10, 10);
		fill(btn.graphics, 10, 10);
		btn.alpha = .0;
		_focusBg2.x = _focusBg2.y = -1;
		_focusBg2.visible = _label.tabEnabled = false;

		parentAddChilds(mc, Vector.<DisplayObject>([
			_focusBg2, _bg, _focusBg, _label, _unitLab, btn
		]));

		create(0, 0, val ,minVal, maxVal);
	}

	public function copy() : InputNumber {
		var newDMUI : InputNumber = new InputNumber();
		var sz : Array = _size_get();
		newDMUI.create(x, y, _defValue, _minValue, _maxValue, _unit, sz[0], sz[1]);
		newDMUI.unit = _unit;
		newDMUI.unitLength = _unitLength;
		newDMUI.showFocus = _showFocus;
		newDMUI.autoSize = _autoSize;
		newDMUI.wordWrap = wordWrap;
		newDMUI.bold = bold;
		newDMUI.italic = italic;
		newDMUI.color = color;
		newDMUI.font = font;
		newDMUI.fontSize = fontSize;
		newDMUI.unitBold = unitBold;
		newDMUI.unitItalic = unitItalic;
		newDMUI.unitWordWrap = unitWordWrap;
		newDMUI.unitColor = unitColor;
		newDMUI.unitFont = unitFont;
		newDMUI.unitFontSize = unitFontSize;
		newDMUI.enabled = _enabled;
		newDMUI.value = _value;
		newDMUI.label = label;
		return newDMUI;
	}

	public function create(_x:int=0, _y:int=0, defVal:Number=0, minVal:Number=NaN, maxVal:Number=NaN, _unitStr:String=null, w:uint=60, h:uint=23) : void {
		x = _x;
		y = _y;
		_minValue = minVal;
		_maxValue = maxVal >= minVal ? maxVal : minVal;
		_defValue = numCheck(defVal, minVal, maxVal);
		_oldStr = _defValue.toString();

		if(_unitStr==null){
			_unitStr = "";
		}
		_unit = _unitLab.text = _unitStr;
		_label.text = _defValue.toString();

		size = [w, h];

		enabled = _enabled;
	}
	/** @private */
	protected override function _size_get() : Array {
		return [_bg.width, _bg.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _bg.width;
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _bg.height;
		_label.autoSize = TextFieldAutoSize.LEFT;
		_label.width = _SizeValue[0];
		_label.height = _SizeValue[1];
		if (_autoSize) {
			_SizeValue[0] = _label.width + _unitLab.width;
			_SizeValue[1] = _label.height >= _unitLab.height * Number(_unitLab.visible) ? _label.height : _unitLab.height * Number(_unitLab.visible);
		} else {
			var _labW : Number = _label.width;
			_label.autoSize = TextFieldAutoSize.NONE;
			if (_label.width > _SizeValue[0] - _unitLab.width * Number(_unitLab.visible) || _label.height > _SizeValue[1]) {
				_label.width = _SizeValue[0] - _unitLab.width * Number(_unitLab.visible);
				_label.height = _SizeValue[1];
			} else {
				_label.width = _labW;
				_label.height = _SizeValue[1];
			}
		}
		_labW = _label.width;
		_bg.width = _SizeValue[0];
		_bg.height = _SizeValue[1];
		fill(_focusBg2.graphics, _SizeValue[0] + 2, _SizeValue[1] + 2, bgColorArr[2]);
		var grap : Graphics = _focusBg.graphics;
		fill(grap, _label.width, _SizeValue[1], bgColorArr[4]);
		grap.beginFill(bgColorArr[2]);
		grap.drawRect(0, _SizeValue[1] - 2, _label.width, 2);
		grap.endFill();
		btn.height = _SizeValue[1];
		_unitLab.x = _labW;
		btn.width = _labW + _unitLab.width * Number(_unitLab.visible);
	}
	/** @private */
	protected override function _focus_in() : void {
		_focusBg.visible = true;
	}
	/** @private */
	protected override function _focus_out() : void {
		_focusBg.visible = false;
		btn.visible = true;
		_bg.visible = false;
	}
	/** @private */
	protected override function _enabled_set() : void {
		_label.selectable = _enabled;
		if (_enabled) {
			btn.addEventListener(MouseEvent.CLICK, CLICK);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, DOWN);
			btn.addEventListener(MouseEvent.MOUSE_OVER, OVER);
			btn.addEventListener(MouseEvent.MOUSE_OUT, OUT);
			_label.addEventListener(FocusEvent.FOCUS_IN, labFcsIn);
			_label.addEventListener(FocusEvent.FOCUS_OUT, labFcsOut);
		} else {
			btn.removeEventListener(MouseEvent.CLICK, CLICK);
			btn.removeEventListener(MouseEvent.MOUSE_DOWN, DOWN);
			btn.removeEventListener(MouseEvent.MOUSE_OVER, OVER);
			btn.removeEventListener(MouseEvent.MOUSE_OUT, OUT);
			_label.removeEventListener(FocusEvent.FOCUS_IN, labFcsIn);
			_label.removeEventListener(FocusEvent.FOCUS_OUT, labFcsOut);
		}
	}
	/** @private */
	protected override function _keyDown() : void {
		if (_KeyboardEvent.keyCode == 13) {
			CLICK(_MouseEvent);
		}
	}

	private function labFcsIn(evt : FocusEvent) : void {
		Mouse.cursor = MouseCursor.IBEAM;
		_focusBg2.visible = _label.background = true;
		_label.autoSize = TextFieldAutoSize.NONE;
		_label.width = _bg.width;
		btn.visible = _unitLab.visible = false;
		_oldStr = _label.text;
		addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
	}

	private function KeyDown(evt : KeyboardEvent) : void {
		if (evt.keyCode == 13) {
			stage.focus = this;
		} else if (evt.keyCode == 27) {
			_label.text = _oldStr;
			stage.focus = this;
		}
	}

	private function labFcsOut(evt : FocusEvent) : void {
		removeEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
		_lockfocus = _label.background = _focusBg2.visible = false;
		_label.autoSize = TextFieldAutoSize.LEFT;
		_unitLab.visible = true;
		var num : Number = Number(_label.text);
		num = numCheck(num, _minValue, _maxValue);
		_label.text = String(num);
		valueCheck();
		if (_oldStr != _label.text && onChange != null) {
			onChange();
		}
	}

	private function DOWN(evt : MouseEvent) : void {
		_moved = false;
		_oldStr0 = _oldStr = _label.text;
		_mouseX = stage.mouseX;
		stage.addEventListener(MouseEvent.MOUSE_UP, UP);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, startMoving);
	}

	private function UP(evt:MouseEvent):void{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, startMoving);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoving);
	}

	private function startMoving(evt : MouseEvent):void{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, startMoving);
		stage.addEventListener(MouseEvent.MOUSE_UP, stopMoving);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoving);
	}

	private function valueCheck() : void {
		if (_unitLength != 0) {
			var val : Number = Number(_label.text);
			if (!isNaN(_minValue)) {
				val = Math.round((val - _minValue) / _unitLength) * _unitLength + _minValue;
			} else {
				_oldStr = isNaN(Number(_oldStr)) ? "0" : _oldStr;
				val = Math.round((val - Number(_oldStr)) / _unitLength) * _unitLength + Number(_oldStr);
			}
			val = numCheck(val, _minValue, _maxValue);
			_label.text = val.toString();
		}
		_value = Number(_label.text);
		size = [];
	}

	private function onMoving(evt : MouseEvent) : void {
		var _oldNum : Number = Number(_label.text);
		_moved = true;
		var _m : Number = stage.mouseX - _mouseX;
		if (_m > 0) {
			_m = Math.round(_m / 4) + 1;
		} else {
			_m = Math.round(Math.abs(_m) / 4) * -1 - 1;
		}
		if(_unitLength!=0){
			_m *=_unitLength;
		}
		var num : Number = _oldNum + _m;
		_mouseX = stage.mouseX;
		num = numCheck(num, _minValue, _maxValue);
		_label.text = String(num);
		valueCheck();
		_oldStr = _value.toString();
		if (_oldNum != _value && onChanging != null) {
			onChanging();
		}
		evt.updateAfterEvent();
	}

	private function stopMoving(evt : MouseEvent) : void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoving);
		stage.removeEventListener(MouseEvent.MOUSE_UP, stopMoving);
		if(onChange != null){
			onChange();
		}
	}

	private function CLICK(evt : MouseEvent) : void {
		if (!_moved) {
			_lockfocus = true;
			btn.visible = false;
			_bg.visible = true;
			stage.focus = _label;
			_label.setSelection(0, _label.text.length);
		}
	}

	private static function OVER(evt : MouseEvent) : void {
		Mouse.cursor = MouseCursor.BUTTON;
	}

	private static function OUT(evt : MouseEvent) : void {
		Mouse.cursor = MouseCursor.AUTO;
	}

	public function set unitLength(num : Number) : void {
		_unitLength = num;
		valueCheck();
	}

	public function get unitLength() : Number {
		return _unitLength;
	}

	public function get label() : String {
		return _label.text;
	}

	public function get color() : Object {
		return "0x" + uint(_tf.color).toString(16);
	}

	public function get font() : String {
		return _tf.font;
	}

	public function get fontSize() : uint {
		return int(_tf.size);
	}

	public function get bold() : Boolean {
		return _tf.bold;
	}

	public function get wordWrap() : Boolean {
		return _label.wordWrap;
	}

	public function get multiline() : Boolean {
		return _label.multiline;
	}

	public function get italic() : Boolean {
		return _tf.italic;
	}

	public function set label(lab : String) : void {
		value = Number(lab);
	}

	public function set color(col : Object) : void {
		_tf.color = uint(col);
		_label.setTextFormat(_tf);
		_label.defaultTextFormat = _tf;
	}

	public function set font(f : String) : void {
		_unitTf.font = _tf.font = f;
		_label.setTextFormat(_tf);
		_label.defaultTextFormat = _tf;
		_unitLab.setTextFormat(_unitTf);
		_unitLab.defaultTextFormat = _unitTf;
		size = [];
	}

	public function set fontSize(sz : uint) : void {
		_unitTf.size = _tf.size = uint(sz);
		_label.setTextFormat(_tf);
		_label.defaultTextFormat = _tf;
		_unitLab.setTextFormat(_unitTf);
		_unitLab.defaultTextFormat = _unitTf;
		size = [];
	}

	public function set bold(boo : Boolean) : void {
		_unitTf.bold = _tf.bold = boo;
		_label.setTextFormat(_tf);
		_label.defaultTextFormat = _tf;
		_unitLab.setTextFormat(_unitTf);
		_unitLab.defaultTextFormat = _unitTf;
		size = [];
	}

	public function set wordWrap(boo : Boolean) : void {
		_label.wordWrap = boo;
		size = [];
	}

	public function set multiline(boo : Boolean) : void {
		_label.multiline = boo;
		size = [];
	}

	public function set italic(boo : Boolean) : void {
		_unitTf.italic = _tf.italic = boo;
		_label.setTextFormat(_tf);
		_label.defaultTextFormat = _tf;
		_unitLab.setTextFormat(_unitTf);
		_unitLab.defaultTextFormat = _unitTf;
		size = [];
	}

	public function get unitColor() : Object {
		return "0x" + uint(_unitTf.color).toString(16);
	}

	public function get unitFont() : String {
		return _unitTf.font;
	}

	public function get unitFontSize() : uint {
		return int(_unitTf.size);
	}

	public function get unitBold() : Boolean {
		return _unitTf.bold;
	}

	public function get unitWordWrap() : Boolean {
		return _unitLab.wordWrap;
	}

	public function get unitItalic() : Boolean {
		return _unitTf.italic;
	}

	public function set unitColor(col : Object) : void {
		_unitTf.color = uint(col);
		_unitLab.setTextFormat(_unitTf);
		_unitLab.defaultTextFormat = _unitTf;
	}

	public function set unitFont(f : String) : void {
		_unitTf.font = f;
		_unitLab.setTextFormat(_unitTf);
		_unitLab.defaultTextFormat = _unitTf;
		size = [];
	}

	public function set unitFontSize(sz : uint) : void {
		_unitTf.size = uint(sz);
		_unitLab.setTextFormat(_unitTf);
		_unitLab.defaultTextFormat = _unitTf;
		size = [];
	}

	public function set unitBold(boo : Boolean) : void {
		_unitTf.bold = boo;
		_unitLab.setTextFormat(_unitTf);
		_unitLab.defaultTextFormat = _unitTf;
		size = [];
	}

	public function set unitWordWrap(boo : Boolean) : void {
		_label.wordWrap = _label.multiline = boo;
		size = [];
	}

	public function set unitItalic(boo : Boolean) : void {
		_unitTf.italic = boo;
		_unitLab.setTextFormat(_unitTf);
		_unitLab.defaultTextFormat = _unitTf;
		size = [];
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
		if (boo) {
			_focusBg2.alpha = 1.0;
		} else {
			_focusBg2.alpha = .0;
		}
	}

	public function get maxValue() : Number {
		return _maxValue;
	}

	public function set maxValue(val : Number) : void {
		_maxValue = numCheck(val, _minValue, val);
		value = numCheck(_value, _minValue, _maxValue);
	}

	public function get minValue() : Number {
		return _minValue;
	}

	public function set minValue(val : Number) : void {
		_minValue = numCheck(val, val, _maxValue);
		value = numCheck(_value, _minValue, _maxValue);
	}

	public function get value() : Number {
		return Number(_label.text);
	}

	public function set value(val : Number) : void {
		var val0 : String = numCheck(val, _minValue, _maxValue).toString();
		if(val0 == _label.text){
			return;
		}
		_label.text = val0;
		valueCheck();
		if(onChange != null){
			onChange();
		}
	}

	public function get unit() : String {
		return _unit;
	}

	public function set unit(str : String) : void {
		str = str == null ? "" : str;
		_unitLab.visible = str != "";
		_unitLab.text = _unit = str;
		size = [];
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}
}
}
