package darkMoonUI.controls {
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.functions.setTF;
import darkMoonUI.assets.interfaces.DMUI_PUB_DEF;
import darkMoonUI.assets.interfaces.DMUI_PUB_LABEL;
import darkMoonUI.controls.regPoint.RegPointAlign;
import darkMoonUI.types.ControlType;

import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.events.Event;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class Loading extends DarkMoonUIControl implements DMUI_PUB_LABEL, DMUI_PUB_DEF  {
    private var
    _loading : Boolean = false,
    _speed : Number = 5,
    _spacing : uint = 10,
    _child : DarkMoonUIControl = null,
    _label : TextField = new TextField(),
    ttf : TextFormat = setTF(textColorArr[1]),
    _mask : Shape = new Shape(),
    _image : Image = new Image(),
    _background : Boolean = true,
    _bg : Shape = new Shape(),
    _bgAlpha : Number = .4,
    _parent : DisplayObjectContainer = null,
    _bgColor : Object = bgColorArr[3];

    private static const
    _base64 : String = "iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAE2ElEQVR4nATgf19M+/+//x9rrTXTVO0RFUEAQSKUAAkEBEEABACgEIREhAgAgQBKBAICQRGqiBKCosjQVDMzM/siAAAAAAAAAAAAAABoNBp7S0vL9mVlZY/VanURAAAAAAAAAAAAgAwAAAAAAAAAAAAAoFQq7URR7GFhYfEBKAIAAAAAAAAAAACQAQAAAAAAtFptbYVCUV+hUCQBAMiy7CGK4lxJktKATAAAvV7vYzQac1UqVQ4AAAAAgAwAAAAAAGBhYTFJFMUQg8EwRJblCwCAAQAwAAAYDIbBkiTFiaIYAQQBAAAAAMgAAAAAAABGo/GaKIohgiCEpqamXnZ3d9cDAAAApKamKgRBCAUwGo3xAAAAAAAAMgAAAAAAgFKpfGo0GiNEUQx0c3ObBWwDAAAAcHNzmy6KoovJZIpSKpXJAAAAAAAAMgBAeXl5Q4VCMdFoNF5RKpXJACUlJetsbW39JUmKLC4ujjaZTO9FUSwzmUxviouL1ZIkRZnN5sKSkpKVAAA6nc5TkiRfvV5/WKVS5QDIAACSJDUQRTFYFMVgo9G4vrS0NFKtVhcZDIZgs9kcYmlpaatUKp9rNJraarW6SKvVOpnN5hyTyRRmZ2en0Wg09tbW1rNFUQwBkCTpPpADIAMAKBSKRIPBMFIQhBWiKAbb2NgElJeXe8myHAPEAACo1eoiACsrq3ygEYDBYPATRTFcEISGJpMp02w2hysUikQAABkAAECW5dMFBQUJDg4OgUAvURRtAAAAAAAAAAAABEGIFATByWQyLS0pKdljZ2enAQAAkAEAAAAcHR1LgdWpqalh7u7uegAAAAAAAAAAAJ1O56XVaovt7Ow0AAAAAACyRqOxVyqVdrIsNwNEwKTX619aWlrmAQAAAAAAAAAAAFhaWuZVVFS4GAwGZwBABEwGgyFLp9MVy1ZWVt6CIIwQRdEPAEAQhGggAAAAAAAAAAAAAKC4uFitVCozAAAAAARBiJVl+bys1WrvWlhYZEmSFA/IgMFgMKQAAAAAAAAAAAAAAOTl5ZWp1WpvQRDqAgZABgxGozGtoqKiUFar1UVAEZAJAAAAAAAAAAAAAAAAAODu7q4HkgAAAAAAAGQAAACA4uJitbW1dXWVSpUNAAAAAAAAAAAAAAAAAAAAAAAgAwAAGAyGYYIghAiCYK/Vaj2srKzyAQAAAAAAAAAAAAAAAAAAAABkAAC9Xu8jSdJZAJPJFKXRaH4BAAAAAAAAAAAAAAAAAAAAAADIAABGozFXFMUIk8l0VaFQJAEAAAAAAAAAAAAAAAAAAAAAAADIAAAqlSoHCAIAADAYDP5ms7lUoVAkAAAAAAAAAAAAAAAAAAAAyAAAAAAAADqdzlOSpFMmkykTSAAAAAAAAEhNTVW4ubn5GY3GdAsLi0wAAAAAABkAAAAAAECSJF8As9m8GQBAq9U6KZVKP51OF2dlZfUZwNXV1VkUxWhBEHYCQQAAAAAAMgAAAAAAgF6vPyZJ0hOFQpEAAKBUKr0kSYpUKpUlwBGA9PT0d25ubmMNBkMGAAAAAACADAAAAAAAoFKpsoFsAAAAo9GYJghCtNFoTAEAcHd31wOxAAAAAAAAADIAAAAAAAAAAAAAQEVFRaEkSdcrKioKAQAAAAAAAAAAAAD+DwAA//8/WXCI42HoOQAAAABJRU5ErkJggg==";

    public function Loading(child:DarkMoonUIControl=null, lab: String="Loading...", sp: Number=5) {
        super();
        _type = ControlType.LOADING;

        fill(_mask.graphics, 200, 200);
        _label.mask = _image.mask = _mask;
        _label.setTextFormat(ttf);
        _label.defaultTextFormat = ttf;
        _label.selectable = false;
        _label.autoSize = TextFieldAutoSize.LEFT;
        _label.antiAliasType = AntiAliasType.ADVANCED;
        _image.regPoint = RegPointAlign.CENTER_CENTER;
        _image.base64 = _base64;

        mc.addChild(_bg);
        mc.addChild(_image);
        mc.addChild(_label);
        mc.addChild(_mask);

        create(0, 0, child, lab);

        mc.addEventListener(Event.ADDED_TO_STAGE, MC_ADDED);
    }

    public function create(_x: int=0, _y: int=0, child:DarkMoonUIControl=null, lab:String="Loading...", sp: Number=5, bg: Boolean=true, bgAlp:Number=0.4) : void {
        x = _x;
        y = _y;

        _child = child;

        _label.text = lab;
        _speed = sp;

        _bgAlpha = bgAlp;
        background = bg;
    }

    private function check_added():void{
        var __parent : DisplayObjectContainer = null;
        if(_child != null) {
            __parent = _child.parent;
            if (__parent != null && _loading) {
                x = _child.x;
                y = _child.y;
                __parent.addChild(this);
            }
        }
        __parent = this.parent;
        if(!_loading && __parent != null){
            __parent.removeChild(this);
        }else if(_loading && _parent != __parent){
            _parent.addChild(this);
        }
        size = [];
    }

    public function get loading() : Boolean {
        return _loading;
    }

    public function set loading(boo : Boolean) : void {
        _loading = boo;
        if(_child != null){
            _child.tempEnabled = boo;
        }
        check_added();
    }

    /** @private */
    protected override function _size_get() : Array {
        return [_mask.width, _mask.height];
    }

    /** @private */
    protected override function _size_set() : void {
        _SizeValue.length = 2;
        if(_child == null) {
            _SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _mask.width;
            _SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _mask.height;
        }else{
            var sz : Array = _child.size;
            _SizeValue[0] = sz[0];
            _SizeValue[1] = sz[1];
        }
        _mask.width = _SizeValue[0];
        _mask.height = _SizeValue[1];
        if(_bg != null){
            fill(_bg.graphics, _SizeValue[0], _SizeValue[1], int(_bgColor));
            _bg.alpha = _alpha;
        }
        var min : uint = Math.min(_label.width, _label.height);
        _image.size = [min, min];
        _image.y = _SizeValue[1] / 2;
        _label.y = _image.y - _label.height / 2;
        _image.x = (_SizeValue[0] - _spacing - _label.width) / 2;
        _label.x = _image.x + min / 2 + _spacing;
    }

    private function FRAME(evt : Event) : void {
        _image.rotationZ += _speed;
    }

    private function MC_ADDED(evt : Event) : void {
        _parent = this.parent;
        if(!_loading){
            this.parent.removeChild(this);
            return;
        }
        mc.removeEventListener(Event.ADDED_TO_STAGE, MC_ADDED);
        mc.addEventListener(Event.REMOVED_FROM_STAGE, MC_REMOVE);
        mc.addEventListener(Event.ENTER_FRAME, FRAME);
    }

    private function MC_REMOVE(evt : Event) : void {
        mc.addEventListener(Event.ADDED_TO_STAGE, MC_ADDED);
        mc.removeEventListener(Event.REMOVED_FROM_STAGE, MC_REMOVE);
        mc.removeEventListener(Event.ENTER_FRAME, FRAME);
    }

    public function set spacing(sp : uint) : void {
        _spacing = sp;
        size = [];
    }

    public function get spacing() : uint {
        return _spacing;
    }

    public function set speed(sp : Number) : void {
        _speed = sp;
    }

    public function get speed() : Number {
        return _speed;
    }

    public function set bgAlpha(alp: Number) : void {
        if(alp > 1){
            alp = 1.0;
        }else if(alp < 0){
            alp = 0;
        }
        _bgAlpha = alp;
        size = [];
    }

    public function set bgColor(col : Object) : void {
        _bgColor = col;
        size = [];
    }

    public function get bgColor() : Object {
        return _bgColor;
    }

    public function get background() : Boolean {
        return _background;
    }

    public function set background(boo : Boolean) : void {
        _background = boo;
        if(boo) {
            if (_bg == null) {
                _bg = new Shape();
                mc.addChildAt(_bg, 0);
            }
        }else if (_bg != null) {
            mc.removeChild(_bg);
            _bg = null;
        }
        size = [];
    }

    public function ADDED(evt : Event) : void {
        _regPoint = _child.regPoint;
        check_added();
    }

    public function set children(obj: DarkMoonUIControl) : void {
        if(_child == obj){
            return;
        }
        if(_child != null){
            _child.removeEventListener(Event.ADDED_TO_STAGE, ADDED);
        }
        _child = obj;
        _child.addEventListener(Event.ADDED_TO_STAGE, ADDED);
        size = [];
    }

    public function get children() : DarkMoonUIControl {
        return _child;
    }

    public override function get showFocus() : Boolean {
        return false;
    }

    public function get font() : String {
        return ttf.font;
    }

    public function set font(f : String) : void {
        ttf.font = f;
        _label.setTextFormat(ttf);
        _label.defaultTextFormat = ttf;
        size = [];
    }

    public function set color(col : Object) : void {
        if(col==null){
            col = textColorArr[1];
        }
        ttf.color = col;
        _label.setTextFormat(ttf);
        _label.defaultTextFormat = ttf;
    }

    public function get color() : Object {
        return "0x" + uint(ttf.color).toString(16);
    }

    public function set fontSize(num : uint) : void {
        ttf.size = num;
        _label.setTextFormat(ttf);
        _label.defaultTextFormat = ttf;
        size = [];
    }

    public function get fontSize() : uint {
        return ttf.size as uint;
    }

    public function set italic(boo : Boolean) : void {
        ttf.italic = boo;
        _label.setTextFormat(ttf);
        _label.defaultTextFormat = ttf;
    }

    public function get italic() : Boolean {
        return ttf.italic;
    }

    public function set wordWrap(boo : Boolean) : void {
        _label.wordWrap = boo;
    }

    public function set multiline(boo : Boolean) : void {
        _label.multiline = boo;
    }

    public function get wordWrap() : Boolean {
        return _label.wordWrap;
    }

    public function get multiline() : Boolean {
        return _label.multiline;
    }

    public function get bold() : Boolean {
        return ttf.bold;
    }

    public function set bold(boo : Boolean) : void {
        ttf.bold = boo;
        _label.setTextFormat(ttf);
        _label.defaultTextFormat = ttf;
    }

    public function get label() : String {
        return _label.text;
    }

    public function set label(lab : String) : void {
        _label.text = lab;
        size = [];
    }
}
}
