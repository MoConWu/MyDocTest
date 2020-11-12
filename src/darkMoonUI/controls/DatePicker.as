package darkMoonUI.controls {
import com.mocon.string.RegExpList;

import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.DatePickerBox;
import darkMoonUI.assets.functions.moveMouse;
import darkMoonUI.controls.datePicker.DatePickerFormat;

import flash.display.NativeWindowSystemChrome;
import flash.display.NativeWindowType;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.display.NativeWindow;
import flash.system.Capabilities;
import flash.display.NativeWindowInitOptions;
import flash.display.Shape;

/**
 * @author moconwu
 */
public class DatePicker extends DarkMoonUIControl implements DMUI_PUB_LABEL {
	public var onChange : Function;
	public var isLoopList : Boolean = false;
	/** @private */
	protected var
	_label : InputText = new InputText(),
	listPanel : NativeWindow,
	appWindow : NativeWindow;
	private static const
	resolutionY : uint = Capabilities.screenResolutionY,
	ReExpFunc0 : Array = [
		DatePickerFormat.YEAR_FULL,
		DatePickerFormat.MONTH_SHORT,
		DatePickerFormat.DATE_SHORT,
		DatePickerFormat.YEAR_SHORT,
		DatePickerFormat.MONTH_FULL,
		DatePickerFormat.DATE_FULL,
		DatePickerFormat.WEEK_SHORT,
		DatePickerFormat.WEEK_FULL
	];
	private var
	iconBtn : IconButton = new IconButton(),
	nwo : NativeWindowInitOptions = new NativeWindowInitOptions(),
	listMC : DatePickerBox = new DatePickerBox(),
	_format : String = DatePickerFormat.ISO_8601_SHORT_YEAR_START,
	_selectedMC : Shape = new Shape(),
	_date : Date = new Date(),
	_showFocus : Boolean = true,
	_autoSize : Boolean = false,
	_canChange : Boolean = true,
	_pickerBorder : Boolean = true;

	public function DatePicker() {
		super();
		_type = ControlType.DATE_PICKER;

		_selectedMC.visible = false;
		fill(_selectedMC.graphics, 10, 2, bgColorArr[2]);
		_selectedMC.x = - 2;
		_selectedMC.y = - 2;
		_label.x = 25;

		nwo.systemChrome = NativeWindowSystemChrome.NONE;
		nwo.type = NativeWindowType.UTILITY;
		nwo.transparent = true;

		_alpha = 1.0;
		tabEnabled = _label.tabEnabled = false;

		_label.onFocusChange = iconBtn.onFocusChange = function() : void {
			_lockfocus = _label.focus ? _label.focus : iconBtn.focus;
		};
		iconBtn.onClick = function() : void {
			DOWN();
		};

		listMC.onSelected = function(t : Number) : void {
			if (t > 0) {
				if (_date == null) {
					_date = new Date();
				}
				_date.time = t;
				setFormat(t);
			}
			try {
				listPanel.close();
			} catch (err : Error) {
			}
		};

		listMC.onChangeMonth = function(t : Number) : void {
			var oldY : uint = listPanel.y;
			showBox(t);
			var num : uint = listPanel.y - oldY;
			if (num != 0) {
				moveMouse(0, num);
			}
		};

		_label.create(25, 0, "");
		iconBtn.create(0, 0);
		iconBtn.spacing = 2;
		iconBtn.base64 = "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";
		_label.edit = _label.showFocus = iconBtn.showFocus = false;

		mc.addChild(_selectedMC);
		mc.addChild(_label);
		mc.addChild(iconBtn);

		create();
	}
	/** @private */
	protected override function _size_get() : Array {
		var sz : Array = _label.size;
		return [25 + sz[0], sz[1]];
	}
	/** @private */
	protected override function _size_set() : void {
		var sz : Array = _label.size;
		_SizeValue.length = 2;
		var w : uint = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : sz[0] + 25;
		var h : uint = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : sz[1];

		if (_autoSize) {
			_label.autoSize = true;
			sz = _label.size;
			w = sz[0] + 25;
			h = sz[1];
		} else {
			_label.autoSize = false;
			_label.size = [w - 25, h];
		}

		_selectedMC.width = w + 5;
		_selectedMC.height = h + 5;

		iconBtn.size = [25, h + 1];
		_SizeValue = Vector.<uint>([25 + sz[0], sz[1]]);
	}
	/** @private */
	protected override function _focus_in() : void {
		_selectedMC.visible = _showFocus;
	}
	/** @private */
	protected override function _focus_out() : void {
		_selectedMC.visible = false;
	}
	/** @private */
	protected override function _enabled_set() : void {
		_label.enabled = iconBtn.enabled = _enabled;
		if(_enabled){
			_label.addEventListener(KeyboardEvent.KEY_UP, UP);
		}else{
			_label.removeEventListener(KeyboardEvent.KEY_UP, UP);
		}
	}
	/** @private */
	protected override function _keyDown() : void {
		if (_KeyboardEvent.keyCode == 27) {
			try {
				listPanel.close();
			} catch (err : Error) {
			}
		}
	}

	public function copy() : DatePicker {
		var newDMUI : DatePicker = new DatePicker();
		var sz : Array = size;
		newDMUI.create(x, y, _date, _label.label, sz[0], sz[1]);
		newDMUI.weekLabels = listMC.weekLabels;
		newDMUI.format = _format;
		newDMUI.pickerSize = listMC.pickerSize;
		newDMUI.spacing = listMC.spacing;
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : int = 0, _y : int = 0, da : Date = null, lab : String = "", w : uint = 110, h : uint = 23) : void {
		x = _x;
		y = _y;

		if (da == null) {
			//da = new Date();
			if (lab != "") {
				_label.label = lab;
			}
		} else {
			date = da;
		}
		iconBtn.size = [25, h + 1];
		_label.size = [w - 25, h];

		size = [w, h];

		enabled = _enabled;
	}

	private function setFormat(t : Number) : void {
		var da : Date = new Date();
		da.time = t;
		var y0 : String = da.fullYear.toString();
		var m0 : String = (da.month + 1).toString();
		var d0 : String = da.date.toString();
		var y00 : String = y0.slice(2, 4);
		if (m0.length == 1) {
			var m00 : String = "0" + m0;
		} else {
			m00 = m0;
		}
		if (d0.length == 1) {
			var d00 : String = "0" + d0;
		} else {
			d00 = d0;
		}
		var _wt : Array = listMC.weekLabels;
		var day : uint = da.day;
		var w0 : String = _wt[day];
		if (_wt.length == 14) {
			var w00 : String = _wt[7 + day];
		} else {
			w00 = w0;
		}
		label = RegExpList(_format, ReExpFunc0, [y0, m0, d0, y00, m00, d00, w0, w00]);
	}

	public function get pickerSize() : Array {
		return listMC.pickerSize;
	}

	public function set pickerSize(sz : Array) : void {
		listMC.pickerSize = sz;
	}

	public function get spacing() : uint {
		return listMC.spacing;
	}

	public function set spacing(sp : uint) : void {
		listMC.spacing = sp;
	}

	public function get format() : String {
		return _format;
	}

	public function set format(fo : String) : void {
		_format = fo;
		date = _date;
	}

	public function set canChange(boo : Boolean) : void {
		_canChange = listMC.canChange = boo;
	}

	public function get canChange() : Boolean {
		return _canChange;
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
		_selectedMC.alpha = Number(boo);
	}

	public function get date() : Date {
		return _date;
	}

	public function set date(da : Date) : void {
		_date = da;
		if (da != null) {
			setFormat(_date.time);
		}
	}

	public function get label() : String {
		return _label.label;
	}

	public function get color() : Object {
		return _label.color;
	}

	public function get font() : String {
		return _label.font;
	}

	public function get fontSize() : uint {
		return _label.fontSize;
	}

	public function get bold() : Boolean {
		return _label.bold;
	}

	public function get wordWrap() : Boolean {
		return _label.wordWrap;
	}

	public function get multiline() : Boolean {
		return _label.multiline;
	}

	public function get italic() : Boolean {
		return _label.italic;
	}

	public function set label(lab : String) : void {
		_label.label = lab;
		if (_autoSize) {
			size = [];
		}
	}

	public function set color(col : Object) : void {
		_label.color = col;
	}

	public function set font(f : String) : void {
		_label.font = f;
	}

	public function set fontSize(sz : uint) : void {
		_label.fontSize = sz;
		size = [];
	}

	public function set bold(boo : Boolean) : void {
		_label.bold = boo;
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

	public function set italic(boo : Boolean) : void {
		_label.italic = boo;
		size = [];
	}

	public function set weekLabels(arr : Array) : void {
		listMC.weekLabels = arr;
	}

	public function get weekLabels() : Array {
		return listMC.weekLabels;
	}

	public function set sundayStart(boo : Boolean) : void {
		listMC.sundayStart = boo;
	}

	public function get sundayStart() : Boolean {
		return listMC.sundayStart;
	}

	private function UP(evt : KeyboardEvent) : void {
		if (evt.keyCode == 13) {
			DOWN();
		}
	}

	private function DOWN() : void {
		_lockfocus = true;
		listMC.date = _date;
		try {
			listPanel.activate();
			listPanel.close();
		} catch (err : Error) {
			showBox(_date == null ? -1 : _date.time);
		}
		_lockfocus = false;
		stage.focus = this;
	}

	private function setListPanelBounds() : void {
		var tP : Sprite = this;
		listPanel.x = iconBtn.x + appWindow.x + this.x + 8 + mc.x;
		listPanel.y = iconBtn.y + appWindow.y + this.y + iconBtn.height + 31 + mc.y;
		do {
			tP = tP.parent as Sprite;
			listPanel.x += tP.x;
			listPanel.y += tP.y;
		} while (tP.toString() == "[object Stage]");
		var halfHgt : uint = listPanel.height - listMC.spacing;
		if (resolutionY - listPanel.y < halfHgt) {
			listPanel.y -= listPanel.height + iconBtn.height;
		}
	}

	private function appWinIN(evt : Event) : void {
		try {
			listPanel.visible = false;
			listPanel.close();
		} catch (err : Error) {
		}
	}

	private function listPanelClose(evt : Event) : void {
		listPanel.removeEventListener(Event.CLOSE, listPanelClose);
		appWindow.removeEventListener(Event.ACTIVATE, appWinIN);
		listPanel.stage.removeEventListener(KeyboardEvent.KEY_DOWN, KEY_DOWN);
	}

	private function KEY_DOWN(evt : KeyboardEvent) : void {
		_KeyboardEvent = evt;
		_keyDown();
	}

	private function showBox(t : Number = 0) : void {
		var sd : Date = new Date();
		sd.time = t <= 0 ? sd.time : t;
		listMC.showDate = sd;
		appWindow = stage.nativeWindow;
		listPanel = new NativeWindow(nwo);
		listPanel.alwaysInFront = true;
		listPanel.stage.scaleMode = "noScale";
		listPanel.stage.align = "TL";
		if (stage.nativeWindow.alwaysInFront) {
			listPanel.alwaysInFront = true;
		}
		listPanel.height = listMC.height;
		listPanel.width = listMC.width;
		listPanel.stage.stageFocusRect = false;
		listPanel.stage.addChild(listMC);

		setListPanelBounds();

		listPanel.activate();
		listPanel.addEventListener(Event.CLOSE, listPanelClose);
		appWindow.addEventListener(Event.ACTIVATE, appWinIN);
		listPanel.stage.addEventListener(KeyboardEvent.KEY_DOWN, KEY_DOWN);
	}

	public function set pickerBorder(boo : Boolean) : void {
		_pickerBorder = boo;
	}

	public function get pickerBorder() : Boolean {
		return _pickerBorder;
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}
}
}
