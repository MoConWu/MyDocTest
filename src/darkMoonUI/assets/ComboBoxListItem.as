package darkMoonUI.assets {
import flash.display.Sprite;
import flash.display.NativeWindow;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextField;
import flash.display.Shape;

import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.controls.ComboBoxItem;

/** @private */
internal class ComboBoxListItem extends Sprite {
	public var
	ID : uint = new uint();
	private var
	_itemLabel : TextField = new TextField(),
	_selected : Boolean = false,
	_sz : Array = [100, 25],
	ttf : TextFormat = setTF(0),
	_item : ComboBoxItem = new ComboBoxItem();

	public function ComboBoxListItem() : void {
		_itemLabel.setTextFormat(ttf);
		_itemLabel.defaultTextFormat = ttf;
		_itemLabel.wordWrap = _itemLabel.selectable = false;

		addChild(_itemLabel);

		this.addEventListener(MouseEvent.MOUSE_OVER, OVER);
		this.addEventListener(MouseEvent.MOUSE_OUT, OUT);
		this.addEventListener(MouseEvent.MOUSE_DOWN, DOWN);
	}

	private function OVER(evt : MouseEvent) : void {
		if (!_selected) {
			fill(this.graphics, _sz[0], _sz[1], bgColorArr[6]);
		}
	}

	private function OUT(evt : MouseEvent) : void {
		if (!_selected) {
			fill(this.graphics, _sz[0], _sz[1], bgColorArr[9]);
		}
	}

	private function DOWN(evt : MouseEvent) : void {
		var appWinddow : NativeWindow = stage.nativeWindow;
		appWinddow.close();
		var cbList : ComboBoxList = super.parent.parent as ComboBoxList;
		cbList.setValue(ID);
	}

	public function set setSize(sz : Array) : void {
		_itemLabel.autoSize = TextFieldAutoSize.LEFT;
		var w : Number = Number(sz[0]) ? Number(sz[0]) : stage.stageWidth;
		_itemLabel.width = w;
		var h : Number = Number(sz[1]) ? Number(sz[1]) : _itemLabel.height > 20 ? _itemLabel.height : 20;
		_itemLabel.autoSize = TextFieldAutoSize.NONE;
		_itemLabel.width = w;
		_itemLabel.height = h;
		_sz[0] = w;
		_sz[1] = h;
		fill(this.graphics, w, h, bgColorArr[9]);
	}

	public function set selected(boo : Boolean) : void {
		if (_selected != boo) {
			fill(this.graphics, _sz[0], _sz[1], boo ? bgColorArr[7] : bgColorArr[9]);
		}
		_selected = boo;
	}

	public function set item(it : ComboBoxItem) : void {
		_item = it;
		_itemLabel.text = _item.label;
		try {
			ttf.font = _item.font;
		} catch (err : Error) {
		}
		ttf.size = _item.fontSize = _item.fontSize == 0 ? 1 : _item.fontSize;
		if (_item.fontSize > 0 && _item.fontSize != ttf.size) {
			ttf.size = uint(_item.fontSize);
		}
		if (_item.fontColor != null) {
			ttf.color = uint(_item.fontColor);
		}
		if (_item.bold) {
			ttf.bold = true;
		}
		if (_item.italic) {
			ttf.italic = true;
		}
		if (_item.wordWrap) {
			_itemLabel.multiline = _itemLabel.wordWrap = true;
		}
		_itemLabel.setTextFormat(ttf);
		_itemLabel.defaultTextFormat = ttf;
	}
}
}