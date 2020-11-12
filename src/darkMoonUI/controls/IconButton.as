package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.interfaces.DMUI_PUB_IMAGE;
import darkMoonUI.assets.util.Base64;
import darkMoonUI.assets.util.Hex;
import darkMoonUI.assets.functions.bgColor2OverColor;
import darkMoonUI.functions.parentAddChilds;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.net.URLRequest;
import flash.utils.ByteArray;

/**
 * @author moconwu
 */
public class IconButton extends DarkMoonUIControl implements DMUI_PUB_IMAGE {
	public var onLoadedError : Function;
	public var onLoading : Function;
	public var onLoaded : Function;
	private var
	iconMC : Sprite = new Sprite(),
	selectedMC : Shape = new Shape(),
	_autoSize : Boolean = false,
	_source : String = "",
	_spacing : uint = 0,
	imgBL : Number, defMCW : Number, defMCH : Number, imgMCBL : Number = 1.0,
	__x : Number,__y : Number,_bmpW : Number = 1.0,_bmpH : Number = 1.0,
	file : File,loader : Loader,bmp : Bitmap,
	_showFocus : Boolean = true,
	_bgColor : uint = bgColorArr[1],
	_overColor : uint = 0,
	_sz : Array = [25, 25];

	public function IconButton(icon : String = "") : void {
		super();

		_type = ControlType.ICON_BUTTON;

		fill(selectedMC.graphics, 10, 2, bgColorArr[2]);
		selectedMC.visible = false;
		selectedMC.blendMode = BlendMode.SCREEN;

		parentAddChilds(mc, Vector.<DisplayObject>([
			iconMC, selectedMC
		]));

		create(0, 0, icon);
	}
	/** @private */
	protected override function _size_get() : Array {
		return _sz;
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _sz[0];
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _sz[1];
		if (_autoSize) {
			_SizeValue[0] = iconMC.width + _spacing * 2;
			_SizeValue[1] = iconMC.height + _spacing * 2;
		} else if (!isNaN(defMCW) && !isNaN(defMCH)) {
			if (_SizeValue[0] / _bmpW > _SizeValue[1] / _bmpH) {
				var _h : int = _SizeValue[1] - _spacing * 2;
				iconMC.height = _h > 0 ? _h : 1;
				iconMC.width = imgMCBL * iconMC.height;
			} else {
				var _w : int = _SizeValue[0] - _spacing * 2;
				iconMC.width = _w > 0 ? _w : 1;
				iconMC.height = iconMC.width / imgMCBL;
			}
		}
		_sz[0] = selectedMC.width = _SizeValue[0];
		_sz[1] = _SizeValue[1];

		selectedMC.y = _sz[1] - 2;
		iconMC.x = (_sz[0] - iconMC.width) / 2;
		iconMC.y = (_sz[1] - iconMC.height) / 2;
		fill(mc.graphics, _sz[0], _sz[1], _bgColor);
	}
	/** @private */
	protected override function _focus_in() : void {
		selectedMC.visible = _showFocus;
	}
	/** @private */
	protected override function _focus_out() : void {
		selectedMC.visible = false;
	}
	/** @private */
	protected override function _mouseOver() : void {
		fill(mc.graphics, _sz[0], _sz[1], _overColor);
		iconMC.alpha = 0.8;
	}
	/** @private */
	protected override function _mouseOut() : void {
		fill(mc.graphics, _sz[0], _sz[1], _bgColor);
		iconMC.alpha = 1.0;
	}
	/** @private */
	protected override function _keyDown() : void {
		if (_KeyboardEvent.keyCode == 13) {
			fill(mc.graphics, _sz[0], _sz[1], _overColor);
			iconMC.alpha = 0.8;
		}
	}
	/** @private */
	protected override function _keyUp() : void {
		if (_KeyboardEvent.keyCode == 13) {
			fill(mc.graphics, _sz[0], _sz[1], _bgColor);
			iconMC.alpha = 1.0;
			if (onClick != null){
				onClick();
			}
		}
	}

	public function copy() : IconButton {
		var newDMUI : IconButton = new IconButton();
		var sz : Array = size;
		newDMUI.create(x, y, source, sz[0], sz[1]);
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : int = 0, _y : int = 0, icon : String = "", w : uint = 25, h : uint = 25) : void {
		x = _x;
		y = _y;
		_sz[0] = selectedMC.width = w;
		_sz[1] = h;
		selectedMC.height = 2;

		selectedMC.y = h - 2;

		source = icon;
		enabled = _enabled;
	}

