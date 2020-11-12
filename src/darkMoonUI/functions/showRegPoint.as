package darkMoonUI.functions {
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.events.NativeWindowBoundsEvent;
import flash.ui.Mouse;
import flash.utils.Timer;

import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.functions.fill_circle;

/**
 * @author moconwu
 */
public function showRegPoint(obj : Object) : void {
	if (obj is DarkMoonUIControl) {
		var timer : Timer = new Timer(1000);
		var point : Sprite = new Sprite();
		var box : Shape = new Shape();
		fill_circle(point.graphics, 4, 0xFF5555, 0, 0);

		var obj0 : DarkMoonUIControl = obj as DarkMoonUIControl;

		var size : Array = obj0.size;
		var w : uint = size[0] > 0 ? size[0] : 1;
		var h : uint = size[1] > 0 ? size[1] : 1;

		box.graphics.lineStyle(0, 0x55FF55, 0.4);
		box.graphics.lineTo(w, 0);
		box.graphics.lineTo(w, h);
		box.graphics.lineTo(0, h);
		box.graphics.lineTo(0, 0);
		box.graphics.lineTo(w, h);
		box.graphics.lineTo(w, 0);
		box.graphics.lineTo(0, h);

		var p : * = obj.parent as Sprite==null ? obj.stage as Stage : obj.parent as Sprite;
		var all : RegPointBox = new RegPointBox();
		all.addChild(box);
		all.addChild(point);
		p.addChild(all);

		reSizing();

		obj0.onResizing = function() : void {
			reSizing();
		};

		obj0.onFocusChange = function() : void {
			point.visible = box.visible = !obj0.focus;
		};

		point.addEventListener(MouseEvent.MOUSE_DOWN, startPoint);
		point.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, midDownPoint);
		point.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, hidPoint);
		point.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, showPoint);
		point.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, reSizing);
		point.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, reSizing);

		function hidPoint(evt : MouseEvent) : void {
			point.visible = box.visible = false;
		}
		function showPoint(evt : MouseEvent) : void {
			point.visible = box.visible = true;
		}

		function midDownPoint(evt : MouseEvent) : void {
			point.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, midUpPoint);
			point.stage.addEventListener(MouseEvent.MOUSE_MOVE, midMovePoint);
			obj0.focus = true;
			obj0.startDrag();
			point.visible = box.visible = false;
			Mouse.hide();
		}
		function midMovePoint(evt : MouseEvent) : void {
			if (!evt.buttonDown) {
				midUpPoint(evt);
			}
		}
		function midUpPoint(evt : MouseEvent) : void {
			point.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, midUpPoint);
			point.stage.removeEventListener(MouseEvent.MOUSE_MOVE, midMovePoint);
			obj0.stopDrag();
			point.visible = box.visible = true;
			reSizing();
			Mouse.show();
			trace("----------\n" + obj0, obj0.name + "\n[POINT]", point.x, point.y + "  [SIZE]", obj0.size);
		}

		function startPoint(evt : MouseEvent) : void {
			point.stage.addEventListener(MouseEvent.MOUSE_UP, stopPoint);
			point.startDrag();
		}

		function stopPoint(evt : MouseEvent) : void {
			point.stopDrag();
			point.stage.removeEventListener(MouseEvent.MOUSE_UP, stopPoint);
			if (gridSpacing != 0) {
				point.x = Math.round(point.x / gridSpacing) * gridSpacing;
				point.y = Math.round(point.y / gridSpacing) * gridSpacing;
			}

			var _x0 : Array = [Math.abs(box.x - point.x), "left"];
			var _x1 : Array = [Math.abs(box.x + box.width / 2 - point.x), "center"];
			var _x2 : Array = [Math.abs(box.x + box.width - point.x), "right"];
			var _y0 : Array = [Math.abs(box.y - point.y), "top"];
			var _y1 : Array = [Math.abs(box.y + box.height / 2 - point.y), "center"];
			var _y2 : Array = [Math.abs(box.y + box.height - point.y), "bottom"];

			var _x : Array,_y : Array;
			if (_x0[0] > _x1[0]) {
				_x = _x1;
			} else {
				_x = _x0;
			}
			if (_x[0] > _x2[0]) {
				_x = _x2;
			}
			if (_y0[0] > _y1[0]) {
				_y = _y1;
			} else {
				_y = _y0;
			}
			if (_y[0] > _y2[0]) {
				_y = _y2;
			}
			obj0.x = point.x;
			obj0.y = point.y;
			obj0.regPoint = [_x[1], _y[1]];
			trace("----------\n" + obj0, obj0.name + "\n[POINT]", point.x, point.y + "  [SIZE]", obj0.size);
		}

		function reSizing(...args) : void {
			if (gridSpacing != 0) {
				point.x = obj.x = Math.round(obj.x / gridSpacing) * gridSpacing;
				point.y = obj.y = Math.round(obj.y / gridSpacing) * gridSpacing;
			} else {
				point.x = obj.x;
				point.y = obj.y;
			}
			var regPoint : Array = ["left", "top"];
			try {
				regPoint = obj0.regPoint;
			} catch (err : Error) {
			}

			var w : uint = obj0.size[0];
			var h : uint = obj0.size[1];

			box.width = w;
			box.height = h;

			if (regPoint[0] == "left") {
				box.x = 0;
			} else if (regPoint[0] == "right") {
				box.x = -w;
			} else if (regPoint[0] == "center") {
				box.x = -w / 2;
			}
			if (regPoint[1] == "top") {
				box.y = 0;
			} else if (regPoint[1] == "bottom") {
				box.y = -h;
			} else if (regPoint[1] == "center") {
				box.y = -h / 2;
			}
			box.x += obj.x;
			box.y += obj.y;
		}
	}
}
}