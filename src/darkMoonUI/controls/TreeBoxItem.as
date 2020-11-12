package darkMoonUI.controls{
import darkMoonUI.types.ControlItemType;
import darkMoonUI.controls.treeBox.TreeNode;

public class TreeBoxItem extends BoxItem{
	/** @private */
	internal var treeNode : TreeNode;

	public function TreeBoxItem(){
		super();
		_type = ControlItemType.TREE_BOX_ITEM;
		treeNode = new TreeNode();
	}

	public function get rootLabel():String{
		return treeNode.rootText;
	}

	public function set label(lab:String):void{
		if(lab.search(/\|/g)!=-1){
			trace("[ERROR:]TreeBox Can't Use '|' String !,Will auto remove.",new Error().getStackTrace());
			lab = lab.replace(/\|/g,"");
		}
		treeNode.text = lab;
	}

	public function get label():String{
		return treeNode.text;
	}

	public function addItem(itm:TreeBoxItem):void{
		if(treeNode.childreenNodes==null){
			treeNode.childreenNodes = [];
		}
		treeNode.childreenNodes.push(itm.treeNode);
		itm.treeNode.parentNode = treeNode;
	}
}
}
