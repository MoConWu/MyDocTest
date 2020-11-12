package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.functions.bgColor2OverColor;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_INFOLABEL;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;
import darkMoonUI.controls.regPoint.RegPointAlign;
import darkMoonUI.functions.parentAddChilds;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * @author moconwu
 */
public class SearchBox extends DarkMoonUIControl implements DMUI_PUB_LABEL,DMUI_PUB_INFOLABEL {
	public var onChange : Function;
	public var onChanging : Function;
	public var onSearch : Function;
	private var
	_oldStr : String = "",
	_round : Array,
	bgMC : Shape = new Shape(),
	selectionMC : Shape = new Shape(),
	srchBtn : IconButton = new IconButton(),
	_title : TextField = new TextField(),
	_label : TextField = new TextField(),
	_infoLab : TextField = new TextField(),
	t_ttf : TextFormat = setTF(textColorArr[0]),
	l_ttf : TextFormat = setTF(textColorArr[1]),
	i_ttf : TextFormat = setTF(textColorArr[1]),
	btn_clear : Button = new Button("x"),
	_showSearch : Boolean = true,
	_showClear : Boolean = true,
	_showFocus : Boolean = true;
	public static const SEARCH_ICON_BASE64 : String = "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";

	public function SearchBox(t : String = "Search:", infoLab : String = "Search") {
		super();
		_type = ControlType.SEARCH_BOX;

		fill(bgMC.graphics, 10, 10, bgColorArr[3], bgColorArr[1]);
		fill(selectionMC.graphics, 10, 10, bgColorArr[2]);
		t_ttf.bold = true;
		i_ttf.italic = true;
		_title.wordWrap = _title.selectable = _title.multiline = _label.multiline = _infoLab.multiline = _infoLab.selectable = _infoLab.wordWrap = _label.wordWrap = selectionMC.visible = false;
		_title.setTextFormat(t_ttf);
		_label.setTextFormat(l_ttf);
		_title.defaultTextFormat = t_ttf;
		_label.defaultTextFormat = l_ttf;
		_infoLab.setTextFormat(i_ttf);
		_infoLab.defaultTextFormat = i_ttf;
		_infoLab.alpha = 0.4;
		_label.type = "input";
		_label.backgroundColor = bgColorArr[1];
		_label.background = true;

		_title.autoSize = "left";
		_title.x = _infoLab.y = _label.y = _title.y = 2;
		selectionMC.x = selectionMC.y = -2;

		srchBtn.size = btn_clear.size = [25, 25];
		_infoLab.mouseWheelEnabled = _infoLab.mouseEnabled =
		btn_clear.visible = btn_clear.showFocus = srchBtn.showFocus = false;
		btn_clear.regPoint = RegPointAlign.RIGHT_TOP;
		btn_clear.bgColor = 0x332222;
		srchBtn.spacing = 2;
		srchBtn.base64 = SEARCH_ICON_BASE64;

		btn_clear.onClick = function():void{
			if(_label.text!=""){
				_label.text = "";
				checkClearBtnVisible();
				stage.focus = _label;
				if(onChanging != null){
					onChanging();
				}else if(onChange != null){
					onChange();
				}
				if(onSearch != null && onSearch != onChanging && onSearch != onChange){
					onSearch();
				}
			}
			infoLabCheck();
		};

		parentAddChilds(mc, Vector.<DisplayObject>([
			selectionMC, bgMC, _title, _label, _infoLab, btn_clear, srchBtn
		]));
		create(0, 0, t, infoLab);
	}

