package darkMoonUI.controls {
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.interfaces.DMUI_PUB_IMAGE;
import darkMoonUI.assets.util.Base64;
import darkMoonUI.assets.util.Hex;
import darkMoonUI.types.ControlType;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.geom.Matrix;
import flash.net.URLRequest;
import flash.utils.ByteArray;

/**
 * @author moconwu
 */
public class Image extends DarkMoonUIControl implements DMUI_PUB_IMAGE {
	public var onLoadedError : Function;
	public var onLoaded : Function;
	public var onLoading : Function;
	private var
	imageSize : Vector.<uint> = Vector.<uint>([]),
	defSize : Vector.<uint> = Vector.<uint>([]),
	image : Sprite = new Sprite(),
	_source : String = "",
	_autoSize : Boolean = false,
	_maxSize : uint = 2000,
	imgBL : Number, defMCW : Number, defMCH : Number, imgMCBL : Number,
	_bmpW : Number,_bmpH : Number, file : File,loader : Loader, bmp : Bitmap,
	bmpData : BitmapData;

	public function Image(_url : String=null) : void {
		super();
		_type = ControlType.IMAGE;

		mc.addChild(image);
		create(0, 0, _url);
	}
	/** @private */
	protected override function _size_get() : Array {
		imageSize.length = 2;
		return [imageSize[0], imageSize[1]];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : defSize[0];
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : defSize[1];
		defSize = Vector.<uint>([_SizeValue[0], _SizeValue[1]]);
		if (_autoSize) {
			_SizeValue[0] = image.width = image.width > 0 ? image.width : 1;
			_SizeValue[1] = image.width = image.height > 0 ? image.height : 1;
		} else if (!isNaN(defMCW) && !isNaN(defMCH)) {
			if (_SizeValue[0] / _bmpW > _SizeValue[1] / _bmpH) {
				image.height = _SizeValue[1];
				image.width = imgMCBL * _SizeValue[1];
			} else {
				image.width = _SizeValue[0];
				image.height = _SizeValue[0] / imgMCBL;
			}
		}
		imageSize = _SizeValue = Vector.<uint>([uint(image.width), uint(image.height)]);
	}
	/** @private */
	protected override function _enabled_set() : void {
		tabEnabled = false;
	}

	public function copy() : Image {
		var newDMUI : Image = new Image();
		var sz : Array = size;
		newDMUI.create(x, y, source, sz[0], sz[1]);
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : int = 0, _y : int = 0, _url : String = "", w : uint = 150, h : uint = 150) : void {
		x = _x;
		y = _y;

		defSize = Vector.<uint>([w, h]);

		source = _url;
		enabled = _enabled;
	}

	public function unloadAndStop():void{
		if(loader){
			loader.unloadAndStop();
		}
		if(bmpData){
			bmpData.dispose();
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
		} catch (e : Error) {
			return;
		}
		if(onLoading != null){
			onLoading();
		}
		if(!loader){
			loader = new Loader();
		}
		unloadAndStop();
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
		loader.load(new URLRequest(file.url));
	}

	private function onLoadError(evt : Event) : void {
		if(onLoadedError != null){
			onLoadedError();
		}
		loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		trace(file.nativePath + " Load Failed!", new Error().getStackTrace());
	}

	private function onLoadComplete(evt : Event) : void {
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
				if(w==0){
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
		} catch (e : Error) {
			trace("[Image:]", e, new Error().getStackTrace());
			return;
		}
		_bmpW = bmp.width;
		_bmpH = bmp.height;
		image.addChild(bmp);
		if (!_autoSize) {
			imgLoadedFunc();
		}
		size = [];
		if(onLoaded != null){
			try{
				onLoaded();
			}catch(e:Error){
			}
		}
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
	}

	private function imgLoadedFunc() : void {
		try {
			imgBL = bmp.width / bmp.height;
		} catch (e : Error) {
			trace("[Image:]", e, new Error().getStackTrace());
			return;
		}
		if (defSize[0] / _bmpW > defSize[1] / _bmpH) {
			hgtFunc();
		} else {
			wdtFunc();
		}
		image.addChild(bmp);
		imgMCBL = image.width / image.height;
		if (isNaN(imgMCBL)) {
			imgMCBL = 1.0;
		}
		defMCW = image.width;
		defMCH = image.height;
	}

	private function wdtFunc() : void {
		bmp.width = defSize[0] > 0 ? defSize[0] : _bmpW;
		bmp.height = bmp.width / imgBL;
	}

	private function hgtFunc() : void {
		bmp.height = defSize[1] > 0 ? defSize[1] : _bmpH;
		bmp.width = bmp.height * imgBL;
	}

	public function set maxSize(num:uint):void{
		_maxSize = num;
	}

	public function get maxSize():uint{
		return _maxSize;
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public function get source() : String {
		return _source;
	}

	public function set source(_url : String) : void {
		if (_url == _source) {
			return;
		}
		unloadAndStop();
		image.x = 0;
		image.y = 0;
		if (image.width > 0 && image.height > 0) {
			image.width = defMCW;
			image.height = defMCH;
			imgMCBL = 1;
		}
		bmp = null;
		image.removeChildren();
		_source = _url;
		try {
			onFileOpen(_url);
		} catch (err : Error) {
			if(onLoadedError != null){
				onLoadedError();
			}
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

	public function get bitmap() : Bitmap {
		return bmp;
	}

	public function set bitmap(b : Bitmap) : void {
		image.removeChildren();
		bmp = b;
		bmp.smoothing = true;
		_bmpW = bmp.width;
		_bmpH = bmp.height;
		image.addChild(bmp);
		if (!_autoSize) {
			imgLoadedFunc();
		}
		size = [];
		if(onLoaded != null){
			onLoaded();
		}
	}

	public override function get showFocus() : Boolean {
		return false;
	}

	public override function set showFocus(boo : Boolean) : void {
	}
}
}
