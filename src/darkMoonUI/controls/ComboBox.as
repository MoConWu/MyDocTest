package darkMoonUI.controls {
import com.mocon.pinyin.PinYin2;

import darkMoonUI.types.ControlType;
import darkMoonUI.assets.ComboBoxList;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.bgColor2OverColor;
import darkMoonUI.assets.functions.drawPolygon;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;
import darkMoonUI.functions.parentAddChilds;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.NativeWindow;
import flash.display.NativeWindowInitOptions;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * @author moconwu
 */
public class ComboBox extends DarkMoonUIControl implements DMUI_PUB_LABEL {
	public var
    onLoading : Function,
	onChange : Function,
	isLoopList : Boolean,
	searchMinItems : int = 5,
    searchUsePinyin : Boolean = true,
    searchMatchCase : Boolean = false,
	dropdownExtraWidth : int = 50;

	/** @private */
	protected var
	_label : TextField = new TextField(),
	listPanel : NativeWindow,
	appWindow : NativeWindow,
	_items : Vector.<ComboBoxItem> = new Vector.<ComboBoxItem>(),
	_selection : int = -1;

	private static const
	resolutionY : uint = Capabilities.screenResolutionY;

	private static var
	appWindow : NativeWindow,
	ipt_search : SearchBox,
	search_items : Vector.<ComboBoxItem>;

	private var
	nwo : NativeWindowInitOptions = new NativeWindowInitOptions(),
	listMC : ComboBoxList,
	listChange : Boolean = true,
	_selMC : Sprite = new Sprite(),
	MEvt : MouseEvent,
	ttf : TextFormat = setTF(textColorArr[1]),
	_autoSize : Boolean = false,
	_wordWrap : Boolean = false,
	_multiline : Boolean = false,
	_sz : Array = [150, 25],
	_selectedMC : Shape = new Shape(),
	arrowMC : Shape = new Shape(),
	_showFocus : Boolean = true,
	_bgColor : uint = bgColorArr[1],
	_overColor : uint = 0,
	_canWheelChange : Boolean = true,
	_canSearch : Boolean = false,
	_showSearch : Boolean = false,
	_labelSpacing : uint = 5;

	public function ComboBox(lab:String=ControlType.COMBO_BOX) : void {
		super();
		_type = ControlType.COMBO_BOX;

		_selectedMC.visible = false;
		fill(_selectedMC.graphics, 10, 2, bgColorArr[2]);
		fill(_selMC.graphics, 10, 10);
		_selMC.alpha = 0.0;
		var point0 : Point = new Point(0, 0);
		var point1 : Point = new Point(15, 0);
		var point2 : Point = new Point(7.5, 6);
		var verticies : Vector.<Point> = Vector.<Point>([point0, point1, point2]);
		drawPolygon(arrowMC.graphics, verticies, textColorArr[1]);

		_label.selectable = _label.wordWrap = false;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;

		nwo.systemChrome = "none";
		nwo.type = "utility";
		nwo.transparent = true;
		_label.x = _labelSpacing;

		listMC = new ComboBoxList();
		listMC.onSelect = function() : void {
			selection = listMC._selection;
		};

		parentAddChilds(mc, Vector.<DisplayObject>([
			_label, arrowMC, _selectedMC, _selMC
		]));

		create(0, 0, lab);
	}

	public function set showArrow(boo : Boolean) : void {
		arrowMC.visible = boo;
		size = [];
	}

	public function get showArrow() : Boolean {
		return arrowMC.visible;
	}
	/** @private */
	protected override function _size_get() : Array {
		return _sz;
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _sz[0];
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _sz[1];
		var arrow : uint = int(arrowMC.visible);
		var labW : uint = _SizeValue[0] - 30 * arrow > 0 ? _SizeValue[0] - 30 * arrow : 0;
		var labH : uint = _SizeValue[1] - 2 > 0 ? _SizeValue[1] - 2 : 0;
		_label.wordWrap = _wordWrap;
		_label.multiline = _multiline;
		_label.autoSize = "left";
		_label.width = labW;
		_label.height = labH;
		if (!_autoSize) {
			if (_label.width > labW || _label.height > labH) {
				_label.autoSize = "none";
				_label.width = labW;
				_label.height = labH;
			}
		} else {
			_SizeValue[0] = _label.width + 30 * arrow;
			_SizeValue[1] = _label.height + 2;
		}
		_selMC.width = _selectedMC.width = _sz[0] = _SizeValue[0];
		_selMC.height = _sz[1] = _SizeValue[1];

		_label.y = (_sz[1] - _label.height) / 2;
		if(arrowMC.visible){
			arrowMC.x = _SizeValue[0] - 25;
			arrowMC.y = (_SizeValue[1] - 6) / 2;
		}
		_selectedMC.y = _SizeValue[1] - 2;
		fill(mc.graphics, _sz[0], _sz[1], _bgColor);
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
		if (_enabled) {
			_selMC.addEventListener(MouseEvent.MOUSE_OVER, OVER);
			_selMC.addEventListener(MouseEvent.MOUSE_OUT, OUT);
			_selMC.addEventListener(MouseEvent.MOUSE_DOWN, DOWN);
			if (_canWheelChange) {
				_selMC.addEventListener(MouseEvent.MOUSE_WHEEL, WHEEL);
			}
		} else {
			_selMC.removeEventListener(MouseEvent.MOUSE_OVER, OVER);
			_selMC.removeEventListener(MouseEvent.MOUSE_OUT, OUT);
			_selMC.removeEventListener(MouseEvent.MOUSE_DOWN, DOWN);
			_selMC.removeEventListener(MouseEvent.MOUSE_WHEEL, WHEEL);
			try {
				listPanel.close();
			} catch (err : Error) {
			}
		}
	}
	/** @private */
	protected override function _keyDown() : void {
		if (_KeyboardEvent.keyCode == 38) {
			selectionChange(false);
		} else if (_KeyboardEvent.keyCode == 40) {
			selectionChange(true);
		} else if (_KeyboardEvent.keyCode == 13) {
			fill(mc.graphics, _sz[0], _sz[1], _bgColor);
			DOWN(MEvt);
			fill(mc.graphics, _sz[0], _sz[1], _bgColor);
		} else if (_KeyboardEvent.keyCode == 27) {
			try {
				listPanel.close();
			} catch (err : Error) {
			}
		}
	}

	public function copy() : ComboBox {
		var newDMUI : ComboBox = new ComboBox();
		var sz : Array = size;
		newDMUI.create(x, y, _label.text, sz[0], sz[1]);
		newDMUI.showFocus = _showFocus;
		newDMUI.enabled = _enabled;
		return newDMUI;
	}

	public function create(_x : int = 0, _y : int = 0, lab : String = "", w : uint = 150, h : uint = 26) : void {
		x = _x;
		y = _y;

		_label.text = lab;

		size = [w, h];

		enabled = _enabled;
	}

	public function set autoSize(boo : Boolean) : void {
		_autoSize = boo;
		size = [];
	}

	public function get autoSize() : Boolean {
		return _autoSize;
	}

	public function get font() : String {
		return ttf.font;
	}

	public function set font(f : String) : void {
		ttf.font = f;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function set wordWrap(boo : Boolean) : void {
		_label.wordWrap = boo;
		size = [];
	}

	public function get wordWrap() : Boolean {
		return _label.wordWrap;
	}

	public function set multiline(boo : Boolean) : void {
		_multiline = _label.multiline = boo;
		size = [];
	}

	public function get multiline() : Boolean {
		return _multiline;
	}

	public function get bold() : Boolean {
		return ttf.bold;
	}

	public function set bold(boo : Boolean) : void {
		ttf.bold = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function set fontSize(sz : uint) : void {
		ttf.size = sz;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
		size = [];
	}

	public function get fontSize() : uint {
		return int(ttf.size);
	}

	public function set color(col : Object) : void {
		if(col==null){
			col = textColorArr[1];
		}
		ttf.color = col;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get color() : Object {
		return "0x" + uint(ttf.color).toString(16);
	}

	public function set italic(boo : Boolean) : void {
		ttf.italic = boo;
		_label.setTextFormat(ttf);
		_label.defaultTextFormat = ttf;
	}

	public function get italic() : Boolean {
		return ttf.italic;
	}

	public override function get showFocus() : Boolean {
		return _showFocus;
	}

	public override function set showFocus(boo : Boolean) : void {
		_showFocus = boo;
	}

	private function OVER(evt : MouseEvent) : void {
		fill(mc.graphics, _sz[0], _sz[1], _overColor);
	}

	private function OUT(evt : MouseEvent) : void {
		fill(mc.graphics, _sz[0], _sz[1], _bgColor);
	}

	private function DOWN(evt : MouseEvent) : void {
		if (_items.length == 0) {
			return;
		}
		_lockfocus = true;
		try {
			listPanel.activate();
			listPanel.close();
		} catch (err : Error) {
		}
		_showSearch = _canSearch && (searchMinItems == -1 || _items.length > searchMinItems);
		appWindow = this.stage.nativeWindow;
		listPanel = new NativeWindow(nwo);
		listPanel.stage.stageFocusRect = false;
		listPanel.stage.scaleMode = "noScale";
		listPanel.stage.align = "TL";
		listPanel.alwaysInFront = true;
		if(_showSearch){
			listMC.y = ipt_search.size[1];
		}else{
			listMC.y = 0;
		}
		listPanel.stage.addChild(listMC);
		if(_showSearch) {
			ipt_search.onChanging = null;
			ipt_search.label = "";
		}
		refreshListMCItems();
		listPanel.width = this.width + this.dropdownExtraWidth;
		if(_showSearch){
			listPanel.stage.addChild(ipt_search);
			ipt_search.size = [listPanel.stage.stageWidth - 1];
			ipt_search.onChanging = refreshListMCItems;
			ipt_search.focus = true;
		}
		listPanel.stage.stageFocusRect = listChange = false;

		setListPanelBounds();

		listPanel.activate();
		listPanel.addEventListener(Event.CLOSE, listPanelClose);
		listPanel.addEventListener(Event.DEACTIVATE, appWinIN);
		listPanel.stage.addEventListener(KeyboardEvent.KEY_DOWN, KEY_DOWN);
		_lockfocus = false;
		try {
			stage.focus = this;
		} catch (e : Error) {
		}
	}

	private function refreshListMCItems() : void {
		var search : String = _showSearch ? ipt_search.label : "";
		var srch : String = search;
//		trace(listMC.name, _items.length, search, searchMatchCase, searchUsePinyin);
		listMC.visible = false;
		if(search != "") {
			search_items = Vector.<ComboBoxItem>([]);
			var search_py : String
			if(searchUsePinyin){
				search_py = PinYin2.toPinyin(srch);
			}
			for (var i:uint = 0; i < _items.length; i++) {
				var finded : Boolean = false;
				var lab : String = _items[i].label;
				if(lab.indexOf(srch) != -1){
					finded = true;
				}else if(!searchMatchCase) {
					if(lab.toLowerCase().indexOf(srch.toLowerCase()) != -1){
						finded = true;
					}
				}
				if(!finded && searchUsePinyin){
					lab = PinYin2.toPinyin(lab);
					if(lab.indexOf(search_py) != -1 || (!searchMatchCase && lab.toLowerCase().indexOf(search_py.toLowerCase()) != -1)){
						finded = true;
					}
				}
				if(!finded){
					continue;
				}
				search_items.push(_items[i]);
			}
		}else{
			search_items = _items;
		}
		listMC.addItems(search_items);
		var panelHgt : uint = listMC.height + listMC.y;
		var maxHgt : int = int(resolutionY / 48) * 24;
		if (panelHgt > maxHgt) {
			panelHgt = maxHgt;
		}
		listPanel.height = panelHgt;
		listMC.setSlider();
		listMC.changeSelection(_selection);
		setListPanelBounds();
		listMC.visible = true;
	}

	private function listPanelClose(evt : Event) : void {
		listPanel.removeEventListener(Event.CLOSE, listPanelClose);
		appWindow.removeEventListener(Event.ACTIVATE, appWinIN);
		listPanel.stage.removeEventListener(KeyboardEvent.KEY_DOWN, KEY_DOWN);
	}

	private function appWinIN(evt : Event) : void {
		try {
			listPanel.visible = false;
			listPanel.close();
		} catch (err : Error) {
		}
	}

	private function setListPanelBounds() : void {
		var tP : DisplayObjectContainer = this;
		listPanel.x = appWindow.x + this.x + 8 + mc.x;
		listPanel.y = appWindow.y + this.y + _sz[1] + 31 + mc.y;
		do {
			try {
				tP = tP.parent as DisplayObjectContainer;
				listPanel.x += tP.x;
				listPanel.y += tP.y;
			} catch (e : Error) {
				break;
			}
		} while (true);
		var halfHgt : uint = listPanel.height / 2;
		if (halfHgt > 400) {
			halfHgt = 400;
		} else if (halfHgt < 100) {
			halfHgt = 100;
		}
		if (resolutionY - listPanel.y < halfHgt) {
			listPanel.y -= listPanel.height + _sz[1];
		}
		listMC.setSlider();
	}

	public function get items() : Vector.<ComboBoxItem> {
		var newItems : Vector.<ComboBoxItem> = new Vector.<ComboBoxItem>();
		var newItem : ComboBoxItem;
		for (var i : uint = 0; i < _items.length; i++) {
			newItem = _items[i].copy();
			newItem.setId(i);
			newItems.push(newItem);
		}
		return newItems;
	}

	public function set items(arr : Vector.<ComboBoxItem>) : void {
		_items.length = 0;
		for each (var item : ComboBoxItem in arr) {
			addItem(item);
		}
		listChange = true;
	}

	public function addItem(item : ComboBoxItem) : void {
		item.setId(_items.length);
		_items.push(item);
		if (_items.length == 1) {
			selection = 0;
		}
	}

	public function addItemAt(item : ComboBoxItem, num : uint) : void {
		if(num > _items.length){
			addItem(item);
			return;
		}
		_items.splice(num, 0, item);
		for(var i : uint = num; i < _items.length; i++){
			_items[i].setId(i);
		}
		if (_items.length == 1) {
			selection = 0;
		}
	}

	public function get selection() : int {
		return _selection;
	}

	public function set selection(num : int) : void {
		if (_items.length == 0) {
			num = -1;
		} else if (_items.length - 1 < num) {
			num = _items.length - 1;
		}
		_selection = num;
		if (num != -1) {
			_label.text = _items[num].label;
		} else {
			_label.text = "";
		}
		try {
			listMC.changeSelection(num);
		} catch (err : Error) {
		}
		size = [];
		if(onChange != null){
			onChange();
		}
	}

	public function removeAll() : void {
		var oldSel : int = _selection;
		for(var i : uint = 0; i < _items.length; i++){
			delete(_items[i]);
		}
		_items.length = 0;
		label = '';
		_selection = -1;
		listChange = true;
		if (oldSel != _selection && onChange != null) {
			onChange();
		}
	}

	public function removeAt(num : uint) : void {
		_items.removeAt(num);
		if (_selection == num) {
			selection = 0;
		}
		listChange = true;
	}

	public function get item() : ComboBoxItem {
		if (_selection >= 0) {
			return _items[_selection];
		} else {
			return null;
		}
	}

	private function WHEEL(evt : MouseEvent) : void {
		if (evt.delta > 0) {
			selectionChange(false);
		} else {
			selectionChange(true);
		}
		try {
			listMC.moveSlider();
		} catch (err : Error) {
		}
	}

	private function KEY_DOWN(evt : KeyboardEvent) : void {
		_KeyboardEvent = evt;
		_keyDown();
	}

	private function selectionChange(boo : Boolean) : void {
		var _search : Boolean = false;
		if(_showSearch){
			var srch : String = ipt_search.label;
			if(srch != "") {
				_search = true;
				var searchItems : Vector.<uint> = Vector.<uint>([]);
				for (var i:uint = 0; i < search_items.length; i++) {
					searchItems.push(search_items[i].id);
				}
			}
		}
		var num : int;
		if(_search) {
			if(searchItems.length > 0){
				var _id : int = searchItems.indexOf(_selection);
				if(_id == -1){
					num = searchItems[0];
				} else {
					_id = boo ? _id + 1 : _id - 1;
					if(_id < 0){
						_id = isLoopList ? searchItems.length - 1 : 0;
					}else if (_id >= searchItems.length) {
						_id = isLoopList ? 0 : searchItems.length - 1;
					}
					num = searchItems[_id];
				}
			}else{
				return;
			}
		}else{
			num = boo ? _selection + 1 : _selection - 1;
		}
		if (num < 0) {
			num = isLoopList ? _items.length - 1 : 0;
		}else if (num >= _items.length) {
			num = isLoopList ? 0 : _items.length - 1;
		}
		selection = num;
	}

	public function get label() : String {
		return _label.text;
	}

	public function set label(lab : String) : void {
		_label.text = lab;
		size = [];
	}

	public function get bgColor() : Object {
		return "0x" + _bgColor.toString(16);
	}

	public function set bgColor(col : Object) : void {
		_bgColor = int(col);
		fill(mc.graphics, _sz[0], _sz[1], _bgColor);
		_overColor = bgColor2OverColor(_bgColor);
	}

	public function set canWheelChange(boo : Boolean) : void {
		_canWheelChange = boo;
		if (boo && _enabled) {
			_selMC.addEventListener(MouseEvent.MOUSE_WHEEL, WHEEL);
		} else {
			_selMC.removeEventListener(MouseEvent.MOUSE_WHEEL, WHEEL);
		}
	}

	public function set labelSpacing(n:uint):void{
		_label.x = _labelSpacing = n;
	}

	public function get labelSpacing():uint{
		return _labelSpacing;
	}

	public function get canWheelChange() : Boolean {
		return _canWheelChange;
	}

	public function set canSearch(boo : Boolean) : void {
		_canSearch = boo;
		if(ipt_search == null){
			ipt_search = new SearchBox();
			ipt_search.title = "";
			ipt_search.infoLabel = "搜索";
			ipt_search.showSearch = false;
			ipt_search.color = bgColorArr[1];
			ipt_search.bgColor = bgColorArr[9];
			ipt_search.clearBgColor = 0xDD9999;
			ipt_search.clearColor = bgColorArr[1];
			ipt_search.showFocus = false;
		}
	}

	public function get canSearch() : Boolean {
		return _canSearch;
	}
}
}
