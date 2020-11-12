package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.controls.imagePabnel.ImagePanelLabelAlign;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_IMAGE;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;
import darkMoonUI.assets.util.Base64;
import darkMoonUI.assets.util.Hex;
import darkMoonUI.functions.parentAddChilds;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.geom.Matrix;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.utils.ByteArray;

/**
 * @author moconwu
 */
public class ImagePanel extends DarkMoonUIControl implements DMUI_PUB_LABEL,DMUI_PUB_IMAGE {
	public var onLoadedError : Function;
	public var onLoading : Function;
	public var onLoaded : Function;
	private var
	_sz : Array = [150, 150],
	_selected : Boolean = false,
	imgMC_mask : Shape = new Shape(),
	imgMC : Sprite = new Sprite(),
	_label : TextField = new TextField(),
	_label_mask : Shape = new Shape(),
	_source : String = "",
	ttf : TextFormat = setTF(textColorArr[0]),
	_labAlign : Array = ImagePanelLabelAlign.LEFT_TOP,
	file : File,loader : Loader, bmp : Bitmap,
	bmpData : BitmapData,
	_alignment : String = "min",// max,min,wdt,hgt
	imgBL : Number, defMCW : Number, defMCH : Number, imgMCBL : Number, imgMCSF : Number,
	_zoom : Boolean,_move : Boolean,
	_scaleX : Number,_scaleY : Number,__x : Number,__y : Number,
	_autoSize : Boolean = false,
	_bmpW : Number,_bmpH : Number,
	_showFocus : Boolean = true,
	_maxSize : uint = 2000,
	_bgColor : uint = bgColorArr[3];

	public function ImagePanel() : void {
		super();
		_type = ControlType.IMAGE_PANEL;

		fill(imgMC_mask.graphics);
		fill(_label_mask.graphics);
//			fill(_selectedMC.graphics, 10, 10, bgColorArr[2]);
		_label.visible = false;
		imgMC.mask = imgMC_mask;
		_label.mask = _label_mask;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		_label.wordWrap = _label.selectable = false;
		this.mouseChildren = false;

		parentAddChilds(mc, Vector.<DisplayObject>([
			imgMC, imgMC_mask, _label, _label_mask
		]));

		create();
	}

	public function copy() : ImagePanel {
		var newDMUI : ImagePanel = new ImagePanel();
		var sz : Array = size;
		newDMUI.create(x, y, sz[0], sz[1], _zoom, _move, _label.visible);
		newDMUI.showFocus = _showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : int = 0, _y : int = 0, w : uint = 150, h : uint = 150, __zoom : Boolean = false, __move : Boolean = false, showLab : Boolean = false, lab : String = "") : void {
		x = _x;
		y = _y;

		_label.visible = showLab;
		_label.text = lab;

		_zoom = __zoom;
		_move = __move;

		defMCW = _sz[0] = w;
		defMCH = _sz[1] = h;

		size = [w, h];
		enabled = _enabled;
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
		if (_autoSize && _bmpW > 0 && _bmpH > 0) {
			_SizeValue[0] = imgMC.width = _bmpW;
			_SizeValue[1] = imgMC.height = _bmpH;
		}
		_label_mask.width = _label.width = _sz[0] = imgMC_mask.width = _SizeValue[0];
		_label_mask.height = _label.height = _sz[1] = imgMC_mask.height = _SizeValue[1];

		fill_bg();

		labelAlign = _labAlign;

		if (imgMC.width > 0 && imgMC.height > 0) {
			imgMC.width = defMCW;
			imgMC.height = defMCH;
			imgMCSF = 1;
		}

		imgLoadedFunc();

		// restrictIMG();

		_mouseWheel(true);

		_SizeValue[0] = _sz[0];
		_SizeValue[1] = _sz[1];
	}

	private function fill_bg() : void {
		var grap :Graphics = mc.graphics;
		grap.clear();
		if (_selected && _showFocus){
			grap.beginFill(bgColorArr[2]);
			grap.drawRect(-2, -2, _sz[0] + 5, _sz[1] + 5);
			grap.endFill();
		}
		fill(grap, _sz[0], _sz[1], _bgColor, bgColorArr[1], 0, false);
	}

