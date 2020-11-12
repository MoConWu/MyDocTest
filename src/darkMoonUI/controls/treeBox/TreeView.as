package darkMoonUI.controls.treeBox{
import flash.geom.Point;

public class TreeView extends TreeNode{
	public var onChange:Function;
	public var onReferesh:Function;
	private var _selectedNode:TreeNode;
	public var focusChange:Function;
	public function TreeView(){
		//addEventListener(Event.ADDED_TO_STAGE,added);
		//addEventListener(Event.REMOVED_FROM_STAGE,deAdded);
	}

	/*private function added(evt:Event):void{
		stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP,keyUp);
	}

	private function deAdded(evt:Event):void{
		stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
		stage.removeEventListener(KeyboardEvent.KEY_UP,keyUp);
	}

	private function keyDown(evt:KeyboardEvent):void{
		KeyDown = -1;
		if(evt.keyCode==17){
			KeyDown = 17;
		}else if(evt.keyCode==16){
			KeyDown = 16;
		}
	}

	private function keyUp(evt:KeyboardEvent):void{
		KeyDown = -1;
	}*/

	public function get selectedNode():TreeNode{
		return _selectedNode;
	}

	public function set selectedNode(sel:TreeNode):void{
		_selectedNode = sel;
		if(focusChange != null){
			focusChange();
		}
	}

	public  override function drawNode():void{
		removeChildren();
		if(childreenNodes == null){
			selectedNode = null;
			return;
		}
		for(var i:int = 0; i < childreenNodes.length; i++){
			var treeNode:TreeNode = childreenNodes[i] as TreeNode;
			treeNode.selected = selectedNode == treeNode;
			treeNode.drawNode();
			treeNode.rootText = treeNode.text;
			var newCorrdinate:Point = calculateNewCorrdinate();
			treeNode.y = newCorrdinate.y;
			treeNode.x = newCorrdinate.x;
			this.addChild(treeNode);
		}
		if(onReferesh != null){
			onReferesh();
		}
		if(onChange != null){
			onChange();
		}
	}

	public function get rootString():String{
		if(selectedNode != null){
			return selectedNode.rootText;
		}else{
			return null;
		}
	}

	private function calculateNewCorrdinate():Point{
		var result:Point = new Point();
		result.y = this.height;
		result.x = 0;
		return result;
	}
}
}