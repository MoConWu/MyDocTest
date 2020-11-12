package darkMoonUI.assets {
import flash.display.DisplayObject;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.KeyboardEvent;
import flash.ui.Mouse;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.display.Bitmap;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.display.NativeWindowSystemChrome;
import flash.display.NativeWindowType;
import flash.display.NativeWindowInitOptions;
import flash.display.Shape;
import flash.events.Event;
import flash.system.Capabilities;
import flash.display.NativeWindow;
import flash.events.MouseEvent;
import flash.display.Sprite;

import com.mocon.tool.RunTool;

import darkMoonUI.controls.orientation.Orientation;
import darkMoonUI.functions.__init__;
import darkMoonUI.functions.parentAddChilds;
import darkMoonUI.controls.IconButton;
import darkMoonUI.assets.functions.colors.hex2rgb;
import darkMoonUI.assets.functions.colors.cmyk2rgb;
import darkMoonUI.assets.functions.colors.lab2rgb;
import darkMoonUI.assets.functions.colors.rgb2hsv;
import darkMoonUI.assets.functions.colors.rgb2cmyk;
import darkMoonUI.assets.functions.colors.rgb2lab;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.controls.regPoint.RegPointAlign;
import darkMoonUI.types.ControlType;
import darkMoonUI.controls.Group;
import darkMoonUI.controls.Label;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.colors.hsv2rgb;
import darkMoonUI.assets.functions.colors.rgb2hex;
import darkMoonUI.assets.functions.colors.rgb2web;
import darkMoonUI.controls.InputText;
import darkMoonUI.controls.CheckBox;
import darkMoonUI.assets.functions.createWindow;
import darkMoonUI.assets.functions.toolPath;

/** @private */
public class ColorPickerBox extends Shape {
	public var onChange : Function;
	public var onChanging : Function;
	public var onCancel : Function;
	public var onClose : Function;

	private static const
	resolutionY : uint = Capabilities.screenResolutionY,
	resolutionX : uint = Capabilities.screenResolutionX,
	_icon_base64 : String = "iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAE8klEQVR4nATg/1/L/////5+2rVXdq1SIEAIEiVQQQFQUIlRVlYoiAAQBAIAiVFWtVQlICKFAEgWAAFJJRVWt1XY/CAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGIAAAAAAAAAAAAAAAAAAACA6OhoHW1tbV+FQjFAqVTmeHl5pQAAAACIAQAAAAAAAAAAAAAAAAAAkpKS7EQi0XWlUolIJEIsFgckJycfUSgUQ7y9vX8CAIgBAAAAAAAAAAAAAAAAAOLj42epqamlt7S0FDc3N8+trq7+qq+vbykWi3MlEklhVFSUaVBQUAOAGAAAAAAAAAAAQCaT2SmVSi93d3cPgMTERF8NDY2YpqamAk9PTysAACAvLS3NVqlU5mlqagYBhwDEAAAAAAAAAAAAtbW1Onp6eu5SqdSwtbX1tEQiiWlsbCzy8vKyAgAAAHB1db0nk8lQqVTWAABiAAAAAAAAAACAwMDAjKSkJAeRSJSlpqY2RS6XS728vDwAAAAAAOLi4kYCqKmpFQAAiAEAAAAAAAAAAAA8PDyuJiQkOAmFwksCgUAHAAAAACApKUlXIpHk1NTUVNTV1UUCAIgBAAAAAAAAAAAAAMRi8RqVSoVIJHKSSqVF7u7ugwEAwsPDxSKR6F1dXZ3E3Nzc1trauhEAQAwAAAAAAAAAABAbG9tGQ0PjmUql6tbU1NRTQ0Ojk0gkupuUlPTYw8PDCsDMzOwX0LasrMzGz8/vPQAAgBgAAAAAAAAAIDY2to26uvoXgUCgV1dXNzwgIKAEKElLS+svFApfSaXSbKFQ2K6lpaVtTU2NVVhYWAEAAACAGAAAAAAAAAAQSCSSbwKBQKexsdEiICCgCAAA0JTL5YhEoklqamrU1NQYhYSEVAAAAAAAiAEAAAAAAABSUlJKWltbdeRyubWvr28RAIBMJnOrqqqSmpiYZIpEopTy8vIkPT29E7Gxsf6+vr41AAAAAGIAAAAAgPj4eEORSFQoFAq7KhQKKx8fnwIAAJlM5lldXZ2gpaV138HBYRpAZGRks4GBQZpEIqkAFgIAAACIAQAAACIiIrQlEsknpVKpq1AoLD09PQsBAFJTU+dVVlYmmJqaZtnb2zsCAAQHB6dLpVILdXX1egAAAAAAMQAAAIChoeENgUCg29DQMN7f378QACAlJcW+qqoq2cjIKN/e3t4RAAAAwN3dvQgAAAAAAEAMAAAQFRWlplKpbJRK5Tp/f//bAABSqdSnsbEx1tjYON/Z2dkGAAAAAAAAAAAAAABADAAAoKOjM1YgEFBfX/8CACA+Pt6vubk5urS0NNfX13cMAAAAAAAAAAAAAAAAgBgAQCaTGQPZra2tt9TV1X+kpqauFAqFPRsaGoIMDQ3v+Pr6jgMAAAAAAAAAAAAAAAAAEAMACASCzJaWllqhULhcJBI9bG1t1VIoFDQ1NcU6OTn5AQAAAAAAAAAAAAAAAAAAiAEA5HJ5obq6uoVKpSpWqVSlgFVVVdXH0NBQOQAAAAAAAAAAAAAAAAAAAIAYAMDb2zsgIyOjTC6XG7i5uYUAAAAAAAAAAAAAAAAAAAAAAAAAiAEAAFxcXDYCAAAAAAAAAAAAAAAAAAAAAAAAAACIAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP4PAAD//zmfdD/lB22fAAAAAElFTkSuQmCC";
	private var
	tool : RunTool = new RunTool(toolPath("screenshot.exe")),
	Box : BoxClass = new BoxClass(),
	Line : LineClass = new LineClass(),
	_oldColorBox : Sprite = new Sprite(),
	_newColorBox : Sprite = new Sprite(),
	_HSBRGrp : Group = new Group(),
	_RGBRGrp : Group = new Group(),
	_LABRGrp : Group = new Group(),
	_CMYKLGrp : Group = new Group(),
	_lab_well : Label = new Label(),
	_btnGrp : Group = new Group(),
	_HSBTGrp : Group = new Group(),
	_RGBTGrp : Group = new Group(),
	_LABTGrp : Group = new Group(),
	_CMYKTGrp : Group = new Group(),
	_ipt_col : InputText = new InputText(),
	_pvchkBox : CheckBox = new CheckBox(),
	mc : Sprite = new Sprite(),
	mainWindow : NativeWindow,
	_title : String = "色彩选择",
	_webChkBox : CheckBox = new CheckBox(),
	_strawBtn : IconButton = new IconButton(),
	_imgURL : URLRequest = new URLRequest(),
	_imgLoader : Loader = new Loader(),
	_imgFile : File = File.cacheDirectory.resolvePath("~screenshot.png"),
	_imgWin : NativeWindow, _imgBmp : Bitmap,
	_imgArrow : Straw,_oldValue : Array = [0, false];

	private static var fullWinOP : NativeWindowInitOptions = null;

	public function ColorPickerBox() {
		_ipt_col.autoOnChange = false;
		_btnGrp.orientation = _CMYKTGrp.orientation = _CMYKLGrp.orientation = _HSBTGrp.orientation = _RGBTGrp.orientation = _LABTGrp.orientation = _LABRGrp.orientation = _RGBRGrp.orientation = _HSBRGrp.orientation = Orientation.V;
		_RGBRGrp.x = _HSBRGrp.x = 305;
		_RGBTGrp.x = _HSBTGrp.x = 345;
		_CMYKTGrp.x = _LABTGrp.x = 435;
		_LABTGrp.y = _LABRGrp.y = _HSBTGrp.y = _HSBRGrp.y = 110;
		_RGBTGrp.y = _CMYKTGrp.y = _CMYKLGrp.y = _RGBRGrp.y = 185;
		_CMYKLGrp.x = 430;
		_LABRGrp.x = 395;

		_HSBRGrp.add(ControlType.RADIO_BUTTON, 3);
		_RGBRGrp.add(ControlType.RADIO_BUTTON, 3);
		_LABRGrp.add(ControlType.RADIO_BUTTON, 3);
		_CMYKLGrp.add(ControlType.LABEL, 4);

		_HSBTGrp.add(ControlType.INPUT_NUMBER, 3, 45);
		_RGBTGrp.add(ControlType.INPUT_NUMBER, 3, 45);
		_LABTGrp.add(ControlType.INPUT_NUMBER, 3, 45);
		_CMYKTGrp.add(ControlType.INPUT_NUMBER, 4, 45);

		_HSBRGrp.setAttributes("label", ["H:", "S:", "B:"], false);
		_HSBTGrp.setAttributes("unit", ["°", "%", "%"], false);
		_RGBRGrp.setAttributes("label", ["R:", "G:", "B:"], false);
		_LABRGrp.setAttributes("label", ["L:", "a:", "b:"], false);
		_CMYKLGrp.setAttributes("regPoint", RegPointAlign.RIGHT_TOP);
		_CMYKLGrp.setAttributes("color", textColorArr[0]);
		_CMYKTGrp.setAttributes("unit", "%");
		_CMYKLGrp.setAttributes("label", ["C:", "M:", "Y:", "K:"], false);
		_LABTGrp.setAttributeAt(0, "minValue", 0);
		_LABTGrp.setAttributeAt(0, "maxValue", 100);
		_HSBTGrp.setAttributeAt(0, "maxValue", 360);
		_HSBTGrp.setAttributes("minValue", 0);
		_HSBTGrp.setAttributes("maxValue", 100, true, 1, 2);
		_LABTGrp.setAttributes("maxValue", 127, true, 1, 2);
		_LABTGrp.setAttributes("minValue", -128, true, 1, 2);
		_RGBTGrp.setAttributes("minValue", 0);
		_RGBTGrp.setAttributes("maxValue", 255);
		_CMYKTGrp.setAttributes("minValue", 0);
		_CMYKTGrp.setAttributes("maxValue", 100);

		_HSBRGrp.setAttributes("autoSize", false);
		_HSBRGrp.setAttributes("size", [20, 23]);

		_LABRGrp.setAttributes("autoSize", false);
		_LABRGrp.setAttributes("size", [20, 23]);

		_RGBRGrp.setAttributes("autoSize", false);
		_RGBRGrp.setAttributes("size", [20, 23]);

		_CMYKLGrp.setAttributes("autoSize", false);
		_CMYKLGrp.setAttributes("size", [20, 23]);

		/*_HSBRGrp.setAttributes("autoOnChange", false);
		_LABRGrp.setAttributes("autoOnChange", false);
		_RGBRGrp.setAttributes("autoOnChange", false);
		_CMYKLGrp.setAttributes("autoOnChange", false);*/

		mc.addChild(_HSBRGrp);
		mc.addChild(_RGBRGrp);
		mc.addChild(_LABRGrp);

		mc.addChild(_HSBTGrp);
		mc.addChild(_RGBTGrp);
		mc.addChild(_LABTGrp);

		mc.addChild(_CMYKLGrp);
		mc.addChild(_CMYKTGrp);

		// _HSBRGrp.setAttributeAt(0, "selected", true);

		_btnGrp.add(ControlType.BUTTON, 2, 80, 22);
		_btnGrp.spacing = 5;
		_btnGrp.setAttributeAt(0, "label", "确定");
		_btnGrp.setAttributeAt(0, "bgColor", 0x206080);
		_btnGrp.setAttributeAt(1, "label", "取消");
		_btnGrp.setAttributes("fontSize", 12);
		_btnGrp.x = 400;
		_btnGrp.y = _newColorBox.y = Line.y = Box.x = Box.y = 0;
		Line.x = 270;
		_oldColorBox.y = 35;
		_newColorBox.x = _oldColorBox.x = 305;
		_lab_well.create(305, 260, "#");
		_ipt_col.create(_lab_well.x + 15, _lab_well.y - 2, "", 70);
		_ipt_col.label = "000000";
		_ipt_col.restrict = "0-9a-fA-F";
		_ipt_col.restrictLength = 6;

		_pvchkBox.create(410, 80, "预览", true);
		_pvchkBox.onChange = function() : void {
			if (_pvchkBox.checked) {
				if(onChanging != null){
					onChanging();
				}
			} else {
				if (onCancel != null){
					onCancel();
				}
			}
		};
		_strawBtn.create(380, 80, "", 20, 20);
		_strawBtn.base64 = _icon_base64;

		if(fullWinOP == null) {
			fullWinOP = new NativeWindowInitOptions();
			fullWinOP.transparent = true;
			fullWinOP.systemChrome = NativeWindowSystemChrome.NONE;
			fullWinOP.type = NativeWindowType.UTILITY;
			fullWinOP.maximizable = fullWinOP.minimizable = fullWinOP.resizable = false;
		}
		_imgURL.url = _imgFile.nativePath;
		_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
		_imgLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, imgSecError);
		_imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgIOError);

		tool.onExit = tool.onError = tool.onIOError = tool.onOutPut = imgComp;
		_strawBtn.onClick = function() : void {
			if (_imgFile.exists) {
				_imgFile.deleteFile();
			}
			_imgArrow = new Straw(fullWinOP);
			_imgWin = new NativeWindow(fullWinOP);
			_imgWin.stage.addEventListener(MouseEvent.MOUSE_MOVE, strawMove);
			_imgWin.stage.addEventListener(MouseEvent.MOUSE_DOWN, strawDown);
			_imgWin.stage.addEventListener(MouseEvent.MOUSE_WHEEL, strawWheel);
			_imgWin.activate();
			tool.run();
			Mouse.hide();
		};

		var hexChange : Function = function() : void {
			var rgb : Vector.<Number> = hex2rgb("0x" + _ipt_col.label);
			if (webColor) {
				rgb = rgb2web(rgb);
			}
			fromeRGBtoXYV(rgb);
			setRGB(rgb, false);
			Line.setColor();
		};
		var HSBChange : Function = function() : void {
			numChange("HSB");
		};
		var LABChange : Function = function() : void {
			numChange("LAB");
		};
		var RGBChange : Function = function() : void {
			numChange("RGB");
		};
		var CMYKChange : Function = function() : void {
			numChange("CMYK");
		};
		_HSBTGrp.setAttributes("onChange", HSBChange);
		_HSBTGrp.setAttributes("onChanging", HSBChange);
		_LABTGrp.setAttributes("onChange", LABChange);
		_LABTGrp.setAttributes("onChanging", LABChange);
		_RGBTGrp.setAttributes("onChange", RGBChange);
		_RGBTGrp.setAttributes("onChanging", RGBChange);
		_CMYKTGrp.setAttributes("onChange", CMYKChange);
		_CMYKTGrp.setAttributes("onChanging", CMYKChange);
		_ipt_col.onChange = function() : void {
			var rgb : Vector.<Number> = hex2rgb("0x" + _ipt_col.label);
			if (webColor) {
				rgb = rgb2web(rgb);
			}
			_ipt_col.label = rgb2hex(rgb).toString().slice(2, 8);
		};
		_ipt_col.onChanging = hexChange;

		_HSBRGrp.setAttributeAt(0, "onSelected", function() : void {
			colorType = 0;
		});
		_HSBRGrp.setAttributeAt(1, "onSelected", function() : void {
			colorType = 1;
		});
		_HSBRGrp.setAttributeAt(2, "onSelected", function() : void {
			colorType = 2;
		});

		_RGBRGrp.setAttributeAt(0, "onSelected", function() : void {
			colorType = 3;
		});
		_RGBRGrp.setAttributeAt(1, "onSelected", function() : void {
			colorType = 4;
		});
		_RGBRGrp.setAttributeAt(2, "onSelected", function() : void {
			colorType = 5;
		});

		_LABRGrp.setAttributeAt(0, "onSelected", function() : void {
			colorType = 6;
		});
		_LABRGrp.setAttributeAt(1, "onSelected", function() : void {
			colorType = 7;
		});
		_LABRGrp.setAttributeAt(2, "onSelected", function() : void {
			colorType = 8;
		});

		Line.onChange = Line.onChanging = function() : void {
			Box.setV(V);
			Box.onChange(true);
			Box.checkTarget();
		};

		Box.onChange = Box.onChanging = function(linChange : Boolean = false) : void {
			switch (colorType) {
				case 0:
				case 1:
				case 2:
					switch (colorType) {
						case 0:
							var __h : Number = V / 255 * 360;
							var __s : Number = X / 255 * 100;
							var __b : Number = Y / 255 * 100;
							break;
						case 1:
							__s = V / 255 * 100;
							__h = X / 255 * 360;
							__b = Y / 255 * 100;
							break;
						case 2:
							__b = V / 255 * 100;
							__h = X / 255 * 360;
							__s = Y / 255 * 100;
							break;
					}
					var hsb : Vector.<Number> = Vector.<Number>([__h, __s, __b]);
					setHSB(hsb);
					break;
				case 3:
				case 4:
				case 5:
					switch (colorType) {
						case 3:
							var __r : Number = V;
							var __g : Number = Y;
							__b = X;
							break;
						case 4:
							__r = Y;
							__g = V;
							__b = X;
							break;
						case 5:
							__r = X;
							__g = Y;
							__b = V;
							break;
					}
					var rgb : Vector.<Number> = Vector.<Number>([__r, __g, __b]);
					hsb = rgb2hsv(rgb);
					setRGB(rgb);
					break;
				case 6:
				case 7:
				case 8:
					switch (colorType) {
						case 6:
							var __l : Number = V / 255 * 100;
							var __a : Number = X - 128;
							__b = Y - 128;
							break;
						case 7:
							__l = Y / 255 * 100;
							__a = V - 128;
							__b = X - 128;
							break;
						case 8:
							__a = X - 128;
							__l = Y / 255 * 100;
							__b = V - 128;
							break;
					}
					var lab : Vector.<Number> = Vector.<Number>([__l, __a, __b]);
					hsb = rgb2hsv(lab2rgb(lab));
					setLAB(lab);
					break;
			}
			Line.nowHSV = Box.nowHSV = hsb;
			if (colorType != 0 && !linChange) {
				Line.setColor();
			}
		};

		_oldColorBox.addEventListener(MouseEvent.CLICK, function(evt : MouseEvent) : void {
			newColor = Box._oldColor;
			set();
		});

		_btnGrp.setAttributeAt(0, "onClick", okBtnOnClick);
		_btnGrp.setAttributeAt(1, "onClick", canelBtnOnClick);

		_webChkBox.create(0, 260, "只有Web颜色");
		_webChkBox.onChange = function() : void {
			webColor = _webChkBox.checked;
		};

		parentAddChilds(mc, Vector.<DisplayObject>([
			_webChkBox, Box, Line, _oldColorBox, _newColorBox,
			_lab_well, _ipt_col, _pvchkBox, _strawBtn, _btnGrp
		]));

		mc.addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}

	private function imgComp() : void {
		if (_imgFile.exists) {
			_imgLoader.load(_imgURL);
		}else{
			Mouse.show();
		}
	}

	private function keyDown(evt : KeyboardEvent) : void {
		if (mainWindow.stage.focus == null) {
			if (evt.keyCode == 13) {
				okBtnOnClick();
			} else if (evt.keyCode == 27) {
				canelBtnOnClick();
			}
		}
	}

	private function strawDown(evt : MouseEvent) : void {
		Mouse.show();
		_imgArrow.close();
		_imgWin.close();
	}

	private function strawWheel(evt : MouseEvent) : void {
		_imgArrow.wheel(evt.delta);
	}

	private function strawMove(evt : MouseEvent) : void {
		var _x : int = _imgWin.stage.mouseX;
		var _y : int = _imgWin.stage.mouseY;
		_imgArrow.XY(_x, _y);
		newColor = _imgBmp.bitmapData.getPixel(_x, _y);
		var rgb : Vector.<Number> = hex2rgb(Box._newColor);
		setRGB(rgb);
		fromeRGBtoXYV(rgb);
		evt.updateAfterEvent();
	}

	private function imgKeyDown(evt : KeyboardEvent) : void {
		if (evt.keyCode == 27) {
			try {
				_imgWin.close();
			} catch (e : Error) {
			}
			try {
				_imgArrow.close();
			} catch (e : Error) {
			}
			Mouse.show();
		}
	}

	private function imgLoaded(evt : Event) : void {
		_imgBmp = new Bitmap(evt.target["content"]["bitmapData"]);
		_imgArrow.alwaysInFront = _imgWin.alwaysInFront = true;
		_imgArrow.stage.align = _imgWin.stage.align = StageAlign.TOP_LEFT;
		_imgArrow.stage.scaleMode = _imgWin.stage.scaleMode = StageScaleMode.NO_SCALE;
		_imgWin.stage.frameRate = 0;
		_imgArrow.stage.frameRate = 60;

		_imgWin.x = _imgWin.y = 0;
		_imgWin.width = _imgBmp.width;
		_imgWin.height = _imgBmp.height;
		_imgWin.stage.removeChildren();
		_imgWin.stage.addChild(_imgBmp);
		_imgWin.stage.addEventListener(KeyboardEvent.KEY_DOWN, imgKeyDown);
		_imgBmp.alpha = 0.01;
		_imgArrow.bitmapData = _imgBmp.bitmapData;
		Mouse.hide();

		_imgArrow.activate();
		_imgWin.activate();
	}

	private function imgSecError(evt : SecurityErrorEvent) : void {
		trace(_imgFile.nativePath + " Loader SecurityError!");
		_imgWin.close();
	}

	private function imgIOError(evt : IOErrorEvent) : void {
		trace(_imgFile.nativePath + " Loader IOError!");
		_imgWin.close();
	}

	public function get window() : NativeWindow {
		return mainWindow;
	}

	public function set preview(boo : Boolean) : void {
		_pvchkBox.checked = _pvchkBox.visible = boo;
	}

	public function get preview() : Boolean {
		return _pvchkBox.visible;
	}

	private function onAdded(evt : Event) : void {
		// showPerformance(mainWindow.stage);
		mainWindow.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
	}

	private function okBtnOnClick() : void {
		oldColor = newColor;
		mainWindow.close();
		if(onChange != null){
			onChange();
		}
	}

	private function canelBtnOnClick() : void {
		mainWindow.close();
		if(onCancel != null){
			onCancel();
		}
	}

	public function show(col : Object) : void {
		newColor = oldColor = uint(col);
		try {
			mainWindow.visible = false;
		} catch (err : Error) {
			createNewWindow();
			colorType = _oldValue[0];
			switch (_oldValue[0]) {
				case 0:
				case 1:
				case 2:
					_HSBRGrp.setAttributeAt(_oldValue[0], "selected", true);
					break;
				case 3:
				case 4:
				case 5:
					_RGBRGrp.setAttributeAt(_oldValue[0] - 3, "selected", true);
					break;
				case 6:
				case 7:
				case 8:
					_LABRGrp.setAttributeAt(_oldValue[0] - 6, "selected", true);
					break;
			}
			webColor = Boolean(_oldValue[1]);
		}
		mainWindow.activate();
	}

	private function createNewWindow() : void {
		mainWindow = createWindow(_title, 538, 354);
		mainWindow.x = (resolutionX - mainWindow.width) / 2;
		mainWindow.y = (resolutionY - mainWindow.height) / 2;
		mainWindow.stage.addChild(mc);
		mc.x = mc.y = 20;
		mainWindow.addEventListener(Event.CLOSE, close);
		set();
	}

	private function close(evt : Event) : void {
		mainWindow = null;
		_oldValue[0] = colorType;
		_oldValue[1] = webColor;
		if(onClose != null){
			onClose();
		}
	}

	private function numChange(str : String) : void {
		var obj : Group = this["_" + str + "TGrp"] as Group;
		var numArr : Array = obj.getAttributes("label");
		var arr : Vector.<Number> = Vector.<Number>([]);
		for (var i : uint = 0; i < numArr.length; i++) {
			arr.push(numArr[i]);
		}
		this["set" + str](arr);
		this["frome" + str + "toXYV"](arr);
		Box.checkTarget();
	}

	private function setRGB(rgb : Vector.<Number>, setIpt : Boolean = true) : void {
		if (webColor) {
			rgb = rgb2web(rgb);
		}
		var hsb : Vector.<Number> = rgb2hsv(rgb);
		var lab : Vector.<Number> = rgb2lab(rgb);
		var cmyk : Vector.<Number> = rgb2cmyk(rgb);

		_HSBTGrp.setAttributes("value", [hsb[0], hsb[1], hsb[2]], false);
		_RGBTGrp.setAttributes("value", [rgb[0], rgb[1], rgb[2]], false);
		_LABTGrp.setAttributes("value", [Math.round(lab[0]), Math.round(lab[1]), Math.round(lab[2])], false);
		_CMYKTGrp.setAttributes("value", [Math.round(cmyk[0]), Math.round(cmyk[1]), Math.round(cmyk[2]), Math.round(cmyk[3])], false);
		var hex : Object = rgb2hex(Vector.<Number>([rgb[0], rgb[1], rgb[2]]));
		changingColor(hex);
		if (setIpt) {
			_ipt_col.label = hex.toString().slice(2, 8);
		}
		Line.nowHSV = Box.nowHSV = hsb;
		Line.nowLAB = Box.nowLAB = lab;
	}
	/** @private */
	protected function setHSB(hsb : Vector.<Number>) : void {
		var rgb : Vector.<Number> = hsv2rgb(hsb);
		if (webColor) {
			rgb = rgb2web(rgb);
			hsb = rgb2hsv(rgb);
		}
		var lab : Vector.<Number> = rgb2lab(rgb);
		var cmyk : Vector.<Number> = rgb2cmyk(rgb);
		_HSBTGrp.setAttributes("value", [Math.round(hsb[0]), Math.round(hsb[1]), Math.round(hsb[2])], false);
		_RGBTGrp.setAttributes("value", [Math.round(rgb[0]), Math.round(rgb[1]), Math.round(rgb[2])], false);
		_LABTGrp.setAttributes("value", [Math.round(lab[0]), Math.round(lab[1]), Math.round(lab[2])], false);
		_CMYKTGrp.setAttributes("value", [Math.round(cmyk[0]), Math.round(cmyk[1]), Math.round(cmyk[2]), Math.round(cmyk[3])], false);
		var hex : Object = rgb2hex(Vector.<Number>([rgb[0], rgb[1], rgb[2]]));
		changingColor(hex);
		_ipt_col.label = hex.toString().slice(2, 8);
		Line.nowHSV = Box.nowHSV = hsb;
	}
	/** @private */
	protected function setLAB(lab : Vector.<Number>) : void {
		var rgb : Vector.<Number> = lab2rgb(lab);
		if (webColor) {
			rgb = rgb2web(rgb);
			lab = rgb2lab(rgb);
		}
		var hsb : Vector.<Number> = rgb2hsv(rgb);
		var cmyk : Vector.<Number> = rgb2cmyk(rgb);
		_HSBTGrp.setAttributes("value", [hsb[0], hsb[1], hsb[2]], false);
		_RGBTGrp.setAttributes("value", [Math.round(rgb[0]), Math.round(rgb[1]), Math.round(rgb[2])], false);
		_LABTGrp.setAttributes("value", [Math.round(lab[0]), Math.round(lab[1]), Math.round(lab[2])], false);
		_CMYKTGrp.setAttributes("value", [Math.round(cmyk[0]), Math.round(cmyk[1]), Math.round(cmyk[2]), Math.round(cmyk[3])], false);
		var hex : Object = rgb2hex(Vector.<Number>([rgb[0], rgb[1], rgb[2]]));
		changingColor(hex);
		_ipt_col.label = hex.toString().slice(2, 8);
		Line.nowHSV = Box.nowHSV = hsb;
		Line.nowLAB = Box.nowLAB = lab;
	}
	/** @private */
	protected function setCMYK(cmyk : Vector.<Number>) : void {
		var rgb : Vector.<Number> = cmyk2rgb(cmyk);
		if (webColor) {
			rgb = rgb2web(rgb);
			cmyk = rgb2cmyk(rgb);
		}
		var hsb : Vector.<Number> = rgb2hsv(rgb);
		var lab : Vector.<Number> = rgb2lab(rgb);
		_HSBTGrp.setAttributes("value", [hsb[0], hsb[1], hsb[2]], false);
		_RGBTGrp.setAttributes("value", [rgb[0], rgb[1], rgb[2]], false);
		_LABTGrp.setAttributes("value", [Math.round(lab[0]), Math.round(lab[1]), Math.round(lab[2])], false);
		_CMYKTGrp.setAttributes("value", [Math.round(cmyk[0]), Math.round(cmyk[1]), Math.round(cmyk[2]), Math.round(cmyk[3])], false);
		var hex : Object = rgb2hex(Vector.<Number>([rgb[0], rgb[1], rgb[2]]));
		changingColor(hex);
		_ipt_col.label = hex.toString().slice(2, 8);
		Line.nowHSV = Box.nowHSV = hsb;
		Line.nowLAB = Box.nowLAB = lab;
	}
	/** @private */
	protected function fromeRGBtoXYV(rgb : Vector.<Number>) : void {
		var __x : Number,__y : Number,__v : Number;
		switch (colorType) {
			case 0:
			case 1:
			case 2:
				fromeHSBtoXYV(rgb2hsv(rgb));
				return;
			case 3:
				__v = rgb[0];
				__y = rgb[1];
				__x = rgb[2];
				break;
			case 4:
				__y = rgb[0];
				__v = rgb[1];
				__x = rgb[2];
				break;
			case 5:
				__x = rgb[0];
				__y = rgb[1];
				__v = rgb[2];
				break;
			case 6:
			case 7:
			case 8:
				fromeLABtoXYV(rgb2lab(rgb));
				return;
		}
		Line.V = __v;
		Box.setV(__v);
		X = __x;
		Y = __y;
		Line.setColor();
	}

	private function changingColor(hex : Object) : void {
		Line._newColor = Box._newColor = hex;
		fill(_newColorBox.graphics, 60, 35, uint(hex));
		if (_pvchkBox.checked) {
			onChanging();
		}
	}
	/** @private */
	protected function fromeLABtoXYV(lab : Vector.<Number>) : void {
		var __x : Number,__y : Number,__v : Number;
		switch (colorType) {
			case 0:
			case 1:
			case 2:
				fromeHSBtoXYV(rgb2hsv(lab2rgb(lab)));
				return;
			case 3:
			case 4:
			case 5:
				fromeRGBtoXYV(lab2rgb(lab));
				return;
			case 6:
				__v = lab[0] / 100 * 255;
				__x = lab[1] + 128;
				__y = lab[2] + 128;
				break;
			case 7:
				__y = lab[0] / 100 * 255;
				__v = lab[1] + 128;
				__x = lab[2] + 128;
				break;
			case 8:
				__y = lab[0] / 100 * 255;
				__x = lab[1] + 128;
				__v = lab[2] + 128;
				break;
		}
		Line.nowLAB = Box.nowLAB = Vector.<Number>(_LABTGrp.getAttributes("value"));
		Line.V = __v;
		Box.setV(__v);
		X = __x;
		Y = __y;
		Line.setColor();
	}
	/** @private */
	protected function fromeCMYKtoXYV(cmyk : Vector.<Number>) : void {
		switch (colorType) {
			case 0:
			case 1:
			case 2:
				fromeHSBtoXYV(rgb2hsv(cmyk2rgb(cmyk)));
				return;
			case 3:
			case 4:
			case 5:
				fromeRGBtoXYV(cmyk2rgb(cmyk));
				return;
			case 6:
			case 7:
			case 8:
				fromeLABtoXYV(rgb2lab(cmyk2rgb(cmyk)));
				return;
		}
	}
	/** @private */
	protected function fromeHSBtoXYV(hsb : Vector.<Number>) : void {
		var __x : Number,__y : Number,__v : Number;
		switch (colorType) {
			case 0:
				__v = hsb[0] / 360 * 255;
				__x = hsb[1] / 100 * 255;
				__y = hsb[2] / 100 * 255;
				break;
			case 1:
				__x = hsb[0] / 360 * 255;
				__v = hsb[1] / 100 * 255;
				__y = hsb[2] / 100 * 255;
				break;
			case 2:
				__x = hsb[0] / 360 * 255;
				__y = hsb[1] / 100 * 255;
				__v = hsb[2] / 100 * 255;
				break;
			case 3:
			case 4:
			case 5:
				fromeRGBtoXYV(hsv2rgb(hsb));
				return;
			case 6:
			case 7:
			case 8:
				fromeLABtoXYV(rgb2lab(hsv2rgb(hsb)));
				return;
		}
		if (colorType == 1 || colorType == 2) {
			Line.setColor();
		}
		Line.V = __v;
		Box.setV(__v);
		X = __x;
		Y = __y;
	}

	private function get X() : Number {
		return Box.X;
	}

	private function get Y() : Number {
		return Box.Y;
	}

	private function get V() : Number {
		return Line.V;
	}

	private function set X(num : Number) : void {
		Box.X = num;
	}

	private function set Y(num : Number) : void {
		Box.Y = num;
	}

	public function set webColor(boo : Boolean) : void {
		Box._webColor = Line._webColor = boo;
		colorType = colorType;
		if (boo) {
			newColor = rgb2hex(rgb2web(hex2rgb(Box._newColor)));
			_ipt_col.label = String(Box._newColor).slice(2);
			_HSBTGrp.setAttributes("unitLength", [12, 10, 10], false);
			_LABTGrp.setAttributes("unitLength", 10);
			_RGBTGrp.setAttributes("unitLength", 26);
			_CMYKTGrp.setAttributes("unitLength", 5);
		} else {
			_HSBTGrp.setAttributes("unitLength", 0);
			_RGBTGrp.setAttributes("unitLength", 0);
			_LABTGrp.setAttributes("unitLength", 0);
			_CMYKTGrp.setAttributes("unitLength", 0);
		}
	}

	public function get webColor() : Boolean {
		return Box._webColor;
	}

	public function set newColor(col : Object) : void {
		Line._newColor = Box._newColor = "0x" + uint(col).toString(16);
		fill(_newColorBox.graphics, 60, 35, uint(col));
	}

	public function get newColor() : Object {
		return "0x" + uint(Box._newColor).toString(16);
	}

	public function set oldColor(col : Object) : void {
		Line._oldColor = Box._oldColor = "0x" + uint(col).toString(16);
		fill(_oldColorBox.graphics, 60, 35, uint(col));
	}

	public function get oldColor() : Object {
		return "0x" + uint(Box._oldColor).toString(16);
	}

	public function set colorType(num : uint) : void {
		Box.colorType = Line.colorType = num;
		switch (colorType) {
			case 0:
				Line.setColor();
			case 1:
			case 2:
				fromeHSBtoXYV(Vector.<Number>(_HSBTGrp.getAttributes("value")));
				break;
			case 3:
			case 4:
			case 5:
				fromeRGBtoXYV(Vector.<Number>(_RGBTGrp.getAttributes("value")));
				break;
			case 6:
			case 7:
			case 8:
				fromeLABtoXYV(Vector.<Number>(_LABTGrp.getAttributes("value")));
				break;
		}
	}

	public function set title(t : String) : void {
		_title = t;
	}

	public function get title() : String {
		return _title;
	}

	public function get colorType() : uint {
		return Box.colorType;
	}

	private function set() : void {
		var rgb : Vector.<Number> = hex2rgb(Box._oldColor);
		switch (colorType) {
			case 0:
			case 1:
			case 2:
				var hsb : Vector.<Number> = rgb2hsv(rgb);
				setHSB(hsb);
				fromeHSBtoXYV(hsb);
				break;
			case 3:
			case 4:
			case 5:
				setRGB(rgb);
				fromeRGBtoXYV(rgb);
				break;
			case 6:
			case 7:
			case 8:
				var lab : Vector.<Number> = rgb2lab(rgb);
				setLAB(lab);
				fromeLABtoXYV(lab);
				break;
		}
	}
}
}