	public function unloadAndStop():void{
		if(loader){
			loader.unloadAndStop();
		}
		if(bmpData){
			bmpData.dispose();
		}
	}
	/** @private */
	protected override function _focus_in() : void {
		if(_showFocus){
			_selected = true;
			fill_bg();
		}
	}
	/** @private */
	protected override function _focus_out() : void {
		_selected = false;
		if(_showFocus){
			fill_bg();
		}
	}
	/** @private */
	protected override function _mouseWheel(boo : Boolean = false) : void {
		if (!zoom || !imgMC || !_MouseEvent || imgMC.width == 0 || imgMC.height == 0 || _MouseEvent.buttonDown) {
			return;
		}
		var _X : Number = (imgMC.width + imgMC.x - mc.mouseX) / (mc.mouseX - imgMC.x);
		var _Y : Number = (imgMC.height + imgMC.y - mc.mouseY) / (mc.mouseY - imgMC.y);
		var minNum : int = _sz[0] < _sz[1] ? _sz[0] : _sz[1];
		var num : int = _MouseEvent.delta * imgMCSF * minNum / 40;
		if(boo){
			num = -1000;
		}
		if (_alignment == "min") {
			if (_sz[0] / bmp.width < _sz[1] / bmp.height) {
				MCwdtFunc(num);
			} else {
				MChgtFunc(num);
			}
		} else if (_alignment == "max") {
			if (_sz[0] / bmp.width < _sz[1] / bmp.height) {
				MChgtFunc(num);
			} else {
				MCwdtFunc(num);
			}
		} else if (_alignment == "wdt") {
			MCwdtFunc(num);
		} else if (_alignment == "hgt") {
			MChgtFunc(num);
		}
		imgMCSF = imgMC.width / defMCW;
		if (Number(imgMC.numChildren) > 0) {
			__x = imgMC.getChildAt(0).x * imgMCSF;
			__y = imgMC.getChildAt(0).y * imgMCSF;
			if (__x < 0) {
				__x = 0;
			}
			if (__y < 0) {
				__y = 0;
			}
		}
		imgMC.x = (_X * mc.mouseX + mc.mouseX - imgMC.width) / (_X + 1);
		imgMC.y = (_Y * mc.mouseY + mc.mouseY - imgMC.height) / (_Y + 1);

		restrictIMG();
	}
	/** @private */
	protected override function _mouseMiddleDown() : void {
		if (!_move || imgMC.width == 0 || imgMC.height == 0) {
			return;
		}
		_scaleX = mouseX - imgMC.x;
		_scaleY = mouseY - imgMC.y;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, MOVE);
		stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, MID_UP);
		Mouse.cursor = MouseCursor.HAND;
	}

	public function get imageSize() : Array {
		if (isNaN(_bmpW) || isNaN(_bmpH)) {
			trace("[Error:] No image or image is on loading! please use [ ImagePanel.onLoaded ].");
		}
		return [_bmpW, _bmpH];
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public function get bitmapData() : BitmapData {
		return bmp.bitmapData;
	}

	public function set bitmapData(bmpData : BitmapData) : void {
		_source = null;
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

	public function get bitmap() : Bitmap {
		return bmp;
	}

	public function set bitmap(b : Bitmap) : void {
		imgMC.removeChildren();
		bmp = b;
		bmp.smoothing = true;
		_bmpW = bmp.width;
		_bmpH = bmp.height;
		imgMC.addChild(bmp);
		if (!_autoSize) {
			imgLoadedFunc();
		}
		size = [];
		if(onLoaded != null){
			onLoaded();
		}
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

	public function set bold(boo : Boolean) : void {
		ttf.bold = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function get bold() : Boolean {
		return ttf.bold;
	}

	public function get color() : Object {
		return "0x" + uint(ttf.color).toString(16);
	}

	public function set color(col : Object) : void {
		ttf.color = col;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get wordWrap() : Boolean {
		return _label.wordWrap;
	}

	public function get multiline() : Boolean {
		return _label.multiline;
	}

	public function set wordWrap(boo : Boolean) : void {
		_label.wordWrap = boo;
		size = [];
	}

	public function set multiline(boo : Boolean) : void {
		_label.multiline = boo;
		size = [];
	}

	public function get fontSize() : uint {
		return int(ttf.size);
	}

	public function set fontSize(sz : uint) : void {
		ttf.size = sz;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function set italic(boo : Boolean) : void {
		ttf.italic = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get italic() : Boolean {
		return ttf.italic;
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
	}

	public function set zoom(boo : Boolean) : void {
		_zoom = boo;
		if (!boo) {
			imgLoadedFunc();
			restrictIMG();
		}
	}

	public function get zoom() : Boolean {
		return _zoom;
	}

	public function set move(boo : Boolean) : void {
		_move = boo;
		if (!boo) {
			imgLoadedFunc();
			restrictIMG();
		}
	}

	public function get move() : Boolean {
		return _move;
	}

	public function set labelAlign(alg : Array) : void {
		if (alg.length == 2) {
			var alg0 : String = alg[0] as String;
			var alg1 : String = alg[1] as String;
			alg0 = alg0.toLowerCase();
			alg1 = alg1.toLowerCase();
			if (alg0 == "left" || alg0 == "center" || alg0 == "right") {
				_labAlign[0] = alg0;
			} else {
				trace("[Wrong in ImagePanel:]" + name + ' - `' + alg[0] + "` is not in ['left','center','right'] !", new Error().getStackTrace());
			}
			if (alg1 == "top" || alg1 == "center" || alg1 == "bottom") {
				_labAlign[1] = alg1;
			} else {
				trace("[Wrong in ImagePanel:]" + name + ' - `' + alg[1] + "` is not in ['top','center','bottom'] !", new Error().getStackTrace());
			}
		} else {
			trace("[Wrong in ImagePanel:]" + name + ' - `' + alg + "` length must be 2,Now is" + alg.length + " !", new Error().getStackTrace());
		}
		if (alg0 == "center") {
			_label.autoSize = "center";
			_label.x = (_sz[0] - _label.width) / 2;
		} else if (alg0 == "right") {
			_label.autoSize = "right";
			_label.x = _sz[0] - _label.width;
		} else {
			_label.autoSize = "left";
		}
		if (alg1 == "center") {
			_label.y = (_sz[1] - _label.height) / 2;
		} else if (alg1 == "bottom") {
			_label.y = _sz[1] - _label.height;
		}
	}

	public function get labelAlign() : Array {
		return _labAlign;
	}

	private function restrictIMG() : void {
		if (imgMC.x > 0 && imgMC.width >= _sz[0]) {
			imgMC.x = 0;
		} else if (imgMC.width + __x > _sz[0] && imgMC.width + imgMC.x + __x < _sz[0]) {
			if (_sz[0] >= imgMC.width) {
				imgMC.x = -__x;
			} else {
				imgMC.x = _sz[0] - imgMC.width - __x;
			}
		}
		if (imgMC.x > 0 - __x) {
			imgMC.x = 0 - __x;
		}
		if (imgMC.width + __x * 2 <= _sz[0] + 1 && imgMC.x < 0 && imgMC.width >= _sz[0]) {
			imgMC.x = 0;
		} else if (imgMC.width <= _sz[0]) {
			imgMC.x = (_sz[0] - imgMC.width - __x * 2) / 2;
		}
		if (imgMC.y > 0 && imgMC.height >= _sz[1]) {
			imgMC.y = 0;
		} else if (imgMC.height + __y > _sz[1] && imgMC.height + imgMC.y + __y < _sz[1]) {
			if (_sz[1] >= imgMC.height) {
				imgMC.y = -__y;
			} else {
				imgMC.y = _sz[1] - imgMC.height - __y;
			}
		}
		if (imgMC.y > 0 - __y) {
			imgMC.y = 0 - __y;
		}
		if (imgMC.height + __y * 2 <= _sz[1] + 1 && imgMC.y < 0 && imgMC.height >= _sz[1]) {
			imgMC.y = 0;
		} else if (imgMC.height <= _sz[1]) {
			imgMC.y = (_sz[1] - imgMC.height - __y * 2) / 2;
		}
	}

	private function MCwdtFunc(num : int) : void {
		imgMC.width += num;
		if (imgMC.width < _sz[0]) {
			imgMC.width = _sz[0];
		}
		imgMC.height = imgMC.width / imgMCBL;
	}

	private function MChgtFunc(num : int) : void {
		imgMC.height += num;
		if (imgMC.height < _sz[1]) {
			imgMC.height = _sz[1];
		}
		imgMC.width = imgMC.height * imgMCBL;
	}

	public function set alignment(alg : String) : void {
		if (alg == "min" || alg == "max" || alg == "wdt" || alg == "hgt") {
			if (_alignment != alg) {
				_alignment = alg;
				imgLoadedFunc();
			}
		}
	}

	public function get alignment() : String {
		return _alignment;
	}

	public function set label(lab : String) : void {
		_label.text = lab;
		labelAlign = _labAlign;
	}

	public function get label() : String {
		return _label.text;
	}

	public function set showLabel(boo : Boolean) : void {
		_label.visible = boo;
	}

	public function get showLabel() : Boolean {
		return _label.visible;
	}

	public function set source(_url : String) : void {
		if (_url == _source) {
			return;
		}
		unloadAndStop();
		imgMC.x = 0;
		imgMC.y = 0;
		if (imgMC.width > 0 && imgMC.height > 0) {
			imgMC.width = defMCW;
			imgMC.height = defMCH;
			imgMCSF = 1;
		}
		bmp = null;
		imgMC.removeChildren();
		_source = _url;
		try {
			onFileOpen(_url);
		} catch (err : Error) {
			if(onLoadedError != null){
				onLoadedError();
			}
		}
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
			if(onLoadedError != null){
				onLoadedError();
			}
			return;
		}
		if(onLoading != null){
			onLoading();
		}
		if(!loader){
			loader = new Loader();
		}
		unloadAndStop();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
		loader.load(new URLRequest(file.url));
	}

	private function onLoadError(e : Event) : void {
		trace(e);
		if(onLoadedError != null){
			onLoadedError();
		}
	}

	public function set maxSize(num:uint):void{
		_maxSize = num;
	}

	public function get maxSize():uint{
		return _maxSize;
	}

	private function onLoadComplete(e : Event) : void {
		bmp = loader.content as Bitmap;
		if(bmp!=null){
			var bl : Number = bmp.width/bmp.height;
			var maxNum : uint = Math.max(bmp.width,bmp.height);
			var w:uint = bmp.width;
			var h:uint = bmp.height;
			var minNum : uint = _maxSize;
			if(maxNum > minNum){
				if(bmp.width > bmp.height){
					w = minNum;
					h = w/bl;
				}else{
					h = minNum;
					w = h*bl;
				}
				if(w == 0){
					w = 5;
				}else if(h==0){
					h = 5;
				}
				var matrix:Matrix = new Matrix();
				matrix.scale(w/bmp.width,h/bmp.height);
				bmpData = new BitmapData(w, h, true, 0);
				bmpData.lock();
				bmpData.draw(bmp, matrix);
				bmp = new Bitmap(bmpData);
			}
		}
		try {
			bmp.smoothing = true;
		} catch (err : Error) {
			if(onLoadedError != null){
				onLoadedError();
			}
			return;
		}
		_bmpW = bmp.width;
		_bmpH = bmp.height;
		imgMC.addChild(bmp);
		if (!_autoSize) {
			imgLoadedFunc();
		}
		size = [];
		if(onLoaded != null){
			onLoaded();
		}
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
	}

	private function imgLoadedFunc() : void {
		try {
			imgBL = bmp.width / bmp.height;
		} catch (err : Error) {
			return;
		}
		if (_alignment == "min") {
			if (_sz[0] / bmp.width > _sz[1] / bmp.height) {
				hgtFunc();
			} else {
				wdtFunc();
			}
		} else if (_alignment == "max") {
			if (_sz[0] / bmp.width > _sz[1] / bmp.height) {
				wdtFunc();
			} else {
				hgtFunc();
			}
		} else if (_alignment == "wdt") {
			wdtFunc();
		} else if (_alignment == "hgt") {
			hgtFunc();
		}
		if(bmp){
			imgMC.addChild(bmp);
		}
		imgMCBL = imgMC.width / imgMC.height;
		defMCW = imgMC.width;
		defMCH = imgMC.height;
		if (Number(imgMC.numChildren) > 0) {
			__x = imgMC.getChildAt(0).x;
			__y = imgMC.getChildAt(0).y;
			if (__x < 0) {
				__x = 0;
			}
			if (__y < 0) {
				__y = 0;
			}
		}
	}

	private function MID_UP(evt : MouseEvent) : void {
		Mouse.cursor = MouseCursor.AUTO;
		stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, MID_UP);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, MOVE);
	}

	private function MOVE(evt : MouseEvent) : void {
		if (mouseX + this.x < 5 || mouseX + this.x > stage.stageWidth - 10 || mouseY + this.y < 5 || mouseY + this.y > stage.stageHeight - 15) {
			MID_UP(evt);
		}
		imgMC.x = mouseX - _scaleX;
		imgMC.y = mouseY - _scaleY;
		restrictIMG();
		evt.updateAfterEvent();
	}

	private function wdtFunc() : void {
		bmp.width = _sz[0] > 0 ? _sz[0] : bmp.width;
		bmp.height = bmp.width / imgBL;
		imgMC.x = (_sz[0] - bmp.width) / 2;
		imgMC.y = (_sz[1] - bmp.height) / 2;
	}

	private function hgtFunc() : void {
		bmp.height = _sz[1] > 0 ? _sz[1] : bmp.height;
		bmp.width = bmp.height * imgBL;
		imgMC.x = (_sz[0] - bmp.width) / 2;
		imgMC.y = (_sz[1] - bmp.height) / 2;
	}

	public function get source() : String {
		return _source;
	}

	public function set bgColor(col : Object) : void {
		_bgColor = int(col);
		fill_bg();
	}

	public function get bgColor() : Object {
		return "0x" + uint(_bgColor).toString(16);
	}
}
}
