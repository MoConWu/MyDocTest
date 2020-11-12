package darkMoonUI.assets.functions {
import flash.desktop.NotificationType;
import flash.events.NativeWindowBoundsEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.events.Event;
import flash.display.NativeWindow;

import darkMoonUI.functions.setStageTempEnabled;

/**
 * @author moconwu
 */
public function ownerWindow(parentW : NativeWindow, childW : NativeWindow) : void {
	parentW.addEventListener(Event.ACTIVATE, pACTIVATE);
	parentW.addEventListener(Event.CLOSE, pCLOSE);
	parentW.addEventListener(Event.CLOSING, pCLOSING);
	parentW.addEventListener(NativeWindowBoundsEvent.MOVING, pLOCK);
	parentW.addEventListener(NativeWindowBoundsEvent.RESIZING, pLOCK);

	childW.addEventListener(Event.CLOSE, cClose);

	var timer : Timer = new Timer(50, 10);
	timer.addEventListener(TimerEvent.TIMER, TIMER);

	setStageTempEnabled(parentW, true);
	function TIMER(evt : TimerEvent) : void {
		childW.notifyUser(NotificationType.CRITICAL);
	}

	function notify() : void {
		try {
			childW.activate();
		}catch (e:Error) {
		}
		timer.stop();
		timer.reset();
		timer.start();
	}

	function pACTIVATE(evt : Event) : void {
		notify();
	}
	function pLOCK(evt : NativeWindowBoundsEvent) : void {
		evt.preventDefault();
		notify();
	}
	function pCLOSING(evt : Event) : void {
		evt.preventDefault();
		notify();
	}
	function pCLOSE(evt : Event) : void {
		cClose(evt);
	}
	function cClose(evt : Event) : void {
		timer.removeEventListener(TimerEvent.TIMER, TIMER);
		timer.stop();
		parentW.removeEventListener(Event.ACTIVATE, pACTIVATE);
		parentW.removeEventListener(Event.CLOSE, pCLOSE);
		parentW.removeEventListener(Event.CLOSING, pCLOSING);
		parentW.removeEventListener(NativeWindowBoundsEvent.MOVING, pLOCK);
		parentW.removeEventListener(NativeWindowBoundsEvent.RESIZING, pLOCK);
		childW.removeEventListener(Event.CLOSE, cClose);
		setStageTempEnabled(parentW);
		try {
			parentW.activate();
		} catch (e : Error) {
		}
	}
}
}
