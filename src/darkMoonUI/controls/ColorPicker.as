package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.ColorPickerBox;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.functions.ownerWindow;

import flash.system.System;
import flash.events.Event;
import flash.display.NativeMenuItem;
import flash.display.NativeMenu;
import flash.events.MouseEvent;
import flash.display.Sprite;
import flash.display.Shape;

public class ColorPicker extends DarkMoonUIControl {
	public var onChange : Function;
	public var onChanging : Function;

	private var
	_canChange : Boolean = true,
	bg : Sprite = new Sprite(),
	_selectMC : Shape = new Shape(),
	Picker : ColorPickerBox = new ColorPickerBox(),
	_color : uint,
	_showFocus : Boolean = true,
	_panelTyp : String = "custom",
	copyMenu : NativeMenuItem = new NativeMenuItem("复制"),
	pasteMenu : NativeMenuItem = new NativeMenuItem("粘贴"),
	thisMenu : NativeMenu = new NativeMenu();

	public function ColorPicker() {
		super();
		_type =  ControlType.COLOR_PICKER;

		copyMenu.addEventListener(Event.SELECT, copyColor);
		pasteMenu.addEventListener(Event.SELECT, paseColor);
		thisMenu.addItem(copyMenu);
		thisMenu.addItem(pasteMenu);

		fill(bg.graphics, 10, 10, 0xFF0000, bgColorArr[1]);
		fill(_selectMC.graphics, 10, 10, bgColorArr[2]);
		_selectMC.visible = false;

		Picker.onChange = function() : void {
			color = Picker.newColor;
			if(onChange != null){
				onChange();
			}
		};
		Picker.onChanging = function() : void {
			color = Picker.newColor;
			if(onChanging != null){
				onChanging();
			}
		};

		Picker.onCancel = function() : void {
			color = uint(Picker.oldColor);
			if(onChanging != null){
				onChanging();
			}
		};

		Picker.onClose = function() : void {
			color = Picker.oldColor;
			stage.focus = mc;
		};

		mc.addChild(_selectMC);
		mc.addChild(bg);

		this.addChild(Picker);
		create();
	}
	/** @private */
	protected override function _size_get() : Array {
		return [bg.width, bg.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		var w : uint = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : bg.width;
		var h : uint = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : bg.height;
		bg.width = w;
		bg.height = h;
		_selectMC.width = w + 3;
		_selectMC.height = h + 3;
		_selectMC.x = _selectMC.y = -1;
		_SizeValue = Vector.<uint>([bg.width, bg.height]);
	}
	/** @private */
	protected override function _focus_in() : void {
		_selectMC.visible = true;
	}
	/** @private */
	protected override function _focus_out() : void {
		_selectMC.visible = false;
	}
	/** @private */
	protected override function _enabled_set() : void {
		if (_enabled) {
			bg.addEventListener(MouseEvent.CLICK, click);
			contextMenu = thisMenu;
		} else {
			_selectMC.visible = false;
			bg.removeEventListener(MouseEvent.CLICK, click);
			contextMenu = null;
		}
	}
	/** @private */
	protected override function _mouseRightDown() : void {
		pasteMenu.enabled = clipboardValue["type"] == ControlType.COLOR_PICKER;
	}

	public function copy() : ColorPicker {
		var newDMUI : ColorPicker = new ColorPicker();
		var sz : Array = size;
		newDMUI.create(x, y, _color, title, sz[0], sz[1]);
		newDMUI.canChange = _canChange;
		newDMUI.preview = preview;
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(x : uint = 0, y : uint = 0, col : Object = 0xFF0000, _t : String = "色彩选择", w : uint = 40, h : uint = 20) : void {
		this.x = x;
		this.y = y;
		color = col;
		size = [w, h];
		title = _t;
		enabled = _enabled;
	}

	private function copyColor(evt : Event) : void {
		clipboardValue["type"] = ControlType.COLOR_PICKER;
		clipboardValue["value"] = color;
		System.setClipboard(color.toString());
	}

	private function paseColor(evt : Event) : void {
		if (clipboardValue["type"] == ControlType.COLOR_PICKER) {
			color = clipboardValue["value"];
			if(onChange != null){
				onChange();
			}
		}
	}

	public function set title(t : String) : void {
		Picker.title = t;
	}

	public function get title() : String {
		return Picker.title;
	}

	private function click(evt : MouseEvent) : void {
		if (_canChange) {
			Picker.show(_color);
			ownerWindow(stage.nativeWindow, Picker.window);
		}
	}

	public function set canChange(boo : Boolean) : void {
		_canChange = boo;
		try {
			if (boo) {
				thisMenu.addItem(pasteMenu);
			} else {
				thisMenu.removeItem(pasteMenu);
			}
		} catch (e : Error) {
		}
	}

	public function get canChange() : Boolean {
		return _canChange;
	}

	public function set colorPanelType(typ : String) : void {
		_panelTyp = typ;
	}

	public function get colorPanelType() : String {
		return _panelTyp;
	}

	public function set color(col : Object) : void {
		if (_color != uint(col)) {
			fill(bg.graphics, 10, 10, uint(col), bgColorArr[1]);
		}
		_color = int(col);
	}

	public function get color() : Object {
		return "0x" + uint(_color).toString(16);
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
		_selectMC.alpha = uint(boo);
	}

	public function get preview() : Boolean {
		return Picker.preview;
	}

	public function set preview(boo : Boolean) : void {
		Picker.preview = boo;
	}
}
}
