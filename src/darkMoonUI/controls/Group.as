package darkMoonUI.controls {
import darkMoonUI.controls.Group;
import darkMoonUI.controls.group.GroupControlType;
import darkMoonUI.types.ControlType;
import darkMoonUI.controls.orientation.Orientation;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.controls.regPoint.RegPointAlign;
import darkMoonUI.controls.group.GroupAddObject;
import darkMoonUI.controls.group.GroupAttributesObject;

import flash.display.DisplayObjectContainer;
import flash.events.NativeWindowBoundsEvent;
import flash.display.Sprite;
import flash.events.Event;

/**
 * @author moconwu
 */
public class Group extends DarkMoonUIControl {
	private var
	_value : Vector.<DarkMoonUIControl> = Vector.<DarkMoonUIControl>([]),
	_stage : DisplayObjectContainer = null,
	_spacing : uint = 0,
	_orientation : String = Orientation.H;

	public function Group() {
		_type = ControlType.GROUP;
		_regPoint = RegPointAlign.LEFT_TOP.slice();
		addEventListener(Event.ADDED_TO_STAGE, ADDED);
	}
	/** @private */
	protected override function _enabled_set():void{
		for(var i : uint=0; i < _value.length; i++){
			_value[i].enabled = _enabled;
		}
	}
	/** @private */
	protected override function _tempEnabled_set():void{
		for(var i : uint = 0; i < _value.length; i++){
			_value[i].tempEnabled = _tempEnabled;
		}
	}

	private function ADDED(evt : Event) : void {
		_stage = this.parent as DisplayObjectContainer;
		stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, resize);
		stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, resize);
		removeEventListener(Event.ADDED_TO_STAGE, ADDED);
		addEventListener(Event.REMOVED_FROM_STAGE, REMOVED);
		refresh();
	}

	private function resize(evt:NativeWindowBoundsEvent):void{
		refresh();
	}

	private function REMOVED(evt : Event) : void {
		addEventListener(Event.ADDED_TO_STAGE, ADDED);
		removeEventListener(Event.REMOVED_FROM_STAGE, REMOVED);
		_stage = null;
	}

	public function refresh() : void {
		if (_stage == null) {
			return;
		}
		for (var i : uint = 0; i < _value.length; i++) {
			createOne(i);
		}
	}

	protected override function _size_set() : void {
		refresh();
	}

	protected override function _size_get() : Array {
		var _w : int = 0;
		var _h : int = 0;
		var sz : Array;
		for(var i : uint = 0; i < _value.length; i++){
			sz = _value[i].size;
			_w = Math.max(_w, sz[0]);
			_h = Math.max(_h, sz[1]);
		}
		return [_w, _h];
	}

	private function createOne(i : uint) : void {
		if (_orientation == Orientation.H) {
			_value[i].y = y;
			_value[i].x = x;
			if (i > 0) {
				_value[i].x = _value[i - 1].x + _value[i - 1].size[0] + _spacing;
			}
		} else {
			_value[i].x = x;
			_value[i].y = y;
			if (i > 0) {
				_value[i].y = _value[i - 1].y + _value[i - 1].size[1] + _spacing;
			}
		}
		if (rotationX != 0) {
			_value[i].rotationX = rotationX;
		}
		if (rotationY != 0) {
			_value[i].rotationY = rotationY;
		}
		if (rotationZ != 0) {
			_value[i].rotationZ = rotationZ;
		}
		if (z != 0) {
			_value[i].z = z;
		}
		if(_value[i] is Group){
			_value[i]["refresh"]();
		}
		if(_stage != null && _value[i].stage != _stage) {
			_stage.addChild(_value[i]);
		}
	}

	private function remove() : void {
		if (_stage != null) {
			for (var i : uint = 0; i < _value.length; i++) {
				try {
					_stage.removeChild(_value[i]);
				} catch (e : Error) {
				}
			}
			refresh();
		}
	}

	public function set orientation(ori : String) : void {
		ori = ori == Orientation.H || ori == Orientation.V ? ori : _orientation;
		if(_orientation == ori){
			return
		}
		_orientation = ori;
		refresh();
	}

	public function get orientation() : String {
		return _orientation;
	}

	public function get spacing() : uint {
		return _spacing;
	}

	public function set spacing(spc : uint) : void {
		_spacing = spc;
		refresh();
	}

	public function get controls() : Vector.<DarkMoonUIControl> {
		return _value;
	}

	public function set controls(val : Vector.<DarkMoonUIControl>) : void {
		remove();
		_value = Vector.<DarkMoonUIControl>([]);
		for (var i : uint = 0; i < val.length; i++) {
			_value.push(val[i]);
		}
		refresh();
	}

	public function add(_typ : String, leng : uint = 1, w : uint = 0, h : uint = 0) : * {
		if(_typ == null){
			return null;
		}
		switch (leng) {
			case 0:
				return null;
			case 1:
				return addOneDMUIControl(_typ, w, h);
			default:
				var DMUIList : *;
				switch (_typ.toLowerCase()) {
					case GroupControlType.ANGLE:
						DMUIList = Vector.<Angle>([]);
						break;
					case GroupControlType.BUTTON:
						DMUIList = Vector.<Button>([]);
						break;
					case GroupControlType.CHECK_BOX:
						DMUIList = Vector.<CheckBox>([]);
						break;
					case GroupControlType.COLOR_PICKER:
						DMUIList = Vector.<ColorPicker>([]);
						break;
					case GroupControlType.COMBO_BOX:
						DMUIList = Vector.<ComboBox>([]);
						break;
					case GroupControlType.DATE_PICKER:
						DMUIList = Vector.<DatePicker>([]);
						break;
					case GroupControlType.FONT_COMBO_BOX:
						DMUIList = Vector.<FontComboBox>([]);
						break;
					case GroupControlType.ICON_BUTTON:
						DMUIList = Vector.<IconButton>([]);
						break;
					case GroupControlType.IMAGE:
						DMUIList = Vector.<Image>([]);
						break;
					case GroupControlType.IMAGE_PANEL:
						DMUIList = Vector.<ImagePanel>([]);
						break;
					case GroupControlType.INPUT_NUMBER:
						DMUIList = Vector.<InputNumber>([]);
						break;
					case GroupControlType.INPUT_TEXT:
						DMUIList = Vector.<InputText>([]);
						break;
					case GroupControlType.LABEL:
						DMUIList = Vector.<Label>([]);
						break;
					case GroupControlType.SIMPLE_LABEL:
						DMUIList = Vector.<SimpleLabel>([]);
						break;
					case GroupControlType.LIST_BOX:
						DMUIList = Vector.<ListBox>([]);
						break;
					case GroupControlType.GRID_BOX:
						DMUIList = Vector.<GridBox>([]);
						break;
					case GroupControlType.PROGRESS_BAR:
						DMUIList = Vector.<ProgressBar>([]);
						break;
					case GroupControlType.RADIO_BUTTON:
						DMUIList = Vector.<RadioButton>([]);
						break;
					case GroupControlType.SCROLL_BAR:
						DMUIList = Vector.<ScrollBar>([]);
						break;
					case GroupControlType.SEARCH_BOX:
						DMUIList = Vector.<SearchBox>([]);
						break;
					case GroupControlType.SLIDER:
						DMUIList = Vector.<Slider>([]);
						break;
					case GroupControlType.SWITCH_BUTTON:
						DMUIList = Vector.<SwitchButton>([]);
						break;
					case GroupControlType.TAB_WIDGET:
						DMUIList = Vector.<TabWidget>([]);
						break;
					case GroupControlType.TREE_BOX:
						DMUIList = Vector.<TreeBox>([]);
						break;
					case GroupControlType.VIDEO_PLAYER:
						DMUIList = Vector.<VideoPlayer>([]);
						break;
					case GroupControlType.GROUP:
						DMUIList = Vector.<Group>([]);
						break;
					default:
						DMUIList = null;
				}
				if (DMUIList == null) {
					return null;
				}
				for (var i : uint = 0; i < leng; i++) {
					DMUIList.push(addOneDMUIControl(_typ, w, h));
				}
				refresh();
				return DMUIList;
		}
	}

	public function set addSetting(obj : GroupAddObject) : void {
		if(obj == null){
			return;
		}
		add(obj.type, obj.length, obj.width, obj.height);
	}

	private function addOneDMUIControl(_typ : String, w : uint = 0, h : uint = 0) : * {
		var newDMUI : DarkMoonUIControl;
		switch (_typ.toLowerCase()) {
			case GroupControlType.ANGLE:
				newDMUI = new Angle();
				break;
			case GroupControlType.BUTTON:
				newDMUI = new Button();
				break;
			case GroupControlType.CHECK_BOX:
				newDMUI = new CheckBox();
				break;
			case GroupControlType.COLOR_PICKER:
				newDMUI = new ColorPicker();
				break;
			case GroupControlType.COMBO_BOX:
				newDMUI = new ComboBox();
				break;
			case GroupControlType.DATE_PICKER:
				newDMUI = new DatePicker();
				break;
			case GroupControlType.FONT_COMBO_BOX:
				newDMUI = new FontComboBox();
				break;
			case GroupControlType.ICON_BUTTON:
				newDMUI = new IconButton();
				break;
			case GroupControlType.IMAGE:
				newDMUI = new Image();
				break;
			case GroupControlType.IMAGE_PANEL:
				newDMUI = new ImagePanel();
				break;
			case GroupControlType.INPUT_NUMBER:
				newDMUI = new InputNumber();
				break;
			case GroupControlType.INPUT_TEXT:
				newDMUI = new InputText();
				break;
			case GroupControlType.LABEL:
				newDMUI = new Label();
				break;
			case GroupControlType.SIMPLE_LABEL:
				newDMUI = new SimpleLabel();
				break;
			case GroupControlType.LIST_BOX:
				newDMUI = new ListBox();
				break;
			case GroupControlType.GRID_BOX:
				newDMUI = new GridBox();
				break;
			case GroupControlType.PROGRESS_BAR:
				newDMUI = new ProgressBar();
				break;
			case GroupControlType.RADIO_BUTTON:
				newDMUI = new RadioButton();
				break;
			case GroupControlType.SCROLL_BAR:
				newDMUI = new ScrollBar();
				break;
			case GroupControlType.SEARCH_BOX:
				newDMUI = new SearchBox();
				break;
			case GroupControlType.SLIDER:
				newDMUI = new Slider();
				break;
			case GroupControlType.SWITCH_BUTTON:
				newDMUI = new SwitchButton();
				break;
			case GroupControlType.TAB_WIDGET:
				newDMUI = new TabWidget();
				break;
			case GroupControlType.TREE_BOX:
				newDMUI = new TreeBox();
				break;
			case GroupControlType.VIDEO_PLAYER:
				newDMUI = new VideoPlayer();
				break;
			case GroupControlType.GROUP:
				newDMUI = new Group();
				break;
			default:
				newDMUI = null;
		}
		if (newDMUI == null) {
			return null;
		}
		newDMUI.regPoint = _regPoint;
		newDMUI.size = [w, h];
		_value.push(newDMUI);
		if (_stage != null) {
			var i : uint = _value.length - 1;
			createOne(i);
		}
		return newDMUI;
	}

	public function setAttributes(name : String, val : *, all : Boolean = true, start : uint = 0, end : uint = 0) : Array {
		if(name == null){
			return null;
		}
		var _results : Array = [];
		end = end == 0 ? 0 : end < start ? start : end;
		var leng : uint = end == 0 || end > _value.length ? _value.length : end;
		for (var i : uint = start; i < leng + start; i++) {
			if (all) {
				_results.push(setAttributeAt(i, name, val));
			} else if (val is Array || val is Vector) {
				var k : uint = i - start;
				if (k >= val["length"]) {
					break;
				}
				_results.push(setAttributeAt(i, name, val[k]));
			} else {
				break;
			}
		}
		refresh();
		return _results;
	}

	public function getAttributes(name : String, start : uint = 0, end : uint = 0) : Array {
		var _attr : Array = [];
		end = end == 0 ? 0 : end < start ? start : end;
		var leng : uint = end == 0 || end > _value.length ? _value.length : end;
		for (var i : uint = start; i < leng + start; i++) {
			_attr.push(getAttributeAt(i, name));
		}
		return _attr;
	}

	public function getAttributeAt(id : uint, name : String) : * {
		var obj : Object = _value[id];
		if (name in obj) {
			return obj[name];
		} else {
			return undefined;
		}
	}

	public function setAttributeAt(id : uint, name : String, val : *) : uint {
		var _results : uint;
		var obj : Object = _value[id];
		if (name in obj) {
			try {
				obj[name] = val;
				_results = 1;
			} catch (e : Error) {
				_results = 0;
			}
		} else {
			_results = 0;
		}
		return _results;
	}

	public function set attributes(obj: GroupAttributesObject) : void {
		if(obj == null){
			return;
		}
		setAttributes(obj.name, obj.value, obj.isAll, obj.start, obj.end);
	}
}
}
