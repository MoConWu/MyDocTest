package darkMoonUI.assets.functions {
import flash.filesystem.File;

/**
 * @author WuHeKang
 */
public function toolPath(pth : String) : String {
	var toolFile : File = new File(File.applicationDirectory.resolvePath("tools/" + pth).nativePath);
	return toolFile.nativePath;
}
}