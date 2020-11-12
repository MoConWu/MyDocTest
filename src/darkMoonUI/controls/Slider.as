package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.drawPolygon;
import darkMoonUI.assets.functions.fill;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.geom.Point;

/**
 * @author moconwu
 */
public class Slider extends DarkMoonUIControl {
	public var onChange : Function;
	public var onChanging : Function;
	public var smooth : Boolean = true;
	private var
	_drag : Boolean = true,
	clickMC : Sprite = new Sprite(),
	bgMC : ProgressBar = new ProgressBar(),
	btnMC : Sprite = new Sprite(),
	sliderMC : Shape = new Shape(),
	unSliderMC : Shape = new Shape(),
	overMC : Shape = new Shape(),
	_value : Number = 0,
	_xy : int = new int(),
	_unitLength : Number = 0,
	_defValue : Number = 0,
	_showPG : Boolean = true,
	_color : uint = bgColorArr[5],
	_smoothSpeed : Number = .25,
	_buttonSize:uint = 6,
	_buttonConvex:uint = 4,
	standFilter : GlowFilter = new GlowFilter(bgColorArr[1], 2, 2, 1, 10, 1),
	overFilter : GlowFilter = new GlowFilter(bgColorArr[6], 2, 2, 1, 10, 1);

	public function Slider(defVal: Number = 0, minVal: Number = 0, maxVal: Number = 100, showPG: Boolean = true) {
		super();
		_type = ControlType.SLIDER;

		fill(clickMC.graphics);
		clickMC.alpha = .0;

		overMC.visible = bgMC.smooth = false;

		_alpha = 1.0;

		btnMC.addChild(sliderMC);
		btnMC.addChild(overMC);
		btnMC.addChild(unSliderMC);

		mc.addChild(bgMC);
		mc.addChild(clickMC);
		mc.addChild(btnMC);

		btnMC.filters = [standFilter];
		bgMC.color = _color;

		create(0, 0, defVal, minVal, maxVal, showPG);
	}

	public function copy() : Slider {
		var sz : Array = size;
		var newDMUI : Slider = new Slider();
		newDMUI.create(x, y, value, bgMC.minValue, bgMC.maxValue, _showPG, sz[0], sz[1]);
		newDMUI.defaultValue = _defValue;
		newDMUI.smooth = smooth;
		newDMUI.unitLength = unitLength;
		newDMUI.smoothSpeed = _smoothSpeed;
		newDMUI.color = _color;
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : uint = 0, _y : uint = 0, defVal : Number = 0, minVal : Number = 0, maxVal : Number = 100, showPG : Boolean = true, w : uint = 150, h : uint = 15) : void {
		x = _x;
		y = _y;

		bgMC.create(0, 6, defVal, minVal, maxVal, w, h - 12);
		bgMC.smooth = false;
		drawSlider(h);
		showProgress = showPG;

		_defValue = value = defVal >= bgMC.minValue ? defVal <= bgMC.maxValue ? defVal : bgMC.maxValue : bgMC.minValue;

		addChild(mc);

		size = [w, h];

		enabled = _enabled;
	}

	public function set drag(boo : Boolean) : void {
		_drag = boo;
		_enabled_set();
	}

