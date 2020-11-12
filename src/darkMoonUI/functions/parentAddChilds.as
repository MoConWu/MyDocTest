package darkMoonUI.functions {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

/**
 * @author Wuhekang
 */
public function parentAddChilds(p : DisplayObjectContainer, objs : Vector.<DisplayObject>) : void {
	for each(var obj : DisplayObject in objs){
		p.addChild(obj);
	}
	objs.length = 0;
}
}
