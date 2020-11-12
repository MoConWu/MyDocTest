package darkMoonUI.controls {
import com.mocon.string.RegExpList;

import darkMoonUI.types.ControlType;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;
import darkMoonUI.assets.functions.getSystemFonts;
import darkMoonUI.assets.DarkMoonUIControl;

/**
 * @author moconwu
 */
public class FontComboBox extends DarkMoonUIControl implements DMUI_PUB_LABEL {
	public var onChange : Function;
	private var
	comboBox : ComboBox = new ComboBox(),
	getFonts : Array = getSystemFonts(),
	_format : String = "{font} Text 文本",
	_defaultItemsFont : ComboBoxItem = new ComboBoxItem();

	public function FontComboBox() {
		super();
		_type = ControlType.FONT_COMBO_BOX;

		comboBox.create(0, 0);
		comboBox.onChange = function() : void {
			if(onChange != null){
				onChange();
			}
		};

		comboBox.onFocusChange = function() : void {
			_lockfocus = comboBox.focus;
		};
		addChild(comboBox);
		create();
	}
	/** @private */
	protected override function _size_get() : Array {
		return comboBox.size;
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : comboBox.size[0];
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : comboBox.size[1];
		comboBox.regPoint = _regPoint;
		comboBox.size = [_SizeValue[0], _SizeValue[1]];
	}
	/** @private */
	protected override function _enabled_set() : void {
		comboBox.enabled = _enabled;
	}

	public function copy() : FontComboBox {
		var newDMUI : FontComboBox = new FontComboBox();
		var sz : Array = size;
		newDMUI.create(x, y, _defaultItemsFont, sz[0], sz[1]);
		newDMUI.defaultItemsFont = _defaultItemsFont;
		newDMUI.format = _format;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : int = 0, _y : int = 0, _dif : ComboBoxItem = null, w : uint = 150, h : uint = 26) : void {
		x = _x;
		y = _y;
		defaultItemsFont = _dif == null ? new ComboBoxItem() : _dif;
		comboBox.size = [w, h];
		enabled = _enabled;
	}

	public function get selection() : int {
		return comboBox.selection;
	}

	public override function get showFocus() : Boolean {
		return comboBox.showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		comboBox.showFocus = boo;
	}

	public function get font() : String {
		return comboBox.font;
	}

	public function set font(f : String) : void {
		comboBox.font = f;
	}

	public function get label() : String {
		return comboBox.label;
	}

	public function get color() : Object {
		return comboBox.color;
	}

	public function get fontSize() : uint {
		return comboBox.fontSize;
	}

	public function get bold() : Boolean {
		return comboBox.bold;
	}

	public function get items() : Vector.<ComboBoxItem> {
		return comboBox.items;
	}

	public function get wordWrap() : Boolean {
		return comboBox.wordWrap;
	}

	public function get multiline() : Boolean {
		return comboBox.multiline;
	}

	public function get autoSize() : Boolean {
		return comboBox.autoSize;
	}

	public function get item() : ComboBoxItem {
		return comboBox.item;
	}

	public function set autoSize(boo : Boolean) : void {
		comboBox.autoSize = boo;
	}

	public function set selection(num : int) : void {
		comboBox.selection = num;
	}

	public function set color(col : Object) : void {
		comboBox.color = col;
	}

	public function set fontSize(sz : uint) : void {
		comboBox.fontSize = sz;
	}

	public function set bold(boo : Boolean) : void {
		comboBox.bold = boo;
	}

	public function set wordWrap(boo : Boolean) : void {
		comboBox.wordWrap = boo;
	}

	public function set multiline(boo : Boolean) : void {
		comboBox.multiline = boo;
	}

	public function set label(lab : String) : void {
		comboBox.label = lab;
	}

	public function set italic(boo : Boolean) : void {
		comboBox.italic = boo;
	}

	public function get italic() : Boolean {
		return comboBox.italic;
	}

	public function set defaultItemsFont(boo : ComboBoxItem) : void {
		_defaultItemsFont = boo;
		createFonts();
	}

	public function get defaultItemsFont() : ComboBoxItem {
		return _defaultItemsFont;
	}

	public function get format() : String {
		return _format;
	}

	public function set format(f : String) : void {
		_format = f;
		createFonts();
	}

	private function createFonts() : void {
		comboBox.items = new Vector.<ComboBoxItem>();
		for (var i : uint = 0; i < getFonts.length; i++) {
			var it : ComboBoxItem = _defaultItemsFont.copy();
			it.label = RegExpList(_format, ["{font}"], [getFonts[i]]);
			it.value = getFonts[i];
			if (_defaultItemsFont.font == null) {
				it.font = getFonts[i];
			}
			comboBox.addItem(it);
		}
	}
}
}
