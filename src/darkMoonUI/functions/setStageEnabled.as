package darkMoonUI.functions {
import flash.display.NativeWindow;

import darkMoonUI.assets.DarkMoonUIControl;

import flash.display.Sprite;

/**
 * @author moconwu
 */
public function setStageEnabled(win : NativeWindow, en : Boolean = true) : void {
	try {
		var stg : * = win.stage.getChildAt(0) as Sprite;
		if(stg["name"]!="root1"){
			stg = win.stage;
		}
	} catch (e : Error) {
		stg = win.stage;
	}
	for (var i : uint = 0; i < uint(stg["numChildren"]); i++) {
		var item : Sprite = stg["getChildAt"](i) as Sprite;
		if (item is DarkMoonUIControl) {
			var control : DarkMoonUIControl = item as DarkMoonUIControl;
			control.enabled = en;
		}
	}
}
}