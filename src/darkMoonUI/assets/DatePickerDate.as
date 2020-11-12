package darkMoonUI.assets {
import flash.display.Sprite;
import flash.events.MouseEvent;

import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.setTF;

import flash.text.TextFormat;

import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;

import flash.text.TextField;
import flash.display.Shape;

/** @private */
public class DatePickerDate extends Sprite {
	public var
	onClick : Function,
	date : uint = 1;
	private var
	bgMC : Shape = new Shape(),
	_ttf : TextFormat = setTF(textColorArr[5], "left"),
	_label : TextField = new TextField(),
	overMC : Shape = new Shape(),
	selMC : Shape = new Shape(),
	borderMC : Shape = new Shape(),
	_enabled : Boolean = true,
	_bgBorder : Shape = new Shape();

	public function DatePickerDate() {
		fill(bgMC.graphics, 25, 25, bgColorArr[9]);
		fill(overMC.graphics, 25, 25, bgColorArr[6]);
		fill(selMC.graphics, 25, 25, bgColorArr[7]);
		fill(borderMC.graphics, 25, 25, -1, bgColorArr[5], 2);
		fill(_bgBorder.graphics, 25, 25, -1, bgColorArr[7], 0);
		borderMC.alpha = .5;

		overMC.visible = selMC.visible = borderMC.visible = _bgBorder.visible = _label.wordWrap = _label.selectable = _label.multiline = false;
		_label.setTextFormat(_ttf);
		_label.defaultTextFormat = _ttf;
		_label.autoSize = "left";

		_label.width = _label.height = 25;

		addChild(bgMC);
		addChild(overMC);
		addChild(selMC);
		addChild(_bgBorder);
		addChild(borderMC);
		addChild(_label);

		enabled = true;
	}

	public function set bgBorder(boo : Boolean) : void {
		_bgBorder.visible = boo;
	}

	public function get bgBorder() : Boolean {
		return _bgBorder.visible;
	}

	public function set selected(boo : Boolean) : void {
		selMC.visible = boo;
	}

	public function get selected() : Boolean {
		return selMC.visible;
	}

	public function set border(boo : Boolean) : void {
		borderMC.visible = boo;
	}

	public function get border() : Boolean {
		return borderMC.visible;
	}

	public function set enabled(bo : Boolean) : void {
		_enabled = bo;
		if (bo) {
			alpha = 1.0;
			addEventListener(MouseEvent.MOUSE_DOWN, DOWN);
			addEventListener(MouseEvent.MOUSE_UP, UP);
			addEventListener(MouseEvent.MOUSE_OVER, OVER);
			addEventListener(MouseEvent.MOUSE_OUT, OUT);
		} else {
			alpha = .33;
			removeEventListener(MouseEvent.MOUSE_DOWN, DOWN);
			removeEventListener(MouseEvent.MOUSE_UP, UP);
			removeEventListener(MouseEvent.MOUSE_OVER, OVER);
			removeEventListener(MouseEvent.MOUSE_OUT, OUT);
		}
	}

	public function get enabled() : Boolean {
		return _enabled;
	}

	public function DOWN(evt : MouseEvent) : void {
		if(onClick != null){
			onClick(evt);
		}
	}

	public function UP(evt : MouseEvent) : void {
	}

	public function OVER(evt : MouseEvent) : void {
		overMC.visible = true;
	}

	public function OUT(evt : MouseEvent) : void {
		overMC.visible = false;
	}

	public function set label(lab : String) : void {
		_label.text = lab;
	}

	public function get label() : String {
		return _label.text;
	}

	public function set size(sz : Array) : void {
		_bgBorder.width = selMC.width = overMC.width = _label.width = bgMC.width = int(sz[0]) > 0 ? uint(sz[0]) : bgMC.width;
		_bgBorder.height = selMC.height = overMC.height = _label.height = bgMC.height = int(sz[1]) > 0 ? uint(sz[1]) : bgMC.height;
		fill(borderMC.graphics, bgMC.width, bgMC.height, -1, bgColorArr[5], 2);
		_label.x = (bgMC.width - _label.width) / 2;
		_label.y = (bgMC.height - _label.height) / 2;
	}

	public function get size() : Array {
		return [bgMC.width, bgMC.height];
	}
}
}