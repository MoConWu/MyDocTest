package darkMoonUI.assets {
import darkMoonUI.types.ControlType;
import darkMoonUI.controls.regPoint.RegPointAlign;
import darkMoonUI.assets.interfaces.DMUI_PUB_DEF;

import flash.display.InteractiveObject;
import flash.display.NativeWindow;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

/**
 * DarkMoonUI控件对象。
 * @author WuHeKang
 */
public class DarkMoonUIControl extends Sprite implements DMUI_PUB_DEF {
	public var lock : Boolean = false;
	public var onResizing : Function;
	public var onClick : Function;
	public var onMouseDown : Function;
	public var onDoubleClick : Function;
	public var onMiddleClick : Function;
	public var onRightClick : Function;
	public var onWheel : Function;
	public var onFocusChange : Function;
	public var onEnabledChange : Function;
	public var onKeyboard : Function;

	/** @private */
	protected var
	_infoTimer : Timer,
	_tempEnabled : Boolean = false,
	_helperInfo : String,
	_helperInfo2 : String,
	mc : Sprite = new Sprite(),
	_enabled : Boolean = true,
	_regPoint : Array = RegPointAlign.LEFT_TOP.slice(),
	_alpha : Number = .4,
	_SizeValue : Vector.<uint> = new Vector.<uint>(),
	_type : String = ControlType.DARK_MOON_UI_CONTROL;

	/** @private */
	protected static var
	_MouseEvent : MouseEvent,
	_KeyboardEvent : KeyboardEvent,
	_FocusEvent : FocusEvent;

	/** @private */
	protected var
	_lockfocus : Boolean = false;
	// protected function

	/** @private */
	private static var
	_infoBox : InfoBox;

	public function DarkMoonUIControl() : void {
		addChild(mc);
		doubleClickEnabled = true;
	}

	/**@private*/
	protected function _focus_in() : void {}
	/**@private*/
	protected function _focus_out() : void {}
	/**@private*/
	protected function _size_get() : Array { return [mc.width, mc.height]; }
	/**@private*/
	protected function _size_set() : void {}
	/**@private*/
	protected function _enabled_set() : void {}
	/**@private*/
	protected function _tempEnabled_set() : void {}
	/**@private*/
	protected function _mouseOut() : void {}
	/**@private*/
	protected function _mouseOver() : void {}
	/**@private*/
	protected function _mouseDown() : void {}
	/**@private*/
	protected function _mouseUp() : void {}
	/**@private*/
	protected function _mouseClick() : void {}
	/**@private*/
	protected function _mouseDoubleClick() : void {}
	/**@private*/
	protected function _mouseMiddleDown() : void {}
	/**@private*/
	protected function _mouseMiddleUp() : void {}
	/**@private*/
	protected function _mouseMiddleClick() : void {}
	/**@private*/
	protected function _mouseRightDown() : void {}
	/**@private*/
	protected function _mouseRightUp() : void {}
	/**@private*/
	protected function _mouseRightClick() : void {}
	/**@private*/
	protected function _mouseWheel(boo : Boolean = false) : void {}
	/**@private*/
	protected function _keyDown() : void {}
	/**@private*/
	protected function _keyUp() : void {}

	public function set enabled(boo : Boolean) : void {
		tabEnabled = _enabled = _tempEnabled ? false : boo;
		setEnabled(_enabled);
		_enabled = boo;
	}

	public function get tempEnabled() : Boolean {
		return _tempEnabled;
	}

	public function set tempEnabled(boo : Boolean) : void {
		_tempEnabled = boo;
		if (boo) {
			var oldEn : Boolean = _enabled;
			_enabled = false;
			setEnabled(false);
			_enabled = oldEn;
		} else {
			setEnabled(_enabled);
		}
		_tempEnabled_set();
	}

	private function setEnabled(boo : Boolean) : void {
		if (boo) {
			this.alpha = 1.0;
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			this.addEventListener(MouseEvent.CLICK, mouseClick);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClick);
			this.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouseMiddleDown);
			this.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouseMiddleUp);
			this.addEventListener(MouseEvent.MIDDLE_CLICK, mouseMiddleClick);
			this.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseRightDown);
			this.addEventListener(MouseEvent.RIGHT_MOUSE_UP, mouseRightUp);
			this.addEventListener(MouseEvent.RIGHT_CLICK, mouseRightClick);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			this.addEventListener(FocusEvent.FOCUS_IN, focus_in);
			this.addEventListener(FocusEvent.FOCUS_OUT, focus_out);
			this.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			this.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		} else {
			try {
				if (stage.focus == this) {
					stage.focus = null;
				}
			} catch (err : Error) {
			}
			this.alpha = _alpha;
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			this.removeEventListener(MouseEvent.CLICK, mouseClick);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClick);
			this.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouseMiddleDown);
			this.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouseMiddleUp);
			this.removeEventListener(MouseEvent.MIDDLE_CLICK, mouseMiddleClick);
			this.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseRightDown);
			this.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, mouseRightUp);
			this.removeEventListener(MouseEvent.RIGHT_CLICK, mouseRightClick);
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			this.removeEventListener(FocusEvent.FOCUS_IN, focus_in);
			this.removeEventListener(FocusEvent.FOCUS_OUT, focus_out);
			this.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			this.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		_enabled_set();
		if(onEnabledChange != null){
			onEnabledChange();
		}
	}

	public function get enabled() : Boolean {
		return _enabled;
	}

	public function get regPoint() : Array {
		return _regPoint;
	}

	public function set regPoint(reg : Array) : void {
		_regPoint[0] = reg[0] == "left" || reg[0] == "right" || reg[0] == "center" ? reg[0] : _regPoint[0];
		_regPoint[1] = reg[1] == "top" || reg[1] == "bottom" || reg[1] == "center" ? reg[1] : _regPoint[1];
		size = [];
	}

	public function get type() : String {
		return _type;
	}

	public function set size(sz : Array) : void {
		_SizeValue.length = 2;
		var _sz : Array = _size_get();
		if(_sz[0] == sz[0] && _sz[1] == sz[1]){
			return;
		}
		_SizeValue[0] = sz[0];
		_SizeValue[1] = sz[1];
		_size_set();
		if (_regPoint[0] == "left") {
			mc.x = 0;
		} else if (_regPoint[0] == "right") {
			mc.x = -_SizeValue[0];
		} else if (_regPoint[0] == "center") {
			mc.x = -_SizeValue[0] / 2;
		}
		if (_regPoint[1] == "top") {
			mc.y = 0;
		} else if (_regPoint[1] == "bottom") {
			mc.y = -_SizeValue[1];
		} else if (_regPoint[1] == "center") {
			mc.y = -_SizeValue[1] / 2;
		}
		if(onResizing != null){
			onResizing();
		}
	}

	public function get size() : Array {
		return _size_get();
	}

	public function set focus(boo : Boolean) : void {
		if (boo && enabled) {
			if (!_lockfocus) {
				stage.focus = this;
			}
		} else if (stage.focus == this) {
			stage.focus = null;
		}
		if (boo) {
			_focus_in();
		} else {
			_focus_out();
		}
	}

	public function get focus() : Boolean {
		if (stage) {
			return stage.focus == this ? true : _lockfocus;
		}
		return false;
	}

	private function focus_in(evt : FocusEvent) : void {
		_focus_in();
		if(onFocusChange != null){
			onFocusChange();
		}
	}

	private function focus_out(evt : FocusEvent) : void {
		_focus_out();
		if(onFocusChange != null){
			onFocusChange();
		}
	}

	private function mouseOut(evt : MouseEvent) : void {
		_MouseEvent = evt;
		_mouseOut();
		if(_infoTimer != null){
			_infoTimer.stop();
		}
	}

	private function downHelper(evt : MouseEvent) : void {
		_infoBox.close();
		removeEventListener(MouseEvent.MOUSE_OVER, showHelper);
		removeEventListener(MouseEvent.MOUSE_DOWN, downHelper);
	}

	private function upHelper(evt : MouseEvent) : void {
		addEventListener(MouseEvent.MOUSE_OVER, showHelper);
		addEventListener(MouseEvent.MOUSE_DOWN, downHelper);
	}

	private function showHelper(evt : MouseEvent) : void {
		if(_infoTimer != null){
			_infoTimer.reset();
			_infoTimer.start();
		}
	}

	private static function closeHelper(evt : MouseEvent) : void {
		_infoBox.close();
	}

	private static function closeHelper0(evt : KeyboardEvent) : void {
		_infoBox.close();
	}

	private function mouseOver(evt : MouseEvent) : void {
		_MouseEvent = evt;
		_mouseOver();
	}

	public function set helperInfo(str:String):void{
		_helperInfo = str;
		setHelper();
	}

	private function setHelper():void{
		if((_helperInfo == null || _helperInfo== "") && (_helperInfo2 == null || _helperInfo2 == "")){
			_infoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, showInfo);
			_infoTimer = null;
		}else{
			if(_infoTimer == null){
				_infoTimer = new Timer(800, 1);
				_infoTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showInfo);
			}
			if(_infoBox == null){
				_infoBox = new InfoBox();
			}
			addEventListener(MouseEvent.MOUSE_OVER, showHelper);
			addEventListener(MouseEvent.MOUSE_OUT, closeHelper);
			addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, closeHelper);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, closeHelper);
			addEventListener(MouseEvent.MOUSE_DOWN, downHelper);
			addEventListener(MouseEvent.MOUSE_UP, upHelper);
			addEventListener(MouseEvent.MOUSE_WHEEL, closeHelper);
			addEventListener(KeyboardEvent.KEY_DOWN, closeHelper0);
		}
	}

	public function set helperInfo2(str:String):void{
		_helperInfo2 = str;
		setHelper();
	}

	private function showInfo(evt : TimerEvent) : void {
		var infoStr : String = "";
		if (_helperInfo != "" && _helperInfo != null && _enabled) {
			infoStr = _helperInfo;
		} else if (_helperInfo2 != "" && _helperInfo2 != null && !_enabled) {
			infoStr = _helperInfo2;
		}
		if (infoStr != "" && infoStr!=null) {
			var mainWin : NativeWindow = stage.nativeWindow;
			try {
				var ttP : Sprite = this;
				var _x : uint = stage.nativeWindow.x;
				var _y : uint = stage.nativeWindow.y;
				do {
					try {
						_x += ttP.x;
						_y += ttP.y;
						ttP = ttP.parent as Sprite;
					} catch (err : Error) {
						break;
					}
				} while (true);
				var active : Boolean = mainWin.active;
				var focusName : InteractiveObject = stage.focus;
				_infoBox.create(infoStr, _x + mouseX + 10, _y + mouseY + 55);
				if (active && !mainWin.alwaysInFront) {
					mainWin.activate();
				}
				stage.focus = focusName;
			} catch (err : Error) {
			}
		}
		//_infoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, showInfo);
	}

	/**@private*/
	protected function mouseDown(evt : MouseEvent) : void {
		_MouseEvent = evt;
		if(_infoTimer != null){
			_infoTimer.stop();
		}
		if (!_lockfocus) {
			stage.focus = this;
		}
		_mouseDown();
		if(onMouseDown != null){
			onMouseDown();
		}
	}

	private function mouseClick(evt : MouseEvent) : void {
		_MouseEvent = evt;
		_mouseClick();
		if(onClick != null){
			onClick();
		}
	}

	private function mouseDoubleClick(evt : MouseEvent) : void {
		_MouseEvent = evt;
		_mouseDoubleClick();
		if(onDoubleClick != null){
			onDoubleClick();
		}
	}

	private function mouseMiddleDown(evt : MouseEvent) : void {
		_MouseEvent = evt;
		if(_infoTimer != null){
			_infoTimer.stop();
		}
		if (!_lockfocus) {
			stage.focus = this;
		}
		_mouseMiddleDown();
	}

	private function mouseMiddleClick(evt : MouseEvent) : void {
		_MouseEvent = evt;
		_mouseMiddleClick();
		if(onMiddleClick != null){
			onMiddleClick();
		}
	}

	private function mouseRightDown(evt : MouseEvent) : void {
		_MouseEvent = evt;
		if(_infoTimer!=null){
			_infoTimer.stop();
		}
		if (!_lockfocus) {
			stage.focus = this;
		}
		_mouseRightDown();
	}

	private function mouseRightClick(evt : MouseEvent) : void {
		_MouseEvent = evt;
		if(_infoTimer != null){
			_infoTimer.stop();
		}
		_mouseRightClick();
		if(onRightClick != null){
			onRightClick();
		}
	}

	private function mouseWheel(evt : MouseEvent) : void {
		_MouseEvent = evt;
		if(_infoTimer != null){
			_infoTimer.stop();
		}
		_mouseWheel();
		if(onWheel != null){
			onWheel();
		}
	}

	private function keyDown(evt : KeyboardEvent) : void {
		_KeyboardEvent = evt;
		if(_infoTimer != null){
			_infoTimer.stop();
		}
		_keyDown();
		if(onKeyboard != null){
			onKeyboard();
		}
	}

	private function keyUp(evt : KeyboardEvent) : void {
		_KeyboardEvent = evt;
		_keyUp();
	}

	private function mouseUp(evt : MouseEvent) : void {
		_MouseEvent = evt;
		_mouseUp();
	}

	private function mouseRightUp(evt : MouseEvent) : void {
		_MouseEvent = evt;
		_mouseRightUp();
	}

	private function mouseMiddleUp(evt : MouseEvent) : void {
		_MouseEvent = evt;
		_mouseMiddleUp();
	}

	/** @private */
	public function get style() : JSON {
		return null;
	}

	/** @private */
	public function set style(js : JSON) : void {
	}

	public function get showFocus() : Boolean{
		return true;
	}

	public function set showFocus(boo : Boolean) : void {
	}
}
}
