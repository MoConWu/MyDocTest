package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.controls.orientation.Orientation;

import flash.display.Graphics;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class DragBar extends DarkMoonUIControl{
    public var
    onChange : Function = null,
    onChanging : Function = null;

    private var
    _autoHide : Boolean = false,
    _is_drage : Boolean = false,
    _autoAlpha : Number = 1.0,
    sp : Shape = new Shape(),
    bg : Shape = new Shape(),
    _orientation : String = Orientation.V,
    _thickness : uint = 6,
    _down : Boolean = false,
    _length : uint = 100;

    private static const
    spc : uint = 6;

    private static var _xy : int = 0;

    public function DragBar(_o : String = Orientation.V, _len : uint = 100, _tick : uint = 6){
        _type = ControlType.DRAG_BAR;
        fill(bg.graphics, 10, 10, bgColorArr[1]);
        mc.alpha = _autoAlpha;

        bg.alpha = .7;

        mc.addChild(bg);
        mc.addChild(sp);

        this.cacheAsBitmapMatrix = new Matrix();
        this.cacheAsBitmap = true;
        this.mouseChildren = false;

        create(0, 0, _o, _len, _tick);
    }

    public function copy() : DragBar {
        var newDMUI : DragBar = new DragBar();
        var sz : Array = size;
        newDMUI.create(x, y, _orientation, _length);
        newDMUI.showFocus = showFocus;
        newDMUI.enabled = _enabled;
        return newDMUI;
    }

    public function create(_x : int = 0, _y : int = 0, _o : String = Orientation.V, _len : uint = 100, _tick : uint = 6) : void {
        x = _x;
        y = _y;

        orientation = _o;
        length = _len;
        thickness = _tick;

        size = [];
        enabled = _enabled;
    }

    protected override function _mouseOver() : void {
        Mouse.cursor = MouseCursor.HAND;
        mc.alpha = 1.0;
    }

    protected override function _mouseOut() : void {
        if(_down){
            return;
        }
        Mouse.cursor = MouseCursor.AUTO;
        mc.alpha = _autoAlpha;
    }

    protected override function _mouseDown() : void {
        if(_orientation == Orientation.V){
            _xy = stage.mouseX - this.x;
        }else{
            _xy = stage.mouseY - this.y;
        }
        fill(bg.graphics, 10, 10, bgColorArr[13]);
        stage.setChildIndex(this, stage.numChildren - 1);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
        stage.addEventListener(MouseEvent.MOUSE_UP, UP);
    }

    private function UP(evt : MouseEvent) : void {
        fill(bg.graphics, 10, 10, bgColorArr[1]);
        addChild(sp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveFunc);
        stage.removeEventListener(MouseEvent.MOUSE_UP, UP);
        if(onChange != null){
            onChange();
        }
        _down = false;
        _mouseOut();
    }

    private function moveFunc(evt : MouseEvent) : void {
        var _x_y : int;
        if(_orientation == Orientation.V){
            _x_y = this.x;
            this.x = stage.mouseX - _xy;
        } else {
            _x_y = this.y;
            this.y = stage.mouseY - _xy;
        }
        if (onChanging != null) {
            if(_orientation == Orientation.V){
                if(_x_y != this.x) {
                    onChanging();
                }
            }else if(_x_y != this.y) {
                onChanging();
            }
        }
    }

    protected override function _size_set() : void {
        var w : uint;
        var h : uint;
        if(_orientation == Orientation.V){
            sp.rotationZ = 90;
            w = _thickness;
            h = _length;
        }else{
            sp.rotationZ = 180;
            h = _thickness;
            w = _length;
        }
        sp.x = w / 2;
        sp.y = h / 2;
        bg.width = w;
        bg.height = h;
        _mouseOut();
    }

    protected override function _size_get() : Array {
        return [bg.width, bg.height];
    }

    public function set orientation(_o : String) : void {
        if(_o == Orientation.H){
            _o = Orientation.H;
        }else if (_o == Orientation.V){
            _o = Orientation.V;
        }else{
            return;
        }
        if(_orientation == _o){
            return;
        }
        _orientation = _o;
        size = [];
    }

    public function get orientation() : String {
        return _orientation;
    }

    public function set length(val : int) : void {
        if (val < 0) {
            val = 0;
        }
        if(_length == val){
            return;
        }
        _length = val;
        var grp : Graphics = sp.graphics;
        grp.clear();
        grp.beginFill(bgColorArr[13]);
        const leng : uint = val / 3 / spc;
        const half : int = (-1 * leng / 2) * spc;
        for(var i : uint = 0; i < leng; i ++){
            grp.drawCircle(half + i * spc, 0, .6);
        }
        grp.endFill();
        mc.setChildIndex(bg, 0);
        size = [];
    }

    public function get length() : int {
        return _length;
    }

    public function set thickness(val : int) : void {
        if (val < 5) {
            val = 5;
        }
        if(_thickness == val){
            return;
        }
        _thickness = val;
        size = [];
    }

    public function get thickness() : int {
        return _thickness;
    }

    public function set autoHide(boo : Boolean) : void {
        if(_autoHide == boo){
            return;
        }
        _autoHide = boo;
        if(boo){
            _autoAlpha = .0;
        }else{
            _autoAlpha = 1.0;
        }
        mc.alpha = _autoAlpha;
    }

    public function get autoHide() : Boolean {
        return _autoHide;
    }
}
}