	private function onFileOpen(str : String) : void {
		try {
			file = new File(str);
			if (!file.exists) {
				trace(str, "is not find!");
				return;
			} else {
				file.url.toUpperCase();
			}
		} catch (err : Error) {
			return;
		}
		if(onLoading != null){
			onLoading();
		}
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
		loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
		loader.load(new URLRequest(file.url));
	}

	private function onLoadError(e : Event) : void {
		if(onLoadedError != null){
			onLoadedError();
		}
		trace(file.nativePath + " Load Failed");
	}

	private function onLoadComplete(e : Event) : void {
		bmp = loader.content as Bitmap;
		try {
			bmp.smoothing = true;
		} catch (err : Error) {
			return;
		}
		_bmpW = bmp.width;
		_bmpH = bmp.height;
		iconMC.addChild(bmp);
		if (!_autoSize) {
			imgLoadedFunc();
		}
		size = [];
		if(onLoaded != null){
			onLoaded();
		}
	}

	private function imgLoadedFunc() : void {
		try {
			imgBL = bmp.width / bmp.height;
		} catch (err : Error) {
			return;
		}
		if (_sz[0] / _bmpW > _sz[1] / _bmpH) {
			hgtFunc();
		} else {
			wdtFunc();
		}
		iconMC.addChild(bmp);
		imgMCBL = iconMC.width / iconMC.height;
		defMCW = iconMC.width;
		defMCH = iconMC.height;
		if (Number(iconMC.numChildren) > 0) {
			__x = iconMC.getChildAt(0).x;
			__y = iconMC.getChildAt(0).y;
			if (__x < 0) {
				__x = 0;
			}
			if (__y < 0) {
				__y = 0;
			}
		}
	}

	private function wdtFunc() : void {
		bmp.width = _sz[0] > 0 ? _sz[0] : _bmpW;
		bmp.height = bmp.width / imgBL;
		iconMC.x = (_sz[0] - bmp.width) / 2;
		iconMC.y = (_sz[1] - bmp.height) / 2;
	}

	private function hgtFunc() : void {
		bmp.height = _sz[1] > 0 ? _sz[1] : _bmpH;
		bmp.width = bmp.height * imgBL;
		iconMC.x = (_sz[0] - bmp.width) / 2;
		iconMC.y = (_sz[1] - bmp.height) / 2;
	}

	public function get bitmap() : Bitmap {
		return bmp;
	}

	public function set bitmap(b : Bitmap) : void {
		iconMC.removeChildren();
		bmp = b;
		bmp.smoothing = true;
		_bmpW = bmp.width;
		_bmpH = bmp.height;
		iconMC.addChild(bmp);
		if (!_autoSize) {
			imgLoadedFunc();
		}
		size = [];
		if(onLoaded != null){
			onLoaded();
		}
	}

	public function get bitmapData() : BitmapData {
		return bmp.bitmapData;
	}

	public function set bitmapData(bmpData : BitmapData) : void {
		var b : Bitmap = new Bitmap(bmpData);
		bitmap = b;
	}

	public function get byteArray() : ByteArray {
		var pixels : ByteArray = PNGEncoder2.encode(bmp.bitmapData);
		return pixels;
	}

	public function set byteArray(bas : ByteArray) : void {
		var bmpDate : BitmapData = PNGEncoder2.decode(bas);
		bitmap = new Bitmap(bmpDate);
	}

	public function get base64() : String {
		return Base64.encodeByteArray(byteArray);
	}

	public function set base64(bas : String) : void {
		var pixels : ByteArray = Base64.decodeToByteArray(bas);
		byteArray = pixels;
	}

	public function get hex() : String {
		return Hex.fromArray(byteArray);
	}

	public function set hex(bas : String) : void {
		var pixels : ByteArray = Hex.toArray(bas);
		byteArray = pixels;
	}

	public function set source(_url : String) : void {
		iconMC.removeChildren();
		_source = _url;
		try {
			onFileOpen(_url);
		} catch (err : Error) {
		}
	}

	public function get source() : String {
		return _source;
	}

	public function set spacing(sp : uint) : void {
		_spacing = sp;
		size = [];
	}

	public function get spacing() : uint {
		return _spacing;
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
	}

	public function set bgColor(col : Object) : void {
		_bgColor = int(col);
		fill(mc.graphics, _sz[0], _sz[1], _bgColor);
		_overColor = bgColor2OverColor(_bgColor);
	}

	public function get bgColor() : Object {
		return "0x" + uint(_bgColor).toString(16);
	}
}
}
