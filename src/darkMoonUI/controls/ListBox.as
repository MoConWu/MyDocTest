package darkMoonUI.controls {
import darkMoonUI.assets.interfaces.DMUI_PUB_BOX;
import darkMoonUI.assets.interfaces.DMUI_PUB_DEF;
import darkMoonUI.types.ControlType;
import darkMoonUI.controls.orientation.Orientation;
import darkMoonUI.functions.parentAddChilds;
import darkMoonUI.assets.BoxHeadItem;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.getStringLength;

import flash.display.DisplayObject;
import flash.display.NativeMenu;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.system.System;
import flash.text.TextField;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

/**
 * @author moconwu
 */
public class ListBox extends DarkMoonUIControl implements DMUI_PUB_DEF, DMUI_PUB_BOX{
	public var onItemDoubleClick : Function;
	public var isLoopList : Boolean = false;
	public var onChange : Function;
	/** @private */
	internal var
	lastSelected : int = -1;
	private var
	_mustKey : Boolean = false,
	_multiline : Boolean = false,
	bgMC : Sprite = new Sprite(),
	headBgMC : Shape = new Shape(),
	headListMC : Sprite = new Sprite(),
	headListMC_mask : Shape = new Shape(),
	listItemsMC : Sprite = new Sprite(),
	listItemsMC_mask : Shape = new Shape(),
	_items : Vector.<ListBoxItem> = Vector.<ListBoxItem>([]),
	_selectedIndexes : Vector.<uint> = Vector.<uint>([]),
	_scrollBarV : ScrollBar = new ScrollBar(),
	_scrollBarH : ScrollBar = new ScrollBar(),
	_scrollBarN : Shape = new Shape(),
	_showHeaders : Boolean = false,
	_headList : Vector.<String> = Vector.<String>([]),
	itemsWdtArr : Vector.<uint> = Vector.<uint>([]),
	itemsWdtArr2 : Vector.<uint>,
	listWdt : uint = 0,
	_scaleX : Number = 0,
	_scaleY : Number = 0,
	_defSerialNum : Boolean = false,
	_sort : Boolean = false,
	_selectedMC : Shape = new Shape(),
	_edit : Boolean = false,
	enabledMC : Sprite = new Sprite(),
	_showFocus : Boolean = true,
	_smooth : Boolean = true,
	_smoothSpeed : Number = .25,
	_searchStr : String = "",
	_treeView:Boolean = false,
	_treeViewSpacing : uint = 15,
	_treeViewColor:Object = 0x806060,
//	_canDelete : Boolean = false,
//	_canCopy : Boolean = false,
//	_canPause : Boolean = false,
//	_canCut : Boolean = false,
//	_canEdit : Boolean = false,
	_iconSpacing : uint = 3,
	_canSearch : Boolean = false,
	_searchMinItems : int = 5,
	_searchUsePinyin : Boolean = true,
	_searchMatchCase : Boolean = false,
	_rci:NativeMenu;

	// _canDrag : Boolean = false;
	public function ListBox() : void {
		super();
		_type = ControlType.LIST_BOX;

		fill(enabledMC.graphics, 10, 10, bgColorArr[0]);
		fill(_selectedMC.graphics, 10, 10, bgColorArr[2]);
		fill(bgMC.graphics, 10, 10, bgColorArr[3], bgColorArr[1]);
		fill(_scrollBarN.graphics, 20, 20, bgColorArr[4]);

		fill(headBgMC.graphics, 10, 25, bgColorArr[3], bgColorArr[1]);
		fill(headListMC_mask.graphics);
		fill(listItemsMC_mask.graphics);
		enabledMC.alpha = .0;
		_selectedMC.x = _selectedMC.y = -2;

		_scrollBarV.create(0, 0, 0, 0, 100, Orientation.V, 20, 200);
		_scrollBarH.create();
		_scrollBarH.regPoint = ["left", "bottom"];

		_selectedMC.visible = _scrollBarN.visible = _scrollBarH.visible = _scrollBarV.visible = false;

		_scrollBarV.onChange = _scrollBarV.onChanging = _scrollBarH.onChange = _scrollBarH.onChanging = function() : void {
			movePanelFunc();
		};

		headListMC.mask = headListMC_mask;
		listItemsMC.mask = listItemsMC_mask;

		parentAddChilds(mc, Vector.<DisplayObject>([
			_selectedMC, bgMC, listItemsMC, listItemsMC_mask, _scrollBarN,
			_scrollBarV, _scrollBarH, headBgMC, headListMC, headListMC_mask, enabledMC
		]));

		create();
	}

	public function copy() : ListBox {
		var newDMUI : ListBox = new ListBox();
		var sz : Array = size;
		newDMUI.create(x, y, sz[0], sz[1], showHeaders, _sort, _defSerialNum, _multiline);
		newDMUI.items = _items;
		newDMUI.showFocus = showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : int = 0, _y : int = 0, w : uint = 150, h : uint = 150, sh : Boolean = false, srt : Boolean = false, dsn : Boolean = false, mult : Boolean = false) : void {
		x = _x;
		y = _y;

		headBgMC.visible = headListMC.visible = sh;

		showHeaders = sh;
		_multiline = mult;
		_defSerialNum = dsn;
		_sort = srt;

		removeAll();

		size = [w, h];
		enabled = _enabled;
	}
	/** @private */
	protected override function _size_get() : Array {
		return [bgMC.width, bgMC.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		var w : uint = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : bgMC.width;
		var h : uint = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : bgMC.height;
		enabledMC.width = bgMC.width = w;
		_selectedMC.width = w + 5;
		enabledMC.height = bgMC.height = h;
		_selectedMC.height = h + 5;

		_scrollBarN.x = _scrollBarV.x = bgMC.width - _scrollBarV.thickness;
		_scrollBarN.y = bgMC.height - _scrollBarH.thickness;
		_scrollBarH.y = bgMC.height;
		listItemsMC_mask.y = _scrollBarV.y = headBgMC.height * Number(_showHeaders);
		refreshLengFunc();
		resetLayoutFunc();
		_SizeValue = Vector.<uint>([bgMC.width, bgMC.height]);
	}
	/** @private */
	protected override function _focus_in() : void {
		_selectedMC.visible = _showFocus;
	}
	/** @private */
	protected override function _focus_out() : void {
		_selectedMC.visible = false;
	}
	/** @private */
	protected override function _enabled_set() : void {
		enabledMC.visible = !_enabled;
		_scrollBarH.enabled = _scrollBarV.enabled = _enabled;
		if (_enabled) {
			bgMC.addEventListener(MouseEvent.MOUSE_DOWN, bgClickFunc);
		} else {
			bgMC.removeEventListener(MouseEvent.MOUSE_DOWN, bgClickFunc);
		}
	}
	/** @private */
	protected override function _mouseWheel(boo : Boolean = false) : void {
		var speed : Number = _MouseEvent.delta * 8;
		if (_scrollBarV.visible) {
			listItemsMC.y += speed;
			panelCheck(false);
		} else if (_scrollBarH.visible && _showHeaders) {
			headListMC.x = listItemsMC.x = listItemsMC.x + speed;
			panelCheck(true, false);
		}
		moveSliderFunc();
	}
	/** @private */
	protected override function _mouseRightDown() : void {
		if(_mouseDown != null){
			_mouseDown();
		}
	}
	/** @private */
	protected override function _mouseMiddleDown() : void {
		_scaleX = mouseX - listItemsMC.x;
		_scaleY = mouseY - listItemsMC.y;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
		stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mdUpFunc);
		Mouse.cursor = MouseCursor.HAND;
		if(_mouseDown != null){
			_mouseDown();
		}
	}

	internal function setKeyDown(evt : KeyboardEvent) : void {
		_mustKey = true;
		_KeyboardEvent = evt;
		_keyDown();
		_mustKey = false;
	}

	/** @private */
	protected override function _keyDown() : void {
		if (focus || _mustKey) {
			if (_KeyboardEvent.keyCode == 65 && _KeyboardEvent.ctrlKey) {
				if (_multiline) {
					// trace("Ctrl + A");
					_selectedIndexes = Vector.<uint>([]);
					for (var i : uint = 0; i < uint(listItemsMC.numChildren); i++) {
						var thisItem : ListBoxItem = _items[i];
						thisItem.IOC = false;
						if (thisItem.mc.visible) {
							thisItem.IOC = false;
							thisItem.selected = true;
							_selectedIndexes.push(_items[i].index);
						}
						thisItem.IOC = true;
					}
					selectedIndexes = _selectedIndexes;
				}
			} else if (_KeyboardEvent.keyCode == 40 || _KeyboardEvent.keyCode == 38) {
				if (selectedIndexes.length > 0) {
					if (_KeyboardEvent.keyCode == 40) {
						var selAdd : int = selectedIndexes[0] + 1;
					} else {
						selAdd = selectedIndexes[0] - 1;
					}
					if (selAdd >= items.length) {
						if (isLoopList) {
							selAdd = 0;
						} else {
							selAdd = items.length - 1;
						}
					} else if (selAdd < 0) {
						if (isLoopList) {
							selAdd = items.length - 1;
						} else {
							selAdd = 0;
						}
					}
					selectedIndexes = Vector.<uint>([selAdd]);
					var getY : int = selAdd * 25 + listItemsMC.y - headBgMC.height * uint(_showHeaders);
					if (getY >= bgMC.y + listItemsMC_mask.height - 25 / 2) {
						listItemsMC.y = -selAdd * 25 + listItemsMC_mask.y;
					} else if (getY < bgMC.y) {
						listItemsMC.y = bgMC.y - selAdd * 25 + listItemsMC_mask.height - 25 * uint(!_showHeaders);
					}
					lastSelected = selAdd;
					refreshList();
				}
			}
		}
	}

	public function setLabel(y : uint, x : uint, str : String = "") : void {
		var _x : uint = x;
		if (_showHeaders) {
			_x++;
		}
		if (y < _items.length) {
			var _item : ListBoxItem = _items[y];
			if (x < _headList.length) {
				_item.labels[x] = str;
			}
		}
	}

	public function removeAll() : void {
		var sel : Boolean = selectedIndexes.length > 0;
		listItemsMC.removeChildren();
		itemsWdtArr = Vector.<uint>([]);
		for (var i : uint = 0; i < _headList.length; i++) {
			var getTTLeng : Number = getStringLength(_headList[i]);
			if (itemsWdtArr.length - 1 < i) {
				itemsWdtArr.push(getTTLeng);
			} else if (getTTLeng > itemsWdtArr[i]) {
				itemsWdtArr[i] = getTTLeng;
			}
		}
		for(i = 0; i < items.length; i++){
			delete(items[i]);
		}
		//items = Vector.<ListBoxItem>([]);
		items.length = 0;
		refreshLengFunc();
		if (sel && onChange != null) {
			onChange();
		}
	}

	public function removeSelected() : void {
		var sel : Boolean = selectedIndexes.length > 0;
		var _xy : Vector.<int> = oldXY;
		var newItems : Vector.<ListBoxItem> = Vector.<ListBoxItem>([]);
		for (var i : uint = 0; i < _items.length; i++) {
			if (!_items[i].selected) {
				newItems.push(_items[i]);
			}
		}
		_items = newItems;
		listItemsMC.removeChildren();
		for (i = 0; i < _items.length; i++) {
			var obj : ListBoxItem = _items[i];
			obj.id = uint(listItemsMC.numChildren);
			addOneItem(obj, false);
		}
		refreshLengFunc();
		oldXY = _xy;
		if (sel && onChange != null) {
			onChange();
		}
	}
	/** @private */
	internal function refreshAt(num : uint) : void {
		if (num < _items.length) {
			_items[num].sizeList = itemsWdtArr2;
		}
	}

	public function removeAt(num : uint) : void {
		if (num >= _items.length) {
			return;
		}
		var _xy : Vector.<int> = oldXY;
		var chg : Boolean = false;
		var newItems : Vector.<ListBoxItem> = Vector.<ListBoxItem>([]);
		for (var i : uint = 0; i < _items.length; i++) {
			if (i != num) {
				newItems.push(_items[i]);
			} else {
				chg = _items[i].selected;
			}
		}
		_items = newItems;
		listItemsMC.removeChildren();
		for (i = 0; i < _items.length; i++) {
			var obj : ListBoxItem = _items[i];
			obj.id = uint(listItemsMC.numChildren);
			addOneItem(obj, false);
		}
		refreshLengFunc();
		oldXY = _xy;
		if (chg && onChange != null) {
			onChange();
		}
	}

	public function set showSerialNum(boo : Boolean) : void {
		if (_defSerialNum) {
			_headList.splice(0, 1);
		}
		_items = items;
		for (var i : uint = 0; i < _items.length; i++) {
			_items[i].showSerialNum = boo;
		}
		_defSerialNum = boo;
		heads = _headList;
	}

	public function get showSerialNum() : Boolean {
		return _defSerialNum;
	}

	public function set showHeaders(boo : Boolean) : void {
		_showHeaders = headBgMC.visible = headListMC.visible = boo;
		size = [];
	}

	public function get showHeaders() : Boolean {
		return _showHeaders;
	}

	public function get items() : Vector.<ListBoxItem> {
		return _items;
	}

	public function set items(arr : Vector.<ListBoxItem>) : void {
		listItemsMC.removeChildren();
		if(arr == null || arr.length == 0){
			System.gc();
			_items = Vector.<ListBoxItem>([]);
			return;
		}
		var newItems : Vector.<ListBoxItem> = Vector.<ListBoxItem>([]);
		for (var i : uint = 0; i < arr.length; i++) {
			newItems.push(arr[i]);
		}
		_items = Vector.<ListBoxItem>([]);
		for (i = 0; i < newItems.length; i++) {
			addItem(arr[i], false);
		}
		size = [];
	}

	public function set selectedIndexes(arr : Vector.<uint>) : void {
		if (selectedIndexes.length == 0) {
			if (arr == null || arr.length == 0) {
				return;
			}
		}
		if (arr == null) {
			arr = Vector.<uint>([]);
		}
		for (var i : uint = 0; i < _items.length; i++) {
			var item : ListBoxItem = _items[i];
			item.IOC = false;
			item.selected = item.mc.visible && arr.indexOf(item.index) != -1;
		}
		for (i = 0; i < _items.length; i++) {
			item = _items[i];
			item.IOC = true;
		}
		var isChange : Boolean = false;
		if(_selectedIndexes != null && arr != null) {
			if (_selectedIndexes.length != arr.length) {
				isChange = true;
			} else {
				for (i = 0; i < _selectedIndexes.length; i++) {
					if(arr.indexOf(_selectedIndexes[i]) == -1){
						isChange = true;
						break;
					}
				}
			}
		}
		_selectedIndexes = arr;
		if(isChange && onChange != null){
			onChange();
		}
	}

	public function moveToSelect():void{
		_selectedIndexes = selectedIndexes;
		if(_selectedIndexes.length>0){
			var selAdd:uint = _selectedIndexes[0];
			var getY : int = selAdd * 25 + listItemsMC.y - headBgMC.height * uint(_showHeaders);
			if (getY >= bgMC.y + listItemsMC_mask.height - 25 / 2) {
				listItemsMC.y = -selAdd * 25 + listItemsMC_mask.y;
			} else if (getY < bgMC.y) {
				listItemsMC.y = bgMC.y - selAdd * 25 + listItemsMC_mask.height - 25 * uint(!_showHeaders);
			}
			lastSelected = selAdd;
			refreshList();
		}
	}

	public function get selectedIndexes() : Vector.<uint> {
		_selectedIndexes = Vector.<uint>([]);
		for (var i : uint = 0; i < _items.length; i++) {
			var item : ListBoxItem = _items[i];
			if (item.selected) {
				if (item.mc.visible) {
					_selectedIndexes.push(item.index);
				}
			}
		}
		return _selectedIndexes;
	}

	public function set selectedItems(arr : Vector.<ListBoxItem>) : void {
		selectedIndexes = null;
		for (var i : uint = 0; i < arr.length; i++) {
			if (arr[i].parent == this) {
				arr[i].selected = true;
			}
		}
	}

	public function get selectedItems() : Vector.<ListBoxItem> {
		var newItems : Vector.<ListBoxItem> = Vector.<ListBoxItem>([]);
		for (var i : uint = 0; i < _items.length; i++) {
			if (_items[i].visible && _items[i].selected) {
				newItems.push(_items[i]);
			}
		}
		return newItems;
	}

	public function set sort(boo : Boolean) : void {
		_sort = boo;
		if(boo){
			headListMC.addEventListener(MouseEvent.CLICK, sortItem);
		}else{
			headListMC.removeEventListener(MouseEvent.CLICK, sortItem);
		}
	}

	public function set edit(boo : Boolean) : void {
		_edit = boo;
		for (var i : uint = 0; i < _items.length; i++) {
			oneItemEdit(_items[i]);
		}
	}

	private function oneItemEdit(item : ListBoxItem) : void {
		item.edit = _edit;
	}

	public function get edit() : Boolean {
		return _edit;
	}

	private function sortItem(evt : MouseEvent) : void {
		if (!_enabled) {
			return;
		}
		var headItem : BoxHeadItem;
		var type : Object = evt.target.constructor;
		if (type == TextField) {
			var tt : TextField = evt.target as TextField;
			headItem = tt.parent as BoxHeadItem;
		} else {
			var mc : Sprite = evt.target as Sprite;
			headItem = mc.parent as BoxHeadItem;
		}
		try{
			headItem.reSort = !headItem.reSort;
		}catch(e : Error){
			return;
		}
		var id : int = headItem.ID;
		if(id < 0){
			return;
		}
		var re : Boolean = headItem.reSort;
		var getItemList : Array = [];
		var numChild : uint = _items.length;
		var topItmes : Array = [];
		var str : String;
		for (var i : uint = 0; i < numChild; i++) {
			if(_items[i].top){
				topItmes.push(i);
				continue;
			}
			str = _items[i].labels[id];
			getItemList.push([i, str]);
		}
		getItemList.sort(function(x : Array, y : Array) : int {
			var a : String = x[1] as String;
			var b : String = y[1] as String;
			if (re) {
				return a.localeCompare(b);
			} else {
				return b.localeCompare(a);
			}
		});
		var newItems : Vector.<ListBoxItem> = Vector.<ListBoxItem>([]);
		for (i = 0; i < topItmes.length; i++) {
			newItems.push(_items[topItmes[i]]);
		}
		for (i = 0; i < getItemList.length; i++) {
			newItems.push(_items[getItemList[i][0]]);
		}
		_items = newItems;
		var _xy : Vector.<int> = oldXY;
		listItemsMC.removeChildren();
		var obj : ListBoxItem;
		for (i = 0; i < _items.length; i++) {
			obj = _items[i];
			obj.id = uint(listItemsMC.numChildren);
			addOneItem(obj, false);
		}
		refreshLengFunc();
		oldXY = _xy;
		// onChange();
	}
	/** @private */
	internal function get oldXY() : Vector.<int> {
		return Vector.<int>([listItemsMC.x, listItemsMC.y]);
	}
	/** @private */
	internal function set oldXY(xy : Vector.<int>) : void {
		xy.length = 2;
		listItemsMC.x = xy[0];
		listItemsMC.y = xy[1];
		refreshList();
	}

	public function get sort() : Boolean {
		return _sort;
	}

	private function refreshHeadLeng() : void {
		itemsWdtArr = Vector.<uint>([]);
		headListMC.removeChildren();
		if (_headList != null) {
			for (var i : uint = 0; i < _headList.length; i++) {
				var headItem : BoxHeadItem = new BoxHeadItem();
				if (_defSerialNum) {
					headItem.ID = i - 1;
				} else {
					headItem.ID = i;
				}
				headItem.label = _headList[i];
				var getTTLeng : Number = getStringLength(headItem.label);
				if (itemsWdtArr.length - 1 < i) {
					itemsWdtArr.push(getTTLeng);
				} else if (getTTLeng > itemsWdtArr[i]) {
					itemsWdtArr[i] = getTTLeng;
				}
				headItem.size = [itemsWdtArr[i]];
				headListMC.addChild(headItem);
			}
		}
	}

	public function set heads(arr : Vector.<String>) : void {
		_headList = Vector.<String>([]);
		for(var i : uint = 0; i <arr.length; i++){
			_headList.push(arr[i]);
		}
		if (_defSerialNum) {
			_headList.splice(0, 0, "");
		}
		refreshHeadLeng();
		refreshLengFunc();
		sort = _sort;
	}

	public function get heads() : Vector.<String> {
		return _headList;
	}

	public function get multiline() : Boolean {
		return _multiline;
	}

	public function set multiline(boo : Boolean) : void {
		_multiline = boo;
		var selectedArr : Vector.<uint> = selectedIndexes;
		if (!_multiline && selectedArr.length > 1) {
			selectedIndexes = Vector.<uint>([selectedArr[0]]);
		}
	}

	private function refreshList() : void {
		var getH : uint = getItemY() * 25;
		if (listItemsMC.y > bgMC.y + headBgMC.height * Number(_showHeaders) || !_scrollBarV.visible) {
			listItemsMC.y = bgMC.y + headBgMC.height * Number(_showHeaders);
		} else if (listItemsMC.y < bgMC.y + bgMC.height - getH - Number(_scrollBarH.visible) * _scrollBarH.thickness) {
			listItemsMC.y = bgMC.y + bgMC.height - getH - Number(_scrollBarH.visible) * _scrollBarH.thickness;
		}
		if (headListMC.x < bgMC.x + bgMC.width - headListMC.width - Number(_scrollBarV.visible) * _scrollBarV.thickness) {
			headListMC.x = listItemsMC.x = bgMC.x + bgMC.width - headListMC.width - Number(_scrollBarV.visible) * _scrollBarV.thickness;
		}
		if (listItemsMC.x > bgMC.x) {
			headListMC.x = listItemsMC.x = bgMC.x;
		}
		headListMC.x = listItemsMC.x;
		moveSliderFunc();
	}

	private function bgClickFunc(evt : MouseEvent) : void {
		var selLeng : uint = selectedIndexes.length;
		for (var i : uint = 0; i < Number(listItemsMC.numChildren); i++) {
			var getItem : ListBoxItem = _items[i];
			getItem.IOC = false;
			getItem.selected = false;
			getItem.IOC = true;
		}
		if (selLeng > 0 && onChange != null) {
			onChange();
		}
	}

	private function moveFunc(evt : MouseEvent) : void {
		if (!evt.buttonDown) {
			mdUpFunc(evt);
			return;
		}
		headListMC.x = listItemsMC.x = mouseX - _scaleX;
		listItemsMC.y = this.mouseY - _scaleY;
		refreshList();
		moveSliderFunc();
	}

	private function mdUpFunc(evt : MouseEvent) : void {
		Mouse.cursor = MouseCursor.AUTO;
		stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, mdUpFunc);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
		_scrollBarH.upFunc(evt);
		_scrollBarV.upFunc(evt);
	}

	public function addItem(obj: ListBoxItem, ref: Boolean=true) : void {
		var _xy : Vector.<int> = oldXY;
		obj.id = uint(listItemsMC.numChildren);
		obj.iconSpacing0 = _iconSpacing;
//		obj.defaultNativeMenu(_canEdit, _canCopy, _canPause, _canCut, _canDelete);
		obj.showSerialNum = _defSerialNum;
		obj.searchMinItems = _searchMinItems;
		obj.searchMatchCase = _searchMatchCase;
		obj.searchUsePinyin = _searchUsePinyin;
		obj.canSearch = _canSearch;
		if(ref){
			obj.added_ref = true;
		}
		if (_edit) {
			oneItemEdit(obj);
		}
		if(_treeView){
			obj.treeView(_treeViewSpacing, _treeViewColor);
		}
		_items.push(obj);
		addOneItem(obj, ref);
		if(obj.top){
			setItemIndex(obj, 0);
		}
		oldXY = _xy;
	}

	public function addItemAt(obj : ListBoxItem, _id : uint) : void {
		addItem(obj);
		if(!obj.top){
			setItemIndex(obj, _id);
		}
		if(obj.selected && onChange != null){
			onChange();
		}
	}

	public function setItemIndex(obj : ListBoxItem, _id : uint) : void {
		_items.splice(obj.id, 1);
		_items.insertAt(_id, obj);
		refresh();
	}

	public function removeItem(obj : ListBoxItem) : void {
		var founded : Boolean = false;
		for (var i : uint = 0; i < _items.length; i++) {
			if (_items[i] == obj) {
				_items.splice(i, 1);
				founded = true;
				break;
			}
		}
		////
		var _xy : Vector.<int> = oldXY;
		var newItems : Vector.<ListBoxItem> = Vector.<ListBoxItem>([]);
		for (i = 0; i < _items.length; i++) {
			newItems.push(_items[i]);
		}
		_items = newItems;
		listItemsMC.removeChildren();
		for (i = 0; i < _items.length; i++) {
			obj = _items[i];
			obj.id = uint(listItemsMC.numChildren);
			addOneItem(obj, false);
		}
		refreshLengFunc();
		oldXY = _xy;
		if (founded && onChange != null) {
			onChange();
		}
	}

	public function refresh() : void {
		for (var i : uint = 0; i < _items.length; i++) {
			_items[i].id = i;
			addOneItem(_items[i], false);
		}
		size = [];
		refreshHeadLeng();
		refreshLengFunc();
	}

	private function addOneItem(obj : ListBoxItem, ref : Boolean = true) : void {
		obj.added_ref = ref;
		switch (_searchStr) {
			case null:
			case "":
				obj.index = obj.id;
				obj.mc.visible = true;
				break;
			default:
				var labs : Vector.<String> = obj.labels;
				obj.mc.visible = false;
				for (var i : uint = 0; i < labs.length; i++) {
					if (labs[i].indexOf(_searchStr) != -1) {
						obj.mc.visible = true;
						break;
					}
				}
				if (!obj.mc.visible) {
					obj.selected = false;
				}
				obj.index = getItemY();
				break;
		}
		obj.y = obj.index * 25;
		listItemsMC.addChild(obj.mc);
	}

	private function getItemY() : uint {
		var m : uint = 0;
		for (var i : uint = 0; i < uint(listItemsMC.numChildren); i++) {
			var item : Sprite = listItemsMC.getChildAt(i) as Sprite;
			if (item.visible) {
				m++;
			}
		}
		return m;
	}
	/** @private */
	internal function mouseSelectMoveFunc() : void {
		for (var i : uint = 0; i < _items.length; i++) {
			var thisItem : ListBoxItem = _items[i];
			thisItem.itemSelectOver = true;
		}
		stage.addEventListener(MouseEvent.MOUSE_UP, upFunc);
	}

	private function upFunc(evt : MouseEvent) : void {
		for (var i : uint = 0; i < _items.length; i++) {
			var thisItem : ListBoxItem = _items[i];
			thisItem.itemSelectOver = false;
		}
	}

	private function refreshLengFunc() : void {
		itemsWdtArr2 = Vector.<uint>([]);
		listWdt = 0;
		var _DSNLeng : uint = 0;
		if (_defSerialNum) {
			if (_items.length > 0) {
				itemsWdtArr[0] = _DSNLeng = _items[_items.length - 1].sizeList[0];
			}
			itemsWdtArr2.push(_DSNLeng);
		}
		var getIfIcons:Vector.<Boolean> = Vector.<Boolean>([]);
		var defIconsLeng:uint = 0;
		getIfIcons.length = itemsWdtArr.length;
		for (var i : uint = 0; i < _items.length; i++) {
			var getList : Vector.<uint> = _items[i].sizeList;
			var icons:Vector.<String> = _items[i].icons;
			if(icons!=null){
				for(var m:uint=0;m<icons.length;m++){
					getIfIcons[m] = icons[m] != null;
				}
			}
			for (var k : uint = 0; k < itemsWdtArr.length; k++) {
				if (k < getList.length) {
					itemsWdtArr[k] = Math.max(itemsWdtArr[k], getList[k]);
				}
			}
		}
		for (i = 0; i < getIfIcons.length; i++) {
			if(getIfIcons[i]){
				defIconsLeng += 25;
			}
		}
		for (i = 0; i < itemsWdtArr.length; i++) {
			listWdt += itemsWdtArr[i];
		}
		var headLeng : uint = listWdt;
		var sliderBoxYWdt : uint = uint(_scrollBarV.visible) * _scrollBarV.thickness;
		if (listWdt < bgMC.width - sliderBoxYWdt) {
			headLeng = bgMC.width - sliderBoxYWdt;
		}
		for (i = 0; i < itemsWdtArr.length; i++) {
			if (uint(headListMC.numChildren) > i) {
				var thisHead : BoxHeadItem = headListMC.getChildAt(i) as BoxHeadItem;
				var lastNum : uint = 0;
				if (_defSerialNum && i == 0) {
					thisHead.size = [_DSNLeng];
				} else{
					if(!getIfIcons[i - uint(_defSerialNum)]){
						var leng : uint = itemsWdtArr[i] / (listWdt - _DSNLeng - defIconsLeng) * (headLeng - _DSNLeng - defIconsLeng);
					}else{
						leng = 25;
					}
					itemsWdtArr2.push(leng);
					thisHead.size = [leng];
					if (i != 0) {
						var lastObj : BoxHeadItem = headListMC.getChildAt(i - 1) as BoxHeadItem;
						lastNum = lastObj.x + lastObj.width;
					}
				}
				thisHead.x = lastNum;
			}
		}
		for (i = 0; i < _items.length; i++) {
			_items[i].sizeList = itemsWdtArr2;
		}
		resetLayoutFunc();
	}

	private function resetLayoutFunc() : void {
		var getH : uint = getItemY() * 25;
		headBgMC.width = headListMC_mask.width = bgMC.width;
		headListMC_mask.height = headBgMC.height;
		_scrollBarH.visible = listItemsMC.width > bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
		_scrollBarV.visible = getH > bgMC.height - headBgMC.height * uint(_showHeaders) - uint(_scrollBarH.visible) * _scrollBarH.thickness;
		_scrollBarH.visible = listItemsMC.width > bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
		listItemsMC_mask.width = bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
		listItemsMC_mask.height = bgMC.height - headBgMC.height * uint(_showHeaders) - uint(_scrollBarH.visible) * _scrollBarH.thickness;
		_scrollBarN.visible = _scrollBarV.visible && _scrollBarH.visible;
		if (listItemsMC.width > bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness) {
			_scrollBarH.length = bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
			_scrollBarH.barLength = listItemsMC_mask.width / listItemsMC.width * _scrollBarH.length;
		}
		if (getH > bgMC.height - headBgMC.height * uint(_showHeaders) - uint(_scrollBarH.visible) * _scrollBarH.thickness) {
			_scrollBarV.length = bgMC.height - headBgMC.height * uint(_showHeaders) - uint(_scrollBarH.visible) * _scrollBarH.thickness;
			_scrollBarV.barLength = listItemsMC_mask.height / getH * _scrollBarV.length;
		}
		if (_scrollBarV.barLength < 10) {
			_scrollBarV.barLength = 10;
		}
		if (_scrollBarH.barLength < 10) {
			_scrollBarH.barLength = 10;
		}
		listItemsMC_mask.width = bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
		listItemsMC_mask.height = bgMC.height - headBgMC.height * uint(_showHeaders) - uint(_scrollBarH.visible) * _scrollBarH.thickness;
		panelCheck();
		moveSliderFunc();
	}

	private function panelCheck(x : Boolean = true, y : Boolean = true) : void {
		if (y) {
			var getH : uint = getItemY() * 25;
			if (getH > listItemsMC_mask.height && listItemsMC.y < bgMC.y + bgMC.height - getH - uint(_scrollBarH.visible) * _scrollBarH.thickness) {
				listItemsMC.y = bgMC.y + bgMC.height - getH - uint(_scrollBarH.visible) * _scrollBarH.thickness;
			} else if (getH <= listItemsMC_mask.height) {
				listItemsMC.y = listItemsMC_mask.y;
			}
			if (listItemsMC.y > listItemsMC_mask.y) {
				listItemsMC.y = listItemsMC_mask.y;
			}
		}
		if (x) {
			if (listItemsMC.width > listItemsMC_mask.width && listItemsMC.x < bgMC.width - listItemsMC.width) {
				headListMC.x = listItemsMC.x = bgMC.width - listItemsMC.width;
			} else if (listItemsMC.width <= listItemsMC_mask.width) {
				headListMC.x = listItemsMC.x = bgMC.x;
			}
			if (listItemsMC.x > bgMC.x) {
				headListMC.x = listItemsMC.x = bgMC.x;
			}
		}
	}

	private function moveSliderFunc() : void {
		var getH : uint = getItemY() * 25;
		_scrollBarH.value = (listItemsMC_mask.x - listItemsMC.x) * 100 / (listItemsMC.width - listItemsMC_mask.width);
		_scrollBarV.value = (listItemsMC_mask.y - listItemsMC.y) * 100 / (getH - listItemsMC_mask.height);
	}

	private function movePanelFunc() : void {
		var valueH : int = (listItemsMC.width - listItemsMC_mask.width) * _scrollBarH.value / 100;
		var valueV : int = (getItemY() * 25 - listItemsMC_mask.height) * _scrollBarV.value / 100;
		listItemsMC.x = headListMC.x = int(listItemsMC_mask.x - valueH);
		listItemsMC.y = int(listItemsMC_mask.y - valueV);
	}
	/** @private */
	internal function tt_FOCUS_OUT(evt : FocusEvent) : void {
		var tt : TextField = evt.target as TextField;
		tt.background = false;
		_lockfocus = false;
	}
	/** @private */
	internal function tt_FOCUS_IN(evt : FocusEvent) : void {
		var tt : TextField = evt.target as TextField;
		tt.background = true;
		_lockfocus = true;
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
	}

	public function set smooth(boo : Boolean) : void {
		_smooth = _scrollBarH.smooth = _scrollBarV.smooth = boo;
	}

	public function get smooth() : Boolean {
		return _smooth;
	}

	public function set smoothSpeed(spd : Number) : void {
		_scrollBarH.smoothSpeed = _scrollBarV.smoothSpeed = _smoothSpeed = spd > 1 ? 1 : spd < 0.01 ? 0.01 : spd;
	}

	public function get smoothSpeed() : Number {
		return _smoothSpeed;
	}

	public function set search(str : String) : void {
		_searchStr = str;
		refresh();
	}

	public function get search() : String {
		return _searchStr;
	}

	public function moveToTop() : void {
		_scrollBarV.value = 0;
		movePanelFunc();
	}

	public function moveToBottom() : void {
		if (listItemsMC.height > listItemsMC_mask.height) {
			_scrollBarV.value = 100;
		} else {
			_scrollBarV.value = 0;
		}
		movePanelFunc();
	}

	public function set treeView(boo:Boolean):void{
		_treeView = boo;
	}

	public function get treeView():Boolean{
		return _treeView;
	}

	public function set treeViewColor(col:Object):void{
		_treeViewColor = col;
	}
	public function get treeViewColor():Object{
		return _treeViewSpacing;
	}
	public function set treeViewSpacing(num:uint):void{
		_treeViewColor = num;
	}
	public function get treeViewSpacing():uint{
		return _treeViewSpacing;
	}
	public function set itemsNativeMenu(rci:NativeMenu):void{
		_rci = rci;
		for(var i : uint = 0; i < _items.length; i++){
			_items[i].setNativeMenu();
//			_items[i].defaultNativeMenu(_canEdit, _canCopy, _canPause, _canCut, _canDelete);
		}
	}
	public function get itemsNativeMenu():NativeMenu{
		return _rci;
	}
	public function set iconSpacing(sp:uint):void{
		_iconSpacing = sp;
		for(var i:uint=0;i<+items.length;i++){
			items[i].iconSpacing0 = _iconSpacing;
		}
	}
	public function get iconSpacing():uint{
		return _iconSpacing;
	}

	public function set canSearch(boo : Boolean) : void {
		_canSearch = boo;
		for each(var _item : ListBoxItem in _items){
			_item.canSearch = boo;
		}
	}

	public function get canSearch() : Boolean {
		return _canSearch;
	}

	public function set searchMinItems(i : int) : void {
		_searchMinItems = i;
		for each(var _item : ListBoxItem in _items){
			_item.searchMinItems = i;
		}
	}

	public function get searchMinItems() : int {
		return _searchMinItems;
	}

	public function set searchUsePinyin(boo : Boolean) : void {
		_searchUsePinyin = boo;
		for each(var _item : ListBoxItem in _items){
			_item.searchUsePinyin = boo;
		}
	}

	public function get searchUsePinyin() : Boolean {
		return _searchUsePinyin;
	}

	public function set searchMatchCase(boo : Boolean) : void {
		_searchMatchCase = boo;
		for each(var _item : ListBoxItem in _items){
			_item.searchMatchCase = boo;
		}
	}

	public function get searchMatchCase() : Boolean {
		return _searchMatchCase;
	}
}
}
