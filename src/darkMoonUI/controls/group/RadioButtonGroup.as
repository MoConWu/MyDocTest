package darkMoonUI.controls.group {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.controls.RadioButton;

/**
 * @author Administrator
 */
public class RadioButtonGroup extends Group {
	private var
	_length : uint = 0,obj : Object = {};

	public function RadioButtonGroup() {
		super();
		obj["group"] = ControlType.RADIO_BUTTON;
	}

	public function get length() : uint {
		return _length;
	}

	public function set length(leng : uint) : void {
		_length = leng;
		var _value : Vector.<DarkMoonUIControl> = Vector.<DarkMoonUIControl>([]);
		for (var i : uint = 0; i < _length; i++) {
			var item : RadioButton = new RadioButton();
			item.create();
			_value.push(item);
		}
		value0 = _value;
	}

	private function changeVlaue(str : String, val : *) : void {
		var _typ : uint = 0;
		switch (str) {
			case "onChange":
			case "onSelected":
				if (val is Function) {
					obj[str] = val;
				} else {
					_typ = 1;
					obj[str] = Vector.<Function>([]);
				}
				break;
			case "label":
			case "font":
			case "group":
				if (!(val is Array) && !(val is Vector)) {
					obj[str] = String(val);
				} else {
					_typ = 1;
					obj[str] = Vector.<String>([]);
				}
				break;
			case "bold":
			case "italic":
			case "autoSize":
			case "showFocus":
			case "wrodWrap":
				if (!(val is Array) && !(val is Vector)) {
					obj[str] = Boolean(val);
				} else {
					_typ = 1;
					obj[str] = Vector.<Boolean>([]);
				}
				break;
			case "fontSize":
				if (!(val is Array) && !(val is Vector)) {
					obj[str] = val;
				} else {
					_typ = 1;
					obj[str] = Vector.<uint>([]);
				}
				break;
			case "color":
				if (!(val is Array) && !(val is Vector)) {
					obj[str] = uint(val);
				} else {
					_typ = 1;
					obj[str] = Vector.<Object>([]);
				}
				break;
			default:
				return;
		}
		if (_typ == 0) {
			for (var i : uint = 0; i < _length; i++) {
				var item : RadioButton = value0[i] as RadioButton;
				item[str] = val;
			}
		} else if (_typ == 1) {
			for (i = 0; i < _length; i++) {
				item = value0[i] as RadioButton;
				if (i < val["length"]) {
					switch (str) {
						case "onChange":
						case "onSelected":
							if (val[i] is Function) {
								item[str] = val[i];
							} else {
								item[str] = new Function();
							}
							break;
						case "label":
						case "font":
						case "group":
							item[str] = String(val[i]);
							break;
						case "bold":
						case "italic":
						case "autoSize":
						case "showFocus":
						case "wrodWrap":
							item[str] = Boolean(val[i]);
							break;
						case "fontSize":
							item[str] = uint(val[i]) > 0 ? uint(val[i]) : 1;
							break;
						case "color":
							item[str] = uint(val[i]);
							break;
					}
				}
				obj[str]["push"](item[str]);
			}
		}
	}

	public function get controls() : Vector.<RadioButton> {
		var _value : Vector.<RadioButton> = Vector.<RadioButton>([]);
		for (var i : uint = 0; i < value0.length; i++) {
			_value.push(value0[i] as RadioButton);
		}
		return _value;
	}

	public function set onChange(val : *) : void {
		if (val != undefined) {
			changeVlaue("onChange", val);
		}
	}

	public function get onChange() : * {
		return obj["onChange"];
	}

	public function set onSelected(val : *) : void {
		if (val != undefined) {
			changeVlaue("onSelected", val);
		}
	}

	public function get onSelected() : * {
		return obj["onSelected"];
	}

	public function set font(val : *) : void {
		if (val != undefined) {
			changeVlaue("font", val);
		}
	}

	public function get font() : * {
		return obj["font"];
	}

	public function set group(val : *) : void {
		if (val != undefined) {
			changeVlaue("group", val);
		}
	}

	public function get group() : * {
		return obj["group"];
	}

	public function set wordWrap(val : *) : void {
		if (val != undefined) {
			changeVlaue("wordWrap", val);
		}
	}

	public function get wordWrap() : * {
		return obj["wordWrap"];
	}

	public function set bold(val : *) : void {
		if (val != undefined) {
			changeVlaue("bold", val);
		}
	}

	public function get bold() : * {
		return obj["bold"];
	}

	public function set fontSize(val : *) : void {
		if (val != undefined) {
			changeVlaue("fontSize", val);
		}
	}

	public function get fontSize() : * {
		return obj["fontSize"];
	}

	public function set color(val : *) : void {
		if (val != undefined) {
			changeVlaue("color", val);
		}
	}

	public function get color() : * {
		return obj["color"];
	}

	public function set italic(val : *) : void {
		if (val != undefined) {
			changeVlaue("italic", val);
		}
	}

	public function get italic() : * {
		return obj["italic"];
	}

	public function set autoSize(val : *) : void {
		if (val != undefined) {
			changeVlaue("autoSize", val);
		}
	}

	public function get autoSize() : * {
		return obj["autoSize"];
	}

	public function set label(val : *) : void {
		if (val != undefined) {
			changeVlaue("label", val);
		}
	}

	public function get label() : * {
		return obj["label"];
	}

	public function set showFocus(val : *) : void {
		if (val != undefined) {
			changeVlaue("showFocus", val);
		}
	}

	public function get showFocus() : * {
		return obj["showFocus"];
	}
}
}
