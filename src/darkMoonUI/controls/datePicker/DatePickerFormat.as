package darkMoonUI.controls.datePicker {
/**
 * @author moconwu
 */
public final class DatePickerFormat extends Object {
	//Y:{yyyy},{yy}
	//M:{mm},{m}
	//D:{dd},{d}
	//W:{ww},{w}
	public static const YEAR_FULL : String = "{yyyy}";
	public static const YEAR_SHORT : String = "{yy}";
	public static const MONTH_FULL : String = "{mm}";
	public static const MONTH_SHORT : String = "{m}";
	public static const DATE_FULL : String = "{dd}";
	public static const DATE_SHORT : String = "{d}";
	public static const WEEK_FULL : String = "{ww}";
	public static const WEEK_SHORT : String = "{w}";

	public static const ISO_8601_FULL_YEAR_START : String = "{yyyy}-{mm}-{dd}";
	public static const ISO_8601_FULL_YEAR_END : String = "{mm}-{dd}-{yyyy}";
	public static const ISO_8601_SHORT_YEAR_START : String = "{yyyy}-{m}-{d}";
	public static const ISO_8601_SHORT_YEAR_END : String = "{m}-{d}-{yyyy}";

	public static const SLASH_FULL_YEAR_START : String = "{yyyy}/{mm}/{dd}";
	public static const SLASH_FULL_YEAR_END : String = "{mm}/{dd}/{yyyy}";
	public static const SLASH_SHORT_YEAR_START : String = "{yyyy}/{m}/{d}";
	public static const SLASH_SHORT_YEAR_END : String = "{m}/{d}/{yyyy}";

	public static const SPACE_FULL_YEAR_START : String = "{yyyy} {mm} {dd}";
	public static const SPACE_FULL_YEAR_END : String = "{mm} {dd} {yyyy}";
	public static const SPACE_SHORT_YEAR_START : String = "{yyyy} {m} {d}";
	public static const SPACE_SHORT_YEAR_END : String = "{m} {d} {yyyy}";

	public static const COMMA_FULL_YEAR_START : String = "{yyyy},{mm},{dd}";
	public static const COMMA_FULL_YEAR_END : String = "{mm},{dd},{yyyy}";
	public static const COMMA_SHORT_YEAR_START : String = "{yyyy},{m},{d}";
	public static const COMMA_SHORT_YEAR_END : String = "{m},{d},{yyyy}";

	public static const WORD_ZH_JA_FULL_YEAR_START : String = "{yyyy}年{mm}月{dd}日";
	public static const WORD_ZH_JA_FULL_YEAR_END : String = "{mm}月{dd}日{yyyy}年";
	public static const WORD_ZH_JA_SHORT_YEAR_START : String = "{yyyy}年{m}月{d}日";
	public static const WORD_ZH_JA_SHORT_YEAR_END : String = "{m}月{d}日{yyyy}年";

	public static const WORD_KR_FULL_YEAR_START : String = "{yyyy}년{mm}월{dd}일";
	public static const WORD_KR_FULL_YEAR_END : String = "{mm}월{dd}일{yyyy}년";
	public static const WORD_KR_SHORT_YEAR_START : String = "{yyyy}년{m}월{d}일";
	public static const WORD_KR_SHORT_YEAR_END : String = "{m}월{d}일{yyyy}년";

	public static const WORD_EN_FULL_YEAR_START : String = "{yyyy} year {mm} month {dd} day";
	public static const WORD_EN_JP_FULL_YEAR_END : String = "{mm} month {dd} day {yyyy} year";
	public static const WORD_EN_JP_SHORT_YEAR_START : String = "{yyyy} year {m} month {d} day";
	public static const WORD_EN_JP_SHORT_YEAR_END : String = "{m} month {d} day {yyyy} year";
}
}