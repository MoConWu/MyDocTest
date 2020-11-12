package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.functions.parentAddChilds;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.fill_circle;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * @author moconwu
 */
public class RadioButton extends DarkMoonUIControl implements DMUI_PUB_LABEL {
	public var onChange : Function;
	public var onSelected : Function;
	private var
	_group : String = ControlType.RADIO_BUTTON,
	_selected : Boolean,
	_autoSize : Boolean = true,
	overMC : Shape = new Shape(),
	_selectedMC : Shape = new Shape(),
	_selectionMC : Shape = new Shape(),
	_label : TextField = new TextField(),
	_selectMC : Shape = new Shape(),
	ttf : TextFormat = setTF(textColorArr[0]),
	bgMC : Shape = new Shape(),
	_showFocus : Boolean = true;

	public function RadioButton(lab:String=ControlType.RADIO_BUTTON, sel:Boolean=true, grp:String=ControlType.RADIO_BUTTON) : void {
		super();
		_type = ControlType.RADIO_BUTTON;

		fill_circle(bgMC.graphics, 6, bgColorArr[8]);
		fill_circle(overMC.graphics, 6, bgColorArr[0]);
		fill_circle(_selectedMC.graphics, 3, textColorArr[1]);
		fill_circle(_selectionMC.graphics, 8, bgColorArr[2]);
		fill(_selectMC.graphics);
		overMC.visible = _label.wordWrap = _label.selectable = _selectedMC.visible = _selectionMC.visible = false;
		_selectMC.alpha = 0;
		_label.text = lab;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		_label.x = 20;
		_label.height = 23;
		overMC.x = bgMC.x = _selectedMC.x = _selectionMC.x = 10;
		overMC.y = bgMC.y = _selectedMC.y = _selectionMC.y = 12.5;

		addEventListener(Event.ADDED_TO_STAGE, ADDED);

		parentAddChilds(mc, Vector.<DisplayObject>([
			_selectionMC, bgMC, overMC, _selectedMC, _label, _selectMC
		]));

		create(0, 0, lab, grp, sel);
	}

	public function copy() : RadioButton {
		var newDMUI : RadioButton = new RadioButton();
		var sz : Array = size;
		newDMUI.create(x, y, _label.text, group, selected, _autoSize, sz[0], sz[1]);
		newDMUI.showFocus = _showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x:int=0, _y:int=0, lab:String=ControlType.RADIO_BUTTON, grp:String=ControlType.RADIO_BUTTON, sel:Boolean=true, au:Boolean=true, w:uint=100, h:uint=23) : void {
		x = _x;
		y = _y;

		_label.text = lab;
		group = grp;
		_autoSize = au;
		size = [h, w];
		enabled = _enabled;
		selected = sel;
	}
	/** @private */
	protected override function _size_get() : Array {
		return [_selectMC.width, _selectMC.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _label.width + 20;
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : 23;
		if (_autoSize) {
			_label.autoSize = "left";
			_label.width = _SizeValue[0];
			_label.height = _SizeValue[1];
			_SizeValue[0] = _label.width + 20;
			_SizeValue[1] = _label.height;
		}
		_selectMC.width = _SizeValue[0];
		_selectMC.height = _SizeValue[1];
		boxBound();
	}
	/** @private */
	protected override function _focus_in() : void {
		_selectionMC.visible = _showFocus;
	}
	/** @private */
	protected override function _focus_out() : void {
		if (_enabled) {
			_selectionMC.visible = false;
		}
	}
	/** @private */
	protected override function _mouseOut() : void {
		overMC.visible = false;
	}
	/** @private */
	protected override function _mouseOver() : void {
		overMC.visible = true;
	}
	/** @private */
	protected override function _mouseDown() : void {
		selected = true;
	}
	/** @private */
	protected override function _keyDown() : void {
		if (_KeyboardEvent.keyCode == 13 && !_selected) {
			selected = true;
		}
	}

	public function set group(grp : String) : void {
		_group = grp;
		selected = _selected;
	}

	public function get group() : String {
		return _group;
	}

	public function get font() : String {
		return ttf.font;
	}

	public function set font(f : String) : void {
		ttf.font = f;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
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

	public function get wordWrap() : Boolean {
		return _label.wordWrap;
	}

	public function get multiline() : Boolean {
		return _label.multiline;
	}

	public function get bold() : Boolean {
		return ttf.bold;
	}

	public function set bold(boo : Boolean) : void {
		ttf.bold = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function set fontSize(sz : uint) : void {
		ttf.size = sz;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function get fontSize() : uint {
		return int(ttf.size);
	}

	public function set color(col : Object) : void {
		ttf.color = col;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get color() : Object {
		return "0x" + uint(ttf.color).toString(16);
	}

	public function set italic(boo : Boolean) : void {
		ttf.italic = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get italic() : Boolean {
		return ttf.italic;
	}

	private function ADDED(evt : Event) : void {
		removeEventListener(Event.ADDED_TO_STAGE, ADDED);
		addEventListener(Event.REMOVED_FROM_STAGE, REMOVE);
		if (!lock) {
			selected = _selected;
		}
	}

	private function REMOVE(evt : Event) : void {
		addEventListener(Event.ADDED_TO_STAGE, ADDED);
		if (!lock) {
			selected = false;
		}
	}

	public function get selected() : Boolean {
		return _selected;
	}

	public function set selected(boo : Boolean) : void {
		var oldSel : Boolean = _selected;
		if (oldSel != boo) {
			_selectedMC.visible = _selected = boo;
			if (boo) {
				try {
					var tP : * = this.parent;
					var numChild : uint = int(tP.numChildren);
				} catch (err : Error) {
					return;
				}
				for (var i : uint = 0; i < numChild; i++) {
					try {
						var item : RadioButton = tP.getChildAt(i) as RadioButton;
						if (item.type == type && item.group == group && item != this) {
							item.selected = false;
						}
					} catch (err : Error) {
					}
				}
				if(onSelected != null){
					onSelected();
				}
			}
			if(onChange != null){
				onChange();
			}
		}
		try {
			tP = this.parent as Sprite;
			numChild = int(tP.numChildren);
		} catch (err : Error) {
			return;
		}
		var sel : uint = 0;
		var selObj : Array = [];
		for (i = 0; i < numChild; i++) {
			try {
				item = tP.getChildAt(i) as RadioButton;
				if (item.type == type && item.group == group) {
					sel += item.value;
					selObj.push(item);
				}
			} catch (err : Error) {
			}
		}
		if (boo && sel > 1) {
			for (i = 0; i < selObj.length; i++) {
				if (selObj[i]["selected"]) {
					selObj[i]["selected"] = false;
					sel--;
					if (sel == 1) {
						return;
					}
				}
			}
		} else if (!boo && sel == 0) {
			selObj[0]["selected"] = true;
		}
	}

	public function get value() : uint {
		return int(_selected);
	}

	public function set value(val : uint) : void {
		selected = Boolean(val);
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function get label() : String {
		return _label.text;
	}

	public function set label(lab : String) : void {
		_label.text = lab;
		size = [];
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
	}

	private function boxBound() : void {
		_selectionMC.y = _selectedMC.y = bgMC.y = overMC.y = _selectMC.height / 2 + _selectMC.y;
		overMC.x = bgMC.x = _selectedMC.x = _selectionMC.x = _selectMC.x + 10;
		_label.x = _selectMC.x + 20;
		_label.y = (_selectMC.height - _label.height) / 2;
	}
}
}
