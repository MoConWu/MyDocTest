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
import flash.events.MouseEvent;
import flash.system.System;
import flash.text.TextField;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

/**
 * @author WuHeKang
 */
public class GridBox extends DarkMoonUIControl implements DMUI_PUB_DEF, DMUI_PUB_BOX {
	public var clear_gc : Boolean = true;
	public var onItemDoubleClick : Function;
	public var isLoopList : Boolean = false;
	public var onChange : Function;
	/** @private */
	internal var
	lastSelected : int = -1;
	private var
	_showFocus : Boolean = true,
	bgMC : Sprite = new Sprite(),
	headBgMC : Shape = new Shape(),
	headListMC : Sprite = new Sprite(),
	headListMC_mask : Shape = new Shape(),
	gridItemsMC : Sprite = new Sprite(),
	gridItemsMC_mask : Shape = new Shape(),
	_items : Vector.<GridBoxItem> = Vector.<GridBoxItem>([]),
	_selectedIndexes : Vector.<uint> = Vector.<uint>([]),
	_scrollBarV : ScrollBar = new ScrollBar(),
	_scrollBarH : ScrollBar = new ScrollBar(),
	_scrollBarN : Shape = new Shape(),
	_showHeaders : Boolean = false,
	_headList : Vector.<String> = Vector.<String>([]),
	_sort : Boolean = false,
	_selectedMC : Shape = new Shape(),
	enabledMC : Sprite = new Sprite(),
	_smooth : Boolean = true,
	_smoothSpeed : Number = .25,
	_searchStr : String = "",
	_multiline : Boolean = false,
	_gdSz : Array = [50, 50],
	itemsWdtArr : Vector.<uint> = Vector.<uint>([]),
	_spacing : uint = 10,
	_scaleX : Number = 0,
	_scaleY : Number = 0,
	_splitSpacing : Boolean = true,
	wMaxNum : int = 1,
	hMaxNum : int = 1,
//	_canDelete : Boolean = false,
//	_canCopy : Boolean = false,
//	_canPause : Boolean = false,
//	_canCut : Boolean = false,
//	_canEdit : Boolean = false,
	_rowNumber : uint = 0,
	_columNumber : uint = 0,
	_rci : NativeMenu
	;

	public function GridBox() : void {
		super();
		_type = ControlType.GRID_BOX;

		fill(enabledMC.graphics, 10, 10, bgColorArr[0]);
		fill(_selectedMC.graphics, 10, 10, bgColorArr[2]);
		fill(bgMC.graphics, 10, 10, bgColorArr[3], bgColorArr[1]);
		fill(_scrollBarN.graphics, 20, 20, bgColorArr[4]);

		fill(headBgMC.graphics, 10, 25, bgColorArr[3], bgColorArr[1]);
		fill(headListMC_mask.graphics);
		fill(gridItemsMC_mask.graphics);
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
		gridItemsMC.mask = gridItemsMC_mask;

		parentAddChilds(mc, Vector.<DisplayObject>([
			_selectedMC, bgMC, gridItemsMC, gridItemsMC_mask, _scrollBarN,
			_scrollBarV, _scrollBarH, headBgMC, headListMC, headListMC_mask, enabledMC
		]));

		create();
	}

