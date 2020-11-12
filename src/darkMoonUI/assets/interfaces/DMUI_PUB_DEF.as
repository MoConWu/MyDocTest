package darkMoonUI.assets.interfaces {

/**
 * @author moconwu
 */
public interface DMUI_PUB_DEF {
	function get type() : String;

	function get size() : Array;

	function set size(sz : Array) : void;

	function get enabled() : Boolean;

	function set enabled(boo : Boolean) : void;

	function set focus(boo : Boolean) : void;

	function get focus() : Boolean;

	function get regPoint() : Array;

	function set regPoint(reg : Array) : void;

	function get showFocus() : Boolean;

	function set showFocus(boo : Boolean) : void;
}
}