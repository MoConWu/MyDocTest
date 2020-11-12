package darkMoonUI.assets {
import flash.events.MouseEvent;
import flash.display.Sprite;
import flash.display.Shape;
import flash.text.TextFormat;
import flash.text.TextField;

import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.assets.colors.textColorArr;
import darkMoonUI.assets.functions.setTF;

/** @private */
public class DatePickerBox extends Sprite {
	public var onChangeMonth : Function;
	public var onSelected : Function;
	private var
	bgMC : Shape = new Shape(),
	btn_y0 : DatePickerBoxButton = new DatePickerBoxButton(),
	btn_y1 : DatePickerBoxButton = new DatePickerBoxButton(),
	btn_m0 : DatePickerBoxButton = new DatePickerBoxButton(),
	btn_m1 : DatePickerBoxButton = new DatePickerBoxButton(),
	_lab_y : TextField = new TextField(),
	_lab_m : TextField = new TextField(),
	_ttf : TextFormat = setTF(textColorArr[5], "", true),
	_ttfW : TextFormat = setTF(textColorArr[5]),
	_weekText : Array = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
	_date : Date = new Date(),
	_showDate : Date = new Date(),
	dateMC : Sprite = new Sprite(),
	_sundayStart : Boolean = true,
	weekArr : Array = [],
	_canChange : Boolean = true,
	_pickerSize : Array = [25, 25],
	_spacing : uint = 5;

	public function DatePickerBox() {
		fill(bgMC.graphics, 220, 200, bgColorArr[9]);
		_lab_y.selectable = _lab_m.selectable = _lab_y.wordWrap = _lab_m.wordWrap = _lab_y.multiline = _lab_m.multiline = false;

		_lab_y.defaultTextFormat = _lab_m.defaultTextFormat = _ttf;
		_lab_y.setTextFormat(_ttf);
		_lab_m.setTextFormat(_ttf);

		btn_y0.label = "«";
		btn_y1.label = "»";
		btn_m0.label = "<";
		btn_m1.label = ">";
		btn_y0.size = btn_y1.size = btn_m0.size = btn_m1.size = [15];
		btn_y0.bold = btn_y1.bold = btn_m0.bold = btn_m1.bold = true;

		btn_y0.onClick = function() : void {
			_showDate.fullYear = _showDate.fullYear - 1;
			if(onChangeMonth != null){
				onChangeMonth(_showDate.time);
			}
		};
		btn_y1.onClick = function() : void {
			_showDate.fullYear = _showDate.fullYear + 1;
			if(onChangeMonth != null){
				onChangeMonth(_showDate.time);
			}
		};
		btn_m0.onClick = function() : void {
			_showDate.month = _showDate.month - 1;
			if(onChangeMonth != null){
				onChangeMonth(_showDate.time);
			}
		};
		btn_m1.onClick = function() : void {
			_showDate.month = _showDate.month + 1;
			if(onChangeMonth != null){
				onChangeMonth(_showDate.time);
			}
		};

		addChild(bgMC);
		addChild(_lab_y);
		addChild(_lab_m);
		addChild(btn_y0);
		addChild(btn_y1);
		addChild(btn_m0);
		addChild(btn_m1);
		addChild(dateMC);

		_ttfW.align = "center";
		for (var i : uint = 0; i < 7; i++) {
			var weekBtn : TextField = new TextField();
			weekBtn.setTextFormat(_ttfW);
			weekBtn.defaultTextFormat = _ttfW;
			weekBtn.selectable = weekBtn.multiline = weekBtn.wordWrap = false;
			weekBtn.text = _weekText[i];
			weekBtn.height = weekBtn.width = _pickerSize[0];
			weekBtn.border = true;
			weekBtn.borderColor = bgColorArr[7];
			weekArr.push(addChild(weekBtn));
		}
	}

	public function set canChange(boo : Boolean) : void {
		_canChange = boo;
	}

	private function show() : void {
		for (var k : uint = 0; k < 7; k++) {
			var tt : TextField = weekArr[k] as TextField;
			tt.y = _spacing * 2 + 25;
			tt.x = _spacing + k * (_pickerSize[0] + _spacing);
			tt.width = _pickerSize[0];
		}
		var d : Date = new Date();
		var nowDate : Date = new Date();
		dateMC.removeChildren();
		d.time = 0;
		d.fullYear = _showDate.fullYear;
		d.month = _showDate.month;
		d.date = 1;
		_lab_y.text = _showDate.fullYear.toString();
		_lab_m.text = (_showDate.month + 1).toString();
		if (_lab_y.text == "1970") {
			btn_y0.visible = false;
			btn_m0.visible = _lab_m.text != "1";
		} else {
			btn_m0.visible = btn_y0.visible = true;
		}
		if (_sundayStart) {
			var startDay : Number = 0;
		} else {
			startDay = 1;
		}
		var i : int = 0;
		if (d.day == startDay) {
			i = -1;
		}
		do {
			if (startDay == d.day) {
				i++;
			}
			var newD : DatePickerDate = new DatePickerDate();
			newD.label = d.date.toString();
			newD.size = _pickerSize;
			if (_sundayStart) {
				newD.x = _spacing + (_spacing + _pickerSize[0]) * d.day;
			} else {
				var td : uint = d.day == 0 ? 6 : d.day - 1;
				newD.x = _spacing + (_spacing + _pickerSize[0]) * td;
			}
			newD.y = (_spacing + _pickerSize[1]) * i;
			if (d.date == nowDate.date && d.fullYear == nowDate.fullYear && d.month == nowDate.month) {
				newD.border = true;
			}
			if (_date != null) {
				if (d.date == _date.date && d.fullYear == _date.fullYear && d.month == _date.month) {
					newD.selected = true;
				}
			}
			newD.bgBorder = true;
			newD.date = d.date;

			if (_canChange) {
				newD.onClick = function(evt : MouseEvent) : void {
					var obj : Object = evt.target;
					do {
						try {
							if (obj is DatePickerDate) {
								break;
							} else {
								obj = obj["parent"];
							}
						} catch (err : Error) {
							break;
						}
					} while (true);
					var item : DatePickerDate = obj as DatePickerDate;
					var da : Date = new Date();
					da.fullYear = Number(_lab_y.text);
					da.month = Number(_lab_m.text) - 1;
					da.date = item.date;
					if(onSelected != null){
						onSelected(da.time);
					}
				};
			} else {
				newD.enabled = false;
			}

			dateMC.addChild(newD);
			d.time += 86400000;
		} while (_showDate.month == d.month);
		_lab_y.y = _lab_m.y = _spacing + 3;
		btn_y0.x = btn_y0.y = btn_y1.y = btn_m0.y = btn_m1.y = _spacing;
		btn_m0.x = _spacing + 20;
		dateMC.y = _spacing * 3 + 50;
		bgMC.width = dateMC.width + _spacing * 2;
		bgMC.height = dateMC.y + dateMC.height + _spacing;
		btn_y1.x = bgMC.width - _spacing - 15;
		btn_m1.x = bgMC.width - _spacing - 35;
		_lab_y.x = bgMC.width / 2;
		_lab_m.x = bgMC.width / 2 - 25;
	}

	public function set showDate(d : Date) : void {
		_showDate.time = d.time;
		show();
	}

	public function set date(d : Date) : void {
		if (d != null) {
			if (_date == null) {
				_date = new Date();
			}
			_date.time = d.time;
		} else {
			_date = null;
		}
		showDate = _showDate;
	}

	public function get date() : Date {
		return _date;
	}

	public function set weekLabels(arr : Array) : void {
		if (arr.length == 7 || arr.length == 14) {
			_weekText = arr;
		}
		for (var i : uint = 0; i < 7; i++) {
			if (_sundayStart) {
				weekArr[i]["text"] = _weekText[i]["toString"]();
			} else {
				var num : uint = i == 6 ? 0 : i + 1;
				weekArr[i]["text"] = _weekText[num]["toString"]();
			}
		}
	}

	public function get weekLabels() : Array {
		return _weekText;
	}

	public function set sundayStart(boo : Boolean) : void {
		_sundayStart = boo;
		weekLabels = [];
	}

	public function get sundayStart() : Boolean {
		return _sundayStart;
	}

	public function set pickerSize(sz : Array) : void {
		_pickerSize[0] = int(sz[0]) > 0 ? uint(sz[0]) : _pickerSize[0];
		_pickerSize[1] = int(sz[1]) > 0 ? uint(sz[1]) : _pickerSize[1];
		show();
	}

	public function get pickerSize() : Array {
		return _pickerSize;
	}

	public function get spacing():uint{
		return _spacing;
	}

	public function set spacing(sp:uint):void{
		_spacing = sp;
		show();
	}
}
}