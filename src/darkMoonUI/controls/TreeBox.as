package darkMoonUI.controls{
import darkMoonUI.types.ControlType;
import darkMoonUI.controls.orientation.Orientation;
import darkMoonUI.functions.parentAddChilds;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.controls.treeBox.TreeNode;
import darkMoonUI.controls.treeBox.TreeView;

import flash.display.DisplayObject;
import flash.display.NativeMenu;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.system.System;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class TreeBox extends DarkMoonUIControl{
	public var collaps : Boolean = true;
	/** @private */
	internal var
	lastSelected : int = -1;
	private var
	_showFocus : Boolean = true,
	_items : Vector.<TreeBoxItem>,
	treeItemsMC:Sprite = new Sprite(),
	bgMC : Sprite = new Sprite(),
	treeItemsMC_mask : Shape = new Shape(),
	_selectedIndexes : Vector.<uint> = Vector.<uint>([]),
	_scrollBarV : ScrollBar = new ScrollBar(),
	_scrollBarH : ScrollBar = new ScrollBar(),
	_scrollBarN : Shape = new Shape(),
	_selectedMC : Shape = new Shape(),
	enabledMC : Sprite = new Sprite(),
	_smooth : Boolean = true,
	_smoothSpeed : Number = .25,
	_searchStr : String = "",
	_multiline : Boolean = false,
	_scaleX : Number = 0,
	_scaleY : Number = 0,
	_rci:NativeMenu,
	treeView:TreeView
	;

	public function TreeBox():void{
		super();
		_type = ControlType.TREE_BOX;

		treeView = new TreeView();
		treeView.onReferesh = function():void{
			size = [];
		};
		treeView.focusChange = function():void{
			if(stage){
				focus = true;
				resetLayoutFunc();
			}
		};
		treeItemsMC.addChild(treeView);
		fill(enabledMC.graphics, 10, 10, bgColorArr[0]);
		fill(_selectedMC.graphics, 10, 10, bgColorArr[2]);
		fill(bgMC.graphics, 10, 10, bgColorArr[3], bgColorArr[1]);
		fill(_scrollBarN.graphics, 20, 20, bgColorArr[4]);

		fill(treeItemsMC_mask.graphics);
		enabledMC.alpha = .0;
		_selectedMC.x = _selectedMC.y = -2;

		_scrollBarV.create(0, 0, 0, 0, 100, Orientation.V, 20, 200);
		_scrollBarH.create();
		_scrollBarH.regPoint = ["left", "bottom"];

		_selectedMC.visible = _scrollBarN.visible = _scrollBarH.visible = _scrollBarV.visible = false;

		_scrollBarV.onChange = _scrollBarV.onChanging = _scrollBarH.onChange = _scrollBarH.onChanging = function() : void {
			movePanelFunc();
		};

		treeItemsMC.mask = treeItemsMC_mask;

		parentAddChilds(mc, Vector.<DisplayObject>([
			_selectedMC, bgMC, treeItemsMC, treeItemsMC_mask,
			_scrollBarN, _scrollBarV, _scrollBarH, enabledMC
		]));

		create();
	}

	public function create(_x : int = 0, _y : int = 0, w : uint = 150, h : uint = 150, mult : Boolean = false) : void {
		x = _x;
		y = _y;

		//_multiline = mult;

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
	protected override function _mouseWheel(boo:Boolean = false) : void {
		var speed : Number = _MouseEvent.delta * 8;
		if (_scrollBarV.visible) {
			treeItemsMC.y += speed;
			panelCheck(false);
		} else if (_scrollBarH.visible) {
			treeItemsMC.x = treeItemsMC.x + speed;
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
		_scaleX = mouseX - treeItemsMC.x;
		_scaleY = mouseY - treeItemsMC.y;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
		stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mdUpFunc);
		Mouse.cursor = MouseCursor.HAND;
		if(_mouseDown != null){
			_mouseDown();
		}
	}

	public function set onChange(func:Function):void{
		treeView.onChange = func;
	}

	public function get onChange():Function{
		return treeView.onChange;
	}

	private function movePanelFunc() : void {
		var getW : uint = treeItemsMC.width;
		var getH : uint = treeItemsMC.height;
		var valueH : int = (getW - treeItemsMC_mask.width) * _scrollBarH.value / 100;
		var valueV : int = (getH - treeItemsMC_mask.height) * _scrollBarV.value / 100;
		treeItemsMC.x = int(treeItemsMC_mask.x - valueH);
		treeItemsMC.y = int(treeItemsMC_mask.y - valueV);
	}

	public function addItem(itm:TreeBoxItem):void{
		_items.push(itm);
		addOneItem(itm);
		size = [];
	}

	private function addOneItem(itm : TreeBoxItem) : void {
		treeView.collaps = collaps;
		if(treeView.childreenNodes==null){
			treeView.childreenNodes = [];
		}
		treeView.childreenNodes.push(itm.treeNode);
		itm.treeNode.parentNode = treeView;
		itm.treeNode.collaps = collaps;
		treeView.drawNode();
		if(treeView.onChange != null){
			treeView.onChange();
		}
	}

	public function removeAll() : void {
		var sel : Boolean = treeView.selectedNode != null;
		treeView.childreenNodes = [];
		treeView.drawNode();
		items = null;
		size = [];
		if (sel && treeView.onChange != null) {
			treeView.onChange();
		}
	}

	public function removeItem(obj : TreeBoxItem) : void {
		var founded : Boolean = false;
		var oldLeng : uint = _items.length;
		for (var i : uint = 0; i < _items.length; i++) {
			if (_items[i] == obj) {
				_items.splice(i, 1);
				founded = true;
				break;
			}
		}
		////
		var _xy : Vector.<int> = oldXY;
		var newItems : Vector.<TreeBoxItem> = Vector.<TreeBoxItem>([]);
		for (i = 0; i < _items.length; i++) {
			newItems.push(_items[i]);
		}
		treeView.childreenNodes = [];
		_items = newItems;
		for (i = 0; i < _items.length; i++) {
			obj = _items[i];
			addOneItem(obj);
		}
		oldXY = _xy;
		if (founded && treeView.onChange != null) {
			treeView.onChange();
		}
	}

	public function get multiline() : Boolean {
		return _multiline;
	}

	public function set items(arr:Vector.<TreeBoxItem>):void{
		if(arr==null || arr.length==0){
			System.gc();
			_items = Vector.<TreeBoxItem>([]);
			return;
		}
		var newItems : Vector.<TreeBoxItem> = Vector.<TreeBoxItem>([]);
		for (var i : uint = 0; i < arr.length; i++) {
			newItems.push(arr[i]);
		}
		_items = Vector.<TreeBoxItem>([]);
		for (i = 0; i < newItems.length; i++) {
			addItem(arr[i]);
		}
	}

	public function get items():Vector.<TreeBoxItem>{
		var newItems: Vector.<TreeBoxItem> = Vector.<TreeBoxItem>([]);
		if(_items!=null){
			for(var i:uint=0;i<_items.length;i++){
				newItems.push(_items[i]);
			}
		}
		return newItems;
	}
	/** @private */
	internal function get oldXY() : Vector.<int> {
		return Vector.<int>([treeItemsMC.x, treeItemsMC.y]);
	}
	/** @private */
	internal function set oldXY(xy : Vector.<int>) : void {
		xy.length = 2;
		treeItemsMC.x = xy[0];
		treeItemsMC.y = xy[1];
		refreshList();
	}

	private function resetLayoutFunc() : void {
		var getW : uint = treeItemsMC.width;
		var getH : uint = treeItemsMC.height;
		_scrollBarH.visible = getW > bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
		_scrollBarV.visible = getH > bgMC.height - uint(_scrollBarH.visible) * _scrollBarH.thickness;
		_scrollBarH.visible = getW > bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
		treeItemsMC_mask.width = bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
		treeItemsMC_mask.height = bgMC.height - uint(_scrollBarH.visible) * _scrollBarH.thickness;
		_scrollBarN.visible = _scrollBarV.visible && _scrollBarH.visible;
		if (getW > bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness) {
			_scrollBarH.length = bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
			_scrollBarH.barLength = treeItemsMC_mask.width / getW * _scrollBarH.length;
		}
		if (getH > bgMC.height - uint(_scrollBarH.visible) * _scrollBarH.thickness) {
			_scrollBarV.length = bgMC.height - uint(_scrollBarH.visible) * _scrollBarH.thickness;
			_scrollBarV.barLength = treeItemsMC_mask.height / getH * _scrollBarV.length;
		}
		if (_scrollBarV.barLength < 10) {
			_scrollBarV.barLength = 10;
		}
		if (_scrollBarH.barLength < 10) {
			_scrollBarH.barLength = 10;
		}
		treeItemsMC_mask.width = bgMC.width - uint(_scrollBarV.visible) * _scrollBarV.thickness;
		treeItemsMC_mask.height = bgMC.height - uint(_scrollBarH.visible) * _scrollBarH.thickness;
		panelCheck();
		moveSliderFunc();
	}

	private function panelCheck(x : Boolean = true, y : Boolean = true) : void {
		if (y) {
			var getH : uint = treeItemsMC.height;
			if (getH > treeItemsMC_mask.height && treeItemsMC.y < bgMC.y + bgMC.height - getH - uint(_scrollBarH.visible) * _scrollBarH.thickness) {
				treeItemsMC.y = bgMC.y + bgMC.height - getH - uint(_scrollBarH.visible) * _scrollBarH.thickness;
			} else if (getH <= treeItemsMC_mask.height) {
				treeItemsMC.y = treeItemsMC_mask.y;
			}
			if (treeItemsMC.y > treeItemsMC_mask.y) {
				treeItemsMC.y = treeItemsMC_mask.y;
			}
		}
		if (x) {
			if (treeItemsMC.width > treeItemsMC_mask.width && treeItemsMC.x < bgMC.width - treeItemsMC.width) {
				treeItemsMC.x = bgMC.width - treeItemsMC.width;
			} else if (treeItemsMC.width <= treeItemsMC_mask.width) {
				treeItemsMC.x = treeItemsMC.x = bgMC.x;
			}
			if (treeItemsMC.x > bgMC.x) {
				treeItemsMC.x = bgMC.x;
			}
		}
	}

	private function moveSliderFunc() : void {
		var getW : uint = treeItemsMC.width ;
		var getH : uint = treeItemsMC.height;
		_scrollBarH.value = (treeItemsMC_mask.x - treeItemsMC.x) * 100 / (getW - treeItemsMC_mask.width);
		_scrollBarV.value = (treeItemsMC_mask.y - treeItemsMC.y) * 100 / (getH - treeItemsMC_mask.height);
	}

	private function bgClickFunc(evt : MouseEvent) : void {
		treeView.selectedNode = null;
		treeView.drawNode();
	}

	public function get rootString():String{
		return treeView.rootString;
	}

	public function set rootString(str:String):void{
		if(str==null || treeView.childreenNodes==null){
			treeView.selectedNode = null;
		}else{
			var arr:Array = str.split("|");
			var nodeArr : Array = treeView.childreenNodes;
			var finalNone : TreeNode;
			for(var i:uint=0;i<arr.length;i++){
				var node:TreeNode = getNode(nodeArr,arr[i]);
				if(node==null){
					break;
				}else{
					finalNone = node;
					nodeArr = node.childreenNodes;
				}
			}
			treeView.selectedNode = finalNone;
		}
		treeView.drawNode();
	}

	private static function getNode(arr:Array, txt:String):TreeNode{
		for each(var node:TreeNode in arr){
			if(node.text==txt){
				return node;
			}
		}
		return null;
	}

	private function moveFunc(evt : MouseEvent) : void {
		if (!evt.buttonDown) {
			mdUpFunc(evt);
			return;
		}
		treeItemsMC.x = mouseX - _scaleX;
		treeItemsMC.y = this.mouseY - _scaleY;
		refreshList();
		moveSliderFunc();
	}

	private function refreshList() : void {
		var getW : uint = treeItemsMC.width;
		var getH : uint = treeItemsMC.height;
		if (treeItemsMC.y > bgMC.y || !_scrollBarV.visible) {
			treeItemsMC.y = bgMC.y;
		} else if (treeItemsMC.y < bgMC.y + bgMC.height - getH - Number(_scrollBarH.visible) * _scrollBarH.thickness) {
			treeItemsMC.y = bgMC.y + bgMC.height - getH - Number(_scrollBarH.visible) * _scrollBarH.thickness;
		}
		if (treeItemsMC.x < bgMC.x + bgMC.width - getW - Number(_scrollBarV.visible) * _scrollBarV.thickness) {
			treeItemsMC.x = bgMC.x + bgMC.width - getW - Number(_scrollBarV.visible) * _scrollBarV.thickness;
		}
		if (treeItemsMC.x > bgMC.x) {
			treeItemsMC.x = bgMC.x;
		}
		moveSliderFunc();
	}

	private function mdUpFunc(evt : MouseEvent) : void {
		Mouse.cursor = MouseCursor.AUTO;
		stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, mdUpFunc);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
		_scrollBarH.upFunc(evt);
		_scrollBarV.upFunc(evt);
	}

	/*public function set itemsNativeMenu(rci:NativeMenu):void{
		_rci = rci;
		for(var i:uint=0;i<_items;i++){
			_items[i].defaultNativeMenu();
		}
	}
	public function get itemsNativeMenu():NativeMenu{
		return _rci;
	}*/
}
}