import flash.geom.Rectangle;
import flash.display.NativeWindowInitOptions;
import flash.display.NativeWindow;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Bitmap;
import flash.ui.Mouse;
import flash.geom.Point;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;

import darkMoonUI.assets.functions.colors.lab2rgb;
import darkMoonUI.assets.functions.colors.rgb2web;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.colors.hsv2rgb;
import darkMoonUI.assets.functions.colors.rgb2hex;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.drawPolygon;
import darkMoonUI.assets.functions.numCheck;


class BoxClass extends Sprite {
public var
nowHSV : Vector.<Number> = Vector.<Number>([0, 0, 0]),
nowLAB : Vector.<Number> = Vector.<Number>([0, 0, 0]),
_oldColor : Object,_newColor : Object,
_webColor : Boolean = false,
onChange : Function,
onChanging : Function;
private var
_COLOR_TYPE : uint = 0,
XYBtn : Sprite = new Sprite(),
XYArrow : Shape = new Shape(),
XYTargetBox : Shape = new Shape(),
XYTarget : Shape = new Shape(),
XYColorBox : Sprite = new Sprite(),
XYColorGrap : Shape = new Shape(),
_x : Number = 0,_y : Number = 0,
_bgChanged : Boolean = false;

public function BoxClass() {
	fill(XYBtn.graphics, 255, 255);
	fill(XYTargetBox.graphics, 255, 255);
	XYBtn.alpha = 0;

	drawArrow(8);
	XYArrow.visible = false;

	drawTarget(1);

	XYTarget.x = XYTarget.y = XYArrow.x = XYArrow.y = 125;

	/*XYArrow.cacheAsBitmapMatrix = XYArrow.transform.concatenatedMatrix;
	XYColorBox.cacheAsBitmapMatrix = XYColorBox.transform.concatenatedMatrix;
	XYColorBox.cacheAsBitmap = XYArrow.cacheAsBitmap = true;*/

	XYTarget.mask = XYTargetBox;

	setV(125);

	XYColorBox.addChild(XYColorGrap);
	addChild(XYColorBox);
	addChild(XYTarget);
	addChild(XYTargetBox);
	addChild(XYArrow);
	addChild(XYBtn);

	XYBtn.addEventListener(MouseEvent.MOUSE_OVER, OVER);
	XYBtn.addEventListener(MouseEvent.MOUSE_OUT, OUT);
	XYBtn.addEventListener(MouseEvent.MOUSE_MOVE, MOVE);
	XYBtn.addEventListener(MouseEvent.MOUSE_DOWN, DOWN);
}

private function drawTarget(col : uint) : void {
	col = col == 0 ? 0 : 0xFFFFFF;
	XYTarget.graphics.clear();
	XYTarget.graphics.lineStyle(1, col);
	XYTarget.graphics.beginFill(0, 0);
	XYTarget.graphics.drawCircle(0, 0, 5);
	XYTarget.graphics.endFill();
}

private function drawArrow(sz : Number) : void {
	XYArrow.graphics.clear();
	XYArrow.graphics.lineStyle(2, 0xFFFFFF);
	XYArrow.graphics.beginFill(0, 0);
	XYArrow.graphics.drawCircle(0, 0, sz);
	XYArrow.graphics.endFill();

	XYArrow.graphics.lineStyle(0, 0);
	XYArrow.graphics.beginFill(0, 0);
	XYArrow.graphics.drawCircle(0, 0, sz);
	XYArrow.graphics.endFill();
}

private function onMoving(evt : MouseEvent) : void {
	XYArrow.x = mouseX;
	XYArrow.y = mouseY;
	_x = XYTarget.x = numCheck(mouseX, 0, 255);
	XYTarget.y = numCheck(mouseY, 0, 255);
	_y = 255 - XYTarget.y;
	if(onChanging != null){
		onChanging();
	}
	checkTarget();
	evt.updateAfterEvent();
}

public function checkTarget() : void {
	if (nowHSV[2] > 60) {
		drawTarget(0);
	} else {
		drawTarget(1);
	}
}

private function DOWN(evt : MouseEvent) : void {
	drawArrow(7);
	_x = XYTarget.x = numCheck(XYArrow.x, 0, 255);
	XYTarget.y = numCheck(XYArrow.y, 0, 255);
	_y = 255 - XYTarget.y;
	XYBtn.removeEventListener(MouseEvent.MOUSE_MOVE, MOVE);
	XYBtn.removeEventListener(MouseEvent.MOUSE_OVER, OVER);
	XYBtn.removeEventListener(MouseEvent.MOUSE_OUT, OUT);
	stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoving);
	stage.addEventListener(MouseEvent.MOUSE_UP, UP);
	if(onChange != null){
		onChange();
	}
	checkTarget();
}

