package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.numCheck;

import flash.display.Shape;
import flash.events.Event;

/**
 * @author Administrator
 */
public class ProgressBar extends DarkMoonUIControl {
	public var onChange : Function = new Function();
	public var onChanging : Function = new Function();
	public var smooth : Boolean = true;

	private var
	_sz : Array = [150, 25],
	valueMC : Shape = new Shape(),
	borderMC : Shape = new Shape(),
	_value : Number = 0,
	_anValue : Number = 0,
	_minValue : Number = 0,
	_maxValue : Number = 100,
	_color : uint = bgColorArr[6],
	_added : Boolean = false,
	_smoothSpeed : Number = .25;

	public function ProgressBar(val : Number = 0, minVal : Number = 0, maxVal : Number = 100) {
		super();
		_type = ControlType.PROGRESS_BAR;

		fill(valueMC.graphics, 10, 10, _color);
		fill(borderMC.graphics, 10, 10, -1, bgColorArr[4]);

		mc.addChild(valueMC);
		mc.addChild(borderMC);

		addEventListener(Event.ADDED_TO_STAGE, function(evt : Event) : void {
			_added = true;
		});
		addEventListener(Event.REMOVED_FROM_STAGE, function(evt : Event) : void {
			_added = false;
		});

		create(0, 0, val, minVal, maxVal);
	}

	public function copy() : ProgressBar {
		var newDMUI : ProgressBar = new ProgressBar();
		var sz : Array = size;
		newDMUI.create(x, y, _value, _minValue, _maxValue, sz[0], sz[1]);
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : uint = 0, _y : uint = 0, val : Number = 0, minVal : Number = 0, maxVal : Number = 100, w : uint = 200, h : uint = 5) : void {
		x = _x;
		y = _y;

		_minValue = minVal;
		_maxValue = maxVal >= minVal ? maxVal : minVal;

		_value = val >= minVal ? val <= maxVal ? val : maxVal : minVal;

		size = [w, h];

		enabled = _enabled;
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

		borderMC.width = _sz[0] = _SizeValue[0];
		valueMC.height = borderMC.height = _sz[1] = _SizeValue[1];
		if (smooth && _added) {
			valueMC.width = (_anValue - _minValue) / (_maxValue - _minValue) * _SizeValue[0];
		} else {
			_anValue = _value;
			valueMC.width = (_value - _minValue) / (_maxValue - _minValue) * _SizeValue[0];
		}
		fill(mc.graphics, _sz[0], _sz[1], bgColorArr[4]);
	}
	/** @private */
	protected override function _enabled_set() : void {
		if (_enabled) {
			valueMC.alpha = 1.0;
		} else {
			valueMC.alpha = .4;
		}
	}

	public function get value() : Number {
		return _value;
	}

	public function set value(val : Number) : void {
		val = numCheck(val, _minValue, _maxValue);
		_value = val;
		if (smooth && _added) {
			stage.removeEventListener(Event.ENTER_FRAME, startMoving);
			stage.addEventListener(Event.ENTER_FRAME, startMoving);
		} else {
			move();
		}
	}

	private function startMoving(evt : Event) : void {
		_anValue += (_value - _anValue) * _smoothSpeed;
		if (Math.abs(_value - _anValue) <= 1) {
			_anValue = _value;
			stage.removeEventListener(Event.ENTER_FRAME, startMoving);
			move();
		}
		_SizeValue = Vector.<uint>([]);
		_size_set();
		onChanging();
	}

	private function move() : void {
		_SizeValue = Vector.<uint>([]);
		_size_set();
		onChange();
	}

	public function get maxValue() : Number {
		return _maxValue;
	}

	public function set maxValue(val : Number) : void {
		_maxValue = val;
		if (val <= _minValue) {
			_minValue = val;
		}
		var newValue : Number = numCheck(_value, _minValue, _maxValue);
		if (newValue != _value) {
			value = newValue;
		}
		move();
	}

	public function get minValue() : Number {
		return _minValue;
	}

	public function set minValue(val : Number) : void {
		_minValue = val;
		if (val >= _maxValue) {
			_maxValue = val;
		}
		var newValue : Number = numCheck(_value, _minValue, _maxValue);
		if (newValue != _value) {
			value = newValue;
		}
		move();
	}

	public function set color(col : Object) : void {
		_color = int(col);
		fill(valueMC.graphics, 10, 10, _color);
		_SizeValue = Vector.<uint>([]);
		_size_set();
	}

	public function get color() : Object {
		return "0x" + uint(_color).toString(16);
	}

	public function set smoothSpeed(spd : Number) : void {
		_smoothSpeed = spd > 1 ? 1 : spd < 0.01 ? 0.01 : spd;
	}

	public function get smoothSpeed() : Number {
		return _smoothSpeed;
	}

	public override function get showFocus() : Boolean {
		return false;
	}

	public override function set showFocus(boo : Boolean) : void {
	}
}
}
