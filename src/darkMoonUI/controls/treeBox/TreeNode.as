package darkMoonUI.controls.treeBox{
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.setTF;

public class TreeNode extends Sprite {
	public static var num:int = 0;
	public static var tab:int = 21;
	public var SN:int = 0;
	public var parentNode:TreeNode;
	public var childreenNodes:Array;
	public var value:Object;
	public var text:String = "Node";
	public var rootText:String;
	public var checked:Boolean = false;
	public var collaps:Boolean = true;
	public var selected:Boolean = false;
	private var nodeMarker:NodeMarker = new NodeMarker();
	public function TreeNode() {
		SN = TreeNode.num;
		TreeNode.num++;
		nodeMarker.parentNode = this;
		addEventListener(MouseEvent.MOUSE_DOWN,onMouseClick);
	}

	public function drawNode():void{
		removeChildren();
		var textField:TextField = new TextField();
		textField.text = this.text;
		var tf:TextFormat = setTF(textColorArr[0]);
		textField.defaultTextFormat = tf;
		textField.setTextFormat(tf);
		textField.mouseEnabled = false;
		textField.autoSize = TextFieldAutoSize.LEFT;
		if(this.checked){
			/*textField.background = true;
			textField.backgroundColor = bgColorArr[7];
			tf.color = textColorArr[5];
			textField.defaultTextFormat = tf;
			textField.setTextFormat(tf);*/
		}
		if(this.selected){
			textField.background = true;
			textField.backgroundColor = bgColorArr[7];
			tf.color = textColorArr[5];
			textField.defaultTextFormat = tf;
			textField.setTextFormat(tf);
		}
		nodeMarker.sideLenght = textField.height;
		nodeMarker.draw();
		this.addChild(nodeMarker);
		textField.x = nodeMarker.width;
		this.addChild(textField);
		if (collaps){
			if(childreenNodes == null){
				return;
			}
			for(var i:int = 0; i < childreenNodes.length; i++){
				var treeNode:TreeNode = childreenNodes[i] as TreeNode;
				treeNode.selected = isSelectedNode(treeNode);
				treeNode.rootText = treeNode.parentNode.rootText + "|" + treeNode.text;
				treeNode.drawNode();
				var newCorrdinate:Point = calculateNewCorrdinate();
				treeNode.y = newCorrdinate.y;
				treeNode.x = newCorrdinate.x;
				this.addChild(treeNode);
			}
		}
	}

	private function calculateNewCorrdinate():Point {
		var result:Point = new Point();
		result.y = this.height;
		result.x = TreeNode.tab;
		return result;
	}

	private function onMouseClick(evt:MouseEvent):void{
		evt.stopImmediatePropagation();
		if(nodeMarker.isChange){
			this.collaps = ! this.collaps;
		}else{
			this.selected = ! this.selected;
			this.setSelectedNode(this);
		}
		nodeMarker.isChange = false;
		treeRedraw();

	}

	private function treeRedraw():void{
		var theParentNode:* = this.parentNode;
		if (theParentNode is TreeView){
			theParentNode.drawNode();
		}else{
			theParentNode.treeRedraw();
		}
	}

	private function setSelectedNode(treeNode:TreeNode):void{
		var theParentNode:* = this.parentNode;
		if(theParentNode is TreeView){
			treeNode.selected = !treeNode.selected;
			theParentNode.selectedNode = treeNode;
		}else{
			theParentNode.setSelectedNode(treeNode);
		}
	}

	private function isSelectedNode(treeNode:TreeNode):Boolean {
		var theParentNode:* = this.parentNode;
		if(theParentNode is TreeView){
			if (theParentNode.selectedNode == null){
				return false;
			}
			return (theParentNode.selectedNode.SN == treeNode.SN);
		}else{
			return theParentNode.isSelectedNode(treeNode);
		}
	}
}
}