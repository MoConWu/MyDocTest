package darkMoonUI.functions {
import flash.display.DisplayObject;
import flash.display.NativeWindow;
import flash.display.Shape;
import flash.display.Stage;
import flash.events.Event;
import flash.events.NativeWindowBoundsEvent;

import darkMoonUI.assets.functions.fill;

/** @private */
internal class CreateFocus {
	public static var f_sp : Shape;
	public static var win : NativeWindow;
	private static const color0 : uint = 0x404040;
	private static const color1 : uint = 0x4378a2;
	public static function resizeLayout(e : NativeWindowBoundsEvent):void{
		win = e.target as NativeWindow;
		if(win){
			if(f_sp){
				fill(f_sp.graphics, win.stage.stageWidth - 1, win.stage.stageHeight - 1, -1, color1);
			}
		}
	}

	public static function setStage(stg : Stage) : void {
		CreateFocus.f_sp = new Shape();
		CreateFocus.f_sp.name = "__FOCUS__";
		stg.addChild(CreateFocus.f_sp);
		stg.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, CreateFocus.resizeLayout);
		stg.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, CreateFocus.resizeLayout);
		stg.nativeWindow.addEventListener(Event.ACTIVATE, CreateFocus.focus_in);
		stg.nativeWindow.addEventListener(Event.DEACTIVATE, CreateFocus.focus_out);
	}

	public static function focus_in(e : Event):void{
		win = e.target as NativeWindow;
		if(win){
			for(var i:uint=0; i<win.stage.numChildren; i++){
				var obj : DisplayObject = win.stage.getChildAt(i);
				if (obj.name == "__FOCUS__"){
					f_sp = obj as Shape;
					fill(f_sp.graphics, win.stage.stageWidth - 1, win.stage.stageHeight - 1, -1, color1);
					return;
				}
			}
		}
	}

	public static function focus_out(e : Event):void{
		trace("focus_out");
		win = e.target as NativeWindow;
		if(win){
			for(var i:uint=0; i<win.stage.numChildren; i++){
				var obj : DisplayObject = win.stage.getChildAt(i);
				if (obj.name == "__FOCUS__"){
					f_sp = obj as Shape;
					fill(f_sp.graphics, win.stage.stageWidth - 1, win.stage.stageHeight - 1, -1, color0);
					return;
				}
			}
		}
	}
}
}