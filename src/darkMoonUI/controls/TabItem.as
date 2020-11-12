package darkMoonUI.controls {
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.types.ControlItemType;

/**
 * @author moconwu
 */
public class TabItem extends Object{
	public var onSelected : Function;
	/** @private */
	internal var
	_selectTab : Function = new Function();
	private var
	_tabP : TabWidget,
	_controls : Vector.<DarkMoonUIControl> = Vector.<DarkMoonUIControl>([]),
	_label : String = "",
	_labelColor : Object = textColorArr[2],
	_bgColor : Object = bgColorArr[3],
	_enabled : Boolean = true,
	_tempEnabled : Boolean = false;
	private static const _type : String = ControlItemType.TAB_ITEM;

	public function TabItem(lab:String="Tab") {
		label = lab;
	}

	public function set parent(p : TabWidget) : void {
		trace("---parent---",p,this);
		if (p != _tabP) {
			if (_tabP != null) {
				_tabP.removeTab(this);
			}
			_tabP = p;
			if (_tabP != null) {
				_tabP.size = [];
			}
		}
	}
	/** @private */
	internal function setParent(p : TabWidget) : void {
		_tabP = p;
		if (_tabP != null) {
			_tabP.size = [];
		}
	}

	public function get parent() : TabWidget {
		return _tabP;
	}

	public function get label() : String {
		return _label;
	}

	public function set label(str : String) : void {
		_label = str;
		if (_tabP != null) {
			_tabP.size = [];
		}
	}

	public function get controls() : Vector.<DarkMoonUIControl> {
		return _controls;
	}

	public function set controls(ctls : Vector.<DarkMoonUIControl>) : void {
		_controls = ctls;
		if (_tabP != null) {
			_tabP.size = [];
		}
	}

	public function addControl(ctl : DarkMoonUIControl) : void {
		_controls.push(ctl);
		if (_tabP != null) {
			_tabP.size = [];
		}
	}

	public function addControls(ctls : Vector.<DarkMoonUIControl>) : void {
		for each(var ctl : DarkMoonUIControl in ctls){
			addControl(ctl);
		}
	}

	public function removeControls(ctls : Vector.<DarkMoonUIControl>) : void {
		for each(var ctl : DarkMoonUIControl in ctls){
			removeControl(ctl);
		}
	}

	public function removeControl(ctl : DarkMoonUIControl) : void {
		for (var i : uint = 0; i < _controls.length; i++) {
			if (ctl == _controls[i]) {
				_controls.removeAt(i);
				if (_tabP != null) {
					_tabP.size = [];
				}
				return;
			}
		}
	}

	public function remove() : void {
		_tabP.removeTab(this);
		_tabP = null;
	}

	public function get labelColor() : Object {
		return _labelColor;
	}

	public function set labelColor(col : Object) : void {
		_labelColor = col;
		if (_tabP != null) {
			_tabP.size = [];
		}
	}

	public function get backgroundColor() : Object {
		return _bgColor;
	}

	public function set backgroundColor(col : Object) : void {
		_bgColor = col;
		if (_tabP != null) {
			_tabP.size = [];
			_tabP.refreshColor();
		}
	}

	public function set enabled(boo : Boolean) : void {
		if (_enabled == boo) {
			return;
		}
		_enabled = boo;
		for (var i : uint = 0; i < _controls.length; i++) {
			_controls[i].enabled = boo;
		}
		if (_tabP != null) {
			_tabP.size = [];
		}
	}

	public function get enabled() : Boolean {
		return _enabled;
	}

	public function get tempEnabled() : Boolean {
		return _tempEnabled;
	}

	public function set tempEnabled(boo : Boolean) : void {
		_tempEnabled = boo;
		for (var i : uint = 0; i < _controls.length; i++) {
			_controls[i].tempEnabled = boo;
		}
		if (_tabP != null) {
			_tabP.size = [];
		}
	}

	public static function get type() : String {
		return _type;
	}
}
}
