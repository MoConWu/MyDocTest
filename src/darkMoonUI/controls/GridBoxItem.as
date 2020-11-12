package darkMoonUI.controls {
import darkMoonUI.types.ControlItemType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.functions.parentAddChilds;

import flash.display.DisplayObject;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

/**
 * @author moconwu
 */
public class GridBoxItem extends BoxItem {
	/** @private */
	internal var
	added_ref : Boolean = false,
	_id : int = -1;
	private var
	_labels : Vector.<String>,
	_mul : Boolean = false,
	_tP : Sprite,
	_parent : GridBox,
	selMC : Shape = new Shape(),
	_sz : Array = [50, 50],
	customSp : Sprite = new Sprite(),
	customSp_msk : Shape = new Shape(),
	custom_obj : Object = {},
	custom_resize_name : String = "size",
	thisMenu : NativeMenu = new NativeMenu();
	private static var
	overMC : Shape;

	public function GridBoxItem() : void {
		super();
		_type = ControlItemType.GRID_BOX_ITEM;
		fill(selMC.graphics, _sz[0], _sz[1], bgColorArr[2], bgColorArr[12]);
		if(overMC == null) {
			overMC = new Shape();
			fill(overMC.graphics, _sz[0], _sz[1], -1, bgColorArr[12]);
			overMC.visible = false;
			overMC.alpha = 0.3;
		}
		fill(customSp_msk.graphics);
		customSp.mask = customSp_msk;
		selMC.visible = mc.tabEnabled = false;
		selMC.alpha = 0.32;
		parentAddChilds(mc, Vector.<DisplayObject>([
			customSp, customSp_msk, selMC
		]));
		mc.addEventListener(Event.ADDED_TO_STAGE, ADDED);
		mc.addEventListener(MouseEvent.MOUSE_OVER, overFunc);
		mc.addEventListener(MouseEvent.MOUSE_OUT, outFunc);
		mc.addEventListener(MouseEvent.MOUSE_DOWN, downFunc);
		mc.addEventListener(MouseEvent.DOUBLE_CLICK, dbClickFunc);
		mc.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, RIGHT_DOWN);
	}

	private function overFunc(evt : MouseEvent) : void {
		mc.addChild(overMC);
		overMC.width = _sz[0] - 1;
		overMC.height = _sz[1] - 1;
		overMC.visible = true;
	}

	private static function outFunc(evt : MouseEvent) : void {
		overMC.visible = false;
	}

	private function ADDED(evt : Event) : void {
		mc.removeEventListener(Event.ADDED_TO_STAGE, ADDED);
		mc.addEventListener(Event.REMOVED_FROM_STAGE, REMOVE);
		_parent = mc.parent.parent.parent as GridBox;
		setNativeMenu();
		if(!added_ref){
//			added_ref = true;
			return;
		}
		if (!_parent.multiline && selected) {
			for (var i : uint = 0; i < _parent.items.length; i++) {
				if (_parent.items[i] != this) {
					_parent.items[i].selected = false;
				}
			}
			if(_parent.onChange != null){
				_parent.onChange();
			}
		}
		var heads : Vector.<String> = _parent.heads;
		if (_labels == null) {
			_labels = Vector.<String>([]);
		}
		if (heads != null) {
			_labels.length = heads.length;
		}
		for (i = 0; i < _labels.length; i++) {
			if (_labels[i] == null) {
				_labels[i] = "";
			}
		}
	}

	private function REMOVE(evt : Event) : void {
		_parent = null;
		mc.removeEventListener(Event.REMOVED_FROM_STAGE, REMOVE);
		mc.addEventListener(Event.ADDED_TO_STAGE, ADDED);
	}

	private function RIGHT_DOWN(evt : MouseEvent) : void {
		if (!selected) {
			selectOneFunc();
		}
		/*if (_canPause) {
		if (clipboardValue["type"] == "listBoxItem") {
		pasteMenu.enabled = true;
		} else {
		pasteMenu.enabled = false;
		}
		}*/
	}

	private function dbClickFunc(evt : MouseEvent) : void {
		var pFunc : Function = _parent.onItemDoubleClick;
		if (pFunc != null) {
			pFunc();
		}
	}

	public function get sprite():Sprite{
		return mc;
	}

	public function clear() : void {
		customSp.removeChildren();
		if (custom_obj is Sprite) {
			custom_obj.removeChildren();
		}
		mc.removeChildren();
	}

	private function downFunc(evt : MouseEvent) : void {
		_tP = mc.parent as Sprite;
		if (!_parent.enabled) {
			return;
		}
		if (_parent.multiline) {
			_parent.mouseSelectMoveFunc();
		}
		_mul = _parent.multiline;
		IOC = false;
		if (_mul) {
			var multNum : int = _parent.lastSelected;
			_parent.lastSelected = id;
			if (evt.shiftKey) {
				if (multNum == -1) {
					selected = true;
				} else {
					var leng : uint = Math.abs(id - multNum);
					var stratNum : int = multNum;
					if (multNum > id) {
						stratNum = id;
						for (var i : uint = 0; i < leng; i++) {
							var getItem : GridBoxItem = _parent.items[stratNum + i];
							getItem.IOC = false;
							if (getItem.mc.visible) {
								getItem.selected = !getItem.selected;
							}
							getItem.IOC = true;
						}
					} else {
						for (i = 1; i < leng + 1; i++) {
							getItem = _parent.items[stratNum + i];
							getItem.IOC = false;
							if (getItem.mc.visible) {
								getItem.selected = !getItem.selected;
							}
							getItem.IOC = true;
						}
					}
				}
			} else if (evt.ctrlKey) {
				selected = !selected;
			} else {
				selectOneFunc();
			}
		} else {
			selectOneFunc();
		}
		IOC = true;
		var selArr : Vector.<uint> = Vector.<uint>([]);
		for (i = 0; i < _parent.items.length; i++) {
			getItem = _parent.items[i];
			if (getItem.selected) {
				selArr.push(getItem.index);
			}
		}
		_parent.selectedIndexes = selArr;
	}

	private function selectOneFunc() : void {
		if (_parent != null) {
			for (var i : uint = 0; i < _parent.items.length; i++) {
				var getItem : GridBoxItem = _parent.items[i];
				getItem.IOC = false;
				if (getItem != this && getItem.selected) {
					getItem.IOC = true;
					getItem.selected = false;
				} else if(!getItem.selected && getItem == this){
					getItem.IOC = true;
					getItem.selected = true;
				}
				getItem.IOC = true;
			}
		}
	}
	/** @private */
	internal override function set itemSelectOver(boo : Boolean) : void {
		if (boo) {
			mc.addEventListener(MouseEvent.MOUSE_OVER, selectOver);
		} else {
			mc.removeEventListener(MouseEvent.MOUSE_OVER, selectOver);
		}
	}

	private function selectOver(evt : MouseEvent) : void {
		// selected = true;
		var va0 : uint = Math.min(_parent.lastSelected, _id);
		var va1 : uint = Math.max(_parent.lastSelected, _id);
		for (var i : uint = 0; i < _parent.items.length; i++) {
			_parent.items[i].IOC = false;
			if (_parent.items[i]._id >= va0 && _parent.items[i]._id <= va1) {
				_parent.items[i].selected = true;
			}
		}
		for (i = 0; i < _parent.items.length; i++) {
			_parent.items[i].IOC = true;
		}
		_parent.lastSelected = _id;
		if(_parent.multiline && _parent.onChange != null){
			_parent.onChange();
		}
	}
	/** @private */
//	internal override function defaultNativeMenu(_cEdit : Boolean, _cCopy : Boolean, _cPause : Boolean, _cCut : Boolean, _cDelete : Boolean, _uMenus : Vector.<NativeMenuItem>=null) : void {
	internal override function defaultNativeMenu() : void {
		/*_canCopy = _cCopy;
		_canEdit = _cEdit;
		_canPause = _cPause;
		_canCut = _cCut;
		_canDelete = _cDelete;
		_userMenus = _uMenus;*/
		setNativeMenu();
	}
	/** @private */
	internal override function setNativeMenu():void{
		if(_parent){
			var _pNM:NativeMenu = _parent.itemsNativeMenu;
			if(_pNM){
				thisMenu = _pNM;
				mc.contextMenu = thisMenu;
			}else{
				mc.contextMenu = null;
			}
		}
	}

	public function set customReSizeName(nam:String):void{
		custom_resize_name = nam;
	}

	public function set customSprite(cs : Sprite) : void {
		cs.tabEnabled = cs.tabChildren = false;
		custom_obj = cs;
		customSp.removeChildren();
		cs.doubleClickEnabled = true;
		customSp.addChild(cs);
	}

	public function get customSprite() : Sprite {
		return custom_obj as Sprite;
	}

	internal function setSize(arr : Array) : void {
		var w : uint = !isNaN(Number(arr[0])) ? Number(arr[0]) : _sz[0];
		var h : uint = !isNaN(Number(arr[1])) ? Number(arr[1]) : _sz[1];
		_sz[0] = w;
		_sz[1] = h;
		fill(mc.graphics, w - 1, h - 1, bgColorArr[3], bgColorArr[1]);
		selMC.width = w - 1;
		customSp_msk.width = w;
		selMC.height = h - 1;
		customSp_msk.height = h;
		if (custom_obj is DarkMoonUIControl) {
			custom_obj["size"] = [w, h];
		}else{
			try{
				custom_obj[custom_resize_name] = [w - 1, h - 1];
			}catch(e:Error){
			}
		}
	}

	public override function set selected(boo : Boolean) : void {
		var oldSel : Boolean = selMC.visible;
		selMC.visible = boo;
		if (oldSel != boo && onChangeSelected != null) {
			onChangeSelected();
		}
		if (_parent != null && IOC) {
			if (!_parent.multiline && boo && _parent.selectedIndexes.length <= 1) {
				var sIOCs : Dictionary = new Dictionary();
				for (var i : uint = 0; i < _parent.items.length; i++) {
					if (_parent.items[i] != this && !_parent.items[i].selected) {
						sIOCs[i] = _parent.items[i].IOC;
						_parent.items[i].IOC = false;
						_parent.items[i].selected = false;
					}
				}
				for (var key : int in sIOCs) {
					_parent.items[key].IOC = sIOCs[key];
					delete sIOCs[key];
				}
				if(oldSel != boo && _parent.onChange != null){
					_parent.onChange();
				}
			} else if (oldSel != boo && _parent.onChange != null){
				_parent.onChange();
			}
		}
	}

	// labels
	public override function set labels(labs : Vector.<String>) : void {
		if (labs != null) {
			if (_parent != null) {
				var heads : Vector.<String> = _parent.heads;
				_labels = Vector.<String>([]);
				for (var i : uint = 0; i < heads.length; i++) {
					if (labs.length > i) {
						_labels.push(labs[i]);
					} else {
						_labels.push("");
					}
				}
			} else {
				_labels = labs;
			}
		}else{
			_labels = Vector.<String>([]);
		}
	}

	public override function get labels() : Vector.<String> {
		return _labels;
	}

	public override function get selected() : Boolean {
		return selMC.visible;
	}

	public override function set visible(boo : Boolean) : void {
		mc.visible = boo;
	}

	public override function get visible() : Boolean {
		return mc.visible;
	}

	public function set parent(p : GridBox) : void {
		_parent = p;
	}

	public function get parent() : GridBox {
		return _parent;
	}
	/** @private */
	internal function setID(_i : int) : void {
		_id = _i;
	}

	public override function get id() : int {
		return _id;
	}

	public override function get size() : Array {
		return _sz;
	}
}
}
