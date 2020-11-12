package darkMoonUI.functions {
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Shape;
import flash.display.Sprite;

import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;

/**
 * @author moconwu
 */
public function showAllRegPoints(main : DisplayObjectContainer, grid : uint = 0) : void {
	gridSpacing = grid;
	var gridMC : Sprite = new Sprite();
	var gridClickMC : Shape = new Shape();
	fill(gridClickMC.graphics, 10, 10);
	gridClickMC.alpha = .0;
	gridMC.doubleClickEnabled = true;
	main.addEventListener(Event.ADDED_TO_STAGE, function(evt : Event) : void {
		main.stage.nativeWindow.addEventListener(Event.RESIZE, fillGrid);
		fillGrid();
		for (var i : uint = 0; i < Number(main.numChildren); i++) {
			var obj : Sprite = main.getChildAt(i) as Sprite;
			showRegPoint(obj);
		}
	});
	function fillGrid(...args) : void {
		gridMC.removeChildren();
		gridClickMC.width = main.stage.stageWidth;
		gridClickMC.height = main.stage.stageHeight;
		if (grid > 0) {
			var ww : uint = main.stage.stageWidth / grid;
			var hh : uint = main.stage.stageHeight / grid;
			gridMC.graphics.clear();
			gridMC.graphics.beginFill(bgColorArr[7], .2);
			for (var i : uint = 0; i < ww * hh; i++) {
				gridMC.graphics.drawCircle(i % ww * grid, Math.floor(i / ww) * grid, 1);
			}
			gridMC.graphics.endFill();
		}
		gridMC.addChild(gridClickMC);
		main.addChildAt(gridMC, 0);
		gridMC.addEventListener(MouseEvent.DOUBLE_CLICK, gridClick);
	}

	function gridClick(evt : MouseEvent) : void {
		gridMC.alpha = gridMC.alpha == 0 ? 1 : 0;
		for (var i : uint = 0; i < Number(main.numChildren); i++) {
			try {
				var obj : RegPointBox = main.getChildAt(i) as RegPointBox;
				if (obj.type == "regPointBox") {
					obj.visible = Boolean(gridMC.alpha);
				}
			} catch (e : Error) {
			}
		}
	}
}
}