	public function get drag() : Boolean {
		return _drag;
	}
	/** @private */
	protected override function _size_get() : Array {
		return [clickMC.width, clickMC.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		var sz : Array = [clickMC.width, clickMC.height];
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : sz[0];
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : sz[1];
		clickMC.width = _SizeValue[0];
		clickMC.height = _SizeValue[1];
		bgMC.size = [_SizeValue[0], _SizeValue[1]];
		btnMC.x = (bgMC.value - bgMC.minValue) / (bgMC.maxValue - bgMC.minValue) * bgMC.size[0];
		changeHeight(_SizeValue[1]);
		_SizeValue = Vector.<uint>([clickMC.width, clickMC.height]);
	}
	/** @private */
	protected override function _focus_in() : void {
		btnMC.filters = [overFilter];
		addEventListener(MouseEvent.MOUSE_WHEEL, WHEEL);
	}
	/** @private */
	protected override function _focus_out() : void {
		btnMC.filters = [standFilter];
		removeEventListener(MouseEvent.MOUSE_WHEEL, WHEEL);
	}
	/** @private */
	protected override function _enabled_set() : void {
		overMC.visible = clickMC.visible = sliderMC.visible = _enabled;
		unSliderMC.visible = !_enabled;
		bgMC.tabChildren = bgMC.tabEnabled = false;
		if (_enabled && _drag) {
			btnMC.addEventListener(MouseEvent.MOUSE_DOWN, DOWN);
			btnMC.addEventListener(MouseEvent.MOUSE_OVER, OVER);
			btnMC.addEventListener(MouseEvent.MOUSE_OUT, OUT);
			clickMC.addEventListener(MouseEvent.MOUSE_DOWN, BGDOWN);
		} else {
			btnMC.removeEventListener(MouseEvent.MOUSE_DOWN, DOWN);
			btnMC.removeEventListener(MouseEvent.MOUSE_OVER, OVER);
			btnMC.removeEventListener(MouseEvent.MOUSE_OUT, OUT);
			clickMC.removeEventListener(MouseEvent.MOUSE_DOWN, BGDOWN);
		}
		if (_enabled) {
			bgMC.alpha = 1.0;
		}else{
			bgMC.alpha = .4;
		}
	}

	public function reset() : void {
		value = _defValue;
	}

	public function set defaultValue(val : Number) : void {
		_defValue = val <= bgMC.maxValue ? val >= bgMC.minValue ? val : bgMC.minValue : bgMC.maxValue;
	}

	public function get defaultValue() : Number {
		return _defValue;
	}

	public function set value(val : Number) : void {
		if (_unitLength > 0) {
			_value = Math.round(val / _unitLength) * _unitLength + bgMC.minValue;
		}
		bgMC.value = _value = val >= bgMC.minValue ? val <= bgMC.maxValue ? val : bgMC.maxValue : bgMC.minValue;
		_SizeValue = Vector.<uint>([]);
		_size_set();
		if(onChange != null){
			onChange();
		}
	}

	public function get value() : Number {
		_value = btnMC.x / bgMC.width * (bgMC.maxValue - bgMC.minValue) + bgMC.minValue;
		if (_unitLength > 0) {
			_value = Math.round(_value / _unitLength) * _unitLength + bgMC.minValue;
		}
		return _value;
	}

	public function get maxValue() : Number {
		return bgMC.maxValue;
	}

	public function get minValue() : Number {
		return bgMC.minValue;
	}

	public function set maxValue(val : Number) : void {
		bgMC.maxValue = val;
		_SizeValue = Vector.<uint>([]);
		_size_set();
	}

	public function set minValue(val : Number) : void {
		bgMC.minValue = val;
		_SizeValue = Vector.<uint>([]);
		_size_set();
	}

	private function changeHeight(h : uint) : void {
		var sz : Array = bgMC.size;
		var getH : uint = sz[1];
		var setH : uint = h - _buttonConvex*2;
		if (getH != setH) {
			bgMC.y = _buttonConvex;
			bgMC.size = [sz[0], setH];
			drawSlider(h);
		}
	}

	private function drawSlider(h : uint) : void {
		var w : uint = _buttonSize;
		var p1 : Point = new Point(0, 0);
		var p2 : Point = new Point(w / 2, w / 2);
		var p3 : Point = new Point(w / 2, h - w / 2);
		var p4 : Point = new Point(0, h);
		var p5 : Point = new Point(-w / 2, h - w / 2);
		var p6 : Point = new Point(-w / 2, w / 2);
		var p7 : Point = new Point(0, 0);
		var verticies : Vector.<Point> = Vector.<Point>([p1, p2, p3, p4, p5, p6, p7]);
		drawPolygon(sliderMC.graphics, verticies, bgColorArr[10]);
		drawPolygon(overMC.graphics, verticies, bgColorArr[7]);
		drawPolygon(unSliderMC.graphics, verticies, bgColorArr[5]);
	}

	public function get showProgress() : Boolean {
		return _showPG;
	}

	public function set showProgress(boo : Boolean) : void {
		_showPG = boo;
		if (!_showPG) {
			bgMC.value = bgMC.minValue;
		} else {
			bgMC.value = _value;
		}
	}

	public override function get showFocus() : Boolean {
		return false;
	}

	public override function set showFocus(boo : Boolean) : void {
	}

	public function set buttonSize(num:uint):void{
		_buttonSize = num;
		size = [];
	}

	public function get buttonSize():uint{
		return _buttonSize;
	}

	public function set buttonConvex(num:uint):void{
		_buttonConvex = num;
	}

	public function get buttonConvex():uint{
		return _buttonConvex;
	}

	private function DOWN(evt : MouseEvent) : void {
		overMC.visible = true;
		_xy = mc.mouseX - btnMC.x;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
		stage.addEventListener(MouseEvent.MOUSE_UP, UP);
		btnMC.removeEventListener(MouseEvent.MOUSE_OUT, OUT);
	}

	//
	private function BGDOWN(evt : MouseEvent) : void {
		overMC.visible = true;
		stage.addEventListener(Event.ENTER_FRAME, sliderMoving);
		stage.addEventListener(MouseEvent.MOUSE_UP, BGUP);
		btnMC.removeEventListener(MouseEvent.MOUSE_OUT, OUT);
	}

	private function BGUP(evt : MouseEvent) : void {
		stage.removeEventListener(MouseEvent.MOUSE_UP, BGUP);
		stage.removeEventListener(Event.ENTER_FRAME, sliderMoving);
		btnMC.addEventListener(MouseEvent.MOUSE_OUT, OUT);
		if(onChange != null){
			onChange();
		}
	}

	private function sliderMoving(evt : Event) : void {
		var oldXY : Number = btnMC.x;
		if (smooth && _unitLength == 0) {
			btnMC.x += (mc.mouseX - btnMC.x) * _smoothSpeed;
		} else {
			btnMC.x = mc.mouseX;
		}
		checkSlider();
		checkValue();
		bgMC.value = _value;
		if (oldXY != btnMC.x && onChanging != null) {
			onChanging();
		}
	}

	//
	private function moveFunc(evt : MouseEvent) : void {
		var _x_y : int = btnMC.x;
		btnMC.x = mc.mouseX - _xy;
		checkSlider();
		_value = btnMC.x / bgMC.size[0] * (bgMC.maxValue - bgMC.minValue) + bgMC.minValue;
		checkValue();
		bgMC.value = _value;
		if (_x_y != btnMC.x && onChanging != null) {
			onChanging();
		}
	}

	private function checkSlider() : void {
		var w : Number = bgMC.size[0];
		if (btnMC.x < 0) {
			btnMC.x = 0;
		} else if (btnMC.x > w) {
			btnMC.x = w;
		}
	}

	private function UP(evt : MouseEvent) : void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
		stage.removeEventListener(MouseEvent.MOUSE_UP, UP);
		btnMC.addEventListener(MouseEvent.MOUSE_OUT, OUT);
		overMC.visible = false;
		if(onChange != null){
			onChange();
		}
	}

