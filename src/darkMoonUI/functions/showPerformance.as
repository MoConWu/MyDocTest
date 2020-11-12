package darkMoonUI.functions {
import flash.display.Stage;

import darkMoonUI.assets.Performance;
/**
 * @author moconwu
 */
public function showPerformance(stg:Stage) : void {
	var fps:Performance = new Performance();
	stg.addChild(fps);
}
}