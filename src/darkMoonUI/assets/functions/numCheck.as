package darkMoonUI.assets.functions {
/**
 * @author moconwu
 */
public function numCheck(num : *, _min : Number, _max : Number) : * {
	if (!isNaN(_min) && !isNaN(_max)) {
		var min : Number = Math.min(_min, _max);
		var max : Number = Math.max(_min, _max);
	} else {
		min = _min;
		max = _max;
	}
	if (num is Number) {
		return check(num);
	} else if (num is Array || num is Vector.<Number>) {
		if (num is Array) {
			var arr : * = [];
		} else if (num is Vector.<Number>) {
			arr = Vector.<Number>([]);
		}
		for (var i : uint = 0; i < num["length"]; i++) {
			arr["push"](check(num[i]));
		}
		return arr;
	}
	function check(val : Number) : Number {
		if (isNaN(val)) {
			return NaN;
		}
		if (!isNaN(min)) {
			val = val < min ? min : val;
		}
		if (!isNaN(max)) {
			val = val > max ? max : val;
		}
		return val;
	}
}
}