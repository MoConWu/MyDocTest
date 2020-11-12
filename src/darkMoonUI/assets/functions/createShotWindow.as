package darkMoonUI.assets.functions {
import flash.display.NativeWindowSystemChrome;
import flash.display.NativeWindowType;
import flash.display.NativeWindowInitOptions;
import flash.display.NativeWindow;

import darkMoonUI.functions.__init__;

public function createShotWindow(title : String = "", w : uint = 500, h : uint = 500, alf : Boolean = true) : NativeWindow {
	var smallWinOptions : NativeWindowInitOptions = new NativeWindowInitOptions();
	smallWinOptions.systemChrome = NativeWindowSystemChrome.STANDARD;
	smallWinOptions.type = NativeWindowType.UTILITY;
	smallWinOptions.maximizable = smallWinOptions.minimizable = smallWinOptions.resizable = false;
	var shotWindow : NativeWindow = new NativeWindow(smallWinOptions);
	shotWindow.title = title;
	__init__(shotWindow.stage);
	shotWindow.width = w;
	shotWindow.height = h;
	shotWindow.alwaysInFront = alf;
	return shotWindow;
}
}