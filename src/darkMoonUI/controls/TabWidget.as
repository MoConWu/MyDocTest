package darkMoonUI.controls {
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.display.Sprite;
import flash.display.Shape;

import darkMoonUI.types.ControlType;
import darkMoonUI.functions.parentAddChilds;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.interfaces.DMUI_PUB_TAB;

/**
 * @author moconwu
 */
public class TabWidget extends DarkMoonUIControl implements DMUI_PUB_TAB {
	public var onChange : Function;
	private var
	_bg : Shape = new Shape(),
	_head : Sprite = new Sprite(),
	_ctlsMask : Shape = new Shape(),
	_headMask : Shape = new Shape(),
	_tabItems : Vector.<TabItem> = Vector.<TabItem>([]),
	_ctls : Sprite = new Sprite(),
	_idList : Vector.<uint> = Vector.<uint>([]),
	_labSize : uint = 12,
	_tabID : int = -1,
	_moreBtn : ComboBox = new ComboBox();

	public function TabWidget() {
		super();
		_type = ControlType.TAB_WIDGET;

		_alpha = 1.0;

		fill(_bg.graphics, 10, 10, bgColorArr[3], bgColorArr[4]);
		fill(_headMask.graphics);
		fill(_ctlsMask.graphics);

		_ctls.mask = _ctlsMask;
		_head.mask = _headMask;
		_moreBtn.label = "";
		_moreBtn.showFocus = _moreBtn.visible = false;
		_moreBtn.onChange = function() : void {
			_moreBtn.label = '';
			setTabID(_moreBtn.selection);
		};

		parentAddChilds(mc, Vector.<DisplayObject>([
			_bg, _ctls, _ctlsMask, _head, _headMask, _moreBtn
		]));

		tabEnabled = false;
		create();
	}

	public function create(_x : uint = 0, _y : uint = 0, __tabItems : Vector.<TabItem>=null, _w : uint = 200, _h : uint = 150) : void {
		x = _x;
		y = _y;

		size = [_w, _h];

		tabItems = __tabItems;

		enabled = _enabled;
	}
	/** @private */
	protected override function _size_get() : Array {
		return [_bg.width, _bg.height + _head.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		var w : uint = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _bg.width;
		var h : uint = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _bg.height + _head.height;
		var _headHgt : uint = 0;
		_idList = Vector.<uint>([]);
		var _hL : headLabel = null;
		if (_tabItems.length > 0) {
			var k : uint = 0;
			for (var i : uint = 0; i < _tabItems.length; i++) {
				var labH : headLabel = _head.getChildAt(k) as headLabel;
				labH.set(i, k, _tabItems[i].label, _labSize, _tabItems[i].labelColor, _tabItems[i].backgroundColor);
				if (k > 0) {
					var last : headLabel = _head.getChildAt(k - 1) as headLabel;
					labH.x = last.x + last.width;
				}
				if (_tabItems.length == 1) {
					labH.size(w);
				}
				if (!_tabItems[i].enabled || _tabItems[i].tempEnabled) {
					labH.alpha = .6;
				} else {
					labH.alpha = 1;
				}
				if (labH.selected) {
					_hL = labH;
				}
				k++;
			}
			_headHgt = _head.height;
		}
		_headMask.width = w + 1;
		_moreBtn.x = w - 35;
		_moreBtn.visible = !(_tabItems.length <= 1 || _head.width <= _headMask.width);
		_headMask.width = w + 1 - uint(_moreBtn.visible) * 35;
		_ctlsMask.width = _bg.width = w;
		_ctlsMask.height = _bg.height = h - _headHgt;
		if (_hL != null) {
			if (_head.x + _hL.x + _hL.width > _headMask.width) {
				_head.x = _headMask.width - _hL.x - _hL.width;
			}
			if (_hL.x + _head.x < 0) {
				_head.x = 0 - _hL.x;
			}
		}
		if (_head.width + _head.x <= _headMask.width) {
			var _x : int = _headMask.width - _head.width;
			if (_x > 0) {
				_x = 0;
			}
			_head.x = _x;
		}
		if (_head.x > 0) {
			_head.x = 0;
		}
		_SizeValue = Vector.<uint>([_bg.width, _bg.height + _head.height]);
	}
	/** @private */
	protected override function _enabled_set() : void {
		tabEnabled = false;
		_moreBtn.enabled = _enabled;
		if (_enabled) {
			_head.alpha = 1.0;
			_head.addEventListener(MouseEvent.MOUSE_WHEEL, headWheel);
		} else {
			_head.alpha = .6;
			_head.removeEventListener(MouseEvent.MOUSE_WHEEL, headWheel);
		}
		for (var i : uint = 0; i < _tabItems.length; i++) {
			_tabItems[i].enabled = _tabItems[i].enabled;
		}
	}
	/** @private */
	protected override function _tempEnabled_set() : void {
		for (var i : uint = 0; i < _tabItems.length; i++) {
			_tabItems[i].tempEnabled = _tempEnabled;
		}
	}
	/** @private */
	protected override function _mouseOver() : void {
		_lockfocus = true;
	}
	/** @private */
	protected override function _mouseOut() : void {
		_lockfocus = false;
	}

	public function get tabID() : int {
		return _tabID;
	}

	public function set tabID(num : int) : void {
		if (num >= 0) {
			if (num < _tabItems.length) {
				if (_tabItems[num].enabled) {
					if (_tabItems.length > 0) {
						if (num < 0) {
							num = 0;
						} else if (num >= _tabItems.length) {
							num = _tabItems.length - 1;
						}
						_moreBtn.selection = num;
					} else {
						_moreBtn.selection = -1;
					}
				}
			}
		}
	}

	private function headWheel(evt : MouseEvent) : void {
		tabID = tabID - evt.delta / 3;
	}

	private function setTabID(num : int) : void {
		var leng : uint = _tabItems.length;
		if (leng > 0 && num < 0) {
			num = 0;
		}
		for (var i : uint = 0; i < _head.numChildren; i++) {
			var _hL : headLabel = _head.getChildAt(i) as headLabel;
			if (i != num) {
				_hL.selected = false;
			} else {
				_hL.selected = true;
				if (_tabID != num) {
					setIndexId(_hL.id);
					var col : uint = int(_tabItems[i].backgroundColor);
					if (_tabItems[i].backgroundColor == null) {
						fill(_bg.graphics, 10, 10, bgColorArr[3], bgColorArr[4]);
					} else {
						fill(_bg.graphics, 10, 10, col, bgColorArr[4]);
					}
				}
				if (_head.x + _hL.x + _hL.width > _headMask.width) {
					_head.x = _headMask.width - _hL.x - _hL.width;
				}
				if (_hL.x + _head.x < 0) {
					_head.x = 0 - _hL.x;
				}
				if (_head.x > 0) {
					_head.x = 0;
				}
			}
		}
		if (_tabID != num) {
			_tabID = num;
			if (onChange != null) {
				onChange();
			}
		}
	}

	private function setIndexId(_id : uint) : void {
		for (var i : int = 0; i < uint(_ctls.numChildren); i++) {
			var ct : DarkMoonUIControl = _ctls.getChildAt(i) as DarkMoonUIControl;
			ct.lock = true;
		}
		_ctls.removeChildren();
		if (_id < _tabItems.length) {
			var ctrs : Vector.<DarkMoonUIControl> = _tabItems[_id].controls;
			for (i = 0; i < ctrs.length; i++) {
				_ctls.addChild(ctrs[i]);
				ctrs[i].lock = false;
			}
		}
	}

	public function set tabItems(tabs : Vector.<TabItem>) : void {
		_tabItems = Vector.<TabItem>([]);
		if (tabs != null) {
			for (var i : uint = 0; i < tabs.length; i++) {
				tabs[i].parent = this;
				_tabItems.push(tabs[i]);
			}
		}
		refresh_head();
		size = [];
	}

	public function get tabItems() : Vector.<TabItem> {
		return _tabItems;
	}

	public function getTabAt(num : uint) : TabItem {
		if (num < _tabItems.length) {
			return _tabItems[num];
		} else {
			return undefined;
		}
	}

	public function setTabAt(item : TabItem, num : uint) : void {
		item.setParent(this);
		_tabItems[num] = item;
		refresh_head();
		size = [];
	}

	public function addTab(tab : TabItem) : void {
		if (_tabItems == null) {
			_tabItems = Vector.<TabItem>([]);
		}
		tab.setParent(this);
		_tabItems.push(tab);
		refresh_head();
		size = [];
	}

	public function refreshColor() : void {
		fill(_bg.graphics, 10, 10, uint(tabItems[tabID].backgroundColor), bgColorArr[4]);
	}

	private function refresh_head() : void {
		_head.removeChildren();
		_moreBtn.removeAll();
		var k : uint = 0;
		for (var i : uint = 0; i < _tabItems.length; i++) {
			var labH : headLabel = new headLabel();
			labH.set(i, k, _tabItems[i].label, _labSize, _tabItems[i].labelColor, _tabItems[i].backgroundColor);
			labH.onClick = function(index : uint) : void {
				tabID = index;
			};
			_head.addChild(labH);
			var item : ComboBoxItem = new ComboBoxItem();
			item.label = _tabItems[i].label;
			_moreBtn.addItem(item);
		}
		_moreBtn.size = [35, _head.height];
		_headMask.height = _head.height;
		_ctlsMask.y = _bg.y = _head.height - 1;
	}

	public function removeTab(tab : TabItem) : void {
		for (var i : uint = 0; i < _tabItems.length; i++) {
			if (_tabItems[i] == tab) {
				tab.setParent(null);
				_tabItems.removeAt(i);
				refresh_head();
				size = [];
				return;
			}
		}
	}

	public function removeTabAt(num : uint) : void {
		if (num < _tabItems.length) {
			_tabItems[num].setParent(null);
			_tabItems.removeAt(num);
			size = [];
		}
	}

	public function addTabAt(tab : TabItem, num : uint) : void {
		removeTab(tab);
		if (num < _tabItems.length) {
			_tabItems.splice(num, 0, tab);
		} else {
			addTab(tab);
		}
		size = [];
	}
}
}

import flash.events.MouseEvent;
import flash.display.Graphics;
import flash.text.TextFormat;
import flash.text.TextField;
import flash.display.Shape;
import flash.display.Sprite;

import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;


class headLabel extends Sprite {
public var onClick : Function;
public var id : uint = 0;

private var
_tf : TextFormat = setTF(textColorArr[4]),
_label : TextField = new TextField(),
_sz : Array = [100, 25],
_bgColor : Object = bgColorArr[3],
_labColor : Object = textColorArr[2],
_fill : Boolean = false,
_selected : Boolean = false,
grap : Graphics = this.graphics;

public function headLabel() {
	fill(grap, _sz[0], _sz[1], bgColorArr[4]);
	_label.selectable = _label.wordWrap = _label.multiline = false;
	_label.autoSize = "left";
	_label.x = 7;
	_label.y = 4;
	addChild(_label);
	addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
}

private function mouseDown(evt : MouseEvent) : void {
	if(onClick != null){
		onClick(id);
	}
}

public function set(_id : uint, _index : uint, lab : String, size : uint = 12, labCol : Object = null, bgCol : Object = null) : void {
	id = _id;
	id = _index;
	_tf.size = size;
	_labColor = labCol;
	_bgColor = bgCol;
	_label.text = lab;
	selected = _selected;
}

public function size(leng : uint) : void {
	_fill = true;
	_sz[0] = leng;
	fill(grap, _sz[0], _sz[1], bgColorArr[4]);
}

public function set selected(boo : Boolean) : void {
	_selected = boo;
	if (!_fill) {
		_sz[0] = _label.width + 14;
	}
	_sz[1] = _label.height + 8;
	if (boo) {
		_tf.color = _labColor;
		fill(grap, _sz[0], _sz[1], uint(_bgColor), bgColorArr[4]);
	} else {
		_tf.color = textColorArr[4];
		fill(grap, _sz[0], _sz[1], bgColorArr[4]);
	}
	_label.defaultTextFormat = _tf;
	_label.setTextFormat(_tf);
}

public function get selected() : Boolean {
	return _selected;
}
}
