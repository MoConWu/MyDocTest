package darkMoonUI.assets.functions {
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.filesystem.File;

/**
 * @author moconwu
 */
public function moveMouse(_x : uint, _y : uint) : void {
	var nircmdFile : File = new File(File.applicationDirectory.resolvePath("tools/nircmd-x64/nircmdc.exe").nativePath);
	if(!nircmdFile.exists){
		return;
	}
	var nircmdPath:String = nircmdFile.parent.nativePath;
	var pan:String = nircmdPath.split(":")[0];

	var args : Vector.<String>= new Vector.<String>();
	args.push('/c');
	args.push('cd \\&cd ' + nircmdPath + '&' + pan + ':&nircmdc movecursor ' + _x + ' ' + _y);

	var nativstart : NativeProcessStartupInfo = new NativeProcessStartupInfo();
	nativstart.executable = new File("C:/WINDOWS/system32/cmd.exe");
	nativstart.arguments = args;

	var nativeProcess : NativeProcess = new NativeProcess();
	nativeProcess.start(nativstart);
}
}