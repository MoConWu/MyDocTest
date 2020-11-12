package darkMoonUI.functions {
import flash.display.NativeWindowType;
import flash.display.Shape;
import flash.display.Stage;
import flash.events.Event;
import flash.events.NativeWindowBoundsEvent;

import darkMoonUI.assets.colors.bgColorArr;

/**
 * @author moconwu
 */
public function __init__(stg:Stage, autoCreateFocus : Boolean = true) : void {
	stg.color = bgColorArr[3];
	stg.stageFocusRect = false;
	stg.align = "TL";
	stg.scaleMode = "noScale";
	stg.frameRate = 60;
	if(autoCreateFocus && stg.nativeWindow.type == NativeWindowType.UTILITY){
		CreateFocus.setStage(stg);
	}
}
}