private function UP(evt : MouseEvent) : void {
	stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoving);
	stage.removeEventListener(MouseEvent.MOUSE_UP, UP);
	XYBtn.addEventListener(MouseEvent.MOUSE_OVER, OVER);
	XYBtn.addEventListener(MouseEvent.MOUSE_OUT, OUT);
	XYBtn.addEventListener(MouseEvent.MOUSE_MOVE, MOVE);
	if (XYArrow.x > 255 || XYArrow.x < 0 || XYArrow.y > 255 || XYArrow.y < 0) {
		XYArrow.visible = false;
		Mouse.show();
	}
	drawArrow(8);
}

private function MOVE(evt : MouseEvent) : void {
	XYArrow.x = XYBtn.mouseX;
	XYArrow.y = XYBtn.mouseY;
	evt.updateAfterEvent();
}

private function OVER(evt : MouseEvent) : void {
	if (!evt.buttonDown) {
		Mouse.hide();
		XYArrow.visible = true;
	}
}

private function OUT(evt : MouseEvent) : void {
	Mouse.show();
	XYArrow.visible = false;
}

public function get X() : Number {
	return _x;
}

public function set X(num : Number) : void {
	XYTarget.x = _x = numCheck(num, 0, 255);
}

public function get Y() : Number {
	return _y;
}

