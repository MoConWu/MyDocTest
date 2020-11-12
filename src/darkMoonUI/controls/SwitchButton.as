package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.functions.parentAddChilds;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.DarkMoonUIControl;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Shape;

/**
 * @author moconwu
 */
public class SwitchButton extends DarkMoonUIControl {
	public var onChange : Function;
	public var defaultValue : Boolean = true;
	public var smooth : Boolean = true;
	private var
	btn : Shape = new Shape(),
	bg : Shape = new Shape(),
	_selectedMC : Shape = new Shape(),
	_selection : Shape = new Shape(),
	_showFocus : Boolean = true,
	_selected : Boolean = true,
	_added : Boolean = false,
	_smoothSpeed : Number = .25;

	public function SwitchButton() {
		super();
		_type = ControlType.SWITCH_BUTTON;

		fill(bg.graphics, 10, 10, bgColorArr[4], bgColorArr[4]);
		fill(_selection.graphics, 10, 10, bgColorArr[2]);
		fill(btn.graphics, 10, 10, bgColorArr[5], bgColorArr[4]);
		fill(_selectedMC.graphics, 10, 10, bgColorArr[2]);

		_selection.visible = false;

		parentAddChilds(mc, Vector.<DisplayObject>([
			_selection, bg, _selectedMC, btn
		]));

		addEventListener(Event.ADDED_TO_STAGE, function(evt : Event) : void {
			_added = true;
		});
		addEventListener(Event.REMOVED_FROM_STAGE, function(evt : Event) : void {
			_added = false;
		});

		create();
	}

	public function copy() : SwitchButton {
		return null;
	}

	public function create(_x : int = 0, _y : int = 0, _defV : Boolean = true, w : uint = 30, h : uint = 15) : void {
		x = _x;
		y = _y;
		defaultValue = _defV;

		size = [w, h];

		enabled = _enabled;
	}
	/** @private */
	protected override function _focus_in() : void {
		_selection.visible = true;
	}
	/** @private */
	protected override function _focus_out() : void {
		_selection.visible = false;
	}
	/** @private */
	protected override function _size_get() : Array {
		return [bg.width, bg.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : bg.width;
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : bg.height;

		bg.width = _SizeValue[0];
		_selectedMC.width = _SizeValue[0];
		_selectedMC.height = _SizeValue[1] - 1;
		_selectedMC.y = 1;
		bg.height = btn.height = _SizeValue[1];
		btn.width = _SizeValue[0] / 2;
		_selection.width = _SizeValue[0] + 3;
		_selection.height = _SizeValue[1] + 3;
		_selection.x = _selection.y = -1;
	}
	/** @private */
	protected override function _enabled_set() : void {
		if (_enabled) {
			addEventListener(MouseEvent.CLICK, click);
		} else {
			removeEventListener(MouseEvent.CLICK, click);
		}
	}
	/** @private */
	protected override function _keyDown():void{
		if(_KeyboardEvent.keyCode==13){
			selected = !_selected;
		}
	}

	private function click(...args) : void {
		if (smooth && _added) {
			removeEventListener(MouseEvent.CLICK, click);
			stage.addEventListener(Event.ENTER_FRAME, changing);
		} else {
			change();
		}
	}

	private function changing(evt : Event) : void {
		btn.x += (Number(_selected) * bg.width / 2 - btn.x) * _smoothSpeed;
		_selectedMC.alpha += (Number(!_selected) - _selectedMC.alpha) * _smoothSpeed * .7;
		if (Math.abs(Number(_selected) * bg.width / 2 - btn.x) <= 1) {
			stage.removeEventListener(Event.ENTER_FRAME, changing);
			addEventListener(MouseEvent.CLICK, click);
			change();
		}
	}

	private function change() : void {
		btn.x = Number(_selected) * bg.width / 2;
		_selected = !_selected;
		_selectedMC.alpha = Number(_selected);
		if(onChange != null){
			onChange();
		}
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_selection.visible = _showFocus = boo;
		_selection.alpha = Number(boo);
	}

	public function set value(val : uint) : void {
		selected = Boolean(val);
	}

	public function get value() : uint {
		return Number(_selected);
	}

	public function set selected(boo : Boolean) : void {
		if (boo != _selected) {
			click();
		}
	}

	public function get selected() : Boolean {
		return _selected;
	}

	public function reset() : void {
		selected = defaultValue;
	}

	public function set smoothSpeed(spd : Number) : void {
		_smoothSpeed = spd > 1 ? 1 : spd < 0.01 ? 0.01 : spd;
	}

	public function get smoothSpeed() : Number {
		return _smoothSpeed;
	}
}
}
