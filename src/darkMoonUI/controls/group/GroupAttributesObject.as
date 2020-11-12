package darkMoonUI.controls.group {
public class GroupAttributesObject extends Object{
    public var name: String = null;
    public var value: * = null;
    public var isAll: Boolean = true;
    public var start: uint = 0;
    public var end: uint = 0;
    public function GroupAttributesObject(_name : String=null, _value: *=null, _isAll: Boolean=true, _start: uint=0, _end: uint=0) : void {
        name = _name;
        value = _value;
        isAll = _isAll;
        start = _start;
        end = _end;
    }
}
}