public function set Y(num : Number) : void {
	XYTarget.y = 255 - numCheck(num, 0, 255);
	_y = num;
}

public function setV(H : Number) : void {
	XYColorBox.removeChildren();
	var grap : Graphics = XYColorGrap.graphics;
	grap.clear();
	var lengW : uint,lengH : uint;
	switch (_COLOR_TYPE) {
		case 0:// hsb
			H = H / 255 * 360;
			if (_webColor) {
				lengW = 50;
				lengH = 60;
			} else {
				lengW = lengH = 25;
			}
			for (var k : uint = 0; k < lengH; k++) {
				for (var i : uint = 0; i < lengW; i++) {
					var RGB : Vector.<Number> = hsv2rgb(Vector.<Number>([H == 360 ? 0 : H, i * 100 / lengW, k * 100 / lengH]));
					if (_webColor) {
						RGB = rgb2web(RGB);
					}
					grap.beginFill(int(rgb2hex(Vector.<Number>([RGB[0], RGB[1], RGB[2]]))));
					grap.drawRect(i, lengH - 1 - k, 1, 1);
					grap.endFill();
				}
			}
			break;
		case 1:
			H = H / 255 * 100;
			if (_webColor) {
				if (H < 50) {
					lengW = 50;
					lengH = 100;
				} else {
					lengW = 120;
					lengH = 40;
				}
			} else {
				lengW = 25;
				lengH = 30;
			}
			for (k = 0; k < lengH; k++) {
				for (i = 0; i < lengW; i++) {
					var ii : uint = i == lengW ? 0 : i;
					RGB = hsv2rgb(Vector.<Number>([ii * 360 / lengW, H, k * 100 / lengH]));
					if (_webColor) {
						RGB = rgb2web(RGB);
					}
					grap.beginFill(int(rgb2hex(Vector.<Number>([RGB[0], RGB[1], RGB[2]]))));
					grap.drawRect(i, lengH - 1 - k, 1, 1);
					grap.endFill();
				}
			}
			break;
		case 2:
			H = H / 255 * 100;
			if (_webColor) {
				lengH = 50;
				lengW = 90;
			} else {
				lengH = 25;
				lengW = 30;
			}
			for (k = 0; k < lengH; k++) {
				for (i = 0; i < lengW; i++) {
					ii = i == lengW ? 0 : i;
					RGB = hsv2rgb(Vector.<Number>([ii * 360 / lengW, k * 100 / lengH, H]));
					if (_webColor) {
						RGB = rgb2web(RGB);
					}
					grap.beginFill(int(rgb2hex(Vector.<Number>([RGB[0], RGB[1], RGB[2]]))));
					grap.drawRect(i, lengH - 1 - k, 1, 1);
					grap.endFill();
				}
			}
			break;
		case 3:// rgb
			lengH = lengW = 17;
			for (k = 0; k < lengH; k++) {
				for (i = 0; i < lengW; i++) {
					var rgb : Vector.<Number> = Vector.<Number>([H, k * 255 / lengH, i * 255 / lengW]);
					if (_webColor) {
						rgb = rgb2web(rgb);
					}
					grap.beginFill(int(rgb2hex(rgb)));
					grap.drawRect(i, lengH - 1 - k, 1, 1);
					grap.endFill();
				}
			}
			break;
		case 4:
			lengH = lengW = 17;
			for (k = 0; k < lengH; k++) {
				for (i = 0; i < lengW; i++) {
					rgb = Vector.<Number>([k * 255 / lengH, H, i * 255 / lengW]);
					if (_webColor) {
						rgb = rgb2web(rgb);
					}
					grap.beginFill(int(rgb2hex(rgb)));
					grap.drawRect(i, lengH - 1 - k, 1, 1);
					grap.endFill();
				}
			}
			break;
		case 5:
			lengH = lengW = 17;
			for (k = 0; k < lengH; k++) {
				for (i = 0; i < lengW; i++) {
					rgb = Vector.<Number>([k * 255 / lengH, i * 255 / lengW, H]);
					if (_webColor) {
						rgb = rgb2web(rgb);
					}
					grap.beginFill(int(rgb2hex(rgb)));
					grap.drawRect(k, lengW - 1 - i, 1, 1);
					grap.endFill();
				}
			}
			break;
		case 6:// lab
			if (_webColor) {
				lengH = 100;
				lengW = 51;
			} else {
				lengH = lengW = 17;
			}
			H = H / 255 * 100;
			for (k = 0; k < lengH; k++) {
				for (i = 0; i < lengW; i++) {
					rgb = lab2rgb(Vector.<Number>([H, 127 - k * 255 / lengH, 127 - i * 255 / lengW]));
					if (_webColor) {
						rgb = rgb2web(rgb);
					}
					grap.beginFill(int(rgb2hex(rgb)));
					grap.drawRect(lengH - 1 - k, i, 1, 1);
					grap.endFill();
				}
			}
			break;
		case 7:
			if (_webColor) {
				lengH = 70;
				lengW = 51;
			} else {
				lengH = 25;
				lengW = 17;
			}
			for (k = 0; k < lengH; k++) {
				for (i = 0; i < lengW; i++) {
					rgb = lab2rgb(Vector.<Number>([k * 100 / lengH, H - 128, i * 255 / lengW - 128]));
					if (_webColor) {
						rgb = rgb2web(rgb);
					}
					grap.beginFill(int(rgb2hex(rgb)));
					grap.drawRect(i, lengH - 1 - k, 1, 1);
					grap.endFill();
				}
			}
			break;
		case 8:
			if (_webColor) {
				lengH = 70;
				lengW = 51;
			} else {
				lengH = 25;
				lengW = 17;
			}
			for (k = 0; k < lengH; k++) {
				for (i = 0; i < lengW; i++) {
					rgb = lab2rgb(Vector.<Number>([k * 100 / lengH, i * 255 / lengW - 128, H - 128]));
					if (_webColor) {
						rgb = rgb2web(rgb);
					}
					grap.beginFill(int(rgb2hex(rgb)));
					grap.drawRect(i, lengH - 1 - k, 1, 1);
					grap.endFill();
				}
			}
			break;
	}
	if (_webColor) {
		XYColorBox.addChild(XYColorGrap);
	} else {
		var bd : BitmapData = new BitmapData(XYColorGrap.width, XYColorGrap.height);
		bd.draw(XYColorGrap);
		var b : Bitmap = new Bitmap(bd);
		b.smoothing = true;
		XYColorBox.addChild(b);
	}
	XYColorBox.width = XYColorBox.height = 255;
}

