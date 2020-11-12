package com.mocon.string {
/**
 * @author moconwu
 */
public function RegExpList(str : String, grp0 : Array, grp1 : Array) : String {
	for (var i : uint = 0; i < grp0.length; i++) {
		var exp : RegExp = new RegExp(grp0[i], "g");
		str = str.replace(exp, grp1[i]);
	}
	return str;
}
}