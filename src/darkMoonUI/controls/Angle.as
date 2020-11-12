package darkMoonUI.controls {
import darkMoonUI.controls.regPoint.RegPointAlign;
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.fill_circle;
import darkMoonUI.assets.functions.numCheck;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

/**
 * Angle 旋转控件。
 * 一般用于旋转值的角度控件，可以以360为一圈的单位进行旋转操作数值。
 *
 * <p><img src="images/angle_01.jpg"/></p>
 *
 * @example 这是一个例子
 * <listing version="3.0">
package{
import flash.display.Sprite;
import darkMoonUI.controls.Angle;
public class AngleTest extends Sprite{
	public function AngleTest(){
		__init__(stage);

		var angle0 : Angle = new Angle();
		var angle1 : Angle = new Angle(100, 20, 200);

		addChild(angle0);
		addChild(angle1);
	}
}
}
 * </listing>
 *
 * @since 2020/06/05
 * @author MoCon
 *
 * @playerversion Flash 10
 * @playerversion AIR 1.5
 * @langversion 3.0
 */
public class Angle extends DarkMoonUIControl implements DMUI_PUB_LABEL {
	public var onChange : Function;
	public var onChanging : Function;

	private var
	_labBox : Sprite = new Sprite(),
	_label0 : InputNumber = new InputNumber(0),
	_label1 : InputNumber = new InputNumber(0),
	_label2 : Label = new Label("x"),
	bgBox : Sprite = new Sprite(),
	bg : Shape = new Shape(),
	line : Shape = new Shape(),
	_value : Number = 0,
	_defVal : Number = 0,
	_minValue : Number = NaN,
	_width : Number = 50,
	_maxValue : Number = NaN;

	/**
	 * 构造函数，用于构造 Angle 旋转控件。
	 * @param val 初始的值，默认是 0。
	 * @param min 设置控件的最小值，默认是 NaN， NaN表示无限制。
	 * @param max 设置控件的最大值，默认是 NaN， NaN表示无限制。
	 * @example <listing version="3.0">var angel : Angle = new Angle(100, 20, 200);</listing>
	 */
	public function Angle(val : Number = 0, min : Number = NaN, max : Number = NaN) {
		super();
		_type = ControlType.ANGLE;

		_label1.value = _label0.value = 0;
		_label1.unit = "°";
		_label1.autoSize = _label0.autoSize = true;
//		_label1.showFocus = _label0.showFocus = false;
		_label0.onChange = _label1.onChange = checkValueChange;
		_label2.regPoint = _label0.regPoint = RegPointAlign.RIGHT_TOP;
		_label0.onChanging = _label1.onChanging = checkValueChanging;
		checkValueChange();
		_label2.color = _label0.color;

		_label0.addEventListener(FocusEvent.FOCUS_IN, labFocusIn);
		_label1.addEventListener(FocusEvent.FOCUS_IN, labFocusIn);
		_label0.addEventListener(FocusEvent.FOCUS_OUT, labFocusOut);
		_label1.addEventListener(FocusEvent.FOCUS_OUT, labFocusOut);

		bgBox.addChild(bg);
		bgBox.addChild(line);

		_labBox.addChild(_label0);
		_labBox.addChild(_label2);
		_labBox.addChild(_label1);

		mc.addChild(bgBox);
		mc.addChild(_labBox);

		create(0, 0, val, min, max);
	}

	/**
	 * 用于创建当前对象，类似于构造函数，也可以用于重置此控件的一些参数。
	 * @param x 控件的 x 轴坐标像素值，默认值 0。
	 * @param y 控件的 y 轴坐标像素值，默认值 0。
	 * @param val 控件的初始值，默认值 0。
	 * @param minVal 控件的 可旋转的最小值，默认值  NaN，NaN表示无限制。
	 * @param maxVal 控件的 可旋转的最大值，默认值  NaN，NaN表示无限制。
	 * @param w 控件的横向宽度，默认值是 30 像素。
	 * @param h 控件的纵向高度，默认值是 50 像素，其中旋转控件的高度是 30，文字高度是 20。
	 * @example <listing version="3.0">angel.create(30, 50, 10, 0, 100);</listing>
	 */
	public function create(x : int = 0, y : int = 0, val : Number = 0, minVal : Number = NaN, maxVal : Number = NaN, w : uint = 30, h : int = 50) : void {
		this.x = x;
		this.y = y;

		minValue = minVal;
		maxValue = maxVal;
		value = val;
		_defVal = _value;

		value = val;

		size = [w, h];
		enabled = _enabled;
	}

	/**
	 * 用于复制出一个参数一样的Angle对象。
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * </table>
	 *
	 * @eventType buttonDown
	 *
	 * @return 返回一个复制的Angle的对象，复制的对象参数与当前对象一样，但是在内存中是独立存在的。
	 *
	 * @see darkMoonUI.assets.DarkMoonUIControl
	 *
	 */
	public function copy() : Angle {
		var newDMUI : Angle = new Angle();
		var sz : Array = size;
		newDMUI.create(x, y, _defVal, _minValue, _maxValue, sz[0], sz[1]);
		newDMUI.value = _value;
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	/** @private */
	protected override function _size_get() : Array {
		return [bgBox.width, bgBox.height + _labBox.height];
	}

	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : bgBox.width;
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : bgBox.height + _labBox.height;

		_SizeValue[0] = _SizeValue[0] >= _SizeValue[1] - _labBox.height ? _SizeValue[1] - _labBox.height : _SizeValue[0];

		_width = _SizeValue[0] / 2;
		fill_circle(bg.graphics, _width, bgColorArr[10]);
		fill(line.graphics, _width, 2);

		const labH : Number = _label1.size[1];
		_SizeValue[1] = _SizeValue[0] + labH;

		bgBox.x = _width;
		bgBox.y = _width + labH;

		_label0.x = -_label2.size[0] / 2;

		_labBox.x = _width + 3;
	}

	/** @private */
	protected override function _enabled_set() : void {
		_label1.enabled = _label0.enabled = _label2.enabled = _enabled;
		if (_enabled) {
			bgBox.addEventListener(MouseEvent.MOUSE_OVER, OVER);
			bgBox.addEventListener(MouseEvent.MOUSE_DOWN, DOWN);
		} else {
			bgBox.removeEventListener(MouseEvent.MOUSE_OVER, OVER);
			bgBox.removeEventListener(MouseEvent.MOUSE_DOWN, DOWN);
		}
	}

	private function labFocusIn(evt : FocusEvent) : void {
		_lockfocus = true;
	}

	private function labFocusOut(evt : FocusEvent) : void {
		_lockfocus = false;
	}

	private function checkValueChange() : void {
		getValue();
		setValue();
		if(onChange != null){
			onChange();
		}
	}

	private function checkValueChanging() : void {
		getValue();
		setValue();
		if (onChanging != null) {
			onChanging();
		}
	}

	private function setValue() : void {
		if(isNaN(_value)){
			_value = 0;
		}
		_value = numCheck(_value, _minValue, _maxValue);
		if (_value >= 0) {
			var __r : int = 1;
		} else {
			__r = -1;
		}
		_label0.value = __r * Math.floor(Math.abs(_value) / 360);
		_label1.value = __r * Math.abs(_value) % 360;
		line.rotationZ = _label1.value;
	}

	private function getValue() : void {
		_value = _label0.value * 360 + _label1.value;
	}

	private function DOWN(evt : MouseEvent) : void {
		fill_circle(bg.graphics, _width, bgColorArr[7]);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, MOVE);
		stage.addEventListener(MouseEvent.MOUSE_UP, UP);
		setRotation();
	}

	private function MOVE(evt : MouseEvent) : void {
		setRotation();
		if(onChanging != null){
			onChanging();
		}
	}

	private function UP(evt : MouseEvent) : void {
		fill_circle(bg.graphics, _width, bgColorArr[10]);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, MOVE);
		stage.removeEventListener(MouseEvent.MOUSE_UP, UP);
		setRotation();
		if(onChange != null){
			onChange();
		}
	}

	private function setRotation() : void {
		var _x : Number = bgBox.mouseX;
		var _y : Number = bgBox.mouseY;
		var val : int = Math.round(Math.atan2(_y, _x) * (180 / Math.PI));
		if (_value >= 0) {
			_label1.value = val >= 0 ? val : val + 360;
		} else {
			_label1.value = val <= 0 ? val : val - 360;
		}
		getValue();
		setValue();
	}

	private function OVER(evt : MouseEvent) : void {
		if (!evt.buttonDown) {
			fill_circle(bg.graphics, _width, bgColorArr[7]);
			bgBox.addEventListener(MouseEvent.MOUSE_OUT, OUT);
		}
	}

	private function OUT(evt : MouseEvent) : void {
		if (!evt.buttonDown) {
			fill_circle(bg.graphics, _width, bgColorArr[10]);
			bgBox.removeEventListener(MouseEvent.MOUSE_OUT, OUT);
		}
	}

	public function reset() : void {
		value = _defVal;
	}

	public function set defaultValue(val : Number) : void {
		_defVal = val;
	}

	public function get defaultValue() : Number {
		return _defVal;
	}

	public function get value() : Number {
		return _value;
	}

	public function get minValue() : Number {
		return _minValue;
	}

	public function get maxValue() : Number {
		return _maxValue;
	}

	public function set value(val : Number) : void {
		_value = val;
		_value = numCheck(_value, _minValue, _maxValue);
		setValue();
	}

	public function set minValue(val : Number) : void {
		if (isNaN(val) || isNaN(_maxValue)) {
			_minValue = val;
		} else {
			_minValue = val <= _maxValue ? val : _maxValue;
		}
		value = _value;
	}

	public function set maxValue(val : Number) : void {
		if (isNaN(val) || isNaN(_minValue)) {
			_maxValue = val;
		} else {
			_maxValue = val >= _minValue ? val : _minValue;
		}
		value = _value;
	}

	public function get label() : String {
		return _label0.label + "x" + _label1.label;
	}

	public function get color() : Object {
		return _label0.color;
	}

	public function get font() : String {
		return _label0.font;
	}

	public function get fontSize() : uint {
		return _label0.fontSize;
	}

	public function get bold() : Boolean {
		return _label0.bold;
	}

	public function get wordWrap() : Boolean {
		return _label0.wordWrap;
	}

	public function get multiline() : Boolean {
		return _label0.multiline;
	}

	public function get italic() : Boolean {
		return _label0.italic;
	}

	public function set label(lab : String) : void {
	}

	public function set color(col : Object) : void {
		_label0.color = _label1.color = _label2.color = col;
	}

	public function set font(f : String) : void {
		_label0.font = _label1.font = _label2.font = f;
		size = [];
	}

	public function set fontSize(sz : uint) : void {
		_label0.fontSize = _label1.fontSize = _label2.fontSize = sz;
		size = [];
	}

	public function set bold(boo : Boolean) : void {
		_label0.bold = _label1.bold = _label2.bold = boo;
		size = [];
	}

	public function set wordWrap(boo : Boolean) : void {
		_label0.wordWrap = _label1.wordWrap = _label2.wordWrap = boo;
		size = [];
	}

	public function set multiline(boo : Boolean) : void {
		_label0.multiline = _label1.multiline = _label2.multiline = boo;
		size = [];
	}

	public function set italic(boo : Boolean) : void {
		_label0.italic = _label1.italic = _label2.italic = boo;
		size = [];
	}

	public override function get showFocus() : Boolean {
		return false;
	}
}
}
