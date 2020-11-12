package darkMoonUI.controls.treeBox{
import flash.display.Sprite;

import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.controls.Button;

public class NodeMarker extends Sprite{
	public var parentNode:TreeNode;
	public var sideLenght:int = 10;
	private var btn:Button = new Button();
	public var isChange : Boolean = false;
	public function NodeMarker(){
		btn.size = [21,21];
		btn.label = "＞";
		btn.showFocus = false;
		btn.onMouseDown = function():void{
			isChange = true;
		}
		addChild(btn);
	}
	public function draw():void{
		if(parentNode.childreenNodes == null ){
			btn.visible = false;
			return;
		}
		btn.visible = true;
		if(parentNode.collaps){
			drawDash();
		}else{
			drawCross();
		}
	}

	public function drawCross():void{
		btn.label = "＞";
		btn.color = textColorArr[0];
	}

	public function drawDash():void{
		btn.label = "∨";
		btn.color = textColorArr[1];
	}
}
}