public function set colorType(num : uint) : void {
	_COLOR_TYPE = num;
	var __x : Number, __y : Number, __v : Number;
	switch (_COLOR_TYPE) {
		case 3:
		case 4:
		case 5:
			var rgb : Vector.<Number> = hsv2rgb(nowHSV);
			break;
		default:
			break;
	}
	switch (_COLOR_TYPE) {
		case 0:
			__v = nowHSV[0] / 360 * 255;
			__x = nowHSV[1] / 100 * 255;
			__y = 255 - nowHSV[2] / 100 * 255;
			break;
		case 1:
			__x = nowHSV[0] / 360 * 255;
			__v = nowHSV[1] / 100 * 255;
			__y = 255 - nowHSV[2] / 100 * 255;
			break;
		case 2:
			__x = nowHSV[0] / 360 * 255;
			__y = nowHSV[1] / 100 * 255;
			__v = 255 - nowHSV[2] / 100 * 255;
			break;
		case 3:
			__v = rgb[0];
			__x = rgb[1];
			__y = 255 - rgb[2];
			break;
		case 4:
			__x = rgb[0];
			__v = rgb[1];
			__y = 255 - rgb[2];
			break;
		case 5:
			__y = rgb[0];
			__x = rgb[1];
			__x = 255 - rgb[2];
			break;
	}
}

