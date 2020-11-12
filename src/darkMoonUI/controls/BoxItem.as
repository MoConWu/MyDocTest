package darkMoonUI.controls {
import darkMoonUI.types.ControlItemType;

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.NativeMenuItem;

public class BoxItem extends Object {
    public var value : * ;
    internal var
    index : int = -1,
    _newIcon : Shape,
    mc : Sprite = new Sprite(),
    IOC : Boolean = true;
    public var onChangeSelected : Function;
    protected var _type : String = ControlItemType.BOX_ITEM;

    public function BoxItem() {

    }

    public function set selected(boo : Boolean) : void {}
    public function get selected() : Boolean { return false }

    public function set labels(labs : Vector.<String>) : void {}
    public function get labels() : Vector.<String> { return null }

    public function set size(w : Array) : void {}
    public function get size() : Array { return null }

    public function set id(_num : int) : void {}
    public function get id() : int { return 0 }

    public function set visible(boo : Boolean) : void {}
    public function get visible() : Boolean { return false }

    internal function set itemSelectOver(boo : Boolean) : void {}

    internal function setNativeMenu() : void {}

//    internal function defaultNativeMenu(_cEdit : Boolean, _cCopy : Boolean, _cPause : Boolean, _cCut : Boolean,
//                                        _cDelete : Boolean, _uMenus : Vector.<NativeMenuItem>=null) : void {}
    internal function defaultNativeMenu() : void {}

    public function get type() : String { return _type }
}
}
