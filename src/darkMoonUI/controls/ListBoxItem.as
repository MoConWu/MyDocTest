package darkMoonUI.controls {
import darkMoonUI.types.ControlItemType;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.functions.parentAddChilds;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.fill_circle;
import darkMoonUI.assets.functions.setTF;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.utils.Dictionary;

/**
 * @author moconwu
 */
public class ListBoxItem extends BoxItem {
	public var onChange : Function;
	public var onInput : Function;
	/** @private */
	internal var
	added_ref : Boolean = false,
	ttMC : Sprite = new Sprite();
	private var
	_top : Boolean = false,
	_id : int = -1,
	_sz : Array = [150, 25],
	_bgColor : uint = bgColorArr[3],
	_selectedColor : uint = bgColorArr[5],
	_parent : ListBox,
	_selected : Boolean = false,
	cbMC : Sprite,
	icoMC : Sprite,
	_labels : Vector.<String>,
	_htmlLabels : Vector.<String>,
	_tP : Sprite,
	_mul : Boolean = false,
	_added : Boolean = false,
	_treeTT: Shape,
	_ttArr : Vector.<TextField>,
	_cbArr : Vector.<ComboBox>,
	_icoArr : Vector.<Image>,
	_serialTT : TextField = new TextField(),
	_tf : TextFormat = setTF(textColorArr[0]),
	_serialTf : TextFormat = setTF(textColorArr[6]),
	_restricts : Vector.<String>,
	_icons : Vector.<String>,
	_bmpDatas : Vector.<BitmapData>,
	_lengths : Vector.<uint>,
	_rounds : Vector.<Vector.<String>>,
	_edits : Vector.<Boolean>,
	_labelColors : Vector.<Object>,
	_infoLabels : Vector.<String>,
	_edit : Boolean = false,
	_passwords : Vector.<Boolean>,
	_treeView : Boolean = false,
	_treeViewSpacing : uint = 10,
	_treeViewColor : Object = 0,
	_canSearch : Boolean = false,
	_searchMinItems : int = 5,
	_searchUsePinyin : Boolean = true,
	_searchMatchCase : Boolean = false,
//	_canDelete : Boolean = false,
//	_canCopy : Boolean = false,
//	_canPause : Boolean = false,
//	_canCut : Boolean = false,
//	_canEdit : Boolean = false,
	/*copyMenu : NativeMenuItem = new NativeMenuItem("复制"),
	pasteMenu : NativeMenuItem = new NativeMenuItem("粘贴"),
	cutMenu : NativeMenuItem = new NativeMenuItem("剪切"),
	editMenu : NativeMenuItem = new NativeMenuItem("编辑"),
	deletMenu : NativeMenuItem = new NativeMenuItem("刪除"),*/
	_userMenus : Vector.<NativeMenuItem>,
	thisMenu : NativeMenu,
	_showSelected : Boolean = true,
	_iconSpacing : uint = 3,
	has_edt : Boolean = false
	;

	// msg : MsgBox;
	public function ListBoxItem() : void {
		super();
		_type = ControlItemType.LIST_BOX_ITEM;
		mc.doubleClickEnabled = _serialTf.bold = true;
		_serialTT.setTextFormat(_serialTf);
		_serialTT.defaultTextFormat = _serialTf;
		_serialTT.autoSize = TextFieldAutoSize.LEFT;
//		fill(mc.graphics, _sz[0], _sz[1], _bgColor, bgColorArr[1]);
		_serialTT.selectable = mc.tabEnabled = ttMC.mouseEnabled = _selected = false;

		parentAddChilds(mc, Vector.<DisplayObject>([
			_serialTT, ttMC
		]));
		mc.addEventListener(Event.ADDED_TO_STAGE, ADDED);
		mc.addEventListener(MouseEvent.MOUSE_DOWN, downFunc);
		mc.addEventListener(MouseEvent.DOUBLE_CLICK, dbClickFunc);
		mc.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, RIGHT_DOWN);
	}

	public function set top(boo : Boolean) : void {
		_top = boo;
		if (boo && _parent != null) {
			_parent.addItemAt(this, 0);
		}
	}

	public function get top() : Boolean {
		return _top;
	}

	/** @private */
	public override function set size(w : Array) : void {
		if(_sz[0] != w[0] || _sz[1] != w[1]) {
			_sz = w;
			fill(mc.graphics, _sz[0], _sz[1], _selected && _showSelected ? _selectedColor : _bgColor, _selected && _showSelected ? -1 : bgColorArr[1]);
		}
	}
	/** @private */
	public override function get size() : Array {
		return _sz;
	}
	/** @private */
	internal function get sizeList() : Vector.<uint> {
		var list : Vector.<uint> = Vector.<uint>([]);
		if (_serialTT.visible) {
			_serialTT.autoSize = TextFieldAutoSize.LEFT;
			list.push(_serialTT.width);
		}
		for (var i : uint = 0; i < _ttArr.length; i++) {
			var treeViewLeng:uint = uint(_treeView)*_treeViewSpacing*id;
			_ttArr[i].autoSize = TextFieldAutoSize.LEFT;
			var ifOK:Boolean = false;
			if (_ttArr[i].visible) {
				ifOK = true;
				list.push(_ttArr[i].width + treeViewLeng);
			} else if(_icoArr!=null) {
				if(i<_icoArr.length){
					if(_icoArr[i]){
						ifOK = true;
						list.push(_sz[1] + treeViewLeng);
					}
				}
			}
			if(!ifOK){
				list.push(_ttArr[i].width + 30 + treeViewLeng);
			}
		}
		return list;
	}
	/** @private */
	internal function set sizeList(list : Vector.<uint>) : void {
		_serialTT.autoSize = TextFieldAutoSize.NONE;
		var n : uint = int(_serialTT.visible);
		if (n) {
			_serialTT.x = list[0] - _serialTT.width;
		}
		for (var i : uint = 0; i < list.length - n; i++) {
			if (i >= _ttArr.length) {
				continue;
			}
			var treeViewLeng:uint = uint(_treeView)*_treeViewSpacing*id;
			_ttArr[i].autoSize = TextFieldAutoSize.NONE;
			_ttArr[i].width = list[i + n] - treeViewLeng;
			_ttArr[i].height = _sz[1] - 4;
			if (i > 0) {
				_ttArr[i].x = _ttArr[i - 1].x + _ttArr[i - 1].width;
			} else if (n) {
				_ttArr[0].x = list[0] + treeViewLeng;
			}
			if (_cbArr[i] != null) {
				_cbArr[i].create(_ttArr[i].x, 0, _ttArr[i].text, _ttArr[i].width, _sz[1]);
			}
			if(_icoArr!=null){
				if(i<_icoArr.length){
					if(_icoArr[i]!=null){
						_icoArr[i].x = _ttArr[i].x + _iconSpacing;
					}
				}
			}
		}
		if(_ttArr.length>0){
			if(_ttArr[0] != null){
				if(_treeTT == null){
					_treeTT = new Shape();
					mc.addChild(_treeTT);
				}
				_treeTT.visible = _treeView && id>0;
				_treeTT.x = _ttArr[0].x - _treeTT.width + 5;
			}
		}
		if (_ttArr.length > 0) {
			size = [_ttArr[_ttArr.length - 1].x + _ttArr[_ttArr.length - 1].width, _sz[1]];
		}
	}

	public override function set selected(boo : Boolean) : void {
		var oldSel : Boolean = _selected;
		if(_selected == boo){
			return;
		}
		_selected = boo;
		fill(mc.graphics, _sz[0], _sz[1], _selected && _showSelected ? _selectedColor : _bgColor, _selected && _showSelected ? -1 : bgColorArr[1]);
		for (var i : uint = 0; i < _cbArr.length; i++) {
			if (_cbArr[i] is ComboBox) {
				if (_cbArr[i].visible) {
					if (boo && _showSelected) {
						_cbArr[i].bgColor = _selectedColor;
					} else {
						_cbArr[i].bgColor = _bgColor;
					}
				}
			}
		}
		if (oldSel != boo && onChangeSelected!=null) {
			onChangeSelected();
		}
		if (_parent != null && IOC) {
			if (!_parent.multiline && boo && _parent.selectedIndexes.length <= 1) {
				var sIOCs : Dictionary = new Dictionary();
				for (i = 0; i < _parent.items.length; i++) {
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

	public override function get selected() : Boolean {
		return _selected && _showSelected;
	}

	/*private function setClipboardValue(val : String) : void {
		if (clipboardValue["type"] == "listBoxItem") {
			if (clipboardValue["value"][1] == "cut") {
				var list : Vector.<ListBoxItem> = clipboardValue["value"][0];
				for (var i : uint = 0; i < list.length; i++) {
					list[i].mc.alpha = 1.0;
				}
			}
		}
		if (val == "cut") {
			list = _parent.selectedItems;
			for (i = 0; i < list.length; i++) {
				list[i].mc.alpha = .4;
			}
		}
		clipboardValue["value"] = [_parent.selectedItems, val, _parent];
		clipboardValue["type"] = "listBoxItem";
	}*/

	/*private function copyMenuFunc(evt : Event) : void {
		setClipboardValue("copy");
	}

	private function cutMenuFunc(evt : Event) : void {
		setClipboardValue("cut");
	}*/

	/*private function pasteMenuFunc(evt : Event) : void {
		// msg.show("请选择是对选择项 [覆盖] 还是在列表中 [新建]", "确认操作", Vector.<String>(["覆蓋", "新建", "取消"]), Vector.<Function>([checkOWItems, newItems]));
	}*/

	/*private function checkOWItems() : void {
	if (clipboardValue["type"] == "listBoxItem") {
	if (clipboardValue["value"][0] != null) {
	const leng0 : uint = clipboardValue["value"][0]["length"];
	const leng1 : uint = _parent.selectedItems.length;
	if (clipboardValue["value"][0]["length"] != _parent.selectedItems.length) {
	if (leng0 == 1) {
	// msg.show("即将 [覆盖] 项数 [" + leng0 + "] 与当前选择项数 [" + leng1 + "] 不一致,是否继续?", "选择操作", Vector.<String>(["全部覆蓋", "覆盖首项", "取消"]), Vector.<Function>([fillOWItems, OWItems]));
	} else if (leng0 > 1) {
	// msg.show("即将 [覆盖] 项数 [" + leng0 + "] 与当前选择项数 [" + leng1 + "] 不一致.\n如果继续则只会覆盖前 [" + Math.min(leng0, leng1) + "] 项,是否继续?", "选择操作", Vector.<String>(["继续", "取消"]), Vector.<Function>([OWItems]));
	}
	return;
	} else {
	OWItems();
	}
	}
	return;
	}
	}

	private function fillOWItems() : void {
	OWItems(true);
	}*/
	/*private function OWItems(_fill : Boolean = false) : void {
	const leng0 : uint = clipboardValue["value"][0]["length"];
	const leng1 : uint = _parent.selectedItems.length;
	var lisbBox : ListBox = clipboardValue["value"][2] as ListBox;
	var cutList : Vector.<ListBoxItem> = Vector.<ListBoxItem>([]);
	if (_fill) {
	var it : ListBoxItem = clipboardValue["value"][0][0];
	if (clipboardValue["value"][1] == "cut") {
	cutList.push(clipboardValue["value"][0][0]);
	}
	var minLeng : uint = leng1;
	} else {
	minLeng = Math.min(leng0, leng1);
	}
	for (var i : uint = 0; i < minLeng; i++) {
	if (!_fill) {
	it = clipboardValue["value"][0][i];
	if (clipboardValue["value"][1] == "cut") {
	cutList.push(it);
	}
	}
	var pasteItem : ListBoxItem = it.copy();
	pasteItem.selected = true;
	pasteItem.showNew();
	var selItem : ListBoxItem = lisbBox.selectedItems[i];
	var _id : uint = selItem.id;
	lisbBox.addItemAt(pasteItem, _id);
	lisbBox.removeAt(_id + 1);
	}
	for (i = 0; i < cutList.length; i++) {
	if (cutList[i].parent != null) {
	cutList[i].remove();
	}
	}
	}

	private function newItems() : void {
	msg.show("你希望从列表的什么地方开始 [新建] ?", "确认操作", Vector.<String>(["当前上方", "当前下方", "列表头", "列表尾"]), Vector.<Function>([newItems_nowUp, newItems_nowDown, newItems_listUp, newItems_listDown]));
	}*/
	/*private function newItems_nowUp() : void {
	}

	private function newItems_nowDown() : void {
	}

	private function newItems_listUp() : void {
	}

	private function newItems_listDown() : void {
	}*/
	public function showNew() : void {
		if(_newIcon == null){
			_newIcon = new Shape();
			fill_circle(_newIcon.graphics, 2, 0xFF2222, 2, 12);
			mc.addChild(_newIcon);
		}
		_newIcon.visible = true;
		_newIcon.alpha = 1.0;
		mc.addEventListener(Event.ENTER_FRAME, showNewAn);
	}

	private function showNewAn(evt : Event) : void {
		_newIcon.alpha -= _newIcon.alpha / 80;
		if (_newIcon.alpha <= .005) {
			_newIcon.alpha = .0;
			mc.removeEventListener(Event.ENTER_FRAME, showNewAn);
		}
	}

	public function get parent() : ListBox {
		return _parent;
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
							var getItem : ListBoxItem = _parent.items[stratNum + i];
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
		var selArr : Vector.<uint> = Vector.<uint>([]);
		for (i = 0; i < _parent.items.length; i++) {
			getItem = _parent.items[i];
			if (getItem.selected) {
				selArr.push(getItem.index);
			}
		}
		IOC = true;
		_parent.selectedIndexes = selArr;
	}

	public function remove() : void {
		if (_parent != null) {
			_parent.removeItem(this);
		}
	}

	private function selectOneFunc() : void {
		if (_parent != null) {
			for (var i : uint = 0; i < _parent.items.length; i++) {
				var getItem : ListBoxItem = _parent.items[i];
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

	private function dbClickFunc(evt : MouseEvent) : void {
		trace(evt);
		var pFunc : Function = _parent.onItemDoubleClick;
		if (pFunc != null) {
			pFunc();
		}
	}

	public function get sprite():Sprite{
		return mc;
	}

	private function ADDED(evt : Event) : void {
		_added = true;
		mc.removeEventListener(Event.ADDED_TO_STAGE, ADDED);
		mc.addEventListener(Event.REMOVED_FROM_STAGE, REMOVE);
		_parent = mc.parent.parent.parent as ListBox;
		setNativeMenu();
		if(has_edt || _edit){
			addTT();
		}else{
			var leng : uint = _parent.heads.length;
			if (_serialTT.visible) {
				leng--;
			}
			if(_htmlLabels !== null){
				if(_htmlLabels.length != leng){
					addTT();
				}else{
					_serialTT.text = uint(index + 1).toString() + ".";
				}
			}else if(_labels !== null){
				if(_labels.length != leng){
					addTT();
				}else{
					_serialTT.text = uint(index + 1).toString() + ".";
				}
			}
		}
		if (!added_ref) {
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
		_parent.size = [];
	}

	private function REMOVE(evt : Event) : void {
		_added = false;
		_parent = null;
		mc.removeEventListener(Event.REMOVED_FROM_STAGE, REMOVE);
		mc.addEventListener(Event.ADDED_TO_STAGE, ADDED);
	}

	public override function set labels(lab : Vector.<String>) : void {
		if(_labels == null){
			_labels = Vector.<String>([]);
		}
		_labels = lab;
		addTT();
		if (_added) {
			_parent.refreshAt(id);
		}
	}

	public function set htmlLabels(hl : Vector.<String>) : void {
		_htmlLabels = hl;
		addTT();
		if (_added) {
			_parent.refreshAt(id);
		}
	}

	private function addTT() : void {
		ttMC.removeChildren();
		if(cbMC != null){
			cbMC.removeChildren();
		}
		var i : uint;
		if (_cbArr != null) {
			for(i = 0; i < _cbArr.length; i++){
				delete(_cbArr[i]);
			}
			_cbArr.length = 0;
		} else {
			_cbArr = Vector.<ComboBox>([]);
		}
		if (_ttArr != null) {
			for(i = 0; i < _ttArr.length; i++){
				delete(_ttArr[i]);
			}
			_ttArr.length = 0;
		} else {
			_ttArr = Vector.<TextField>([]);
		}
		if (_labels == null) {
			_labels = Vector.<String>([]);
		}
		if (_htmlLabels == null) {
			_htmlLabels = Vector.<String>([]);
		}
		if (_added) {
			var leng : uint = _parent.heads.length;
			if (_serialTT.visible) {
				leng--;
			}
		} else {
			leng = _labels.length > _htmlLabels.length ? _labels.length : _htmlLabels.length;
		}
		_htmlLabels.length = _labels.length = leng;
		_serialTT.autoSize = "left";
		_serialTT.text = uint(index + 1).toString() + ".";
		_serialTT.y = (_sz[1] - _serialTT.height) / 2;
		var tt : TextField;
		for (i = 0; i < leng; i++) {
			tt = new TextField();
			tt.setTextFormat(_tf);
			tt.defaultTextFormat = _tf;
			tt.backgroundColor = bgColorArr[1];
			if (_labels[i] == null) {
				_labels[i] = "";
			}
			if (_htmlLabels[i] == null) {
				_htmlLabels[i] = "";
			}
			tt.text = _labels[i];
			if (_htmlLabels[i] != "") {
				tt.htmlText = _htmlLabels[i];
			}
			tt.autoSize = "left";
			if (i > 0) {
				tt.x = _ttArr[i - 1].x + _ttArr[i - 1].width;
			}
			tt.y = 2;
			_ttArr.push(tt);
			ttMC.addChild(tt);
		}
		if (_ttArr.length > 0) {
			tt = _ttArr[_ttArr.length - 1];
			size = [tt.x + tt.width, _sz[1]];
		}
		setRestricts();
		setLengths();
		setEdits();
		setRounds();
		setIcons();
		setLabelColors();
		setInfoLabels();
		setPassWords();
	}

	public override function get labels() : Vector.<String> {
		_labels = Vector.<String>([]);
		if (_ttArr) {
			for (var i : uint = 0; i < _ttArr.length; i++) {
				if (i < _cbArr.length) {
					if (_cbArr[i] == null) {
						_labels.push(_ttArr[i].text);
					} else if (_cbArr[i].visible) {
						_labels.push(_cbArr[i].label);
					} else {
						_labels.push(_ttArr[i].text);
					}
				} else {
					_labels.push(_ttArr[i].text);
				}
			}
		}
		for(i = 0; i < _labels.length; i++){
			if(_infoLabels!=null){
				if(i<_infoLabels.length){
					if(_labels[i]==_infoLabels[i]){
						_labels[i] = "";
					}
				}
			}
		}
		return _labels;
	}

	public function setLabelAt(tx : String, _x : uint = 0) : void {
		if(_ttArr != null && _ttArr.length > _x){
			_ttArr[_x].text = tx;
			if(_parent != null){
				_parent.refresh();
			}
		}
	}

	public function get iconSpacing():uint{
		return _iconSpacing;
	}
	/** @private */
	internal function set iconSpacing0(sp:uint):void{
		_iconSpacing = sp*2>_sz[1] ? _sz[1]/2 : sp;
		if(_icoArr!=null||_bmpDatas!=null){
			for(var i:uint = 0;i<_icoArr.length;i++){
				if(_icoArr[i] && _ttArr[i]){
					_icoArr[i].y = sp;
					_icoArr[i].x = _ttArr[i].x + sp;
					var wh:uint = _sz[1] - sp*2;
					_icoArr[i].size = [wh, wh];
				}
			}
		}
	}
	/** @private */
	internal function set showSerialNum(boo : Boolean) : void {
		_serialTT.visible = boo;
		addTT();
	}
	/** @private */
	internal function set y(num : uint) : void {
		mc.y = num;
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
		if(_parent.lastSelected != id){
			var min : uint = Math.min(_parent.lastSelected, id);
			var max : uint = Math.max(_parent.lastSelected, id);
			var items : Vector.<ListBoxItem> = _parent.items;
			for(var i : uint=min; i < max; i++){
				items[i].selected = true;
			}
		}
		selected = true;
		_parent.lastSelected = id;
	}

	public function set edit(boo : Boolean) : void {
		_edit = boo;
		if (boo) {
			_edits = Vector.<Boolean>([]);
			if (_ttArr) {
				for (var i : uint = 0; i < _ttArr.length; i++) {
					_edits.push(true);
				}
			}
		} else {
			_edits = null;
		}
		setEdits();
	}

	public function get edit() : Boolean {
		if (_ttArr) {
			_edit = true;
			for (var i : uint = 0; i < _ttArr.length; i++) {
				if (_ttArr[i].type != TextFieldType.INPUT) {
					_edit = false;
					break;
				}
			}
		}
		return _edit;
	}

	public function set restricts(arr : Vector.<String>) : void {
		if (arr != null) {
			if (_restricts == null) {
				_restricts = Vector.<String>([]);
			}
			for (var i : uint = 0; i < _ttArr.length; i++) {
				if (i < arr.length) {
					if (arr[i] == null || arr[i] is String) {
						_ttArr[i].restrict = arr[i];
					}
				}
				_restricts[i] = _ttArr[i].restrict;
			}
		} else {
			_restricts = null;
		}
		setRestricts();
	}

	public function get restricts() : Vector.<String> {
		if (_ttArr) {
			_restricts = Vector.<String>([]);
			var n : Boolean = true;
			for (var i : uint = 0; i < _ttArr.length; i++) {
				var val : String = _ttArr[i].restrict;
				_restricts.push(val);
				if (val != null) {
					n = false;
					break;
				}
			}
			if (n) {
				_restricts = null;
			}
		}
		return _restricts;
	}

	public function set edits(arr : Vector.<Boolean>) : void {
		if (arr != null) {
			if(_ttArr){
				if (_edits == null) {
					_edits = Vector.<Boolean>([]);
				}
				for (var i : uint = 0; i < _ttArr.length; i++) {
					if (i < arr.length) {
						_edits[i] = arr[i];
						if (!_edits[i]) {
							_edit = false;
						}
					}
				}
			}
		} else {
			_edits = null;
			_edit = false;
		}
		setEdits();
	}

	public function get edits() : Vector.<Boolean> {
		if (_ttArr) {
			_edits = Vector.<Boolean>([]);
			var n : Boolean = true;
			for (var i : uint = 0; i < _ttArr.length; i++) {
				var val : String = _ttArr[i].type;
				if (val == TextFieldType.INPUT) {
					_edits.push(true);
				} else {
					_edits.push(false);
					n = false;
				}
			}
			if (!n) {
				_edits = null;
			}
		}
		return _edits;
	}

	private function setEdits() : void {
		if (!_ttArr) {
			return;
		}
		for (var i : uint = 0; i < _ttArr.length; i++) {
			if (_edits != null) {
				if (i > _edits.length - 1) {
					if (_edit) {
						_edits.push(true);
					} else {
						_edits.push(false);
					}
				}
			}
		}
		for (i = 0; i < _ttArr.length; i++) {
			_ttArr[i].selectable = _ttArr[i].mouseEnabled = false;
			if (_edits == null) {
				_ttArr[i].type = TextFieldType.DYNAMIC;
				if (_added) {
					_ttArr[i].removeEventListener(FocusEvent.FOCUS_IN, _parent.tt_FOCUS_IN);
					_ttArr[i].removeEventListener(FocusEvent.FOCUS_OUT, _parent.tt_FOCUS_OUT);
					_ttArr[i].removeEventListener(FocusEvent.FOCUS_OUT, resetLables);
				}
			} else if (_edits.length > i) {
				if (_edits[i]) {
					has_edt = true;
					_ttArr[i].type = TextFieldType.INPUT;
					_ttArr[i].selectable = _ttArr[i].mouseEnabled = true;
					if (_added) {
						_ttArr[i].addEventListener(FocusEvent.FOCUS_IN, _parent.tt_FOCUS_IN);
						_ttArr[i].addEventListener(FocusEvent.FOCUS_OUT, _parent.tt_FOCUS_OUT);
						_ttArr[i].addEventListener(FocusEvent.FOCUS_OUT, resetLables);
					}
				} else {
					_ttArr[i].type = TextFieldType.DYNAMIC;
					if (_added) {
						_ttArr[i].removeEventListener(FocusEvent.FOCUS_IN, _parent.tt_FOCUS_IN);
						_ttArr[i].removeEventListener(FocusEvent.FOCUS_OUT, _parent.tt_FOCUS_OUT);
						_ttArr[i].removeEventListener(FocusEvent.FOCUS_OUT, resetLables);
					}
				}
			}
		}
	}

	private function resetLables(evt : FocusEvent):void{
		_labels = labels;
		if(onChange != null){
			onChange(_id);
		}
	}

	private function setRestricts() : void {
		for (var i : uint = 0; i < _ttArr.length; i++) {
			if (_restricts == null) {
				_ttArr[i].restrict = null;
			} else if (_restricts.length > i) {
				_ttArr[i].restrict = _restricts[i];
			}
		}
	}

	private function setLengths() : void {
		for (var i : uint = 0; i < _ttArr.length; i++) {
			if (_lengths == null) {
				_ttArr[i].maxChars = 0;
			} else if (_lengths.length > i) {
				_ttArr[i].maxChars = _lengths[i];
			}
		}
	}

	public function set lengths(arr : Vector.<uint>) : void {
		if (arr != null) {
			if (_lengths == null) {
				_lengths = Vector.<uint>([]);
			}
			for (var i : uint = 0; i < _ttArr.length; i++) {
				if (i < arr.length) {
					if (!isNaN(Number(arr[i]))) {
						_ttArr[i].maxChars = uint(arr[i]);
					}
				}
				_lengths[i] = _ttArr[i].maxChars;
			}
		} else {
			_lengths = null;
		}
		setLengths();
	}

	public function set infoLabels(arr : Vector.<String>) : void {
		_infoLabels = arr;
		setInfoLabels();
	}

	private function setInfoLabels() : void {
		if (_infoLabels == null) {
			return;
		}
		if (_ttArr) {
			for (var i : uint = 0; i < _infoLabels.length; i++) {
				if (i >= _ttArr.length) {
					break;
				}
				_ttArr[i].addEventListener(FocusEvent.FOCUS_IN, textFocusIn);
				_ttArr[i].addEventListener(FocusEvent.FOCUS_OUT, textFocusOut);
			}
		}
	}

	private function textFocusOut(evt : FocusEvent) : void {
		var tt : TextField = evt.target as TextField;
		for (var i : uint = 0; i < _ttArr.length; i++) {
			var t : TextField = _ttArr[i];
			if (t == tt) {
				if (t.text == "") {
					t.text = _infoLabels[i];
				}
			}
		}
	}

	private function textFocusIn(evt : FocusEvent) : void {
		var tt : TextField = evt.target as TextField;
		for (var i : uint = 0; i < _ttArr.length; i++) {
			var t : TextField = _ttArr[i];
			if (t == tt) {
				if (t.text == _infoLabels[i]) {
					t.text = "";
				}
			}
		}
		tt.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		tt.addEventListener(Event.CHANGE, ttChange)
	}

	private function ttChange(evt:Event):void{
		if(onInput != null){
			var tt_name : String = evt.target.name;
			for(var i:uint = 0; i < _ttArr.length; i++){
				if (_ttArr[i].name == tt_name) {
					_labels[i] = _ttArr[i].text;
					onInput(this, i);
					return;
				}
			}
		}
	}

	private function keyDown(evt:KeyboardEvent):void{
		var i : uint;
		if(evt.keyCode == 13){
			var tt : TextField = evt.target as TextField;
			var get_ttID : uint = 0;
			for(i = 0; i < _ttArr.length; i++){
				if(_ttArr[i] == tt){
					get_ttID = i;
					break;
				}
			}
			var items:Vector.<ListBoxItem> = parent.items as Vector.<ListBoxItem>;
			trace(get_ttID);
			if (items.length - 1 > id) {
				parent.selectedIndexes = Vector.<uint>([id + 1]);
				mc.stage.focus = items[id + 1]._ttArr[get_ttID];
			} else {
				mc.stage.focus = mc;
			}
			tt.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}/*else if(onInput != null){
			var tt_name : String = evt.target.name;
			for(i = 0; i < _ttArr.length; i++){
				if (_ttArr[i].name == tt_name) {
					_labels[i] = _ttArr[i].text;
					onInput(this, i);
					return;
				}
			}
		}*/
	}

	public function get infoLabels() : Vector.<String> {
		return _infoLabels;
	}

	public function get lengths() : Vector.<uint> {
		if(_lengths == null){
			_lengths = Vector.<uint>([]);
		}else{
			_lengths.length = 0;
		}
		var n : Boolean = true;
		for (var i : uint = 0; i < _ttArr.length; i++) {
			var val : int = _ttArr[i].maxChars;
			_lengths.push(val);
			if (val != 0) {
				n = false;
			}
		}
		if (n) {
			_lengths = null;
		}
		return _lengths;
	}

	public function set rounds(arr : Vector.<Vector.<String>>) : void {
		_rounds = arr;
		if (_added) {
			setRounds();
		}
	}

	private function setRounds() : void {
		if(cbMC != null){
			cbMC.removeChildren();
		}
		_cbArr = Vector.<ComboBox>([]);
		if (_rounds != null) {
			for (var i : uint = 0; i < _ttArr.length; i++) {
				if (i < _rounds.length) {
					if (_rounds[i] != null) {
						if(cbMC == null){
							cbMC = new Sprite();
							mc.addChild(cbMC);
						}
						_ttArr[i].visible = false;
						var cb : ComboBox = new ComboBox();
						var selCb : int = -1;
						cb.canWheelChange = cb.showFocus = false;
						cb.bgColor = selected && _showSelected ? _selectedColor : _bgColor;
						cb.color = textColorArr[0];
						for (var k : uint = 0; k < _rounds[i].length; k++) {
							var cbItem : ComboBoxItem = new ComboBoxItem();
							cbItem.label = _rounds[i][k];
							if (_ttArr[i].text == _rounds[i][k]) {
								selCb = k;
							}
							cb.addItem(cbItem);
						}
						cb.selection = selCb;
						cb.label = _ttArr[i].text;
						cb.onChange = function() : void {
							labels = labels;
							if(onChange != null){
								onChange(_id);
							}
						};
						cb.create(_ttArr[i].x, _ttArr[i].y, _ttArr[i].text, _ttArr[i].width, _ttArr[i].height);
						cb.labelSpacing = 0;
						cb.canSearch = _canSearch;
						cb.searchUsePinyin = _searchUsePinyin;
						cb.searchMatchCase = _searchMatchCase;
						cb.searchMinItems = _searchMinItems;
						_cbArr.push(cb);
						cbMC.addChild(cb);
					} else {
						_cbArr.push(null);
					}
				} else {
					_cbArr.push(null);
				}
			}
		}else{
			for (i = 0; i < _ttArr.length; i++) {
				_cbArr.push(null);
			}
		}
	}

	/*private function setLabelVisible():void{
		if (_cbArr==null && _icoArr==null) {
			for (var i:uint = 0; i < _ttArr.length; i++) {
				_ttArr[i].visible = true;
			}
		}else{
			for(i=0;i<_ttArr.length;i++){
				if(i>=_cbArr.length && i>=_icoArr.length){
					_ttArr[i].visible = true;
				}else if(_cbArr[i]==null && _icoArr[i]==null){
					_ttArr[i].visible = true;
				}
			}
		}
	}*/

	public function get rounds() : Vector.<Vector.<String>> {
		return _rounds;
	}

	public function set labelColors(arr : Vector.<Object>) : void {
		_labelColors = arr;
		if (_added) {
			setLabelColors();
		}
	}

	private function setIcons():void{
		if(icoMC != null){
			icoMC.removeChildren();
		}
		if (_icoArr == null){
			_icoArr = Vector.<Image>([]);
		}else{
			_icoArr.length = 0;
		}
		for (var i : uint = 0; i < _ttArr.length; i++) {
			if(_icons != null || _bmpDatas!=null){
				var ico : Image = new Image();
				ico.maxSize = 30;
				var wh:uint = _sz[1] - _iconSpacing * 2;
				var ifBoo:Boolean = false;
				if(_icons != null){
					if(icoMC == null){
						icoMC = new Sprite();
						mc.addChildAt(icoMC, 1);
					}
					if (i < _icons.length) {
						if (_icons[i] != null) {
							ifBoo = true;
							_ttArr[i].visible = ico.showFocus = false;
							ico.create(_ttArr[i].x + _iconSpacing, _iconSpacing, _icons[i], wh, wh);
							ico.mouseChildren = false;
							_icoArr.push(ico);
							icoMC.addChild(ico);
						}
					}
				}
				if(!ifBoo && _bmpDatas!=null){
					if (i < _bmpDatas.length) {
						if (_bmpDatas[i] != null) {
							if(icoMC == null){
								icoMC = new Sprite();
								mc.addChildAt(icoMC, 1);
							}
							ifBoo = true;
							_ttArr[i].visible = ico.showFocus = false;
							ico.create(_ttArr[i].x + _iconSpacing, _iconSpacing, "", wh, wh);
							ico.bitmapData = _bmpDatas[i];
							ico.mouseChildren = false;
							_icoArr.push(ico);
							icoMC.addChild(ico);
						}
					}
				}
				if(!ifBoo){
					_icoArr.push(null);
				}
			}
		}
	}

	public function set icons(vec:Vector.<String>):void{
		_icons = vec;
		if (_added) {
			setIcons();
		}
	}

	public function get icons():Vector.<String>{
		return _icons;
	}

	public function set bitmapDatas(vec:Vector.<BitmapData>):void{
		_bmpDatas = vec;
		if (_added) {
			setIcons();
		}
	}

	public function get bitmapDatas():Vector.<BitmapData>{
		return _bmpDatas;
	}

	private function setLabelColors() : void {
		for (var i : uint = 0; i < _ttArr.length; i++) {
			var ttf : TextFormat = _ttArr[i].defaultTextFormat;
			if (_labelColors == null) {
				ttf.color = textColorArr[0];
			} else if (_labelColors.length > i) {
				if(_labelColors[i] == null){
					ttf.color = textColorArr[0];
				}else{
					ttf.color = _labelColors[i];
				}
			}
			if (_cbArr.length > i) {
				if (_cbArr[i] != null) {
					_cbArr[i].color = ttf.color;
				}
			}
			_ttArr[i].defaultTextFormat = ttf;
			_ttArr[i].setTextFormat(ttf);
		}
	}

	public function set passwords(pswds:Vector.<Boolean>) : void {
		if (pswds != null) {
			if (_passwords == null) {
				_passwords = Vector.<Boolean>([]);
			}
			for (var i : uint = 0; i < _ttArr.length; i++) {
				if (i < pswds.length) {
					_ttArr[i].displayAsPassword = pswds[i];
				}
				_passwords[i] = _ttArr[i].displayAsPassword;
			}
		} else {
			_passwords = null;
		}
		setPassWords();
	}

	public function get passwords() : Vector.<Boolean> {
		return _passwords;
	}

	private function setPassWords():void{
		for (var i : uint = 0; i < _ttArr.length; i++) {
			if (_passwords == null) {
				_ttArr[i].displayAsPassword = false;
			} else if (_passwords.length > i) {
				_ttArr[i].displayAsPassword = _passwords[i];
			}
		}
	}

	public function get labelColors() : Vector.<Object> {
		if (_added) {
			_labelColors = Vector.<Object>([]);
			for (var i : uint = 0; i < _ttArr.length; i++) {
				_labelColors.push(_ttArr[i].defaultTextFormat.color);
			}
		}
		return _labelColors;
	}

	public function copy() : ListBoxItem {
		var newItem : ListBoxItem = new ListBoxItem();
		newItem.labels = labels;
		newItem.edit = edit;
		newItem.edits = edits;
		newItem.restricts = restricts;
		newItem.rounds = rounds;
		newItem.infoLabels = infoLabels;
		newItem.size = size;
		newItem.selected = selected;
		newItem.labelColors = _labelColors;
		newItem.canSearch = _canSearch;
		newItem.searchUsePinyin = _searchUsePinyin;
		newItem.searchMatchCase = searchMatchCase;
		newItem.searchMinItems = _searchMinItems;
//		newItem.defaultNativeMenu(_canEdit, _canCopy, _canPause, _canCut, _canDelete, _userMenus);
		return newItem;
	}

	public override function get visible() : Boolean {
		return mc.visible;
	}
	/** @private */
//	internal override function defaultNativeMenu(_cEdit : Boolean, _cCopy : Boolean, _cPause : Boolean, _cCut : Boolean, _cDelete : Boolean, _uMenus : Vector.<NativeMenuItem>=null) : void {
////		_canCopy = _cCopy;
////		_canEdit = _cEdit;
////		_canPause = _cPause;
////		_canCut = _cCut;
////		_canDelete = _cDelete;
////		_userMenus = _uMenus;
////		setNativeMenu();
//	}

	internal override function setNativeMenu() : void {
		/*thisMenu.removeAllItems();
		if (_userMenus != null) {
			for (var i : uint = 0; i < _userMenus.length; i++) {
				thisMenu.addItem(_userMenus[i]);
			}
		}
		checkSeparator();

		if (_canEdit) {
			editMenu = new NativeMenuItem("编辑");
			thisMenu.addItem(editMenu);
		}
		checkSeparator();
		if (_canCut) {
			cutMenu = new NativeMenuItem("剪切");
			cutMenu.addEventListener(Event.SELECT, cutMenuFunc);
			thisMenu.addItem(cutMenu);
		}
		if (_canCopy) {
			copyMenu = new NativeMenuItem("复制");
			copyMenu.addEventListener(Event.SELECT, copyMenuFunc);
			thisMenu.addItem(copyMenu);
		}
		if (_canPause) {
			pasteMenu = new NativeMenuItem("粘贴");
			pasteMenu.addEventListener(Event.SELECT, pasteMenuFunc);
			thisMenu.addItem(pasteMenu);
		}
		checkSeparator();
		if (_canDelete) {
			deletMenu = new NativeMenuItem("刪除");
			thisMenu.addItem(deletMenu);
		}
		if (thisMenu.items.length > 0) {
			mc.contextMenu = thisMenu;
		} else {
			mc.contextMenu = null;
		}*/
		if(_parent){
			var _pNM:NativeMenu = _parent.itemsNativeMenu;
			if(_pNM){
				thisMenu = _pNM;
				mc.contextMenu = thisMenu;
			}else{
				mc.contextMenu = null;
			}
		}
		//mc.mouseChildren = mc.mouseEnabled = true;
	}

	public function check() : int {
		if (_infoLabels == null) {
			return -1;
		}
		for (var i : uint = 0; i < _ttArr.length; i++) {
			if (i < _infoLabels.length) {
				var t : TextField = _ttArr[i];
				if (t.text == _infoLabels[i]) {
					return i;
				}
			}
		}
		return -1;
	}

	public function set showSelected(boo:Boolean) : void {
		_showSelected = boo;
	}

	public function get showSelected():Boolean{
		return _showSelected;
	}

	/*private function checkSeparator() : void {
		if (thisMenu.items.length > 0) {
			if (!thisMenu.items[thisMenu.items.length - 1]["isSeparator"]) {
				var nullMenu : NativeMenuItem = new NativeMenuItem("", true);
				thisMenu.addItem(nullMenu);
			}
		}
	}*/

	public override function set id(_num:int):void{
		_id = _num;
		_serialTT.text = (_id + 1).toString() + ".";
	}

	public override function get id():int{
		return _id;
	}

	/** @private */
	internal function treeView(sp : uint, col : Object):void{
		_treeView = true;
		_treeViewSpacing = sp;
		_treeViewColor = col;
		if(_treeTT == null){
			_treeTT = new Shape();
			mc.addChild(_treeTT);
		}
		var grap:Graphics = _treeTT.graphics;
		var len:int = sp - 8 > 0 ? sp - 8 : 0;
		grap.clear();
		grap.lineStyle(1, int(_treeViewColor), 1, true);
		grap.lineTo(0, 0);
		grap.lineTo(0, 14);
		grap.lineTo(len, 14);
		grap.lineTo(len + 2,12);
		grap.lineTo(len + 4,14);
		grap.lineTo(len + 2,16);
		grap.lineTo(len, 14);
	}

	public function set canSearch(boo : Boolean) : void {
		_canSearch = boo;
		if(_cbArr != null){
			for (var i : uint = 0; i < _cbArr.length; i++) {
				if(_cbArr[i] == null){
					continue;
				}
				_cbArr[i].canSearch = boo;
			}
		}
	}

	public function get canSearch() : Boolean {
		return _canSearch;
	}

	public function set searchMatchCase(boo : Boolean) : void {
		_searchMatchCase = boo;
		if(_cbArr != null){
			for (var i : uint = 0; i < _cbArr.length; i++) {
				if(_cbArr[i] == null){
					continue;
				}
				_cbArr[i].searchMatchCase = boo;
			}
		}
	}

	public function get searchMatchCase() : Boolean {
		return _searchMatchCase;
	}

	public function set searchUsePinyin(boo : Boolean) : void {
		_searchUsePinyin = boo;
		if(_cbArr != null){
			for (var i : uint = 0; i < _cbArr.length; i++) {
				if(_cbArr[i] == null){
					continue;
				}
				_cbArr[i].searchUsePinyin = boo;
			}
		}
	}

	public function get searchUsePinyin() : Boolean {
		return _searchUsePinyin;
	}

	public function set searchMinItems(k : int) : void {
		_searchMinItems = k;
		if(_cbArr != null){
			for (var i : uint = 0; i < _cbArr.length; i++) {
				if(_cbArr[i] == null){
					continue;
				}
				_cbArr[i].searchMinItems = k;
			}
		}
	}

	public function get searchMinItems() : int {
		return _searchMinItems;
	}
}
}
