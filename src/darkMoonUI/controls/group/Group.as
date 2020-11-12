package darkMoonUI.controls.group {
import darkMoonUI.controls.orientation.Orientation;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Shape;

import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.controls.regPoint.RegPointAlign;

/** @private */
internal class Group extends Shape {
	private var
	_value : Vector.<DarkMoonUIControl> = Vector.<DarkMoonUIControl>([]),
	_stage : Sprite,
	_spacing : uint = 0,
	_orientation : String = Orientation.H,
	_regPoint : Array = RegPointAlign.LEFT_TOP.slice();

	public function Group() {
		addEventListener(Event.ADDED_TO_STAGE, ADDED);
		addEventListener(Event.REMOVED_FROM_STAGE, REMOVED);
		addEventListener(Event.ADDED_TO_STAGE, ACTIVATE);
	}

	private function ADDED(evt : Event) : void {
		_stage = this.parent as Sprite;
		refresh();
	}

	private function REMOVED(evt : Event) : void {
		remove();
		_stage = null;
	}

	private function ACTIVATE(evt : Event) : void {
		refresh();
	}

	public function refresh() : void {
		if (_stage != null) {
			for (var i : uint = 0; i < _value.length; i++) {
				createOne(i);
			}
		}
	}

	private function createOne(i : uint) : void {
		if (_orientation == Orientation.H) {
			_value[i].y = y;
			_value[i].x = x;
			if (i > 0) {
				_value[i].x = _value[i - 1].x + _value[i - 1].size[0] + _spacing;
			}
		} else {
			_value[i].x = x;
			_value[i].y = y;
			if (i > 0) {
				_value[i].y = _value[i - 1].y + _value[i - 1].size[1] + _spacing;
			}
		}
		if(rotationX!=0){
			_value[i].rotationX = rotationX;
		}
		if(rotationY!=0){
			_value[i].rotationY = rotationY;
		}
		if(rotationZ!=0){
			_value[i].rotationZ = rotationZ;
		}
		if(z!=0){
			_value[i].z = z;
		}
		_stage.addChild(_value[i]);
	}

	private function remove() : void {
		if (_stage != null) {
			for (var i : uint = 0; i < _value.length; i++) {
				try {
					_stage.removeChild(_value[i]);
				} catch (e : Error) {
					trace(e);
				}
			}
		}
	}

	public function set orientation(ori : String) : void {
		ori = ori == Orientation.H || ori == Orientation.V ? ori : _orientation;
		if(_orientation == ori){
			return;
		}
		refresh();
	}

	public function get orientation() : String {
		return _orientation;
	}

	public function get spacing() : uint {
		return _spacing;
	}

	public function set spacing(spc : uint) : void {
		_spacing = spc;
		refresh();
	}
	/** @private */
	protected function get value0() : Vector.<DarkMoonUIControl> {
		return _value;
	}
	/** @private */
	protected function set value0(val : Vector.<DarkMoonUIControl>) : void {
		remove();
		_value = Vector.<DarkMoonUIControl>([]);
		for (var i : uint = 0; i < val.length; i++) {
			_value.push(val[i]);
		}
		regPoint = [];
		refresh();
	}

	public function get regPoint() : Array {
		return _regPoint;
	}

	public function set regPoint(rp : Array) : void {
		_regPoint[0] = rp[0] == "left" || rp[0] == "center" || rp[0] == "right" ? rp[0] : _regPoint[0];
		_regPoint[1] = rp[1] == "top" || rp[1] == "center" || rp[1] == "bottom" ? rp[1] : _regPoint[1];
		for (var i : uint = 0; i < _value.length; i++) {
			_value[i].regPoint = _regPoint;
		}
	}
}

}