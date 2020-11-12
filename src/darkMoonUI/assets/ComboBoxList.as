package darkMoonUI.assets {
import flash.events.MouseEvent;
import flash.display.Sprite;

import darkMoonUI.controls.ComboBoxItem;
import darkMoonUI.assets.ComboBoxListItem;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;

/** @private */
public class ComboBoxList extends Sprite {
	public var
	_selection : uint = 0,
	onSelect : Function,
	list : Sprite = new Sprite();
	private var
	item : ComboBoxListItem,
	slider : Sprite = new Sprite(),
	_y : int = new int(),
	hideW : uint = 5,
	stgH : uint,
	showW : uint = 10;

	public function ComboBoxList() : void {
		super();
		slider.visible = false;
		fill(slider.graphics, hideW, 20, bgColorArr[2]);
		slider.addEventListener(MouseEvent.MOUSE_OUT, OUT);
		slider.addEventListener(MouseEvent.MOUSE_OVER, OVER);
		slider.addEventListener(MouseEvent.MOUSE_DOWN, DOWN);
		slider.addEventListener(MouseEvent.MOUSE_MOVE, OVER);
		addChild(list);
		addChild(slider);
	}

	public function setSlider() : void {
		stgH = stage.stageHeight - this.y;
		if (list.height <= stgH) {
			slider.visible = false;
			return;
		}
		this.addEventListener(MouseEvent.MOUSE_WHEEL, WHEEL);
		slider.height = stgH / list.height * stgH;
		if (slider.height < 20) {
			slider.height = 20;
		}
		slider.visible = true;
		slider.x = stage.stageWidth - slider.width;
		moveSlider();
	}

	public function moveSlider() : void {
		slider.y = - list.y / (list.height - stgH ) * (stgH - slider.height);
		checkSlider();
	}

	private function OVER(evt : MouseEvent) : void {
		slider.width = showW;
		slider.x = stage.stageWidth - showW;
	}

	private function OUT(evt : MouseEvent) : void {
		slider.width = hideW;
		slider.x = stage.stageWidth - hideW;
	}

	private function DOWN(evt : MouseEvent) : void {
		_y = this.mouseY - slider.y;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, MOVE);
		stage.addEventListener(MouseEvent.MOUSE_UP, UP);
		slider.removeEventListener(MouseEvent.MOUSE_OUT, OUT);
	}

	private function MOVE(evt : MouseEvent) : void {
		slider.y = mouseY - _y;
		checkSlider();
		list.y = Math.round(-slider.y / (stgH - slider.height) * (list.height - stgH ));
		evt.updateAfterEvent();
	}

	private function UP(evt : MouseEvent) : void {
		slider.width = hideW;
		slider.x = stage.stageWidth - hideW;
		slider.addEventListener(MouseEvent.MOUSE_OUT, OUT);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, MOVE);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, UP);
	}

	private function checkSlider() : void {
		if (slider.y < 0) {
			slider.y = 0;
		} else if (slider.y + slider.height > stgH) {
			slider.y = stgH - slider.height;
		}
	}

	public function addItems(allItems : Vector.<ComboBoxItem>) : void {
		list.y = 0;
		list.removeChildren();
		for (var i : uint = 0; i < allItems.length; i++) {
			item = new ComboBoxListItem();
			item.item = allItems[i];
			item.setSize = [stage.stageWidth];
			item.y = list.height;
			item.ID = allItems[i].id;
			list.addChild(item);
		}
	}

	public function changeSelection(num : uint) : void {
		var sel : int = -1;
		for (var i : uint = 0; i < Number(list.numChildren); i++) {
			var item : ComboBoxListItem = list.getChildAt(i) as ComboBoxListItem;
			if(item.ID == num){
				sel = i;
				item.selected = true;
			}else{
				item.selected = false;
			}
		}
		if(sel != -1) {
			var selItem:Sprite = list.getChildAt(sel) as Sprite;
			var getY:int = selItem.y + list.y;
			if (getY >= stgH - selItem.height / 2) {
				list.y = -selItem.y;
			} else if (getY < 0) {
				list.y = stgH - selItem.y - selItem.height;
			}
		}
		checkList();
		moveSlider();
	}

	private function WHEEL(evt : MouseEvent) : void {
		list.y += evt.delta * 8;
		checkList();
		moveSlider();
	}

	private function checkList() : void {
		if (list.y > 0 || list.height <= stgH) {
			list.y = 0;
		} else if (list.height + list.y < stgH) {
			list.y = stgH - list.height;
		}
	}

	public function setValue(num : uint) : void {
		_selection = num;
		if(onSelect != null){
			onSelect();
		}
	}
}
}