	public function copy() : SearchBox {
		var newDMUI : SearchBox = new SearchBox();
		var sz : Array = size;
		newDMUI.create(x, y, _title.text, _infoLab.text, sz[0], sz[1]);
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : int = 0, _y : int = 0, tt : String = "Search:", infoStr : String = "Search", w : uint = 180, h : uint = 25) : void {
		x = _x;
		y = _y;

		_title.text = tt;
		_infoLab.text = infoStr;
		srchBtn.size = [25, h];

		enabled = _enabled;

		size = [w, h];
	}
	/** @private */
	protected override function _size_get() : Array {
		return [bgMC.width, bgMC.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		var w : uint = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : bgMC.width;
		var h : uint = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : bgMC.height;
		bgMC.width = w;
		bgMC.height = h;
		_infoLab.width = _label.width = w - 4;
		_infoLab.height = _label.height = h - 4;
		selectionMC.width = w + 5;
		selectionMC.height = h + 5;

		if (_title.text == "") {
			_title.visible = false;
		}

		bgMC.width = w;
		bgMC.height = h;
		selectionMC.width = w + 5;
		selectionMC.height = h + 5;
		_title.height = h - 4;
		_infoLab.width = w - _title.width * int(_title.visible) - 2 - int(_showSearch) * srchBtn.size[0];
		_label.width = _infoLab.width - btn_clear.size[0] * int(btn_clear.visible);
		_label.height = _infoLab.height = h - 3.5;
		srchBtn.size = btn_clear.size = [0, h];

		_infoLab.x = _label.x = 2 + _title.width * int(_title.visible);

		btn_clear.x = srchBtn.x = w - int(_showSearch) * srchBtn.size[0];
		_SizeValue = Vector.<uint>([bgMC.width, bgMC.height]);
	}
	/** @private */
	protected override function _enabled_set() : void {
		srchBtn.enabled = _label.selectable = _label.tabEnabled = _enabled;
		tabEnabled = srchBtn.tabEnabled = false;
		if (_enabled) {
			_label.type = "input";
			_label.addEventListener(FocusEvent.FOCUS_IN, labFcsIn);
			_label.addEventListener(FocusEvent.FOCUS_OUT, labFcsOut);
			srchBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnDown);
			srchBtn.addEventListener(MouseEvent.MOUSE_UP, btnUp);
			_label.addEventListener(Event.CHANGE, labChange);
		} else {
			_label.type = "dynamic";
			_label.removeEventListener(FocusEvent.FOCUS_IN, labFcsIn);
			_label.removeEventListener(FocusEvent.FOCUS_OUT, labFcsOut);
			srchBtn.removeEventListener(MouseEvent.MOUSE_DOWN, btnDown);
			srchBtn.removeEventListener(MouseEvent.MOUSE_UP, btnUp);
			_label.removeEventListener(Event.CHANGE, labChange);
		}
	}
	/** @private */
	protected override function _focus_in() : void {
		stage.focus = _label;
		selectionMC.visible = _showFocus;
		checkClearBtnVisible();
	}
	/** @private */
	protected override function _focus_out() : void {
		selectionMC.visible = false;
		checkClearBtnVisible();
	}
	/** @private */
	protected override function _keyDown() : void {
		if (_KeyboardEvent.keyCode == 13) {
			_lockfocus = true;
			focus = true;
			search();
			if(_showSearch) {
				srchBtn.focus = true;
			}
			_lockfocus = false;
		}
	}

	private function checkClearBtnVisible():void{
		if(_showClear) {
			btn_clear.visible = _label.text != "";
		}
		_label.width = size[0] - _title.width * Number(_title.visible) - 2 - srchBtn.size[0] * int(_showSearch) - btn_clear.size[0] * int(btn_clear.visible);
	}

	private function labChange(evt : Event) : void {
		infoLabCheck();
		checkClearBtnVisible();
		if(onChanging != null){
			onChanging();
		}
	}

	private function btnDown(evt : MouseEvent) : void {
		_lockfocus = true;
	}

	private function btnUp(evt : MouseEvent) : void {
		_lockfocus = true;
		search();
	}

	private function search() : void {
		trace("[SearchBox Search:] " + _label.text);
		if(onSearch != null){
			onSearch();
		}
	}

	private function labFcsIn(...args) : void {
		_lockfocus = true;
		infoLabCheck();
		_label.background = true;
		_oldStr = _label.text;
	}

	private function labFcsOut(...args) : void {
		_lockfocus = false;
		infoLabCheck();
		checkClearBtnVisible();
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
		_label.background = _label.text != "";
		var isChange : Boolean = _oldStr != _label.text;
		if(isChange && onChange != null){
			onChange();
		}
	}

	private function infoLabCheck() : void {
		_infoLab.visible = _label.text == "";
	}

	public function get round() : Array {
		return _round;
	}

	public function set round(rd : Array) : void {
		_round = rd;
	}

	public function get iconBitmap() : Bitmap {
		return srchBtn.bitmap;
	}