public function setXY(__x : Number, __y : Number) : void {
	XYTarget.x = __x;
	XYTarget.y = __y;
}

public function get colorType() : uint {
	return _COLOR_TYPE;
}

public function set bgChanged(boo : Boolean) : void {
	_bgChanged = boo;
	if (boo) {
		XYBtn.removeEventListener(MouseEvent.MOUSE_OVER, OVER);
		XYBtn.removeEventListener(MouseEvent.MOUSE_OUT, OUT);
		XYBtn.removeEventListener(MouseEvent.MOUSE_MOVE, MOVE);
	} else {
		XYBtn.removeEventListener(MouseEvent.MOUSE_OVER, OVER);
		XYBtn.removeEventListener(MouseEvent.MOUSE_OUT, OUT);
		XYBtn.removeEventListener(MouseEvent.MOUSE_MOVE, MOVE);
	}
}
}

/** @private */
internal class LineClass extends Sprite {
public var
nowHSV : Vector.<Number> = Vector.<Number>([0, 0, 0]),
nowLAB : Vector.<Number> = Vector.<Number>([0, 0, 0]),
_oldColor : Object,_newColor : Object,
_webColor : Boolean = false,
onChanging : Function,
onChange : Function;
private var
_COLOR_TYPE : uint = 0,
VColorBox : Sprite = new Sprite(),
VBtn : Sprite = new Sprite(),
VArrow : Sprite = new Sprite();

public function LineClass() {
	fill(VBtn.graphics, 40, 255);
	VBtn.alpha = 0;
	VBtn.x = -15;
	VBtn.addEventListener(MouseEvent.MOUSE_DOWN, VBtn_down);

	var VArrow0 : Shape = new Shape();
	var VArrow1 : Shape = new Shape();
	var p0 : Point = new Point(0, 0);
	var p1 : Point = new Point(-6, 4);
	var p2 : Point = new Point(-6, -4);
	var p3 : Point = new Point(6, 4);
	var p4 : Point = new Point(6, -4);
	var verticie0 : Vector.<Point> = Vector.<Point>([p0, p1, p2]);
	var verticie1 : Vector.<Point> = Vector.<Point>([p0, p3, p4]);
	drawPolygon(VArrow0.graphics, verticie0, bgColorArr[9]);
	drawPolygon(VArrow1.graphics, verticie1, bgColorArr[9]);
	VArrow1.x = 20;

	VArrow.addChild(VArrow0);
	VArrow.addChild(VArrow1);
	VArrow.y = 125;
	VArrow.x = -1;

	VColorBox.cacheAsBitmapMatrix = VColorBox.transform.concatenatedMatrix;
	VColorBox.cacheAsBitmap = true;

	addChild(VColorBox);
	addChild(VArrow);
	addChild(VBtn);
}

private function VBtn_down(evt : MouseEvent) : void {
	VArrow.y = VBtn.mouseY;
	stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoving);
	stage.addEventListener(MouseEvent.MOUSE_UP, stopMove);
	if(onChange != null){
		onChange();
	}
}

