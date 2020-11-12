package com.mocon.tool {
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.IOErrorEvent;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.utils.IDataInput;

/**
 * @author Administrator
 */
public class RunTool {
	public var
	onExit : Function,
	onOutPut : Function,
	onError : Function,
	onIOError : Function;

	private var
	nativstart : NativeProcessStartupInfo,
	nativeProcess : NativeProcess;

	public function RunTool(str: String="", arg: String="", arg0: String="/c") : void {
		set(str, arg, arg0);
	}

	public function set(str: String="", arg: String="", arg0: String="/c") : void {
		var args : Vector.<String>= Vector.<String>([]);
		if(arg0 != ""){
			args.push(arg0);
		}
		args.push(arg);

		if(str != ""){
			var file : File = new File(str);
			if(!file.exists){
				trace("[RunTool Error:] File not Founded!" + str);
				str = "";
			}
		}

		nativstart = new NativeProcessStartupInfo();
		if (str == "") {
			nativstart.executable = new File("C:/WINDOWS/system32/cmd.exe");
		}else if(str != null){
			nativstart.executable = new File(str);
		}
		nativstart.arguments = args;
	}

	public function run() : void {
		trace("[RunTool run():]", nativstart.executable.nativePath);
		nativeProcess = new NativeProcess();
		try {
			nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onStandardOutPut);
			nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onStandardError);
			nativeProcess.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onStandardErrorIo);
			nativeProcess.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onStandardErrorIo);
			nativeProcess.addEventListener(NativeProcessExitEvent.EXIT, onNativeProcessExit);
			nativeProcess.start(nativstart);
		} catch (e : Error) {
			trace("[RunTool run() Error:]", e);
		}
	}

	private function onNativeProcessExit(e : NativeProcessExitEvent) : void {
		if(onExit != null){
			onExit();
		}
	}

	private function onStandardOutPut(e: ProgressEvent) : void {
		trace("[RunTool onOutPut:]",e);
		var np : NativeProcess = e.target as NativeProcess;
		var by : IDataInput = IDataInput(np.standardOutput);
		var outStr : String = by.readMultiByte(by.bytesAvailable, "ansl");
		if(onOutPut != null){
			try{
				onOutPut(outStr);
			}catch(e:Error){
			}
		}
	}

	private function onStandardError(e: ProgressEvent) : void {
		trace("[RunTool onError:]",e);
		if(onError != null){
			try{
				onError();
			}catch(e:Error){
			}
		}
	}

	private function onStandardErrorIo(e: IOErrorEvent) : void {
		trace("[RunTool onIOError:]",e);
		if(onIOError != null){
			try{
				onIOError();
			}catch(e:Error){
			}
		}
	}
}
}