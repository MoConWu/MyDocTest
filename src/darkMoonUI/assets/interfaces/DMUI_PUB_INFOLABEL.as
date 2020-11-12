package darkMoonUI.assets.interfaces {
/**
 * @author moconwu
 */
public interface DMUI_PUB_INFOLABEL {
	function get infoLabel():String;
	function set infoLabel(lab:String):void;

	function set infoColor(col:Object):void;
	function get infoColor():Object;

	function set infoFont(f:String):void;
	function get infoFont():String;

	function set infoBold(boo:Boolean):void;
	function get infoBold():Boolean;

	function set infoItalic(boo:Boolean):void;
	function get infoItalic():Boolean;
}
}