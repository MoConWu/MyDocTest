package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.bgColor2OverColor;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_INFOLABEL;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;
import darkMoonUI.functions.parentAddChilds;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * @author moconwu
 */
public class InputText extends DarkMoonUIControl implements DMUI_PUB_LABEL,DMUI_PUB_INFOLABEL {
	public var
	onChange : Function = null,
	onChanging : Function = null;

	private var
	bgMC : Shape = new Shape(),
	selectionMC : Shape = new Shape(),
	_label : TextField = new TextField(),
	_infoLab : TextField = new TextField(),
	l_ttf : TextFormat = setTF(textColorArr[1]),
	i_ttf : TextFormat = setTF(textColorArr[1]),
	_round : Array,
	_oldStr : String = "",
	_edit : Boolean = true,
	_showFocus : Boolean = true,
	_autoSize : Boolean = false,
	_restrictLength : uint = 0,
	_textChange : String,
	_bgColor : uint = bgColorArr[1],
	_autoOnChange:Boolean = true;

	public function InputText(infoStr:String=ControlType.INPUT_TEXT) {
		super();
		_type = ControlType.INPUT_TEXT;

		fill(bgMC.graphics, 10, 10, _bgColor, bgColorArr[1]);
		fill(selectionMC.graphics, 10, 10, bgColorArr[2]);
		_label.multiline = _infoLab.multiline = _infoLab.selectable = _infoLab.wordWrap = _label.wordWrap = selectionMC.visible = false;
		i_ttf.italic = true;
		_label.setTextFormat(l_ttf);
		_infoLab.setTextFormat(i_ttf);
		_label.defaultTextFormat = l_ttf;
		_infoLab.defaultTextFormat = i_ttf;
		_infoLab.alpha = 0.4;
		_label.type = "input";
		bgColor = _bgColor;
		selectionMC.x = selectionMC.y = -2;
		_infoLab.x = _label.x = _infoLab.y = _label.y = 2;
		_infoLab.mouseEnabled = _infoLab.mouseWheelEnabled = false;

		parentAddChilds(mc, Vector.<DisplayObject>([
			selectionMC, bgMC, _label, _infoLab
		]));

		create(0, 0, infoStr);
	}

	public function copy() : InputText {
		var newDMUI : InputText = new InputText();
		var sz : Array = size;
		newDMUI.create(x, y, _infoLab.text, sz[0], sz[1], wordWrap, edit, selectable);
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x:int=0, _y:int=0, infoStr:String=ControlType.INPUT_TEXT, w:uint=150, h:uint=23, ww:Boolean=false, edt:Boolean=true, sel:Boolean=true) : void {
		x = _x;
		y = _y;

		_infoLab.text = infoStr;

		wordWrap = ww;
		edit = edt;
		selectable = sel;

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
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : bgMC.width;
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : bgMC.height;

		if (_autoSize) {
			_infoLab.autoSize = _label.autoSize = "left";
			_SizeValue[0] = _label.width > _infoLab.width ? _label.width + 4 : _infoLab.width + 4;
			_SizeValue[1] = _label.height > _infoLab.height ? _label.height + 3.5 : _infoLab.height + 3.5;
			if (_label.width < _SizeValue[0] || _label.height < _SizeValue[1]) {
				_label.autoSize = "none";
				_label.width = _SizeValue[0] - 4;
				_label.height = _SizeValue[1] - 3.5;
			}
		} else {
			_infoLab.autoSize = _label.autoSize = "none";
			_infoLab.width = _label.width = _SizeValue[0] - 4;
			_infoLab.height = _label.height = _SizeValue[1] - 3.5;
		}

		bgMC.width = _SizeValue[0];
		bgMC.height = _SizeValue[1];

		selectionMC.width = _SizeValue[0] + 5;
		selectionMC.height = _SizeValue[1] + 5;
	}
	/** @private */
	protected override function _enabled_set() : void {
		_label.selectable = _enabled;
		if (_edit) {
			tabEnabled = false;
			_label.tabEnabled = _enabled;
		} else {
			_label.tabEnabled = false;
		}
		if (_enabled) {
			_label.type = _edit ? "input" : "dynamic";
			_label.addEventListener(Event.CHANGE, labChange);
			_label.addEventListener(FocusEvent.FOCUS_IN, labFcsIn);
		} else {
			_label.type = "dynamic";
			_label.removeEventListener(Event.CHANGE, labChange);
			_label.removeEventListener(FocusEvent.FOCUS_IN, labFcsIn);
			_label.removeEventListener(FocusEvent.FOCUS_OUT, labFcsOut);
		}
	}
	/** @private */
	protected override function _focus_in() : void {
		if(stage != null) {
			stage.focus = _label;
			selectionMC.visible = _showFocus;
		}
	}
	/** @private */
	protected override function _focus_out() : void {
		selectionMC.visible = false;
	}
	/** @private */
	protected override function _keyDown() : void {
		if (_KeyboardEvent.keyCode == 13) {
			if (!_lockfocus) {
				stage.focus = _label;
				_label.setSelection(0, _label.text.length);
			} else {
				if (!multiline) {
					labFcsOut(_FocusEvent);
					focus = true;
				}
			}
		}
		if (_KeyboardEvent.keyCode == 27 && _lockfocus) {
			labFcsOut(_FocusEvent);
			focus = true;
		}
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
	}