private function onMoving(evt : MouseEvent) : void {
	var num : Number = VArrow.y;
	VArrow.y = numCheck(VBtn.mouseY, 0, 255);
	if (num != VArrow.y && onChanging != null) {
		onChanging();
	}
	evt.updateAfterEvent();
}

private function stopMove(evt : MouseEvent) : void {
	stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoving);
	stage.removeEventListener(MouseEvent.MOUSE_UP, stopMove);
}

public function set V(val : Number) : void {
	VArrow.y = numCheck(255 - val, 0, 255);
}

public function get V() : Number {
	return 255 - VArrow.y;
}

public function set colorType(num : uint) : void {
	_COLOR_TYPE = num;
}

public function setColor() : void {
	VColorBox.graphics.clear();
	switch (_COLOR_TYPE) {
		case 3:
		case 4:
		case 5:
			var RGB : Vector.<Number> = hsv2rgb(Vector.<Number>(nowHSV));
			if (_webColor) {
				RGB = rgb2web(RGB);
			}
			break;
	}
	switch (_COLOR_TYPE) {
		case 0:// hsb
			for (var i : uint = 0; i < 90; i++) {
				RGB = hsv2rgb(Vector.<Number>([359 - i * 4, 100, 100]));
				if (_webColor) {
					RGB = rgb2web(RGB);
				}
				VColorBox.graphics.beginFill(int(rgb2hex(Vector.<Number>([RGB[0], RGB[1], RGB[2]]))));
				VColorBox.graphics.drawRect(0, i, 18, 1);
				VColorBox.graphics.endFill();
			}
			break;
		case 1:
			for (i = 0; i < 100; i++) {
				RGB = hsv2rgb(Vector.<Number>([nowHSV[0], 100 - i, nowHSV[2]]));
				if (_webColor) {
					RGB = rgb2web(RGB);
				}
				VColorBox.graphics.beginFill(int(rgb2hex(Vector.<Number>([RGB[0], RGB[1], RGB[2]]))));
				VColorBox.graphics.drawRect(0, i, 18, 1);
				VColorBox.graphics.endFill();
			}
			break;
		case 2:
			for (i = 0; i < 100; i++) {
				RGB = hsv2rgb(Vector.<Number>([nowHSV[0], nowHSV[1], 100 - i]));
				if (_webColor) {
					RGB = rgb2web(RGB);
				}
				VColorBox.graphics.beginFill(int(rgb2hex(Vector.<Number>([RGB[0], RGB[1], RGB[2]]))));
				VColorBox.graphics.drawRect(0, i, 18, 1);
				VColorBox.graphics.endFill();
			}
			break;
		case 3:// rgb
			for (i = 0; i < 128; i++) {
				var rgb : Vector.<Number> = Vector.<Number>([255 - i * 2, RGB[1], RGB[2]]);
				if (_webColor) {
					rgb = rgb2web(rgb);
				}
				VColorBox.graphics.beginFill(int(rgb2hex(rgb)));
				VColorBox.graphics.drawRect(0, i, 18, 1);
				VColorBox.graphics.endFill();
			}
			break;
		case 4:
			for (i = 0; i < 128; i++) {
				rgb = Vector.<Number>([RGB[0], 255 - i * 2, RGB[2]]);
				if (_webColor) {
					rgb = rgb2web(rgb);
				}
				VColorBox.graphics.beginFill(int(rgb2hex(rgb)));
				VColorBox.graphics.drawRect(0, i, 18, 1);
				VColorBox.graphics.endFill();
			}
			break;
		case 5:
			for (i = 0; i < 128; i++) {
				rgb = Vector.<Number>([RGB[0], RGB[1], 255 - i * 2]);
				if (_webColor) {
					rgb = rgb2web(rgb);
				}
				VColorBox.graphics.beginFill(int(rgb2hex(rgb)));
				VColorBox.graphics.drawRect(0, i, 18, 1);
				VColorBox.graphics.endFill();
			}
			break;
		case 6:// lab
			for (i = 0; i < 100; i++) {
				RGB = lab2rgb(Vector.<Number>([100 - i, nowLAB[1], nowLAB[2]]));
				if (_webColor) {
					RGB = rgb2web(RGB);
				}
				VColorBox.graphics.beginFill(int(rgb2hex(Vector.<Number>([RGB[0], RGB[1], RGB[2]]))));
				VColorBox.graphics.drawRect(0, i, 18, 1);
				VColorBox.graphics.endFill();
			}
			break;
		case 7:
			for (i = 0; i < 128; i++) {
				RGB = lab2rgb(Vector.<Number>([nowLAB[0], 127 - i * 2, nowLAB[2]]));
				if (_webColor) {
					RGB = rgb2web(RGB);
				}
				VColorBox.graphics.beginFill(int(rgb2hex(Vector.<Number>([RGB[0], RGB[1], RGB[2]]))));
				VColorBox.graphics.drawRect(0, i, 18, 1);
				VColorBox.graphics.endFill();
			}
			break;
		case 8:
			for (i = 0; i < 128; i++) {
				RGB = lab2rgb(Vector.<Number>([nowLAB[0], nowLAB[1], 127 - i * 2]));
				if (_webColor) {
					RGB = rgb2web(RGB);
				}
				VColorBox.graphics.beginFill(int(rgb2hex(Vector.<Number>([RGB[0], RGB[1], RGB[2]]))));
				VColorBox.graphics.drawRect(0, i, 18, 1);
				VColorBox.graphics.endFill();
			}
			break;
	}
	VColorBox.height = 255;
}
}

