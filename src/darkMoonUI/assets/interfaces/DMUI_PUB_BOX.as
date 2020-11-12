package darkMoonUI.assets.interfaces {
import flash.display.NativeMenu;

/**
 * @author moconwu
 */
public interface DMUI_PUB_BOX {
	function removeAll() : void;
	function removeSelected() : void;
	function removeAt(num : uint) : void;
	function moveToSelect() : void;
	function refresh() : void;
	function moveToTop() : void;
	function moveToBottom() : void;

	function set heads(h: Vector.<String>) : void;
	function get heads() : Vector.<String>;

	function get multiline() : Boolean;
	function set multiline(boo : Boolean) : void;

	function set showHeaders(boo : Boolean) : void;
	function get showHeaders() : Boolean;

	function get selectedIndexes() : Vector.<uint>;
	function set selectedIndexes(val : Vector.<uint>) : void;

	function get sort() : Boolean;
	function set sort(boo : Boolean) : void;

	function get smooth() : Boolean;
	function set smooth(boo : Boolean) : void;

	function get smoothSpeed() : Number;
	function set smoothSpeed(spd : Number) : void;

	function get search() : String;
	function set search(str : String) : void;

	function get itemsNativeMenu():NativeMenu;
	function set itemsNativeMenu(nm : NativeMenu) : void;
}
}