	public function set iconBitmap(bmp : Bitmap) : void {
		srchBtn.bitmap = bmp;
	}

	public function get iconPath() : String {
		return srchBtn.source;
	}

	public function set iconPath(path : String) : void {
		srchBtn.source = path;
	}

	public function set buttonWidth(w : uint) : void {
		srchBtn.size = [w];
		size = [];
	}

	public function get buttonWidth() : uint {
		return srchBtn.size[0];
	}

	public function get title() : String {
		return _title.text;
	}

	public function set title(tt : String) : void {
		_title.text = tt;
		size = [];
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

	public function get infoLabel() : String {
		return _infoLab.text;
	}

	public function set infoLabel(info : String) : void {
		_infoLab.text = info;
		size = [];
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
		var old:String = _label.text;
		_label.text = lab;
		labFcsOut();
		size = [];
		if(old!=lab){
			if(onChanging != null){
				onChanging();
			}else if(onChange != null){
				onChange();
			}
		}
	}

	public function set color(col : Object) : void {
		if(col==null){
			col = textColorArr[1];
		}
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

	public function set wordWrap(boo : Boolean) : void {
		_infoLab.wordWrap = _label.wordWrap = boo;
		size = [];
	}

	public function set multiline(boo : Boolean) : void {
		_infoLab.multiline = _label.multiline = boo;
		size = [];
	}

	public function set italic(boo : Boolean) : void {
		l_ttf.italic = boo;
		_label.setTextFormat(l_ttf);
		_label.defaultTextFormat = l_ttf;
	}

	public function get italic() : Boolean {
		return l_ttf.italic;
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

	public function get titleColor() : Object {
		return "0x" + uint(t_ttf.color).toString(16);
	}

	public function get titleFontSize() : uint {
		return int(t_ttf.size);
	}

	public function get titleBold() : Boolean {
		return t_ttf.bold;
	}

	public function get titleWordWrap() : Boolean {
		return _title.wordWrap;
	}

	public function set titleColor(col : Object) : void {
		t_ttf.color = col;
		_title.setTextFormat(t_ttf);
		_title.defaultTextFormat = t_ttf;
	}

	public function set titleFontSize(sz : uint) : void {
		t_ttf.size = sz;
		_title.setTextFormat(t_ttf);
		_title.defaultTextFormat = t_ttf;
		size = [];
	}

	public function set titleBold(boo : Boolean) : void {
		t_ttf.bold = boo;
		_title.setTextFormat(t_ttf);
		_title.defaultTextFormat = t_ttf;
		size = [];
	}

	public function set titleWordWrap(boo : Boolean) : void {
		_title.wordWrap = boo;
		size = [];
	}

	public function get titleFont() : String {
		return t_ttf.font;
	}

	public function set titleFont(f : String) : void {
		t_ttf.font = f;
		_title.setTextFormat(t_ttf);
		_title.defaultTextFormat = t_ttf;
		size = [];
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
	}

	public function set showSearch(boo : Boolean) : void {
		_showSearch = boo;
		if(boo){
			mc.addChild(srchBtn);
		}else{
			mc.removeChild(srchBtn);
		}
	}

	public function get showSearch() : Boolean {
		return _showSearch;
	}

	public function set showClear(boo : Boolean) : void {
		_showClear = boo;
		if(boo){
			mc.addChild(btn_clear);
		}else{
			btn_clear.visible = false;
			mc.removeChild(btn_clear);
		}
	}

	public function get showClear() : Boolean {
		return _showClear;
	}

	public function set bgColor(col : Object) : void {
		fill(bgMC.graphics, 10, 10, int(col), bgColorArr[1]);
		srchBtn.bgColor = bgColor2OverColor(int(col));
		_label.backgroundColor = bgColor2OverColor(int(col));
	}

	public function set clearBgColor(col : Object) : void {
		btn_clear.bgColor = col;
	}

	public function get clearBgColor() : Object {
		return btn_clear.bgColor;
	}

	public function set clearColor(col : Object) : void {
		btn_clear.color = col;
	}

	public function get clearColor() : Object {
		return btn_clear.color;
	}

	public function set searchBgColor(col : Object) : void {
		srchBtn.bgColor = col;
	}

	public function get searchBgColor() : Object {
		return srchBtn.bgColor;
	}
}
}
