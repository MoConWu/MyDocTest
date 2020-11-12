package darkMoonUI.controls {
import flash.display.NativeWindow;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.system.Capabilities;

import darkMoonUI.assets.MsgBoxIcons;
import darkMoonUI.assets.functions.createWindow;
import darkMoonUI.assets.functions.ownerWindow;

/**
 * @author moconwu
 */
public class MsgBox {
	public var onClose : Function;
	private static const
	spacing : uint = 15,
	resolutionY : uint = Capabilities.screenResolutionY,
	resolutionX : uint = Capabilities.screenResolutionX;
	private static var
	sz : Array = [30, 30],
	msgWindow : NativeWindow,
	_btns : Vector.<String>, _funcs : Vector.<Function>,
	iconBmp : Image = new Image(),
	btnMC : Sprite = new Sprite(),
	_defBtn : uint = 0,_escBtn : int = -1,
	infoText : Label = new Label(),
	_info : String,
	_title : String,
	_icon : String,
	_btnColors : Vector.<Object>,
	_html : Boolean = false;
	private var
	stage : Stage,
	_canClose:Boolean = true,
	_listenClose:Boolean = false;

	public function MsgBox(stg : Stage = null) {
		if (stg != null) {
			setStage(stg);
		}
		iconBmp.create(spacing, spacing, "", sz[0], sz[1]);
	}

	public function show(info : String, title : String = "", btns : Vector.<String> = null, funcs : Vector.<Function> = null, icon : String = "i", defBtn : uint = 0, escBtn : int = -1, btnColors : Vector.<Object> = null, html : Boolean = false, canClose:Boolean = true, listenClose : Boolean=false) : void {// question/information/warning/error
		if (stage == null) {
			trace("MsgBox if not have STAGE, The Function maybe not run!", new Error().getStackTrace());
		}
		if (btns == null || btns.length == 0) {
			if(canClose){
				btns = Vector.<String>(["确定"]);
			}else{
				btns = Vector.<String>([]);
			}
		}
		_title = title;
		_icon = icon;
		_btns = btns;
		_funcs = funcs;
		_defBtn = defBtn;
		_escBtn = escBtn;
		_info = info;
		_html = html;
		_btnColors = btnColors;
		_canClose = canClose;
		_listenClose = listenClose;
		try {
			msgWindow.removeEventListener(Event.CLOSING, closeCheck);
			msgWindow.addEventListener(Event.CLOSE, tryClose);
			msgWindow.close();
		} catch (err : Error) {
			tryClose();
		}
		if (msgWindow.closed) {
			tryClose();
		}
	}

	public function setStage(stg : Stage) : void {
		stage = stg;
	}

	private function closeCheck(evt:Event):void{
		trace("[MSG INFO] ---closeCheck---");
		if(!_canClose){
			evt.preventDefault();
			msgWindow.activate();
		}
	}

	private static function active(evt:Event):void{
		msgWindow.close();
	}

	private function tryClose(...args) : void {
		trace("[MSG INFO] ---tryClose---");
		msgWindow = createWindow();
		msgWindow.addEventListener(Event.CLOSING, closeCheck);
		msgWindow.removeEventListener(Event.CLOSE, tryClose);
		msgWindow.title = _title;

		if (MsgBoxIcons[_icon] != undefined) {
			iconBmp.create(spacing, spacing, "", sz[0], sz[1]);
			iconBmp.base64 = MsgBoxIcons[_icon];
			iconBmp.visible = true;
		} else {
			iconBmp.visible = false;
		}
		infoText.wordWrap = false;
		iconBmp.x = iconBmp.y = spacing;
		var infoX : uint = (iconBmp.x + sz[0]) * uint(iconBmp.visible) + spacing;
		infoText.x = infoX;
		infoText.y = spacing;
		if (_html) {
			infoText.htmlText = _info;
		} else {
			infoText.label = _info;
		}
		if (infoText.size[0] > resolutionX * .6){
			infoText.wordWrap = true;
			infoText.size = [resolutionX * .6];
		}
		var infoY : uint = infoText.y + infoText.size[1];
		var iconY : uint = iconBmp.y + sz[1];
		var btnY : uint = infoY > iconY ? infoY + spacing - 5 : iconY + spacing - 5;
		var btnArr : Array = [];
		for (var i : uint = 0; i < _btns.length; i++) {
			var btn : Button = new Button();
			btn.create(0, 0, _btns[i]);
			btn.autoSize = true;
			if (_btnColors != null && i < _btnColors.length) {
				if (!isNaN(uint(_btnColors[i]))) {
					btn.bgColor = _btnColors[i];
				}
			}
			var btnSZ : Array = btn.size;
			btn.autoSize = false;
			btn.size = [btnSZ[0] + 10];
			btn.addEventListener(MouseEvent.CLICK, btnClick);
			btnArr.push(btn);
		}

		btnMC.removeChildren();
		for (i = 0; i < _btns.length; i++) {
			var thisBtn : Button = btnArr[i];
			var lastX : uint = 0;
			if (i > 0) {
				var lastBtn : Button = btnArr[i - 1];
				lastX = lastBtn.size[0] + lastBtn.x + spacing - 5;
			}
			thisBtn.x = lastX;
			btnMC.addChild(thisBtn);
		}

		msgWindow.stage.removeChildren();
		msgWindow.stage.addChild(iconBmp);
		msgWindow.stage.addChild(infoText);
		msgWindow.stage.addChild(btnMC);

		var width0 : uint = infoText.x + infoText.size[0] + spacing;
		var width1 : uint = btnMC.width + spacing * 2;

		var winW : uint = width0 > width1 ? width0 : width1;
		if (winW < 120) {
			winW = 120;
			var iconW : uint = (iconBmp.x + sz[0]) * uint(iconBmp.visible);
			infoText.x = (winW - infoText.width - iconW) / 2 + iconW;
		}
		var winH : uint = btnY + btnMC.height + spacing;
		msgWindow.stage.stageWidth = winW;
		msgWindow.stage.stageHeight = winH;
		btnMC.y = btnY;
		btnMC.x = (winW - btnMC.width) / 2;

		if (_canClose) {
			msgWindow.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		if (stage) {
			msgWindow.x = stage.nativeWindow.x + (stage.nativeWindow.width - winW) / 2;
			msgWindow.y = stage.nativeWindow.y + (stage.nativeWindow.height - winH) / 2;
			if (msgWindow.x < 0) {
				msgWindow.x = (resolutionX - winW) / 2;
			}
			if (msgWindow.y < 0) {
				msgWindow.y = (resolutionY - winH) / 2;
			}
		}else{
			msgWindow.x = (resolutionX - winW) / 2;
			msgWindow.y = (resolutionY - winH) / 2;
		}
		msgWindow.addEventListener(Event.CLOSE, closed);
		msgWindow.activate();
		if (stage != null) {
			ownerWindow(stage.nativeWindow, msgWindow);
		}
	}

	private function closed(evt : Event) : void {
		trace("[MSG INFO] ---closed---");
		if(onClose != null){
			onClose();
		}
	}

	private function btnClick(evt : MouseEvent) : void {
		if(_canClose && !_listenClose){
			msgWindow.close();
		}
		if(_canClose && _listenClose){
			evt.preventDefault();
			msgWindow.addEventListener(Event.ACTIVATE,active);
		}
		var btn : Button;
		if (evt.target["parent"] == "[object Button]") {
			btn = evt.target["parent"] as Button;
		} else {
			btn = evt.target["parent"]["parent"] as Button;
		}
		try {
			var num : uint = _btns.indexOf(btn.label);
			if(_funcs){
				if(num<=_funcs.length-1){
					if(_funcs[num]){
						_funcs[num]();
					}
				}
			}
		} catch (e : Error) {
			trace("[Msg Error:]",e,e.getStackTrace());
		}
	}

	private function defKeyUp(evt : KeyboardEvent) : void {
		try {
			_funcs[_defBtn]();
		} catch (err : Error) {
		}
		if(_canClose){
			msgWindow.close();
		}
	}

	private static function escKeyUp(evt : KeyboardEvent) : void {
		msgWindow.close();
	}

	private function keyDown(evt : KeyboardEvent) : void {
		if (evt.keyCode == 32 || evt.keyCode == 13) {
			try {
				var defBtnMC : Button = btnMC.getChildAt(_defBtn) as Button;
				defBtnMC.focus = true;
				defBtnMC.addEventListener(KeyboardEvent.KEY_UP, defKeyUp);
			} catch (err : Error) {
			}
		} else if (evt.keyCode == 27) {
			try {
				var escBtnMC : Button = btnMC.getChildAt(_btns.length + _escBtn) as Button;
				escBtnMC.focus = true;
				escBtnMC.addEventListener(KeyboardEvent.KEY_UP, escKeyUp);
			} catch (err : Error) {
			}
		}
	}

	public function get window():NativeWindow{
		return msgWindow;
	}

	public function close() : void {
		try {
			msgWindow.removeEventListener(Event.CLOSING, closeCheck);
			msgWindow.removeEventListener(Event.CLOSE, tryClose);
			msgWindow.close();
		} catch (e : Error) {
			trace("[MSG ERROR:]",e,e.getStackTrace());
		}
	}
}
}