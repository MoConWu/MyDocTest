package darkMoonUI.functions {
import flash.display.NativeWindow;

public function windowCenter(p_win:NativeWindow, c_win:NativeWindow):void {
    c_win.x = p_win.x + (p_win.width - c_win.width) / 2;
    c_win.y = p_win.y + (p_win.height - c_win.height) / 2;
    if (c_win.x < 0) {
        c_win.x = 0;
    }
    if (c_win.y < 0) {
        c_win.y = 0;
    }
}
}
