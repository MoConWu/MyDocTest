package darkMoonUI.assets.interfaces {
import flash.utils.ByteArray;
import flash.display.BitmapData;
import flash.display.Bitmap;

/**
 * @author moconwu
 */
public interface DMUI_PUB_IMAGE {
	function get byteArray() : ByteArray;

	function set byteArray(bas : ByteArray) : void;

	function get base64() : String;

	function set base64(bas : String) : void;

	function get hex() : String;

	function set hex(bas : String) : void;

	function get bitmap() : Bitmap;

	function set bitmap(bmp : Bitmap) : void;

	function get bitmapData() : BitmapData;

	function set bitmapData(bmpData : BitmapData) : void;

	function get source() : String;

	function set source(pt : String) : void;

	/*function get imageSize() : Array;

	function set imageSize(pt : Array) : void;*/

	/*function onLoadedError() : void;

	function onLoading() : void;

	function onLoaded() : void;*/
}
}