class Straw extends NativeWindow {
private var
_bmp0 : Bitmap = new Bitmap(),
_bmp : Bitmap = new Bitmap(),
img : Sprite = new Sprite(),
line : Shape = new Shape(),
arrow : Shape = new Shape(),
box : Sprite = new Sprite(),
_scale : int = 2,
sz : uint;

public function Straw(initOptions : NativeWindowInitOptions) : void {
	super(initOptions);
	arrow.graphics.lineStyle(0, 0);
	arrow.graphics.beginFill(0, 0);
	arrow.graphics.drawCircle(0, 0, 4);
	arrow.graphics.endFill();
	arrow.graphics.lineStyle(0, 0xFFFFFF);
	arrow.graphics.beginFill(0, 0);
	arrow.graphics.drawCircle(0, 0, 5);
	arrow.graphics.endFill();
	setScale();
	box.addChild(img);
	box.addChild(line);
	box.addChild(arrow);
	stage.addChild(box);
}

public function set bitmapData(bmpData : BitmapData) : void {
	_bmp = new Bitmap(bmpData);
	_bmp0 = new Bitmap(bmpData);
}

public function XY(_x : uint = 0, _y : uint = 0) : void {
	box.visible = false;
	img.removeChildren();
	x = _x - sz / 2;
	y = _y - sz / 2;
	if (_scale != 1) {
		var sz0 : Number = sz / _scale;
		var rect : Rectangle = new Rectangle(_x - sz0 / 2, _y - sz0 / 2, sz0, sz0);
		_bmp = Cut(_bmp0, rect);
		_bmp.width = _bmp.height = sz;
		img.addChild(_bmp);
	}
	box.visible = true;
}

private static function Cut(data : Bitmap, rect : Rectangle) : Bitmap {
	var bitmapdata : BitmapData = data.bitmapData;
	var retdata : BitmapData = new BitmapData(rect.width, rect.height, false);
	retdata.copyPixels(bitmapdata, rect, new Point(0, 0));
	return new Bitmap(retdata);
}

private function setScale() : void {
	box.visible = false;
	sz = _scale * 50;
	var grap : Graphics = line.graphics;
	grap.clear();
	grap.lineStyle(0, 0, 1, true);
	grap.lineTo(1, 1);
	grap.lineTo(sz - 1, 1);
	grap.lineTo(sz - 1, sz - 1);
	grap.lineTo(1, sz - 1);
	grap.lineTo(1, 1);
	grap.lineStyle(0, 0xFFFFFF, 1, true);
	grap.lineTo(0, 0);
	grap.lineTo(sz, 0);
	grap.lineTo(sz, sz);
	grap.lineTo(0, sz);
	grap.lineTo(0, 0);
	arrow.x = arrow.y = sz / 2;
	width = height = sz + 1;
	box.visible = true;
}

public function wheel(num : int) : void {
	var _x : Number = x + sz / 2;
	var _y : Number = y + sz / 2;
	_scale += num / 3;
	_scale = _scale < 1 ? 1 : _scale > 15 ? 15 : _scale;
	setScale();
	XY(_x, _y);
}
}