	private function OVER(evt : MouseEvent) : void {
		overMC.visible = true;
	}

	private function OUT(evt : MouseEvent) : void {
		overMC.visible = false;
	}

	private function WHEEL(evt : MouseEvent) : void {
		if (_unitLength > 0) {
			_value += evt.delta / 3 * _unitLength;
		} else {
			_value += evt.delta / 3;
		}
		value = _value;
		checkSlider();
	}

	private function checkValue() : void {
		_value = value;
		if (_unitLength > 0) {
			_value = Math.round((_value - bgMC.minValue) / _unitLength) * _unitLength + bgMC.minValue;
			if (_value > bgMC.maxValue) {
				_value = bgMC.maxValue;
			} else if (_value < bgMC.minValue) {
				_value = bgMC.minValue;
			}
			value = _value;
		}
	}

	public function set unitLength(num : Number) : void {
		_unitLength = num >= 0 ? num : _unitLength;
		checkValue();
	}

	public function get unitLength() : Number {
		return _unitLength;
	}

	public function set color(col : Object) : void {
		_color = int(col);
		bgMC.color = _color;
	}

	public function get color() : Object {
		return "0x" + _color.toString(16);
	}

	public function set smoothSpeed(spd : Number) : void {
		_smoothSpeed = spd > 1 ? 1 : spd < 0.01 ? 0.01 : spd;
	}

	public function get smoothSpeed() : Number {
		return _smoothSpeed;
	}
}
}
