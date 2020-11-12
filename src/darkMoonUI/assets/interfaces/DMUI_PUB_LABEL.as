package darkMoonUI.assets.interfaces {
/**
 * @author moconwu
 */
public interface DMUI_PUB_LABEL {
	function get label():String;
	function set label(lab:String):void;

	function set color(col:Object):void;
	function get color():Object;

	function set font(f:String):void;
	function get font():String;

	function set fontSize(sz:uint):void;
	function get fontSize():uint;

	function set bold(boo:Boolean):void;
	function get bold():Boolean;

	function set wordWrap(boo:Boolean):void;
	function get wordWrap():Boolean;

	function set multiline(boo:Boolean):void;
	function get multiline():Boolean;

	function set italic(boo:Boolean):void;
	function get italic():Boolean;
}
}