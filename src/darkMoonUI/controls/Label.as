package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_DEF;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;

import flash.display.Shape;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * @author moconwu
 */
public class Label extends DarkMoonUIControl implements DMUI_PUB_LABEL, DMUI_PUB_DEF {
	private var
	_label : TextField = new TextField(),
	ttf : TextFormat = setTF(textColorArr[1]),
	_autoSize : Boolean = true,
	_mask : Shape = new Shape();

	public function Label(lab:String=ControlType.LABEL) : void {
		super();
		_type = ControlType.LABEL;

		fill(_mask.graphics, 100, 23);
		_label.autoSize = TextFieldAutoSize.LEFT;
		_label.mask = _mask;
		_label.antiAliasType = AntiAliasType.ADVANCED;

		mc.addChild(_label);
		mc.addChild(_mask);
		create(0, 0, lab);
	}

	public function copy() : Label {
		var newDMUI : Label = new Label();
		var sz : Array = size;
		newDMUI.create(x, y, _label.text, _autoSize, Boolean(ttf.bold), _label.wordWrap, select, ttf.color, sz[0], sz[1]);
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x:int=0, _y:int=0, lab:String=ControlType.LABEL, auto:Boolean=true, b:Boolean=false, ww:Boolean=false, sel:Boolean=false, col:Object=0xD4D4D4, w:uint=100, h:uint=23) : void {
		x = _x;
		y = _y;

		ttf.color = col;
		ttf.bold = b;

		if(lab == null){
			lab = "";
		}

		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		_label.text = lab;
		_label.wordWrap = ww;

		select = sel;
		_autoSize = auto;
		size = [w, h];
		enabled = _enabled;
	}
	/** @private */
	protected override function _size_get() : Array {
		return [_mask.width, _mask.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _mask.width;
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _mask.height;
		if (_autoSize) {
			_label.width = _SizeValue[0];
			_label.height = _SizeValue[1];
			_mask.width = _label.width;
			_mask.height = _label.height;
		} else {
			_mask.width = _SizeValue[0];
			_mask.height = _SizeValue[1];
		}
		_SizeValue = Vector.<uint>([_mask.width, _mask.height]);
	}
	/** @private */
	protected override function _mouseClick() : void {
		if (ttf.url != "" && ttf.url != null) {
			var urlR : URLRequest = new URLRequest(ttf.url);
			navigateToURL(urlR, "_blank");
		}
	}
	/** @private */
	protected override function _enabled_set() : void {
		tabEnabled = false;
	}

	public function set htmlText(h : String) : void {
		_label.htmlText = h;
		size = [];
	}

	public function get htmlText() : String {
		return _label.htmlText;
	}

	public override function get showFocus() : Boolean {
		return false;
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

	public function set color(col : Object) : void {
		if(col==null){
			col = textColorArr[1];
		}
		ttf.color = col;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get color() : Object {
		return "0x" + uint(ttf.color).toString(16);
	}

	public function set fontSize(num : uint) : void {
		ttf.size = num;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function get fontSize() : uint {
		return ttf.size as uint;
	}

	public function set italic(boo : Boolean) : void {
		ttf.italic = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get italic() : Boolean {
		return ttf.italic;
	}

	public function get url() : String {
		return ttf.url;
	}

	public function set url(u : String) : void {
		ttf.url = u;
		ttf.underline = u != "" && u != null;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public function set select(boo : Boolean) : void {
		_lockfocus = _label.selectable = boo;
	}

	public function get select() : Boolean {
		return _label.selectable;
	}

	public function set wordWrap(boo : Boolean) : void {
		_label.wordWrap = boo;
	}

	public function set multiline(boo : Boolean) : void {
		_label.multiline = boo;
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
	}

	public function get label() : String {
		return _label.text;
	}

	public function set label(lab : String) : void {
		if(lab == null){
			lab = "";
		}
		_label.text = lab;
		size = [];
	}

	public function set backgroundColor(col : Object) : void {
		_label.backgroundColor = uint(col);
	}

	public function set background(boo : Boolean) : void {
		_label.background = boo;
	}

	public function get backgroundColor() : Object {
		return _label.backgroundColor;
	}

	public function get background() : Boolean {
		return _label.background;
	}
}
}