	public function set infoColor(col : Object) : void {
		i_ttf.color = col;
		_infoLab.setTextFormat(i_ttf);
		_infoLab.defaultTextFormat = i_ttf;
	}

	public function get infoColor() : Object {
		return "0x" + uint(i_ttf.color).toString(16);
	}

	public function set infoFont(f : String) : void {
		i_ttf.font = f;
		_infoLab.setTextFormat(i_ttf);
		_infoLab.defaultTextFormat = i_ttf;
	}

	public function get infoFont() : String {
		return i_ttf.font;
	}

	public function set infoBold(boo : Boolean) : void {
		i_ttf.bold = boo;
		_infoLab.setTextFormat(i_ttf);
		_infoLab.defaultTextFormat = i_ttf;
	}

	public function get infoBold() : Boolean {
		return i_ttf.bold;
	}

	public function set infoItalic(boo : Boolean) : void {
		i_ttf.italic = boo;
		_infoLab.setTextFormat(i_ttf);
		_infoLab.defaultTextFormat = i_ttf;
	}

	public function get infoItalic() : Boolean {
		return i_ttf.italic;
	}

	public function get edit() : Boolean {
		return _edit;
	}

	public function set edit(boo : Boolean) : void {
		_edit = boo;
		if (boo) {
			_label.type = "input";
		} else {
			_label.type = "dynamic";
		}
	}

	public function get selectable() : Boolean {
		return _label.selectable;
	}

	public function set selectable(boo : Boolean) : void {
		_label.selectable = boo;
	}

	public function set align(alg : String) : void {
		l_ttf.align = i_ttf.align = alg;
		_label.setTextFormat(l_ttf);
		_infoLab.setTextFormat(i_ttf);
		_label.defaultTextFormat = l_ttf;
		_infoLab.defaultTextFormat = i_ttf;
	}

	public function get align() : String {
		return l_ttf.align;
	}

	public function set italic(boo : Boolean) : void {
		l_ttf.italic = boo;
		_label.setTextFormat(l_ttf);
		_label.defaultTextFormat = l_ttf;
	}

	public function get italic() : Boolean {
		return l_ttf.italic;
	}

	public function set isPassword(boo : Boolean) : void {
		_label.displayAsPassword = boo;
	}

	public function get isPassword() : Boolean {
		return _label.displayAsPassword;
	}

	private function labChange(evt : Event) : void {
		if (_autoSize) {
			size = [];
		}
		var _tt : String = _label.text;
		if (_restrictLength > 0 && _tt.length > _restrictLength) {
			_label.text = _tt.slice(0, _restrictLength);
		}
		infoLabCheck();
		if (_textChange != _label.text) {
			if(onChanging != null){
				onChanging();
			}
		}
		_textChange = _label.text;
	}

	private function labFcsIn(evt : FocusEvent) : void {
		_lockfocus = true;
		infoLabCheck();
		_label.background = true;
		_oldStr = _label.text;
		_label.addEventListener(FocusEvent.FOCUS_OUT, labFcsOut);
	}