	public function create(_x : int = 0, _y : int = 0, w : uint = 150, h : uint = 150, gridSz : Array = null, sh : Boolean = false, srt : Boolean = false, mult : Boolean = false) : void {
		x = _x;
		y = _y;

		headBgMC.visible = headListMC.visible = sh;

		showHeaders = sh;
		_multiline = mult;
		_sort = srt;

		gridSize = gridSz;

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
		gridItemsMC_mask.y = _scrollBarV.y = headBgMC.height * Number(_showHeaders);
		// /
		gridItemsMC.visible = false;
		grdReSize();
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
			gridItemsMC.y += speed;
			panelCheck(false);
		} else if (_scrollBarH.visible && _showHeaders) {
			headListMC.x = gridItemsMC.x = gridItemsMC.x + speed;
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
		_scaleX = mouseX - gridItemsMC.x;
		_scaleY = mouseY - gridItemsMC.y;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
		stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mdUpFunc);
		Mouse.cursor = MouseCursor.HAND;
		if(_mouseDown != null){
			_mouseDown();
		}
	}
	/** @private */
	protected override function _keyDown() : void {
		if (focus) {
			if (_KeyboardEvent.keyCode == 65 && _KeyboardEvent.ctrlKey) {
				if (_multiline) {
					// trace("Ctrl + A");
					_selectedIndexes = Vector.<uint>([]);
					for (var i : uint = 0; i < uint(gridItemsMC.numChildren); i++) {
						var thisItem : GridBoxItem = _items[i];
						thisItem.IOC = false;
						if (thisItem.mc.visible) {
							thisItem.selected = true;
							_selectedIndexes.push(_items[i].index);
						}
						thisItem.IOC = true;
					}
					selectedIndexes = _selectedIndexes;
				}
			} else if (_KeyboardEvent.keyCode >= 37 && _KeyboardEvent.keyCode <= 40) {
				if (selectedIndexes.length > 0) {
					if (_KeyboardEvent.keyCode == 39) {
						var selAdd : int = selectedIndexes[0] + 1;
					} else if (_KeyboardEvent.keyCode == 37) {
						selAdd = selectedIndexes[0] - 1;
					} else if (_KeyboardEvent.keyCode == 38) {
						selAdd = selectedIndexes[0] - wMaxNum;
					} else if (_KeyboardEvent.keyCode == 40) {
						selAdd = selectedIndexes[0] + wMaxNum;
					}
					if (selAdd >= items.length) {
						if (isLoopList && _KeyboardEvent.keyCode == 39) {
							selAdd = 0;
						} else if (isLoopList && _KeyboardEvent.keyCode == 40) {
							selAdd = selAdd % wMaxNum;
						} else {
							return;
						}
					} else if (selAdd < 0) {
						if (isLoopList && _KeyboardEvent.keyCode == 37) {
							selAdd = items.length - 1;
						} else if (isLoopList && _KeyboardEvent.keyCode == 38) {
							selAdd += items.length;
						} else {
							return;
						}
					}
					selectedIndexes = Vector.<uint>([selAdd]);
					var selAddNum : uint = Math.floor(selAdd / wMaxNum) * (_gdSz[1] + _spacing);
					var getY : int = selAddNum + gridItemsMC.y - headBgMC.height * uint(_showHeaders);
					if (getY >= bgMC.y + gridItemsMC_mask.height - _gdSz[1] / 2) {
						gridItemsMC.y = -selAddNum + gridItemsMC_mask.y;
					} else if (getY < bgMC.y) {
						gridItemsMC.y = bgMC.y - selAddNum - _gdSz[1] + gridItemsMC_mask.height - 25 * uint(!_showHeaders);
					}
					lastSelected = selAdd;
					refreshList();
				}
			}
		}
	}

	// //////////////////////////// item //////////////////////////////
	// items
	public function set items(arr : Vector.<GridBoxItem>) : void {
		gridItemsMC.removeChildren();
		if(arr==null || arr.length==0){
			System.gc();
			_items = Vector.<GridBoxItem>([]);
			return;
		}
		var newItems : Vector.<GridBoxItem> = Vector.<GridBoxItem>([]);
		for (var i : uint = 0; i < arr.length; i++) {
			newItems.push(arr[i]);
		}
		_items = Vector.<GridBoxItem>([]);
		for (i = 0; i < newItems.length; i++) {
			addItem(arr[i], false);
		}
		size = [];
	}

	public function get items() : Vector.<GridBoxItem> {
		return _items;
	}

	// item
	public function addItem(itm : GridBoxItem, ref : Boolean = true) : void {
		_items.push(itm);
		addOneItem(itm);
		if(ref){
			itm.added_ref = true;
			size = [];
		}
	}

	private function addOneItem(itm : GridBoxItem) : void {
		itm.index = itm._id = uint(gridItemsMC.numChildren);
		gridItemsMC.addChild(itm.mc);
	}

	public function addItemAt(itm : GridBoxItem, _id : uint, ref : Boolean = true) : void {
		addItem(itm, ref);
		setItemIndex(itm, _id);
	}

	public function removeItem(obj : GridBoxItem) : void {
		var founded : Boolean = false;
		var oldLeng : uint = _items.length;
		for (var i : uint = 0; i < _items.length; i++) {
			if (_items[i] == obj) {
				_items[i].parent = null;
				delete(items[i]);
				_items.splice(i, 1);
				founded = true;
				break;
			}
		}
		if (founded) {
			gridItemsMC.removeChild(obj.mc);
			if (oldLeng != 0) {
				refresh();
			}
			if (obj.selected) {
				if(onChange != null){
					onChange();
				}
			}
		}
	}

	public function removeAt(num : uint) : void {
		if (num >= _items.length) {
			return;
		}
		var newItems : Vector.<GridBoxItem> = Vector.<GridBoxItem>([]);
		var chg : Boolean = false;
		for (var i : uint = 0; i < _items.length; i++) {
			if (i != num) {
				newItems.push(_items[i]);
			} else {
				_items[i].parent = null;
				if (!chg){
					chg = _items[i].selected;
				}
			}
		}
		_items = newItems;
		gridItemsMC.removeChildren();
		for (i = 0; i < _items.length; i++) {
			var obj : GridBoxItem = _items[i];
			addOneItem(obj);
		}
		size = [];
		if (chg) {
			if(onChange != null){
				onChange();
			}
		}
	}

	public function removeAll() : void {
		var sel : Boolean = selectedIndexes.length > 0;
		gridItemsMC.removeChildren();
		for(var i:uint=0;i<items.length;i++){
			if(clear_gc){
				items[i].clear();
			}
			items[i].parent = null;
			delete(items[i]);
		}
		items.length = 0;
		size = [];
		if (sel) {
			if(onChange != null){
				onChange();
			}
		}
	}

	public function removeSelected() : void {
		var newItems : Vector.<GridBoxItem> = Vector.<GridBoxItem>([]);
		for (var i : uint = 0; i < _items.length; i++) {
			if (!_items[i].selected) {
				newItems.push(_items[i]);
			}else{
				delete(items[i]);
			}
		}
		_items = newItems;
		size = [];
	}

	public function setItemIndex(obj : GridBoxItem, _id : uint) : void {
		_items.splice(obj.id, 1);
		_items.insertAt(_id, obj);
		refresh();
	}

	// //////////////////////////// item //////////////////////////////
	/** @private */
	internal function mouseSelectMoveFunc() : void {
		for (var i : uint = 0; i < _items.length; i++) {
			var thisItem : GridBoxItem = _items[i];
			thisItem.itemSelectOver = true;
		}
		stage.addEventListener(MouseEvent.MOUSE_UP, upFunc);
	}

	private function upFunc(evt : MouseEvent) : void {
		for (var i : uint = 0; i < _items.length; i++) {
			var thisItem : GridBoxItem = _items[i];
			thisItem.itemSelectOver = false;
		}
	}

	public function refresh() : void {
		var index : uint = 0;
		for (var i : uint = 0; i < _items.length; i++) {
			_items[i].setID(i);
			if (_items[i].visible) {
				_items[i].index = index;
				index++;
			}
		}
		size = [];
		refreshHeadFunc();
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
		var str : String;
		for (var i : uint = 0; i < numChild; i++) {
			str = _items[i].labels[id];
			getItemList.push([i, str, _items[i].selected]);
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
		var newItems : Vector.<GridBoxItem> = Vector.<GridBoxItem>([]);
		for (i = 0; i < getItemList.length; i++) {
			newItems.push(_items[getItemList[i][0]]);
		}
		_items = newItems;
		gridItemsMC.removeChildren();
		var obj : GridBoxItem;
		for (i = 0; i < _items.length; i++) {
			obj = _items[i];
			obj._id = uint(gridItemsMC.numChildren);
			addOneItem(obj);
		}
		size = [];
	}

	private function bgClickFunc(evt : MouseEvent) : void {
		var selLeng : uint = selectedIndexes.length;
		for (var i : uint = 0; i < Number(gridItemsMC.numChildren); i++) {
			var getItem : GridBoxItem = _items[i];
			getItem.IOC = false;
			getItem.selected = false;
			getItem.IOC = true;
		}
		if (selLeng > 0) {
			if(onChange != null){
				onChange();
			}
		}
	}

	private function refreshHeadFunc() : void {
		var listWdt : uint = 0;
		for (var i : uint = 0; i < itemsWdtArr.length; i++) {
			listWdt += itemsWdtArr[i];
		}
		var headLeng : uint = bgMC.width;
		for (i = 0; i < itemsWdtArr.length; i++) {
			if (uint(headListMC.numChildren) > i) {
				var thisHead : BoxHeadItem = headListMC.getChildAt(i) as BoxHeadItem;
				var lastNum : uint = 0;
				var leng : uint = itemsWdtArr[i] / listWdt * headLeng;
				thisHead.size = [leng];
				if (i != 0) {
					var lastObj : BoxHeadItem = headListMC.getChildAt(i - 1) as BoxHeadItem;
					lastNum = lastObj.x + lastObj.width;
				}
				thisHead.x = lastNum;
			}
		}
	}

	private function moveFunc(evt : MouseEvent) : void {
		if (!evt.buttonDown) {
			mdUpFunc(evt);
			return;
		}
		headListMC.x = gridItemsMC.x = this.mouseX - _scaleX;
		gridItemsMC.y = this.mouseY - _scaleY;
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

	public function moveToTop() : void {
		_scrollBarV.value = 0;
		movePanelFunc();
	}

	public function moveToBottom() : void {
		if (gridItemsMC_height > gridItemsMC_mask.height) {
			_scrollBarV.value = 100;
		} else {
			_scrollBarV.value = 0;
		}
		movePanelFunc();
	}

	private function resetLayoutFunc() : void {
		const getW : uint = gridItemsMC_width;
		const getH : uint = gridItemsMC_height;
		headBgMC.width = headListMC_mask.width = bgMC.width;
		headListMC_mask.height = headBgMC.height;
		_scrollBarH.visible = getW > bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
		_scrollBarV.visible = getH > bgMC.height - headBgMC.height * uint(_showHeaders) - uint(_scrollBarH.visible) * _scrollBarH.thickness;
		_scrollBarH.visible = getW > bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
//		trace("gridSize:", gridSize, "_spacing:", _spacing);
//		trace("getW:", getW, "bgMC.width:", bgMC.width, "thickness:", _scrollBarV.thickness);
		gridItemsMC_mask.height = bgMC.height - headBgMC.height * uint(_showHeaders) - uint(_scrollBarH.visible) * _scrollBarH.thickness;
		_scrollBarN.visible = _scrollBarV.visible && _scrollBarH.visible;
		if (getW > bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness) {
			_scrollBarH.length = bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
			_scrollBarH.barLength = gridItemsMC_mask.width / getW * _scrollBarH.length;
		}
		if (getH > bgMC.height - headBgMC.height * uint(_showHeaders) - uint(_scrollBarH.visible) * _scrollBarH.thickness) {
			_scrollBarV.length = bgMC.height - headBgMC.height * uint(_showHeaders) - uint(_scrollBarH.visible) * _scrollBarH.thickness;
			_scrollBarV.barLength = gridItemsMC_mask.height / getH * _scrollBarV.length;
		}
		if (_scrollBarV.barLength < 10) {
			_scrollBarV.barLength = 10;
		}
		if (_scrollBarH.barLength < 10) {
			_scrollBarH.barLength = 10;
		}
		gridItemsMC_mask.width = bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
		gridItemsMC_mask.height = bgMC.height - headBgMC.height * uint(_showHeaders) - uint(_scrollBarH.visible) * _scrollBarH.thickness;
		panelCheck();
		moveSliderFunc();
	}

	private function panelCheck(x : Boolean = true, y : Boolean = true) : void {
		if (y) {
			const getH : uint = gridItemsMC_height + _spacing * 2;
			if (getH > gridItemsMC_mask.height && gridItemsMC.y < bgMC.y + bgMC.height - getH - uint(_scrollBarH.visible) * _scrollBarH.thickness) {
				gridItemsMC.y = bgMC.y + bgMC.height - getH - uint(_scrollBarH.visible) * _scrollBarH.thickness;
			} else if (getH <= gridItemsMC_mask.height) {
				gridItemsMC.y = gridItemsMC_mask.y;
			}
			if (gridItemsMC.y > gridItemsMC_mask.y) {
				gridItemsMC.y = gridItemsMC_mask.y;
			}
		}
		if (x) {
			const getW : uint = gridItemsMC_width;
			if (getW > gridItemsMC_mask.width && gridItemsMC.x < bgMC.width - getW) {
				headListMC.x = gridItemsMC.x = bgMC.width - getW;
			} else if (getW <= gridItemsMC_mask.width) {
				headListMC.x = gridItemsMC.x = bgMC.x;
			}
			if (gridItemsMC.x > bgMC.x) {
				headListMC.x = gridItemsMC.x = bgMC.x;
			}
		}
	}

	private function movePanelFunc() : void {
		const getW : uint = gridItemsMC_width;
		const getH : uint = gridItemsMC_height;
		const valueH : int = (getW - gridItemsMC_mask.width) * _scrollBarH.value / 100;
		const valueV : int = (getH - gridItemsMC_mask.height) * _scrollBarV.value / 100;
		gridItemsMC.x = headListMC.x = int(gridItemsMC_mask.x - valueH);
		gridItemsMC.y = int(gridItemsMC_mask.y - valueV);
	}

	private function moveSliderFunc() : void {
		const getW : uint = gridItemsMC_width;
		const getH : uint = gridItemsMC_height;
		_scrollBarH.value = (gridItemsMC_mask.x - gridItemsMC.x) * 100 / (getW - gridItemsMC_mask.width);
		_scrollBarV.value = (gridItemsMC_mask.y - gridItemsMC.y) * 100 / (getH - gridItemsMC_mask.height);
	}

	private function refreshList() : void {
		const getW : uint = gridItemsMC_width;
		const getH : uint = gridItemsMC_height;
		if (gridItemsMC.y > bgMC.y + headBgMC.height * Number(_showHeaders) || !_scrollBarV.visible) {
			gridItemsMC.y = bgMC.y + headBgMC.height * Number(_showHeaders);
		} else if (gridItemsMC.y < bgMC.y + bgMC.height - getH - Number(_scrollBarH.visible) * _scrollBarH.thickness) {
			gridItemsMC.y = bgMC.y + bgMC.height - getH - Number(_scrollBarH.visible) * _scrollBarH.thickness;
		}
		if (gridItemsMC.x < bgMC.x + bgMC.width - getW - Number(_scrollBarV.visible) * _scrollBarV.thickness) {
			gridItemsMC.x = bgMC.x + bgMC.width - getW - Number(_scrollBarV.visible) * _scrollBarV.thickness;
		}
		if (gridItemsMC.x > bgMC.x) {
			gridItemsMC.x = bgMC.x;
		}
		headListMC.x = gridItemsMC.x;
		moveSliderFunc();
	}

	/** @private */
	internal function get oldXY() : Vector.<int> {
		return Vector.<int>([gridItemsMC.x, gridItemsMC.y]);
	}
	/** @private */
	internal function set oldXY(xy : Vector.<int>) : void {
		xy.length = 2;
		gridItemsMC.x = xy[0];
		gridItemsMC.y = xy[1];
		refreshList();
	}

	private function get gridItemsMC_height():uint{
		var leng:uint = _items.length;
		if(leng>0){
			return _items[leng-1].mc.y + _gdSz[1] - spacing;
		}else{
			return 0;
		}
	}

	private function get gridItemsMC_width():uint{
		var leng:uint = _items.length;
		if(leng>0){
			for (var i : uint = 0; i < _items.length; i++) {
				if (i % wMaxNum == 0 && i != 0) {
					return _items[i].mc.x + _gdSz[0] + spacing;
				}
			}
			return _items[leng-1].mc.x + _gdSz[0] + spacing;
		}else{
			return 0;
		}
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
			var item : GridBoxItem = _items[i];
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
		if(isChange && onChange != null) {
			onChange();
		}
	}

	public function moveToSelect():void{
		_selectedIndexes = selectedIndexes;
		if(_selectedIndexes.length>0){
			var selAdd:uint = _selectedIndexes[0];
			var selAddNum : uint = Math.floor(selAdd / wMaxNum) * (_gdSz[1] + _spacing);
			var getY : int = selAddNum + gridItemsMC.y - headBgMC.height * uint(_showHeaders);
			if (getY >= bgMC.y + gridItemsMC_mask.height - _gdSz[1] / 2) {
				gridItemsMC.y = -selAddNum + gridItemsMC_mask.y;
			} else if (getY < bgMC.y) {
				gridItemsMC.y = bgMC.y - selAddNum - _gdSz[1] + gridItemsMC_mask.height - 25 * uint(!_showHeaders);
			}
			refreshList();
		}
	}

	public function get selectedIndexes() : Vector.<uint> {
		_selectedIndexes = Vector.<uint>([]);
		for (var i : uint = 0; i < _items.length; i++) {
			var item : GridBoxItem = _items[i];
			if (item.selected && item.mc.visible) {
				_selectedIndexes.push(item.index);
			}
		}
		return _selectedIndexes;
	}

	public function set selectedItems(arr : Vector.<GridBoxItem>) : void {
		selectedIndexes = null;
		for (var i : uint = 0; i < arr.length; i++) {
			if (arr[i].parent == this) {
				arr[i].selected = true;
			}
		}
	}

	public function get selectedItems() : Vector.<GridBoxItem> {
		var newItems : Vector.<GridBoxItem> = Vector.<GridBoxItem>([]);
		for (var i : uint = 0; i < _items.length; i++) {
			if (_items[i].visible && _items[i].selected) {
				newItems.push(_items[i]);
			}
		}
		return newItems;
	}

	public function set spacing(sp : uint) : void {
		_spacing = sp;
		size = [];
	}

	public function get spacing() : uint {
		return _spacing;
	}

	public function set heads(arr : Vector.<String>) : void {
		_headList = Vector.<String>([]);
		for(var i:uint=0;i<arr.length;i++){
			_headList.push(arr[i]);
		}
		itemsWdtArr = Vector.<uint>([]);
		headListMC.removeChildren();
		if (_headList != null) {
			for (i = 0; i < _headList.length; i++) {
				var headItem : BoxHeadItem = new BoxHeadItem();
				headItem.ID = i;
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
		refreshHeadFunc();
		sort = _sort;
	}

	public function get heads() : Vector.<String> {
		return _headList;
	}

	public function set sort(boo : Boolean) : void {
		_sort = boo;
		if(boo){
			headListMC.addEventListener(MouseEvent.CLICK, sortItem);
		}else{
			headListMC.removeEventListener(MouseEvent.CLICK, sortItem);
		}
	}

	public function get sort() : Boolean {
		return _sort;
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

	// search
	public function set search(str : String) : void {
		_searchStr = str;
		refresh();
	}

	public function get search() : String {
		return _searchStr;
	}

	// splitSpacing
	public function set splitSpacing(boo : Boolean) : void {
		_splitSpacing = boo;
		size = [];
	}

	public function get splitSpacing() : Boolean {
		return _splitSpacing;
	}

	// gridSize
	public function set gridSize(arr : Array) : void {
		if (arr != null) {
			if (arr.length >= 1) {
				_gdSz[0] = isNaN(Number(arr[0])) ? _gdSz[0] : uint(arr[0]);
			}
			if (arr.length >= 2) {
				_gdSz[1] = isNaN(Number(arr[1])) ? _gdSz[1] : uint(arr[1]);
			}
		}
		grdReSize();
	}

	private function grdReSize():void{
		var sz:Array = size;
		var w:uint = sz[0];
		var h:uint = sz[1];
		var _xy : Vector.<int> = oldXY;
		var gW : int = w;
		var sp : uint = _spacing;
		wMaxNum = (gW - sp) / (_gdSz[0] + sp);
		if (wMaxNum <= 0) {
			wMaxNum = 1;
		}
		hMaxNum = Math.ceil(_items.length / wMaxNum);
		if (hMaxNum * (sp + _gdSz[1]) + sp > h) {
			gW = w - _scrollBarV.size[0];
			wMaxNum = (gW - sp) / (_gdSz[0] + sp);
			if (wMaxNum == 0) {
				wMaxNum = 1;
			}
		}
		var wSp : int = _splitSpacing ? (gW - wMaxNum * _gdSz[0]) / (wMaxNum + 1) : sp;
		if (wSp <= 0) {
			wSp = sp;
		}
		var hNum : uint = 0;
		var wNum : uint = 0;
		for (var i : uint = 0; i < _items.length; i++) {
			_items[i].setSize(_gdSz);
			if (i % wMaxNum == 0 && i != 0) {
				hNum++;
				wNum = 0;
			}
			_items[i].mc.y = hNum * (sp + _gdSz[1]) + sp;
			_items[i].mc.x = wNum * (wSp + _gdSz[0]) + wSp;
			wNum++;
		}
		if (_items.length > 0) {
			hNum++;
		}
		_rowNumber = hNum;
		_columNumber = wNum;
		gridItemsMC.visible = true;
		oldXY = _xy;
		// /
		refreshHeadFunc();
		resetLayoutFunc();
	}

	public function get gridSize() : Array {
		return _gdSz;
	}

	// showHeaders
	public function set showHeaders(boo : Boolean) : void {
		_showHeaders = headBgMC.visible = headListMC.visible = boo;
		size = [];
	}

	public function get showHeaders() : Boolean {
		return _showHeaders;
	}

	// showFocus
	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
	}

	public function set itemsNativeMenu(rci : NativeMenu):void{
		_rci = rci;
		for(var i : uint = 0; i < _items.length; i++){
//			_items[i].defaultNativeMenu(_canEdit, _canCopy, _canPause, _canCut, _canDelete);
			_items[i].defaultNativeMenu();
		}
	}
	public function get itemsNativeMenu():NativeMenu{
		return _rci;
	}

	public function get rowNumber() : uint {
		return _rowNumber;
	}

	public function get columNumber() : uint {
		return _columNumber;
	}
}
}
