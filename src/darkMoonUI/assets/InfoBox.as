package darkMoonUI.assets {
import flash.display.NativeWindow;
import flash.display.NativeWindowInitOptions;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterQuality;
import flash.filters.DropShadowFilter;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFormat;

import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.setTF;

/** @private */
public class InfoBox {
	private var _infoPanel : NativeWindow;
	private var _textBox : TextField = new TextField();
	private var _textBg : Shape = new Shape();
	private var _main : Sprite = new Sprite();
	private var nwo : NativeWindowInitOptions = new NativeWindowInitOptions();
	private static var rX:uint = Capabilities.screenResolutionX;
	private static var rY:uint = Capabilities.screenResolutionY;

	public function InfoBox() : void {
		nwo.systemChrome = "none";
		nwo.type = "utility";
		nwo.transparent = true;
		var _ttf : TextFormat = setTF(0x555555, "", false, 12);
		_textBox.defaultTextFormat = _ttf;
		_textBox.selectable = false;
		_textBox.multiline = true;
		fill(_textBg.graphics, 10, 10, 0xEEEEEE, 0x555555);
		_textBox.autoSize = "left";
		var filter : BitmapFilter = getBitmapFilter();
		var myFilters : Array = [];
		myFilters.push(filter);
		_main.filters = myFilters;
	}

	public function create(str : String, x : uint, y : uint) : void {
		close();
		_infoPanel = new NativeWindow(nwo);
		_infoPanel.alwaysInFront = true;
		_infoPanel.stage.scaleMode = "noScale";
		_infoPanel.stage.align = "TL";
		_main.alpha = 0.0;
		_main.addChild(_textBg);
		_main.addChild(_textBox);
		_infoPanel.stage.addChild(_main);
		_textBox.text = str;
		_textBox.wordWrap = false;
		var width : uint = _textBox.width;
		if (width > 400) {
			width = 400;
		}
		_textBox.wordWrap = true;
		_textBox.width = width;
		_textBg.width = _textBox.width + 6;
		_textBg.height = _textBox.height + 6;
		_textBox.x = _textBox.y = 3;
		_infoPanel.width = _textBg.width + 10;
		_infoPanel.height = _textBg.height + 10;
		if(x + _infoPanel.width <= rX){
			_infoPanel.x = x;
		}else{
			_infoPanel.x = x - _infoPanel.width;
		}
		if(y + _infoPanel.height <= rY){
			_infoPanel.y = y;
		}else{
			_infoPanel.y = y - _infoPanel.height - 28;
		}
		_infoPanel.stage.addEventListener(MouseEvent.MOUSE_OVER, closed);
		_infoPanel.stage.addEventListener(Event.ENTER_FRAME, anShow);
		_infoPanel.activate();
	}

	private function anShow(evt : Event) : void {
		_main.alpha += (1 - _main.alpha) / 10 + 0.04;
		if (_main.alpha >= 0.95) {
			_main.alpha = 1.0;
			_infoPanel.stage.removeEventListener(Event.ENTER_FRAME, anShow);
		}
	}

	private static function getBitmapFilter() : BitmapFilter {
		var color : Number = 0x000000;
		var angle : Number = 20;
		var alpha : Number = 0.4;
		var blurX : Number = 3;
		var blurY : Number = 3;
		var distance : Number = 5;
		var strength : Number = 0.65;
		var inner : Boolean = false;
		var knockout : Boolean = false;
		var quality : Number = BitmapFilterQuality.HIGH;
		return new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout);
	}

	private function closed(evt : MouseEvent) : void {
		close();
	}

	public function close() : void {
		try {
			_infoPanel.close();
		} catch (err : Error) {
		}
	}
}
}