	private function labFcsOut(evt : FocusEvent) : void {
		_label.removeEventListener(FocusEvent.FOCUS_OUT, labFcsOut);
		_lockfocus = false;
		infoLabCheck();
		_label.background = false;
		if (_round != null) {
			if (_round.indexOf(_label.text) == -1) {
				if (_round.indexOf(_oldStr) == -1) {
					if (_round.length > 0) {
						_oldStr = _round[0];
					} else {
						_oldStr = "";
					}
				}
				_label.text = _oldStr;
			}
		}
		if (_oldStr != _label.text) {
			if (onChange != null) {
				onChange();
			}
		}
	}

	private function infoLabCheck() : void {
		_infoLab.visible = !(_label.text != "" && _label.htmlText != "");
	}

	public function get infoLabel() : String {
		return _infoLab.text;
	}

	public function set infoLabel(info : String) : void {
		_infoLab.text = info;
	}

	public function get round() : Array {
		return _round;
	}

	public function set round(rd : Array) : void {
		_round = rd;
	}

	public function get restrict() : String {
		return _label.restrict;
	}

	public function set restrict(res : String) : void {
		_label.restrict = res;
	}

	public function get font() : String {
		return l_ttf.font;
	}

	public function set font(f : String) : void {
		l_ttf.font = i_ttf.font = f;
		_label.setTextFormat(l_ttf);
		_infoLab.setTextFormat(i_ttf);
		_label.defaultTextFormat = l_ttf;
		_infoLab.defaultTextFormat = i_ttf;
		size = [];
	}

	public function get label() : String {
		return _label.text;
	}

	public function get color() : Object {
		return "0x" + uint(l_ttf.color).toString(16);
	}

	public function get fontSize() : uint {
		return int(l_ttf.size);
	}

	public function get bold() : Boolean {
		return l_ttf.bold;
	}

	public function get wordWrap() : Boolean {
		return _label.wordWrap;
	}

	public function get multiline() : Boolean {
		return _label.multiline;
	}

	public function set label(lab : String) : void {
		_textChange = _label.text = lab;
		infoLabCheck();
		if(_autoOnChange){
			if(onChange != null){
				onChange();
			}
		}
	}

	public function set color(col : Object) : void {
		l_ttf.color = i_ttf.color = col;
		_label.setTextFormat(l_ttf);
		_infoLab.setTextFormat(i_ttf);
		_label.defaultTextFormat = l_ttf;
		_infoLab.defaultTextFormat = i_ttf;
	}

	public function set fontSize(sz : uint) : void {
		l_ttf.size = i_ttf.size = sz;
		_label.setTextFormat(l_ttf);
		_infoLab.setTextFormat(i_ttf);
		_label.defaultTextFormat = l_ttf;
		_infoLab.defaultTextFormat = i_ttf;
		size = [];
	}

	public function set bold(boo : Boolean) : void {
		l_ttf.bold = i_ttf.bold = boo;
		_label.setTextFormat(l_ttf);
		_infoLab.setTextFormat(i_ttf);
		_label.defaultTextFormat = l_ttf;
		_infoLab.defaultTextFormat = i_ttf;
		size = [];
	}

	public function set restrictLength(leng : uint) : void {
		_restrictLength = leng;
	}

	public function get restrictLength() : uint {
		return _restrictLength;
	}

	public function set wordWrap(boo : Boolean) : void {
		_label.wordWrap = _infoLab.wordWrap = boo;
		size = [];
	}

	public function set multiline(boo : Boolean) : void {
		_label.multiline = _infoLab.multiline = boo;
		size = [];
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public function get bgColor() : Object {
		return "0x" + _bgColor.toString(16);
	}

	public function set bgColor(col : Object) : void {
		_bgColor = int(col);
		fill(bgMC.graphics, 10, 10, _bgColor, bgColorArr[1]);
		_label.backgroundColor = bgColor2OverColor(_bgColor);
	}

	public function set htmlText(html : String) : void {
		_label.htmlText = html;
		infoLabCheck();
	}

	public function get htmlText() : String {
		return _label.htmlText;
	}

	public function set maxChars(len : uint) : void {
		_label.maxChars = len;
	}

	public function get maxChars() : uint {
		return _label.maxChars;
	}

	public function moveToBottom() : void {
		_label.scrollV = _label.maxScrollV;
	}

	public function moveToTop() : void {
		_label.scrollV = 0;
	}

	public function set autoOnChange(boo:Boolean):void{
		_autoOnChange = boo;
	}

	public function get autoOnChange():Boolean{
		return _autoOnChange;
	}
}
}
