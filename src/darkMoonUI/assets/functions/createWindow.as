package darkMoonUI.assets.functions {
import flash.display.NativeWindowInitOptions;
import flash.display.NativeWindow;

import darkMoonUI.functions.__init__;

public function createWindow(l : String = "", w : uint = 0, h : uint = 0, owner : NativeWindow = null) : NativeWindow {
	var smallWinOptions : NativeWindowInitOptions = new NativeWindowInitOptions();
	smallWinOptions.systemChrome = "alternate";
	smallWinOptions.maximizable = smallWinOptions.minimizable = smallWinOptions.resizable = false;
	if (owner != null) {
		smallWinOptions.owner = owner;
	}
	var window : NativeWindow = new NativeWindow(smallWinOptions);
	window.alwaysInFront = true;
	__init__(window.stage);
	window.title = l;
	if (w != 0) {
		window.width = w;
	}
	if (h != 0) {
		window.height = h;
	}
	return window;
}
}