package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.controls.orientation.Orientation;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Sprite;

/**
 * @author moconwu
 */
public class ScrollBar extends DarkMoonUIControl {
	public var onChange : Function = new Function();
	public var onChanging : Function = new Function();
	public var smooth : Boolean = true;
	private var
	slider : Sprite = new Sprite(),
	bgMC : Sprite = new Sprite(),
	_xy : int = new int(),
	_value : Number = 0,
	_minValue : Number = 0,
	_maxValue : Number = 100,
	_barLength : uint = 20,
	_length : uint,
	_unitLength : Number = 0,
	_orientation : String = Orientation.H,
	_defValue : Number = 0,
	_thickness : uint,
	_smoothSpeed : Number = 0.25;

	public function ScrollBar() : void {
		super();
		_type = ControlType.SCROLL_BAR;

		fill(bgMC.graphics, 20, 200, bgColorArr[4]);
		fill(slider.graphics, 20, 50, bgColorArr[3], bgColorArr[4]);
		mc.addChild(bgMC);
		mc.addChild(slider);

		create();
	}

	public function copy() : ScrollBar {
		var sz : Array = size;
		var newDMUI : ScrollBar = new ScrollBar();
		newDMUI.create(x, y, value, _minValue, _maxValue, sz[0], sz[1]);
		newDMUI.defaultValue = _defValue;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : int = 0, _y : int = 0, defVal : Number = 0, minVal : Number = 0, maxVal : Number = 100, ori : String = Orientation.H, w : uint = 200, h : uint = 20) : void {
		x = _x;
		y = _y;
		_minValue = minVal;
		_maxValue = maxVal >= _minValue ? maxVal : _maxValue;
		_defValue = _value = defVal >= _minValue ? defVal <= _maxValue ? defVal : _maxValue : _minValue;

		orientation = ori;

		if (_orientation == Orientation.H) {
			_length = w;
		} else {
			_length = h;
		}

		size = [w, h];

		enabled = _enabled;
	}
	/** @private */
	protected override function _size_get() : Array {
		return [bgMC.width, bgMC.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		if (_orientation == Orientation.H) {
			_SizeValue[0] = Number(_SizeValue[0]) ? int(_SizeValue[0]) : _length ? _length : bgMC.width;
			_SizeValue[1] = Number(_SizeValue[1]) ? int(_SizeValue[1]) : _thickness ? _thickness : bgMC.height;
		} else {
			_SizeValue[0] = Number(_SizeValue[0]) ? int(_SizeValue[0]) : _thickness ? _thickness : bgMC.width;
			_SizeValue[1] = Number(_SizeValue[1]) ? int(_SizeValue[1]) : _length ? _length : bgMC.height;
		}
		bgMC.width = _SizeValue[0];
		bgMC.height = _SizeValue[1];
		_length = _orientation == Orientation.H ? _SizeValue[0] : _SizeValue[1];
		_thickness = _orientation == Orientation.H ? _SizeValue[1] : _SizeValue[0];
		var _x_y : Number = (_value - _minValue) / (_maxValue - _minValue) * (_length - _barLength);
		if (_orientation == Orientation.H) {
			slider.height = _SizeValue[1] - 1;
			slider.y = 0;
			slider.x = _x_y;
		} else {
			slider.width = _SizeValue[0] - 1;
			slider.x = 0;
			slider.y = _x_y;
		}
		checkSlider();
	}
	/** @private */
	protected override function _enabled_set() : void {
		if (_enabled) {
			slider.addEventListener(MouseEvent.MOUSE_DOWN, downFunc);
			slider.addEventListener(MouseEvent.MOUSE_OVER, overFunc);
			slider.addEventListener(MouseEvent.MOUSE_OUT, outFunc);
			bgMC.addEventListener(MouseEvent.MOUSE_DOWN, BGDOWN);
			addEventListener(MouseEvent.MOUSE_WHEEL, WHEEL);
		} else {
			slider.removeEventListener(MouseEvent.MOUSE_DOWN, downFunc);
			slider.removeEventListener(MouseEvent.MOUSE_OVER, overFunc);
			slider.removeEventListener(MouseEvent.MOUSE_OUT, outFunc);
			bgMC.removeEventListener(MouseEvent.MOUSE_DOWN, BGDOWN);
			removeEventListener(MouseEvent.MOUSE_WHEEL, WHEEL);
		}
	}

	private function overFunc(evt : MouseEvent) : void {
		fill(slider.graphics, 20, 50, bgColorArr[5], bgColorArr[4]);
		slider.alpha = .6;
	}

	private function outFunc(evt : MouseEvent) : void {
		fill(slider.graphics, 20, 50, bgColorArr[3], bgColorArr[4]);
		slider.alpha = 1.0;
	}

	public function reset() : void {
		value = _defValue;
	}

	public function set defaultValue(val : Number) : void {
		_defValue = val <= _maxValue ? val >= _minValue ? val : _minValue : _maxValue;
	}

	public function get defaultValue() : Number {
		return _defValue;
	}

	public function get length() : Number {
		return _length;
	}

	public function set length(leng : Number) : void {
		if(_barLength>leng){
			barLength = leng;
		}
		_length = leng;
		if (_orientation == Orientation.H) {
			size = [_length];
		} else {
			size = [bgMC.width, _length];
		}
	}

	public function get orientation() : String {
		return _orientation;
	}

	public function set orientation(str : String) : void {
		_orientation = str == Orientation.H || str == Orientation.V ? str : _orientation;
		barLength = _barLength;
	}

	private function downFunc(evt : MouseEvent) : void {
		overFunc(evt);
		slider.removeEventListener(MouseEvent.MOUSE_OVER, overFunc);
		slider.removeEventListener(MouseEvent.MOUSE_OUT, outFunc);
		if (_orientation == Orientation.H) {
			_xy = mc.mouseX - slider.x;
		} else {
			_xy = mc.mouseY - slider.y;
		}
		stage.addEventListener(MouseEvent.MOUSE_UP, upFunc);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
	}

	public function get barLength() : Number {
		return _barLength;
	}

	public function set barLength(num : Number) : void {
		if (_orientation == Orientation.H) {
			_barLength = slider.width = num <= bgMC.width ? num : bgMC.width;
			slider.height = bgMC.height - 1;
		} else {
			_barLength = slider.height = num <= bgMC.height ? num : bgMC.height;
			slider.width = bgMC.width - 1;
		}
		_SizeValue = Vector.<uint>([]);
		_size_set();
	}

	public function get value() : Number {
		if (_orientation == Orientation.H) {
			return slider.x / (bgMC.width - slider.width) * (_maxValue - _minValue) + _minValue;
		} else {
			return slider.y / (bgMC.height - slider.height) * (_maxValue - _minValue) + _minValue;
		}
	}

	public function set value(num : Number) : void {
		_value = num >= _minValue ? num <= _maxValue ? num : _maxValue : _minValue;
		_SizeValue = Vector.<uint>([]);
		_size_set();
	}

	public function upFunc(evt : MouseEvent) : void {
		outFunc(evt);
		slider.addEventListener(MouseEvent.MOUSE_OVER, overFunc);
		slider.addEventListener(MouseEvent.MOUSE_OUT, outFunc);
		stage.removeEventListener(MouseEvent.MOUSE_UP, upFunc);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
	}

	private function BGDOWN(evt : MouseEvent) : void {
		stage.addEventListener(Event.ENTER_FRAME, sliderMoving);
		stage.addEventListener(MouseEvent.MOUSE_UP, BGUP);
	}

	private function BGUP(evt : MouseEvent) : void {
		outFunc(evt);
		slider.addEventListener(MouseEvent.MOUSE_OVER, overFunc);
		slider.addEventListener(MouseEvent.MOUSE_OUT, outFunc);
		stage.removeEventListener(MouseEvent.MOUSE_UP, BGUP);
		stage.removeEventListener(Event.ENTER_FRAME, sliderMoving);
		onChange();
	}

	private function sliderMoving(evt : Event) : void {
		overFunc(_MouseEvent);
		slider.removeEventListener(MouseEvent.MOUSE_OVER, overFunc);
		slider.removeEventListener(MouseEvent.MOUSE_OUT, outFunc);
		if (_orientation == Orientation.H) {
			var oldXY : Number = slider.x;
			if (smooth && _unitLength == 0) {
				slider.x += (mc.mouseX - slider.x - slider.width / 2) * _smoothSpeed;
			} else {
				slider.x = mc.mouseX - slider.width / 2;
			}
			checkValue();
			if (oldXY != slider.x) {
				onChanging();
			}
		} else {
			oldXY = slider.y;
			if (smooth) {
				slider.y += (mc.mouseY - slider.y - slider.height / 2) * _smoothSpeed;
			} else {
				slider.y = mc.mouseY - slider.height / 2;
			}
			checkValue();
			if (oldXY != slider.y) {
				onChanging();
			}
		}
	}

	private function moveFunc(evt : MouseEvent) : void {
		if (_orientation == Orientation.H) {
			var oldXY : Number = slider.x;
			slider.x = mc.mouseX - _xy;
			checkValue();
			checkSlider();
			if (oldXY != slider.x) {
				onChanging();
			}
		} else {
			oldXY = slider.y;
			slider.y = mc.mouseY - _xy;
			checkValue();
			checkSlider();
			if (oldXY != slider.y) {
				onChanging();
			}
		}
	}

	private function checkSlider() : void {
		if (_orientation == Orientation.H) {
			if (slider.x < 0) {
				slider.x = 0;
			} else if (slider.x + slider.width > bgMC.width) {
				slider.x = bgMC.width - slider.width;
			}
		} else {
			if (slider.y < 0) {
				slider.y = 0;
			} else if (slider.y + slider.height > bgMC.height) {
				slider.y = bgMC.height - slider.height;
			}
		}
	}

	private function WHEEL(evt : MouseEvent) : void {
		var oldVal : Number = _value;
		if (_orientation == Orientation.H) {
			if (_unitLength > 0) {
				_value += evt.delta / 3 * _unitLength;
			} else {
				_value += evt.delta / 3;
			}
		} else {
			if (_unitLength > 0) {
				_value -= evt.delta / 3 * _unitLength;
			} else {
				_value -= evt.delta / 3;
			}
		}
		value = _value;
		checkSlider();
		if (oldVal != _value) {
			onChange();
		}
	}

	public function set unitLength(num : Number) : void {
		_unitLength = num >= 0 ? num : _unitLength;
		checkValue();
	}

	public function get unit() : Number {
		return _unitLength;
	}

	private function checkValue() : void {
		_value = value;
		if (_unitLength > 0) {
			_value = Math.round((_value - _minValue) / _unitLength) * _unitLength + _minValue;
			if (_value > _maxValue) {
				_value = _maxValue;
			} else if (_value < _minValue) {
				_value = _minValue;
			}
		}
		value = _value;
	}

	public function set maxValue(val : Number) : void {
		_maxValue = val >= _minValue ? val : _minValue;
		_value = _value > _maxValue ? _maxValue : _value;
		_SizeValue = Vector.<uint>([]);
		_size_set();
	}

	public function set minValue(val : Number) : void {
		_minValue = val <= _maxValue ? val : _maxValue;
		_value = _value < _minValue ? _minValue : _value;
		_SizeValue = Vector.<uint>([]);
		_size_set();
	}

	public function get maxValue() : Number {
		return _maxValue;
	}

	public function get minValue() : Number {
		return _minValue;
	}

	public function get thickness() : Number {
		return _thickness;
	}

	public function set thickness(num : Number) : void {
		_thickness = num > 0 ? num : 1;
		if (_orientation == Orientation.H) {
			size = [_length, _thickness];
		} else {
			size = [_thickness, _length];
		}
	}

	public function set smoothSpeed(spd : Number) : void {
		_smoothSpeed = spd > 1 ? 1 : spd < 0.01 ? 0.01 : spd;
	}

	public function get smoothSpeed() : Number {
		return _smoothSpeed;
	}
}
}
