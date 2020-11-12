package darkMoonUI.controls {
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.interfaces.DMUI_PUB_BOX;
import darkMoonUI.assets.interfaces.DMUI_PUB_DEF;
import darkMoonUI.functions.parentAddChilds;

import flash.display.DisplayObject;
import flash.display.NativeMenu;
import flash.display.Shape;

public class DoubleListBox extends DarkMoonUIControl implements DMUI_PUB_DEF, DMUI_PUB_BOX {
    public var
    onChange0 : Function,
    onChange1 : Function,
    onChange : Function;

    private static var
    _btnW : uint = 20,
    W : uint = 200,
    H : uint = 200,
    _this : DoubleListBox,
    _focusID : int = -1,
    _defSerialNum : Boolean = false,
    _isLoopList : Boolean = false;

    private const
    sel : Shape = new Shape(),
    btn0 : Button = new Button("＞"),
    btn1 : Button = new Button("＜"),
    list0 : ListBox = new ListBox(),
    list1 : ListBox = new ListBox();

    public function DoubleListBox() {
        super();
        _type = "doubleListBox";
        _this = this;

        sel.x = sel.y = -1;
        fill(sel.graphics, 10, 10 , bgColorArr[2]);
        sel.visible = false;
        btn0.showFocus = btn1.showFocus = list0.showFocus = list1.showFocus = false;
        btn0.bgColor = 0x223022;
        btn1.bgColor = 0x302222;

        btn0.onFocusChange = btn1.onFocusChange = list0.onFocusChange = list1.onFocusChange = function():void{
            if(btn0.focus || btn1.focus || list0.focus || list1.focus){
                if(list0.focus){
                    _focusID = 0;
                }else if(list1.focus){
                    _focusID = 1;
                }else{
                    _focusID = -1;
                }
                stage.focus = _this;
            }
        };

        list0.onChange = list0_onChange;
        list1.onChange = list1_onChange;

        btn0.onClick = list0.onItemDoubleClick = function() : void {
            var itm : Vector.<ListBoxItem> = list0.selectedItems;
            list0.removeSelected();
            for(var i : uint = 0; i < itm.length; i++){
                list1.addItem(itm[i], false);
            }
            list1.refresh();
            list1.moveToSelect();
        };

        btn1.onClick = list1.onItemDoubleClick = function() : void {
            var itm : Vector.<ListBoxItem> = list1.selectedItems;
            list1.removeSelected();
            for(var i : uint = 0; i < itm.length; i++){
                list0.addItem(itm[i], false);
            }
            list0.refresh();
            list0.moveToSelect();
        };

        parentAddChilds(mc, Vector.<DisplayObject>([
            sel, btn0, btn1, list0, list1
        ]));

        create();
    }

    public function create(_x: int=0, _y: int=0, w : uint = 300, h : uint = 150, sh : Boolean = false, srt : Boolean = false, dsn : Boolean = false, mult : Boolean = false) : void {
        x = _x;
        y = _y;

        showSerialNum = dsn;
        showHeaders = sh;
        sort = srt;

        size = [w, h];

        enabled = _enabled;
    }

    protected override function _keyDown() : void {
        if (focus) {
            if (_focusID == 0) {
                list0.setKeyDown(_KeyboardEvent);
            }else{
                list1.setKeyDown(_KeyboardEvent);
            }
        }
    }

    private function list0_onChange() : void {
        list1.onChange = null;
        list1.selectedIndexes = null;
        if(onChange0 != null){
            onChange0();
        }
        if(onChange != null){
            onChange();
        }
        list1.onChange = list1_onChange;
    }

    private function list1_onChange() : void {
        list0.onChange = null;
        list0.selectedIndexes = null;
        if(onChange1 != null){
            onChange1();
        }
        if(onChange != null){
            onChange();
        }
        list0.onChange = list0_onChange;
    }

    public function addItem0(itm: ListBoxItem, ref: Boolean=true) : void {
        list0.addItem(itm, ref);
    }

    public function addItem1(itm: ListBoxItem, ref: Boolean=true) : void {
        list1.addItem(itm, ref);
    }

    public function set items0(itms : Vector.<ListBoxItem>) : void {
        list0.onChange = list1.onChange = null;
        list0.removeAll();
        var change1 : Boolean = false;
        var item1 : Vector.<ListBoxItem> = list1.items;
        for(i = 0; i < item1.length; i++){
            if(itms.indexOf(item1[i]) != -1){
                item1[i].remove();
                change1 = true;
            }
        }
        for(var i : uint = 0; i < itms.length; i++){
            list0.addItem(itms[i], false);
        }
        list0.refresh();
        list0.onChange = list0_onChange;
        list1.onChange = list1_onChange;
        if(change1 && onChange1 != null){
            onChange1();
        }
        if(onChange0 != null){
            onChange0();
        }
        if(onChange != null){
            onChange();
        }
    }

    public function set items1(itms : Vector.<ListBoxItem>) : void {
        list0.onChange = list1.onChange = null;
        list1.removeAll();
        var change0 : Boolean = false;
        var item0 : Vector.<ListBoxItem> = list1.items;
        for(i = 0; i < item0.length; i++){
            if(itms.indexOf(item0[i]) != -1){
                item0[i].remove();
                change0 = true;
            }
        }
        for(var i : uint = 0; i < itms.length; i++){
            list1.addItem(itms[i], false);
        }
        list1.refresh();
        list0.onChange = list0_onChange;
        list1.onChange = list1_onChange;
        if(change0 && onChange0 != null){
            onChange0();
        }
        if(onChange1 != null){
            onChange1();
        }
        if(onChange != null){
            onChange();
        }
    }

    public function get items0() : Vector.<ListBoxItem> {
        return list0.items;
    }

    public function get items1() : Vector.<ListBoxItem> {
        return list1.items;
    }

    public function set selectedItems0(itms : Vector.<ListBoxItem>) : void {
        list0.selectedItems = itms;
    }

    public function set selectedItems1(itms : Vector.<ListBoxItem>) : void {
        list1.selectedItems = itms;
    }

    public function get selectedItems0() : Vector.<ListBoxItem> {
        return list0.selectedItems;
    }

    public function get selectedItems1() : Vector.<ListBoxItem> {
        return list1.selectedItems;
    }

    public function set selectedIndexes0(vals : Vector.<uint>) : void {
        list0.selectedIndexes = vals;
    }

    public function set selectedIndexes1(vals : Vector.<uint>) : void {
        list1.selectedIndexes = vals;
    }

    public function get selectedIndexes0() :  Vector.<uint> {
        return list0.selectedIndexes;
    }

    public function get selectedIndexes1() :  Vector.<uint> {
        return list1.selectedIndexes;
    }

    public function removeAt1(num: uint) : void {
        list1.removeAt(num);
    }

    public function moveToSelect1():void{
        list1.moveToSelect();
    }

    public function moveToTop1():void{
        list1.moveToTop();
    }

    public function moveToBottom1():void{
        list1.moveToBottom();
    }

    public function set edit(boo : Boolean) : void {
        list0.edit = list1.edit = boo;
    }

    public function get edit() : Boolean {
        return list0.edit;
    }

    public function set edit1(boo : Boolean) : void {
        list1.edit = boo;
    }

    public function get edit1() : Boolean {
        return list1.edit;
    }

    protected override function _size_set() : void {
        _SizeValue.length = 2;
        _SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : sel.width - 2;
        _SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : sel.height - 2;
        const _w : int = (_SizeValue[0] - _btnW) / 2;
        const _h : int = _SizeValue[1] / 2;
        _SizeValue[0] = _w * 2 + _btnW;
        _SizeValue[1] = _h * 2;
        if(W == _SizeValue[0] && H == _SizeValue[1]){
            return;
        }
        W = _SizeValue[0];
        H = _SizeValue[1];
        btn0.size = btn1.size = [_btnW, _h];
        list0.size = list1.size = [_w, H - 1];
        btn0.x = btn1.x = _w;
        btn1.y = _h;
        list1.x = _w + _btnW;
        sel.width = W + 3;
        sel.height = H + 2;
    }

    public function get buttonWidth() : uint {
        return _btnW;
    }

    public function set buttonWidth(w : uint) : void {
        _btnW = w;
        size = [];
    }

    public function set selectedItems(sels: Vector.<ListBoxItem>) : void {
        list0.selectedItems = sels;
        list1.selectedItems = sels;
        /*if(sels == null){
            list0.selectedIndexes = null;
            list1.selectedIndexes = null;
        }else{
            var itm0 : Vector.<ListBoxItem> = list0.items;
            var itm1 : Vector.<ListBoxItem> = list1.items;
            for(var i : uint = 0; i < itm0.length; i++){
                itm0[i].selected = sels.indexOf(itm0[i]) != -1;
            }
            for(i = 0; i < itm1.length; i++){
                itm1[i].selected = sels.indexOf(itm1[i]) != -1;
            }
        }*/
    }

    public function get selectedItems() : Vector.<ListBoxItem> {
        var itm0 : Vector.<ListBoxItem> = list0.selectedItems;
        var itm1 : Vector.<ListBoxItem> = list1.selectedItems;
        for(var i : uint = 0; i < itm1.length; i++){
            itm0.push(itm1[i]);
        }
        return itm0;
    }

    public function set items(itm: Vector.<ListBoxItem>) : void {
        list0.removeAll();
        list1.removeAll();
        for(var i : uint = 0; i < itm.length; i++){
            list0.addItem(itm[i], false);
        }
        list0.refresh();
    }

    public function get items() : Vector.<ListBoxItem> {
        var itm0 : Vector.<ListBoxItem> = list0.items;
        var itm1 : Vector.<ListBoxItem> = list1.items;
        for(var i : uint = 0; i < itm1.length; i++){
            itm0.push(itm1[i]);
        }
        return itm0;
    }

    public function addItem(itm: ListBoxItem, ref: Boolean=true) : void {
        list0.addItem(itm, ref);
    }

    public function addItemAt(obj : ListBoxItem, _id : uint) : void {
        list0.addItemAt(obj, _id);
    }

    public function removeItem(obj : ListBoxItem):void{
        list0.removeItem(obj);
        list1.removeItem(obj);
    }

    protected override function _size_get() : Array {
        return [W, H];
    }

    protected override function _enabled_set() :void {
        btn0.enabled = btn1.enabled = list0.enabled = list1.enabled = _enabled;
    }

    protected override function _focus_in() : void {
        sel.visible = true;
    }

    protected override function _focus_out() : void {
        sel.visible = false;
    }

    public function set showSerialNum(boo : Boolean) : void {
        list0.showSerialNum = list1.showSerialNum = boo;
    }

    public function get showSerialNum() : Boolean {
        return list0.showSerialNum;
    }

    public override function set showFocus(boo : Boolean) : void {
        sel.alpha = int(boo) * 1.0;
    }

    public function set isLoopList(boo : Boolean) : void {
        list0.isLoopList = list1.isLoopList = boo;
    }

    public function get isLoopList() : Boolean {
        return list0.isLoopList;
    }

    public function set heads(h: Vector.<String>) : void {
        list0.heads = list1.heads = h;
    }

    public function get heads() : Vector.<String> {
        return list0.heads;
    }

    public function removeAll():void {
        list0.removeAll();
        list1.removeAll();
    }

    public function removeSelected():void {
        list0.removeSelected();
        list1.removeSelected();
    }

    public function removeAt(num:uint):void {
        list0.removeAt(num);
    }

    public function moveToSelect():void {
        list0.moveToSelect();
        list1.moveToSelect();
    }

    public function refresh():void {
        list0.refresh();
        list1.refresh();
    }

    public function moveToTop():void {
        list0.moveToTop();
        list1.moveToTop();
    }

    public function moveToBottom():void {
        list0.moveToBottom();
        list1.moveToBottom();
    }

    public function get multiline():Boolean {
        return list0.multiline;
    }

    public function set multiline(boo:Boolean):void {
        list0.multiline = list1.multiline = boo;
    }

    public function set showHeaders(boo:Boolean):void {
        list0.showHeaders = list1.showHeaders = boo;
    }

    public function get showHeaders():Boolean {
        return list0.showHeaders;
    }

    public function get selectedIndexes():Vector.<uint> {
        return list0.selectedIndexes;
    }

    public function set selectedIndexes(val:Vector.<uint>):void {
        list0.selectedIndexes = val;
    }

    public function get sort():Boolean {
        return list0.sort;
    }

    public function set sort(boo:Boolean):void {
        list0.sort = list1.sort = boo;
    }

    public function get smooth():Boolean {
        return list0.smooth;
    }

    public function set smooth(boo:Boolean):void {
        list0.smooth = list1.smooth = boo;
    }

    public function get smoothSpeed():Number {
        return list0.smoothSpeed;
    }

    public function set smoothSpeed(spd:Number):void {
        list0.smoothSpeed = list1.smoothSpeed = spd;
    }

    public function get search():String {
        return list0.search;
    }

    public function set search(str:String):void {
        list0.search = list1.search = str;
    }

    public function get itemsNativeMenu():NativeMenu {
        return list0.itemsNativeMenu;
    }

    public function set itemsNativeMenu(nm:NativeMenu):void {
        list0.itemsNativeMenu = list1.itemsNativeMenu = nm;
    }
}
}
