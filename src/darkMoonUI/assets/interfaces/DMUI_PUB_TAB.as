package darkMoonUI.assets.interfaces {
import darkMoonUI.controls.TabItem;

/**
 * @author moconwu
 */
public interface DMUI_PUB_TAB {
	function addTab(tab : TabItem) : void;

	function removeTab(tab : TabItem) : void;

	function addTabAt(tab : TabItem, num : uint) : void;

	function setTabAt(tab : TabItem, num : uint) : void;

	function getTabAt(num : uint) : TabItem;

	function removeTabAt(num : uint) : void;

	function set tabID(num : int) : void;
	function get tabID() : int;

	function set tabItems(num : Vector.<TabItem>) : void;
	function get tabItems() : Vector.<TabItem>;
}
}