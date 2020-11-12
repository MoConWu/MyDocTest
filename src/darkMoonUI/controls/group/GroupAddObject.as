package darkMoonUI.controls.group {
public class GroupAddObject extends Object {
    public var type : String = null;
    public var length : uint = 1;
    public var width : uint = 50;
    public var height : uint = 20;
    public function GroupAddObject(_type : String=null, _length: uint=1, _width: uint=50, _height: uint=20) : void {
        type = _type;
        length = _length;
        width = _width;
        height = _height;
    }
}
}
