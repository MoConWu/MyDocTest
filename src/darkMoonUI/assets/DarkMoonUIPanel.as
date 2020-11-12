package darkMoonUI.assets {
import flash.events.FocusEvent;
import flash.display.Sprite;

/** @private */
public class DarkMoonUIPanel extends Sprite {
	// user public var function
	public var
	onResizing : Function,
	onClick : Function,
	onFocusChange : Function,
	onEnabledChange : Function;
	/** @private */
	protected var
	_type : String = "darkMoonUIControl",
	_enabled : Boolean = true,
	_regPoint : Array = ["left","top"],
	_alpha:Number = .6;
	/** @private */
	protected static var
	_SizeValue : Array,
	_FocusEvent : FocusEvent;
	/** @private */
	protected var
	_lockfocus : Boolean = false;
	/** @private */
	protected var
	_focus_in : Function,
	_focus_out : Function,
	_size_get : Function,
	_size_set : Function,
	_enabled_set : Function;

	public function DarkMoonUIPanel() : void {
	}

	public function set enabled(boo : Boolean) : void {
		_enabled = boo;
		trace(boo,"-------");
		if (boo) {
			this.alpha = 1.0;
			this.addEventListener(FocusEvent.FOCUS_IN, focus_in);
			this.addEventListener(FocusEvent.FOCUS_OUT, focus_out);
		} else {
			try {
				if (stage.focus == this) {
					stage.focus = null;
				}
			} catch (err : Error) {
			}
			this.alpha = _alpha;
			this.removeEventListener(FocusEvent.FOCUS_IN, focus_in);
			this.removeEventListener(FocusEvent.FOCUS_OUT, focus_out);
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
		_SizeValue = sz;
		_size_set();
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
		} else {
			stage.focus = null;
		}
	}

	public function get focus() : Boolean {
		return stage.focus == this ? true : _lockfocus;
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

	public function get style():JSON{
		return null;
	}

	public function set style(js:JSON):void{

	}
}
}