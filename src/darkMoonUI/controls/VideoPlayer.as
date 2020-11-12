package darkMoonUI.controls {
import darkMoonUI.types.ControlType;
import darkMoonUI.assets.DarkMoonUIControl;
import darkMoonUI.assets.colors.bgColorArr;
import darkMoonUI.assets.functions.fill;
import darkMoonUI.controls.regPoint.RegPointAlign;
import darkMoonUI.functions.__init__;
import darkMoonUI.functions.parentAddChilds;

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.NativeWindow;
import flash.display.NativeWindowInitOptions;
import flash.display.NativeWindowSystemChrome;
import flash.display.NativeWindowType;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.NativeWindowBoundsEvent;
import flash.events.NetStatusEvent;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.utils.ByteArray;
import flash.utils.Timer;

public class VideoPlayer extends DarkMoonUIControl {
	private var
	_bg : Shape = new Shape(),
	_control_bg : Shape = new Shape(),
	_control_sp : Sprite = new Sprite(),
	_btn_play : IconButton = new IconButton(),
	_btn_stop : IconButton = new IconButton(),
	_btn_left : IconButton = new IconButton(),
	_btn_right : IconButton = new IconButton(),
	_btn_loop : IconButton = new IconButton(),
	_btn_full : IconButton = new IconButton(),
	_btn_audio : IconButton = new IconButton(),
	_slider : Slider = new Slider(),
	_video_sp : Sprite = new Sprite(),
	_video : Video = new Video(),
	_video_path : String,
	_auto_play : Boolean = true,
	_cbb_lvl : ComboBox = new ComboBox(),
	_txt_time : SimpleLabel = new SimpleLabel(),

	_video_width : uint = 0,
	_video_height : uint = 0,

	_time_now : uint = 0,
	_time_all : uint = 0,
	_playing : Boolean = false,
	_loop : Boolean = false,

	nConection : NetConnection,
	nStream : NetStream,
	nProcess : NativeProcess,
	process0 : NativeProcess,

	timer : Timer,

	play_ok : Boolean = false,
	check_timer : Timer = new Timer(500, 1),
	checked_err : Boolean = false,

	_full_screen : Boolean = false,

	_click_timer : Timer = new Timer(260, 1),
	_is_click : Boolean = false,
	_click_time : uint = 0,

	_canFullScreen : Boolean = true,

	_autoHideController : Boolean = false,

	_autoHideControllerOnFullScreen : Boolean = false,

	_has_audio : Boolean = true,

	_old_playing : Boolean = false,

	sndTrans : SoundTransform = new SoundTransform(),

	_slider_sz0 : int = 0,

	_root_parent : DisplayObjectContainer,
	_old_x : int,
	_old_y : int,
	_old_sz : Array,
	appWin : NativeWindow,
	_lab_info : SimpleLabel = new SimpleLabel(""),
	_info_timer : Timer = new Timer(800, 1)
	;

	private static const
	lvl_arr : Vector.<String> = Vector.<String>(["中清", "高清", "超清"]),
	lvl_bit : Vector.<Object> = Vector.<Object>([
		{
			"smoothing": false,
			"preset": "ultrafast",
			"crf": "20",
			"bv": "1500k",
			"ba": "128k",
			"ar": "22050"
		},
		{
			"smoothing": true,
			"preset": "fast",
			"crf": "18",
			"bv": "2400k",
			"ba": "192k",
			"ar": "44100"
		},
		{
			"smoothing": true,
			"preset": "slower",
			"crf": "15",
			"bv": "4800k",
			"ba": "320k",
			"ar": "48000"
		}]),
	ffmpeg : File = File.applicationDirectory.resolvePath("tools/ffmpeg/ffmpeg.exe"),
	ffprobe : File = File.applicationDirectory.resolvePath("tools/ffmpeg/ffprobe.exe"),
	_control_size : uint = 20,
	_control_cbb_size : uint = 36,
	bmp_b64_loop : String = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAERElEQVR4nATg/5/M9f//7x8zO2QjEYqqKJCqBUJVFaGKUJsqAAAAALAWAAAAAAAAAAAAYAAAAAAArN1OAQAAAAAAAAAAAAAAAAAAAIAQAAAAAAAAAAAAAAAAAAAAQAgAAAAAAAAAAAAAAAAAAAAgBAAAAAAAAAAAAAAAAAAAABACAAAAAAAAAAAAAAAAAAAACAEAAMycOTMyc+bMWePj4yMAAAAAAAAAEhIS7uXJk+cMEgAAAEIAALBu3bokqVOnDgcCgUwAAAAAAAAAAOFw+GRcXFypXLlyHQAAgBAAACRNmjRNIBDIBAAAAAAAAAAAwWAwc6JEiWYgGxIAAEIAAJA3b96L4XC4PoohCAAAAAAAAICcwWAwVSAQyLpjx44M+fLlOwsAEAIAAIiKihqEQQAAAAAAAAAQDodXoAgkSpQoOQAAhAAAAAAAAAAAAAAAAAAAAABCAAAAAAAAAAAAAAcOHCgYCARSQSAQSAsQERFROBwOZ4GnT5+uzZcv320IAQAAAAAAAAAAQExMTCgQCCwIBoPJAAAiIiJ6AURGRtbFEAgBAAAAAAAAAABAbGxsXHR0dNGEhISlgUAgKQAAxMfHz962bdtIgBAAAABs3749ef78+R8AAAAAAEBUVNTGcDhcEgsDgUAkAMTHx8+aM2dO6djY2DiAEAAAxMTEhKKjo6cEAoFi4XC4RFRU1GoAAAAAAIiKilodDoeLY2EgEIiE+Pj4WXPmzCkdGxsbBwAhAICYmJhQdHT01GAwWAqwMBwOF4+KiloNAAAAAABRUVGrw+FwcSxISEhYPGfOnDKxsbFxAAAhAIiJiQlFR0dPDQaDpQACgUAkFobD4eJRUVGrAQAAAAAgKipq9fbt29Plz5//AQAAQAigVKlSEdHR0ROCwWApAIBAIBCJheFwuHhUVNRqAAAAAADInz//AwAAAAgBtGvXrmYwGCwNAAAQCAQiExIS5sXExKSMjY2NAwAAAAAAAAAACAE8ffp0emRk5A1ISEhIHxER0QsSEhLCCQkJnSE+Pv5WbGxsHAAAAAAAAAAAAIQA8uXLdxuzYO/evdkjIiJAQkLCtaioqFkAAAAAAAAAAAAAACEAAAAAAAAAAAAAAAAAAACAEAAAxMXFPUycODFA7nA4vAoAAAAAAAAA8fHx8Uty5MgxEAAAQgAAkDdv3rPhcPhEMBjMEgwGU6EQAAAAAAAAAASDwSI7d+6clzdv3osAACEAAEDCy5cvSyVKlGhWMBjMAgAAAAAAAACQkJBw/PHjxzcBACAEAACQO3fuMLLu3r07YyAQSAEAAAAAAAAQDAZf3bt371iBAgWeAQBACAAAACBPnjynAQAAAAAAAAAAAAAgBAAAAAAAAAAAAAAAAAAAABACAAAAAAAAAAAAAAAAAAAACAEAAAAAAAAAAAAAAAAAAACEAAAAAAAAAAAAAAAAAAAAAP4PAAD//xfT8pz9keofAAAAAElFTkSuQmCC",
	bmp_b64_loop0 : String = "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",
	bmp_b64_stop : String = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAC10lEQVR4nATgbd+NZd/3bU+DoVJVVQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWPsEAAAAAAAAAAAAAAAAAAAAAIIAAAAAAAAAAAAAAAAAAAAAQQAAAAAAAAAAAAAAAAAAAIAgAAAAAAAAAAAAAAAAAAAAQBAAAAAAAAAAAAAAAAAAAAAgCAAAAAAAAAAAAAAAAAAAABAEAAAAAAAAAAAAAAAAAAAACAIAAACcPn06TahQoYqHhISEBQAAAACAQCDw8fv372tSpUp1EgAAAIIAAABw6tSp1KFChToUCATCBAIBAAAAAAAAoUOH7nry5MkMqVOnPgUAABAEAACA0KFDlwgEAmEAAAAAAAAAAoFAmGAwWBKnAAAAggAAABASEhI2EAgAAAAAAAAAgJCQkLAAAAAQBAAAAAAAAAAAAAAAAAAAAAgCAAAAAAAAAAAAAAAAAAAABAEAAAAAAAAAAAAAAAAAAACCAAAAAAAAAAAAAAAAAAAAAEEAAAAAAAAAAAAAAAAAAACAIAAAAAAAAAAAAAAAAAAAAEAQAAAAAAAAAAAAAAAAAAAAIAgAAAAAAAAAAAAAAAAAAAAQBAAAAAAAAAAAAAAAAAAAAAgCAAAAAAAAAAAAAAAAAAAABAEAAAAAAAAAAAAAAAAAAACCAAAAEAgEPgIAAAAAAAAABAKBjwAAABAEAACAb9++rQ4Gg10DgUAYAAAAAAAACAkJ+fr169dVAAAAEAQAAIDUqVOfOnnyZIZgMFgyJCQkLAAAAAAABAKBj1+/fl2VJk2a0wAAABAEAAAASJ069SmcAgAAAAAAAAAAAAAIAgAAAAAAAAAAAAAAAAAAAAQBAAAAAAAAAAAAAAAAAAAAggAAAAAAAAAAAAAAAAAAAABBAAAAAAAAAAAAAAAAAAAAgCAAAAAAAAAAAAAAAAAAAABAEAAAAAAAAAAAAAAAAAAAAOD/AAAA///tazmAMRWoFgAAAABJRU5ErkJggg==",
	bmp_b64_play : String = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADgElEQVR4nATgbZ/O9f/3bS8zViJVqqqoAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAADAAAAAICZHkEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAACAAAAADAkiVLIlWoUOEzAAAAAAAAAAAAAAQAAAAATp8+PSk4OLjemTNn1nz48KFdhgwZrgMAAAAAAAAAAEAAAAAAIDg4uE5QUFAElI4cOXLhM2fOjLh///6AggULvgMAAAAAAAAAgAAAAABAUFBQRIDg4ODI6BI9evRap0+f7hwSEjIX4QAAAAAAAAAQAAAAAAAAgODg4BiYfebMmWZhYWEtQkJCDgEAAAAAAAAEAAAAAAAAACAoKCh9cHDwgdDQ0Hnv379vnylTpkcAAAAAAAABAAAAAAAAAICgoKCgoKCg6lGjRi0eGho66OLFiyMrVKjwGQAAAAAgAAAAAAAAAAAAEBQUFC0oKGhQ4sSJ64SGhrZOmTLlBgAAAAAIAAAAAAAAAAAAAAQHByfE+tDQ0NUfP35sniFDhjsAAAAQAAAAAAAAAAAAAAAIDg4uGSVKlLhICQAAAAEAAAAAAAAAAAAAAEA4AAAAQAAAAAAAAAAAAAAAICwsbPXHjx+bAwAAAAQAAAAAAAAAAAAAwsLCLqN1ypQpNwAAAABAAAAAAAAAAAAAIDw8/GV4ePigixcvjqxQocJnAAAAAIAAAAAAAAAAAEB4eHhYeHj4/Pfv37fPlCnTIwAAAAAAgAAAAAAAAAAAhIeHHw0LC2sREhJyCAAAAAAAACAAAAAAAAAAYWFh98PDwzuHhITMRTgAAAAAAAAABAAAAADCw8O/BAUFRYSwsLCPQUFBIx48eDCgYMGC7wAAAAAAAAAAIAAAAACA6eHh4fWw9uPHj+0yZMhwHQAAAAAAAAAAAAIAAAAAKVKkaDx58uQWDRs2/AIAAAAAAAAAAAAAAQAAAABo2LDhFwAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAA/B8AAP//7vigOZWU/nkAAAAASUVORK5CYII=",
	bmp_b64_pause : String = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADKElEQVR4nATg3ZqNZ9u2XbcqnQRJEkkCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKCyBAEAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAABAAAAAAgNOnTycLDg4ui/Dw8+fP8wMGDFi0bNmyH1ChQoVQ3bp1qxocHJwM8OH79+8r0qZNexEAAAAgAAAAAHDixIn4oUKFOhoUFBQOIDg4WM+ePTMsW7asFfTo0WNUcHBwCwAIHTp05+PHj6dMnz79DQAAAAgAAAAAhA4dukhQUFA4AICQkJDyaAUoBwAQFBQULkyYMEUxDgAAAAIAAAAACAcAAEFBQWEBgoKCwgIAAMIBAAAABAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAACAAAAAAAA+AgAAPgKEhIR8CgoKigAAgI8AAAAAAQAAAIBv375tChMmzMegoKBwABASErIMICgoaDlaAkBISMiHz58/bwAAAAAIAAAAAKRLl+76yZMnMwQCgXIIHxISEhIUFHR+xYoViwCWL1/epkyZMseCg4OTA95/+/ZtRcaMGW8CAAAABAAAAAAgbdq0F3ERAACgT58+P/v06TMfAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAD4PwAA//8sQF8UBR2s8wAAAABJRU5ErkJggg==",
	bmp_b64_left : String = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAD6klEQVR4nATgbZ/N9f//b29rzQKlVEoqgaqqaoACAAAAAAAAAAAAAAAAAAAAAAAAYAYAAAAAAKZbAAAAAAAAAAAAAAAAAAAAACAEAAAAAAAAAAAAAAAAAAAAEAIAAAAAAAAAAAAAAAAAAAAIAQAAAAAAAAAAAAAAAAAAAIQAAAAAAAAAAAAAAAAAAAAAQgAAAAAAAAAAAAAAAAAAAAAhAAAAAAAAAAAAAAAAAAAAgBAAAAAAAADAkSNHCoSFhaV4+/btnNSpU18AANi3b1/cmDFjVgsEAvcXLVo0vVu3bh8BACAEAAAAAAAAx44dGxAIBFpC9OjRayApogD27duXJFasWFuCwWAiKF68eKxu3bqNAQCAEAAAAAAAwLFjxwYEAoGWAMFgMPGWLVviZMuW7THs378/aaxYsbYEAoGEAIFAIDkAAEAIAAAAAAAiIiJ6BwKBlgAAoVAoAIcPH04ULVq0jYFAICEAAAAAQAgAAAAAICIiondYWFg7AACAw4cPJ4oWLdqWQCCQBAAAAAAAQgAAAAAQERHROywsrB0AAEDs2LEThUKhxYFAIAkAAAAAAEAIAAAAICIiYmBYWFgLAAAACIVC6wKBQDwAAAAAAAAIAQAAQERERO+wsLAWAAAAAIFAIB4AAAAAAABACAAAICIion5YWFg7AAAAAAAAAAAAAACAEAAAQFRU1EcAAAAAAAAAAAAAAAAIAQAAJE+efGxkZGSCYDDYAQAAAAAAAAAAAAAAQgAAABAeHt4xMjIyFAwG2wAAAMDHjx9vB4PB+AAAAAAAABACAAAACA8PbxsZGfk+GAx2AAAAeP/+fd5o0aItDgQCSQEAAAAAAEIAAAAAEB4e3jEyMjIqGAx2BACAFy9eXI0VK1a2GDFibAkEAkkBAAAAACAEAAAAABAeHt4pMjJSMBjsCAAAqVOnvnrw4MFsMWLE2BIIBJICAAAAAIQAAAAAACA8PLxTZGRktGAw2AYA3r9/HwWpU6e+euTIkRxhYWFbgsFgYgAAAAAIAQAAAAAAhIeHt42IiIgKCwtrC1FRUZeyZcv2BCBFihSXjxw5kg1bgsFgYoiKijoKAAAQAgAAAAAAgGTJkrWLiIjYhlRv3ryZgygASJEixeUdO3akjBMnTvWoqKj7ixcvngEAABACAAAAAAAASJYs2VqsBQAAyJQp0yMMAgAAAAgBAAAAAAAAAAAAAAAAAAAAhAAAAAAAAAAAAAAAAAAAAABCAAAAAAAAAAAAAAAAAAAAACEAAAAAAAAAAAAAAAAAAACAEAAAAAAAAAAAAAAAAAAAAEAIAAAAAAAAAAAAAAAAAAAA4P8AAAD//76/q1bVvtCEAAAAAElFTkSuQmCC",
	bmp_b64_right : String = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAD9UlEQVR4nATgbZ/N9f//b28zs0ypSiKpCqWqKrNSAsAAAAAAAAAAAAAAAAAAAAAAAABmAAAAAAAw0y0EAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAACAAAAAQOfOnUOLFy9eCQkeP348KVOmTA8BAA4cOJA8PDy8bGxs7IFgMLgGAAAAAAAAAgAAAMWKFasTGho6EuLFi9fg8OHDkSlTprwEgJDw8PCNoaGhSSEqKqpPMBhsCwAAAAAAEAAAAAgJCQkChIaGJsPmw4cPR6ZMmfISbN68OV5oaGhSgLCwsDbR0dEhERERbQAAAAAAIAAAAAAAEBoamiwkJGTrvn37IlOnTn0hEAiEAACEhoa2joqKCgSDwRYAAAAAAAEAAAAAAAgJCUkSN27czfv27Yt8/fr1QwAACAsLax4VFSUYDLYAAAAAgAAAAAAAAEBISEiSuHHjbg4LCysGAAAQFhbWPCoqSjAYbAEAAAAQAAAAAAAAgJCQkCRx4sRZAQAAAGFhYc2jo6PfRUREtAEAAIAAAAAAAAAAQGhoaGIAAACA0NDQ1lFRUYFgMNgCAAAgAAAAAAAAAAAAAAAAEBYW1jw6OvpsRETEWAAACAAAAAAAAAAAAAAAAEBsbGwoAABAAAAAAAAAAAAAAAAAICYmZnAwGBwNAAAQAAAAAAAAAIiNjb0TEhKSCAAAAN6/fz8wGAy2AAAAgAAAAAAAAADExMRcfffuXbHw8PD9AAAAMTExg4PBYAsAAACAAAAAAAAAQExMzNU3b95Evnz58kF4eDgAAHj//v2gYDDYHAAAAAACAAAAAAAQExNz9c2bN5GpUqU6v3379vgAAPD+/ftBwWCwOQAAAABAAAAAAAAgNjb2yqtXryJTp059Ad69excLABAbGzsgGAy2BAAAAACAAAAAQGxsbBRATEzM5ZcvX0amSZPmIkBkZOTj6Ojoy6GhoUkhNjZ2QIoUKVoCAAAAAAAEAAAAFi1aNKZYsWLPQ0JCEj579mxy+vTpHwAAYt+8eZM9Tpw4ZUJCQg5FRESsBgAAAAAAgAAAAEDXrl1junbtOhUAAABSpUp1Hj0BAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAACA/wMAAP//0FnKAPlPZGMAAAAASUVORK5CYII=",
	bmp_b64_audio : String = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAE10lEQVR4nATgbZ+N9f//72/7sggxUpKoqFQgppFhJEoqUVJEoiChpKooEEaSAAAAAACAAQAGWBgAAAAAAMzqFgAAAAAAAAAAAAAAAAAAAACEAQAAAAAAAAAAAAAAAAAAAMIAAAAAAAAAAAAAAAAAAAAAYQAAAAAAAAAAAAAAAAAAAIAwAAAAAAAAAADAtm3b4kOhUPG7d+/OjI+PPwEAAAAAEAYAAAAAAACASCSSEBcXlwyhUCh3KBTqnSFDhu47duwYfefOnXbx8fEnAAAAAMIAAAAAAAAAkUgkIRwOJyELAARBEEa99OnTV922bVuD2NjYSQAAABAGAAAAAACASCSSEA6Hk0KhUAzA0aNH5+XOnbtOEATNQqFQwVAoFBMEwYSUlJRshQsX7gcAABAGAAAAAACIRCIJ4XA4KRQKxQBApUqVbmNU27Ztx1WpUqV5EASJQRCE0Gfbtm0XYmNjJwMAQBgAAAAAACKRSEI4HE4KhUIxAAAAiYmJDxMTEzts3779UCgUGhsEQShNmjQD161bt7ZkyZKnAADCAAAAAACRSCQhHA4nhUKhGAAAWLt2bfZFixZdTkxMfAhFihSZkJKSkjcIgvZBEGTNlClTR9QGAAgDAAAAQCQSSQiHw0mhUCgGAAAgc+bMZapWrdqsYsWKleLj489CcnJyp4SEhOqhUKhgEAQ1Nm7c2Do+Pv4EAIQBAHbu3BkFAAAAAAAACIKgWPr06WfOnz+/TIUKFe41bNjwQUpKSleMCIIgbfr06auiBwCEAQAAAAAAAAAAAEKhUPFcuXLVwjC4fv36tCxZsgwJgiCMcugBAGEAAAAAAAAAAAAACIVCdTEMSpUqdSMlJWVnEASxQRDkAwAIAwAAAAAAAAAAAEA0Gs0HADiNWOQAAAgDAAAAAAAAAAAAAAAAAohGo6kAAGEAAAAAAAAAAAAACIJgLwAgJwRBcB4AIAwAAAAAAAAAAAAAjx49Gg6wfv36mCAICgL2AACEAQAAAAAAAAAAAFJTU9fv379/LEDGjBmrBEEQhtTU1CUAAGEAgEKFCgUAAJFIJCEcDieFQqEYAAAAiEajyTdu3KhcrVq1+zBo0KC0aArRaPT+nTt3pgIAhAEAAAAgLi4uORKJlA+Hw0mhUCgGAACuXr26ok+fPtOnTJnyCKBkyZItgyAoANFodHyJEiVOAgCEAQAAAADi4uKSI5FI+XA4nBQKhWIAAEqXLn0BAFJSUmqiDUSj0csPHz5sBQAAYQAAAAAAiIuLS45EIuXD4XBSKBSKAQCAQYMGpU1ISGgRBEHbIAhC0Wg0NRqNNoqLizsNAABhAAAAAACAuLi45EgkUj4cDieFQqEYgNmzZ2fMkydP9SAImgVBkB+i0Wj00aNHjWNjY6cAAACEAQAAAAAAIC4uLnnLli1l06VLtxggT548FUOh0HCA1NTU66gfGxs7BQAAAMIAAAAAAAAARYsW3RKJRCoCAESj0QfRaHTU7du3E0uUKHESAAAAIAwAAAAAAAAAcXFxyQCpqanH0OTmzZszSpYseQoAAAAAIAwAAAAAAAAAABAbG7sRGwEAAAAAAMIAAAAAAAAAAAAAAAAAAAAAYQAAAAAAAAAAAAAAAAAAAIAwAAAAAAAAAAAAAAAAAAAAwP8BAAD//+OaLcvl08GMAAAAAElFTkSuQmCC",
	bmp_b64_audio0 : String = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAFzklEQVR4nATg/3/P9f///x9vt/sdiCKZFFWpWqndZhEgzVCKUqJAVQVJUSmoQFUUUVVKIAKLQiliRqSUZrcZKVWSKioAwHbvEAAAAAAAAAAAAAAAAAAAAAAkAQAAAAAAAAAAAAAAAAAAAJIAAAAAAAAAAAAAAAAAAAAASQAAAAAAAAAAAAAAAAAAAIAkAABAfn5+lezs7H0AAAAAAAAAAAAAAABJAACI47hvGIbD4jhuFUVRMQAAAADEcTwgCIIGqVRqZhRFSwEAAAAAkgAA+fn5VcIwHBYEQY0wDPPiOM6JoqgYAADiOB4RRdEIQJUwDLui66ZNm9aVlpb2jqKoGAAAACAJAJCdnb0vjuNWYRjmBUGQFoZhXhzHOVEUFQNAHMcjEonEcIyAIAi2lZaWHgzDsHIQBE3CMFxfVFTUMyMjYzYAAAAkAQAgiqLiOI5zwjDMC4IgLQzDvDiOc6IoKoaioqKuYRgOB4CMjIxZa9euXVy5cuUhYRgODIKgImYUFhaWZGZmzgMAAEgCAABEUVQcx3FOGIZ5QRCkhWGYF8dxThRFxVu3bp2fnp7eJQzDdgDQrFmzgxhaUFCwrEyZMguDIKgShuH0goKCTVlZWVsAACAJAAAAURQVx3GcE4ZhXhAEaWEY5sVxnBNFUXFubm7H9PT0BQAAkJWVtbqgoKBDmTJllodhWD6ZTE5BYwAASAIAAABEUVQcx3FOGIZ5QRCkhWGYF8dxThRFxbm5uR0B4jjun0qldmVmZs6FrKys1XEcj0skEoPDMGy0cePG1vXq1VsOAJAEACgoKIiSyeRYAIBUKrU/CIK0IAjSwjDMi+M4J4qiYgBUTSQS4wsLC1OZmZnzYM+ePWOqVavWLwzDSolEoieWAwAkAQCCIKgahmErAAAACIIgLQzDvDiOc6IoKoYgCI4EQRAkEomJ+fn5S7Kzsw9lZ2fvKyoqWoRuaDl8+PBw5MiRpQCQBAAAAAAAAAiCIC0Mw7w4jnOiKCreunXrhPT09OZhGLarVq1aJ0wDrEG3MAyrtW/fvtbIkSN3AEASAAAAAAAAAIIgSAvDcOWGDRty6tevvyk3N7djenp6biqVqgtQUlKyMwxDkEgkamAHACQBAAAAAAAAAIIgqF6uXLkVcRznRFFUnJub2zk9Pb0tQBAEIUAQBCEAQBIAAAAAAAAAIJVK7Q6CIC0Mw7w4jnOiKCrGIoAgCGoDHD9+fDcAQBIAAAAAAAAAoLS0NCcMw7wgCNLCMMyL4zgniqJigDAMcyCVSu1v2LDhdgCAJABAKpXaW1paugIAgiCoEARBUwAAiKKoOI7jnDAM84IgSAvDMC+O45woioohlUqVBEEglUotQwoAIAkAkJWVFaM1AEBRUdGgMAxHAwBAFEXFGzZsaFG2bNmVYRjWDMNw5YYNG3Lq16+/aevWrd3T09PLlpSUTAYAgCQAAAAAQEZGxpg4jiskEonhAABQv379rXEct0mlUnlBEKSVK1duRRzHOVEUFefm5nbu3LnzSQAASAIAAAAAQBRFI+I4lkgkhgMAQBRFxXEc5wRBsCoMw7QwDPPiOM6JoqgYAAAgCQAAAAAAEEXRiDiOJRKJ4QAA69evrxYEQa8gCKpCEARpYRjmxXGcE0VRMQAAJAEAAAAAACCKohFxHEskEsMBCgsLe4RhOCkMw/KQSqUOp1Kpo2EYpoVhmBfHcU4URcUAAEkAAAAAAACAKIpGxHEMIAiCOmEYlofS0tJlJSUlfVKpVMUyZcqsDIKgRhiGK/Lz89Ozs7P3AUASAAAAAAAAAKIoGgGAfaWlpXMwNSMjYwVAYWFhTiKRyCstLR2VnZ29DwAgCQAAAAAAAAAAEEXRBAAAyMzM3Jyfn5+enZ29DwAAkgAAAAAAAAAAAAAAAJCdnb0PAAAgCQAAAAAAAAAAAAAAAAAAAJAEAAAAAAAAAAAAAAAAAAAASAIAAAAAAAAAAAAAAAAAAAD8HwAA//++DbFPurrOLQAAAABJRU5ErkJggg==",
	bmp_b64_full : String = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAD70lEQVR4nATgbZ/N9f//b29rLCpQSVVNlWhKSiQAAAAAAAAAAAAAAAAAAAAAAAAADAAAAAAAMKtbAAAAAAAAAAAAAAAAAAAAACAIAAAAAAAAAAAAAAAAAAAAEAQAAAAAAAAAAAAAAAAAAAAIAgAAAAAAAAAAAAAAAAAAAAQBAAAAAAAAAAAAAAAAAAAAggAAAAAAAAAAAAAAAAAAAABBAAAAAAAAABg3blz0JEmSxAYAAADIlCnTE4QAACAIAAAAAAAAAOnSpcsSFha2AQAAAGDfvn3x06RJ8xAAAIIAAAAAAAAAAAAAAAAAAAAAQQAAAAAAAAA4c+bMrgQJEiQCgBgxYkSEhYXNDwsLiwsAAAAAQQAAAAAAAAAoXbr0a1wCiIyMjIgWLdqkQCAQNyoq6kVYWFhsAAAAgCAAAAAAAAAAAEBkZGREMBjcEggEwkOh0L2PHz9WDwsLWwkAAAAQBAAAAAAAAACAyMjIiGAwuCUQCISHQqF7Hz9+zI6XAAAAABAEAAAAAAAAAIiMjIwIBoNbAoFAeCgUuvfx48fsyZMnPxkZGZkAAAAAAIIAAAAAAAAAsHv37njBYHBLIBAID4VCd9+/f589RYoUpwAAAAAAIAgAANClS5dgiRIlssKVK1d2Fy5c+BUA7N69O1769OkfHT9+fEIoFKr3/v377ClSpDgFAAAAAAAQBAAAyJcvX8ywsLANEB4eHoELAJGRkRHBYHDL8ePHJyRNmrTbwYMHR6VMmfIBAJw/f/5u4sSJc8GRI0eeAQAABAEAAAAAACIjIyOCweCWQCAQHgqF6m3fvn10ypQp7wMAlC5d+jU2AgAAAAQBAAAAACAyMjIiGAxuCQQC4aFQ6F5UVFTOzJkz3wcAAAAAAACAIAAAAABAZGRkRDAY3BIIBMJDodC9qKioHMmSJTsBAAAAAAAAABAEAAAAgOjRo0cEAoEJgUAgPBQK3YuKisqRLFmyEwAAAAAAAAAAEAQAAAAAzAsEAnFCodDd9+/fZ0+RIsUpAAAAAAAAAACAIAAAAACEhYXFCYVCLz98+FDjw4cPb/bv358Q4M6dO3cKFy78CgAAAAAAACAIAAAAABAIBGJFjx59ZfTo0QFAggQJ8mMNAAAAAAAAQBAAAAAAAAAAAAAAAAAAAAAgCAAAkDZt2uc7duyIBwAAAHDq1KkXAAAAAAAAABAEAABAKFOmTI8BAAAAAAAAAAAAAACCAAAAAAAAAAAAAAAAAAAAAEEAAAAAAAAAAAAAAAAAAACAIAAAAAAAAAAAAAAAAAAAAEAQAAAAAAAAAAAAAAAAAAAAIAgAAAAAAAAAAAAAAAAAAADwfwAAAP//BTLRqMbkhHoAAAAASUVORK5CYII=",
	bmp_b64_full0 : String = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAD0ElEQVR4nATgbZ/N9f//b29rLKaqqkqVCqiqCGUAAAAAAAAAAAAAAAAAAAAAAAAABgYAAAAAYIyZbgEAAAAAAAAAAAAAAAAAAACAIAAAAAAAAAAAAAAAAAAAAEAQAAAAAAAAAAAAAAAAAAAAIAgAAAAAAAAAAAAAAAAAAAAQBAAAAAAAAAAAAAAAAAAAAAgCAAAAAAAAAAAAAAAAAAAABAEAAAAAAAAAIiIi6gQCgTzYkiJFigkAcPTo0USxYsXKlCJFijkAAABBAAAAAAAAAICQkJBUgUCgTHR09FMAOHr0aKJYsWJtDwQC8SMiIoIpU6acAQAAQQAAAAAAAAAAAAAIDw9PEAwGtwYCgYQxMTFPoqKiTgIAAAQBAAAAAAAAAAAAwsPDE4SGhm4PBAKJY2JinkRGRuYJCws7DAAAEAQAAAAAAAAAAIDw8PAEoaGh2wKBQOKYmJgnkZGRecLCwg4DAABAEAAAAAAAAAAAAAnjxImzIxAIJIqOjn4YFRWVOywsLAIAAAAgCAAAAAAAAAAAEBISkhdiYmKevH//Pn9YWFgEAAAAAAQBAAAAAAAAAAAAsDd27Nhljh8/XgYgJibmUsqUKScBAEAQAAAAAAAAAAAAIBAIFAoEAoUAIDo6ehsmAQBAEAAAAAAAAAAgOjr6SCAQWAQAAACBQOAUAABAEAAAICIiolYgEIgLAAAA0dHRe1KmTDkJkwAAAAAAAACCAAAAgUCgZUhISFIAAACIiYnpgd0AAAAAAAAAEAQAAAgEAvuio6NvAwDihYSEJAMAAAAAAAAAAIAgAABA8uTJawNAeHh4gtDQ0O0AAAAAAAAAAAAAQQAAAAA4evRoolixYm0PBAIJo6OjH+J+SEhIUgAAAAAAAAAACAIAAACEh4cnCAaDWwOBQMKYmJgn79+/zx87duyuSAoAAAAAAAAAAEEAAAAIDw9PEBoaui0QCCSOiYl5EhkZmScsLOzw8ePHAQAAAAAAAAAABAEAAMLDwxOEhoZuCwQCSWJiYp5ERkbmCQsLOwwAAAAAAAAAAAAQBAAAiBMnTotAIJAkOjr6YVRUVO6wsLAIAAAAAAAAAAAAAAgCAAAsWbKkTenSpUOjoqImpEqVKgIAcC8mJuYyngAAAAAAAAAABAEAAHr06BHVo0ePhgAAkCJFiroAAAAAAAAAAABBAAAAAAAAAAAAAAAAAAAAgCAAAAAAAAAAAAAAAAAAAABAEAAAAAAAAAAAAAAAAAAAACAIAAAAAAAAAAAAAAAAAAAAEAQAAAAAAAAAAAAAAAAAAAD4PwAA//8EKb9WAwWv2QAAAABJRU5ErkJggg=="
	;

	public function VideoPlayer(_video_path : String = null, _w : uint = 480, _h : uint = 270, _auto_play : Boolean = true)
	{
		super();
		_type = ControlType.VIDEO_PLAYER;

		fill(_bg.graphics, 10, 10, 0);
		fill(_video_sp.graphics, 10, 10, 0);
		fill(_control_bg.graphics, 10, 10, bgColorArr[1]);

		_video_sp.alpha = 0;

		_btn_loop.size = _btn_full.size = _btn_stop.size = _btn_play.size = _btn_audio.size = _btn_left.size = _btn_right.size = [_control_size, _control_size];

		_slider.size = [0, _control_size - 8];

		_control_bg.height = _control_size;

		_slider.buttonConvex = 2;
		_slider.buttonSize = 5;
		_slider.color = bgColorArr[11];
		_slider.drag = _cbb_lvl.canWheelChange = _slider.smooth = false;

		_txt_time.fontSize = 12;

		_btn_loop.showFocus = _cbb_lvl.showArrow = _cbb_lvl.showFocus = _btn_full.showFocus = _btn_stop.showFocus = _btn_play.showFocus = _btn_audio.showFocus = _btn_left.showFocus = _btn_right.showFocus = _slider.showFocus = false;

		_btn_stop.regPoint = _btn_play.regPoint = _btn_left.regPoint = _btn_right.regPoint = _slider.regPoint = RegPointAlign.LEFT_BOTTOM;
		_btn_loop.regPoint = _txt_time.regPoint = _cbb_lvl.regPoint = _btn_full.regPoint = _btn_audio.regPoint = RegPointAlign.RIGHT_BOTTOM;

		_cbb_lvl.size = [_control_cbb_size, _control_size];
		_cbb_lvl.fontSize = 11;

		_btn_stop.base64 = bmp_b64_stop;
		_btn_play.base64 = bmp_b64_play;
		_btn_left.base64 = bmp_b64_left;
		_btn_right.base64 = bmp_b64_right;
		_btn_audio.base64 = bmp_b64_audio;
		_btn_full.base64 = bmp_b64_full;

		var cbb_item : ComboBoxItem;
		for(var i : uint = 0; i < lvl_arr.length; i++){
			cbb_item = new ComboBoxItem(lvl_arr[i]);
			_cbb_lvl.addItem(cbb_item);
		}
		_cbb_lvl.selection = 1;

		_btn_stop.onClick = stop;

		_btn_play.onClick = function() : void {
			if(_playing){
				pause();
			}else{
				play();
				//nStream.resume();
			}
		};

		_btn_left.onClick = function() : void {
			pause();
			//nStream.step(10);
		};

		_btn_right.onClick = function() : void {
			pause();
			//nStream.step(10);
		};

		_cbb_lvl.onClick = function() : void {
			pause();
		};

		_cbb_lvl.onChange = function() : void {
			stop();
			play();
		};

		_btn_loop.base64 = bmp_b64_loop0;
		_btn_loop.onClick = function() : void {
			loop = !_loop;
			showLabel("循环播放: " + (_loop ? "开启" : "关闭"));
		};

		_btn_audio.onClick = function() : void {
			_has_audio = !_has_audio;
			if(_has_audio){
				sndTrans.volume = 1;
				_btn_audio.base64 = bmp_b64_audio;
			}else{
				sndTrans.volume = 0;
				_btn_audio.base64 = bmp_b64_audio0;
			}
			nStream.soundTransform = sndTrans;
		};

		_btn_full.onClick = function() :void {
			_full_screen = !_full_screen;
			_old_playing = _playing;
			if(_full_screen){
				pause();
				_root_parent = mc.parent;
				_old_x = mc.x;
				_old_y = mc.y;
				_old_sz = size;
				var initOptions : NativeWindowInitOptions = new NativeWindowInitOptions();
				initOptions.systemChrome = NativeWindowSystemChrome.STANDARD;
				initOptions.type = NativeWindowType.NORMAL;
				//initOptions.owner = _root_parent.stage.nativeWindow;
				appWin = new NativeWindow(initOptions);
				__init__(appWin.stage, false);
				appWin.stage.color = 0;
				appWin.stage.addChild(mc);
				appWin.stage.displayState = StageDisplayState.FULL_SCREEN;
				appWin.addEventListener(NativeWindowBoundsEvent.RESIZE, appWin_resize);
				appWin.addEventListener(Event.CLOSE, appWin_close);
				appWin.activate();
				_root_parent.stage.nativeWindow.visible = false;
				appWin.visible = true;
				mc.x = mc.y = 0;
				size = [appWin.stage.stageWidth, appWin.stage.stageHeight];
				_btn_full.base64 = bmp_b64_full0;
				if(!_autoHideController && _autoHideControllerOnFullScreen){
					_control_sp.alpha = 0.0;
					_control_sp.addEventListener(MouseEvent.MOUSE_OVER, _control_over);
					_control_sp.addEventListener(MouseEvent.MOUSE_OUT, _control_out);
				}
				if(_old_playing){
					play();
				}
			}else{
				pause();
				appWin.close();
			}
		};

		_lab_info.visible = false;
		_lab_info.x = _lab_info.y = 10;
		_lab_info.fontSize = 16;
		_lab_info.color = 0xEEEE22;
		_lab_info.background = true;
		_lab_info.backgroundColor = 0x444444;
		_lab_info.alpha = .8;
		_info_timer.addEventListener(TimerEvent.TIMER, info_timer_comp);

		mc.mouseChildren = true;

		_click_timer.addEventListener(TimerEvent.TIMER, click_timer_func);
		check_timer.addEventListener(TimerEvent.TIMER, checked);
		parentAddChilds(_control_sp, Vector.<DisplayObject>([
			_control_bg, _btn_stop, _slider, _btn_audio, _btn_left, _btn_right, _cbb_lvl,
			_txt_time, _btn_loop, _btn_full, _btn_play
		]));

		addEventListener(Event.ADDED_TO_STAGE, added);

		parentAddChilds(mc, Vector.<DisplayObject>([
			_bg, _video, _lab_info, _video_sp, _control_sp
		]));

		create(0, 0, _w, _h, _video_path, _auto_play);
	}

	public function create(_x : int = 0, _y : int = 0, _w : uint = 480, _h : uint = 290, _video_path : String = null, _auto_play : Boolean = true) : void {
		this._auto_play = _auto_play;

		source = _video_path;

		size = [_w, _h];
		enabled = _enabled;
	}

	public function set level(k : int) : void {
		if(k >= _cbb_lvl.items.length){
			k = _cbb_lvl.items.length - 1;
		}
		if (k < 0) {
			k = 0;
		}
		_cbb_lvl.selection = k;
	}

	public function get level() : int {
		return _cbb_lvl.selection;
	}

	public function changeStage() : void {
		_btn_play.onClick();
	}

	private function showLabel(str : String) : void {
		_lab_info.label = str;
		_lab_info.visible = true;
		_info_timer.reset();
		_info_timer.start();
	}

	private function info_timer_comp(evt : TimerEvent) : void {
		_lab_info.visible = false;
	}

	private function click_timer_func(evt : TimerEvent) : void {
		if(_click_time == 1){
			_btn_play.onClick();
		} else {
			_btn_full.onClick();
		}
		_is_click = false;
	}

	private function appWin_close(evt : Event): void {
		_full_screen = false;
		_root_parent.addChild(mc);
		size = _old_sz;
		mc.x = _old_x;
		mc.y = _old_y;
		_btn_full.base64 = bmp_b64_full;
		_control_sp.alpha = _autoHideController ? 0.0 : 1.0;
		try{
			if(_old_playing){
				play();
			}
			if(!_autoHideController && _autoHideControllerOnFullScreen){
				_control_sp.alpha = 1.0;
				_control_sp.removeEventListener(MouseEvent.MOUSE_OVER, _control_over);
				_control_sp.removeEventListener(MouseEvent.MOUSE_OUT, _control_out);
			}
			_root_parent.stage.nativeWindow.visible = true;
			_root_parent.stage.nativeWindow.activate();
			focus = true;
		}catch(e:Error){
			stop();
		}
	}

	private function appWin_resize(evt:NativeWindowBoundsEvent):void{
		if(appWin.stage.displayState != StageDisplayState.FULL_SCREEN){
			_btn_full.onClick();
		}
	}

	private function video_click(evt : MouseEvent):void{
		if(_canFullScreen){
			if(!_is_click){
				_click_time = 0;
				_is_click = true;
				_click_timer.reset();
				_click_timer.start();
			}
			_click_time++;
		}else{
			_btn_play.onClick();
		}
	}

	private function added(ect : Event) : void {
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.nativeWindow.addEventListener(Event.CLOSE, main_win_closed);
	}

	private function main_win_closed(evt : Event) : void {
		if(nStream){
			nStream.dispose();
		}
		if(nProcess){
			nProcess.exit(true);
		}
		if(process0){
			process0.exit(true);
		}
	}

	public function stop() : void {
		pause();
		_time_now = 0;
		if(nStream){
			nStream.dispose();
		}
		if(nProcess){
			nProcess.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			nProcess.exit(true);
		}
		if(process0){
			nProcess.exit(true);
		}
		showLabel("停止");
		reset_lab_time();
	}

	public function pause() : void {
		_playing = false;
		if(nStream){
			nStream.pause();
		}
		_btn_play.base64 = bmp_b64_play;
		if(timer){
			timer.stop();
		}
		showLabel("暂停");
	}

	public function play() : void {
		_playing = true;
		if(_time_now != 0 && _time_now != _time_all){
			nStream.togglePause();
		}else{
			source = _video_path;
		}
		_btn_play.base64 = bmp_b64_pause;
		if(timer){
			timer.start();
		}
		showLabel("播放");
	}

	public function set loop(boo : Boolean) : void {
		_loop = boo;
		_btn_loop.base64 = _loop ? bmp_b64_loop : bmp_b64_loop0;
	}

	public function get loop() : Boolean {
		return _loop;
	}

	public function set showFast(boo : Boolean) : void {
		_btn_left.visible = _btn_right.visible = boo;
		_size_set();
	}

	public function get showFast() : Boolean {
		return _btn_left.visible;
	}

	public function set showStop(boo : Boolean) : void {
		_btn_stop.visible = boo;
		_size_set();
	}

	public function get showStop() : Boolean {
		return _btn_stop.visible;
	}

	public function set showPlay(boo : Boolean) : void {
		_btn_play.visible = boo;
		_size_set();
	}

	public function get showPlay() : Boolean {
		return _btn_play.visible;
	}

	public function set showAudio(boo : Boolean) : void {
		_btn_audio.visible = boo;
		_size_set();
	}

	public function get showAudio() : Boolean {
		return _btn_audio.visible;
	}

	public function set showFullScreen(boo : Boolean) : void {
		_btn_full.visible = boo;
		_size_set();
	}

	public function get showFullScreen() : Boolean {
		return _btn_full.visible;
	}

	public function set showTime(boo : Boolean) : void {
		_txt_time.visible = boo;
		_size_set();
	}

	public function get showTime() : Boolean {
		return _txt_time.visible;
	}

	public function set showQuality(boo : Boolean) : void {
		_cbb_lvl.visible = boo;
		_size_set();
	}

	public function get showQuality() : Boolean {
		return _cbb_lvl.visible;
	}

	public function set showController(boo : Boolean) : void {
		_control_sp.visible = boo;
		_size_set();
	}

	public function get showController() : Boolean {
		return _control_sp.visible;
	}

	public function set showLoop(boo : Boolean) : void {
		_btn_loop.visible = boo;
	}

	public function get showLoop() : Boolean {
		return _btn_loop.visible;
	}

	public function set canFullScreen(boo : Boolean) : void {
		_canFullScreen = boo;
		if(!boo){
			showFullScreen = false;
		}
	}

	public function get canFullScreen() : Boolean {
		return _canFullScreen;
	}

	public function set autoHideController(boo : Boolean) : void {
		_autoHideController = _autoHideControllerOnFullScreen = boo;
		if(boo){
			_control_sp.alpha = 0.0;
			_control_sp.addEventListener(MouseEvent.MOUSE_OVER, _control_over);
			_control_sp.addEventListener(MouseEvent.MOUSE_OUT, _control_out);
		}else{
			_control_sp.alpha = 1.0;
			_control_sp.removeEventListener(MouseEvent.MOUSE_OVER, _control_over);
			_control_sp.removeEventListener(MouseEvent.MOUSE_OUT, _control_out);
		}
		_size_set();
	}

	public function get autoHideController() : Boolean {
		return _autoHideController;
	}

	public function set autoHideControllerOnFullScreen(boo : Boolean) : void {
		_autoHideControllerOnFullScreen = boo;
		_size_set();
	}

	public function get autoHideControllerOnFullScreen() : Boolean {
		return _autoHideControllerOnFullScreen;
	}

	private function _control_over(evt : MouseEvent) : void {
		_control_sp.alpha = 1.0;
	}

	private function _control_out(evt : MouseEvent) : void {
		_control_sp.alpha = 0.0;
	}
	/** @private */
	protected override function _keyUp() :void {
		trace(_KeyboardEvent.keyCode);
		if(_KeyboardEvent.keyCode == 32){
			_btn_play.onClick();
		}
	}
	/** @private */
	protected override function _enabled_set():void {
		_btn_loop.enabled = _btn_audio.enabled = _btn_full.enabled = _btn_left.enabled = _btn_play.enabled =
			_btn_right.enabled = _btn_stop.enabled = _cbb_lvl.enabled = _slider.enabled = _enabled;
		if(_enabled){
			_video_sp.addEventListener(MouseEvent.CLICK, video_click);
		}else{
			_video_sp.removeEventListener(MouseEvent.CLICK, video_click);
			pause();
		}
		autoHideController = _autoHideController;
	}
	/** @private */
	protected override function _size_get() : Array {
		return [_bg.width, _bg.height];
	}
	/** @private */
	protected override function _size_set() : void {
		_SizeValue.length = 2;
		_SizeValue[0] = int(_SizeValue[0]) > 0 ? int(_SizeValue[0]) : _bg.width;
		_SizeValue[1] = int(_SizeValue[1]) > 0 ? int(_SizeValue[1]) : _bg.height;

		if(_SizeValue[0] < 100){
			_SizeValue[0] = 100;
		}
		if(_SizeValue[1] < 100){
			_SizeValue[1] = 100;
		}

		var _s_c : uint;
		if(!_autoHideController && _autoHideControllerOnFullScreen && _full_screen){
			_s_c = 0;
		}else{
			_s_c = int(_control_sp.visible) * _control_size * int(!_autoHideController);
		}
		var _s_s : uint = int(_btn_stop.visible) * _control_size;
		var _s_p : uint = int(_btn_play.visible) * _control_size;
		var _s_l : uint = int(_btn_left.visible) * _control_size;
		var _s_r : uint = int(_btn_right.visible) * _control_size;
		var _s_q : uint = int(_cbb_lvl.visible) * _control_cbb_size;
		var _s_f : uint = int(_btn_full.visible) * _control_size;
		var _s_lp : uint = int(_btn_loop.visible) * _control_size;
		var _s_a : uint = int(_btn_audio.visible) * _control_size;
		var _s_t : uint = int(_txt_time.visible) * _txt_time.size[0];

		_video_sp.width = _bg.width = _control_bg.width = _SizeValue[0];
		_bg.height = _SizeValue[1];
		_video_sp.height = _SizeValue[1] - _control_size;

		_control_bg.y = _SizeValue[1] - _control_size;

		_btn_loop.y = _cbb_lvl.y = _btn_full.y = _btn_play.y = _btn_audio.y = _btn_left.y = _btn_right.y = _btn_stop.y = _SizeValue[1];

		_txt_time.y = _SizeValue[1];

		_btn_left.x = _s_s;
		_btn_play.x = _s_l + _s_s;
		_btn_right.x = _s_l + _s_p + _s_s;

		_btn_loop.x = _SizeValue[0] - _s_f - _s_q;
		_btn_audio.x = _SizeValue[0] - _s_f - _s_lp - _s_q;
		_txt_time.x = _SizeValue[0] - _s_q - _s_f - _s_lp - _s_a;
		_cbb_lvl.x = _SizeValue[0] - _s_f;
		_btn_full.x = _SizeValue[0];

		_slider.x = _s_r + _s_l + _s_p + _s_s + 10;
		_slider.y = _SizeValue[1] - 5;

		_slider_sz0 = _SizeValue[0] - _s_a - _s_f - _s_lp - _s_r - _s_l - _s_p - _s_s - _s_q - 22;
		_slider.size = [_slider_sz0 - _s_t];

		if (!_video_width) {
			_video_width = _SizeValue[0];
		}
		if (!_video_height) {
			_video_height = _SizeValue[1];
		}
		var imgBL : Number = _video_width / _video_height;
		if (_SizeValue[0] / _video_width > (_SizeValue[1] - _s_c)  / _video_height) {
			_video.height = _SizeValue[1] - _s_c > 0 ? _SizeValue[1] - _s_c : _video_width;
			_video.width = _video.height * imgBL;
			_video.x = (_SizeValue[0] - _video.width) / 2;
			_video.y = (_SizeValue[1] - _s_c - _video.height) / 2;
		} else {
			_video.width = _SizeValue[0] > 0 ? _SizeValue[0] : _video_width;
			_video.height = _video.width / imgBL;
			_video.x = (_SizeValue[0] - _video.width) / 2;
			_video.y = (_SizeValue[1] - _s_c - _video.height) / 2;
		}
	}

	private function reset_lab_time() : void {
		_slider.value = _time_now;
		_txt_time.label = time_to_str(_time_now) + " / " + time_to_str(_time_all);
		var _s_t : uint = int(_txt_time.visible) * _txt_time.size[0];
		_slider.size = [_slider_sz0 - _s_t];
	}

	private static function time_to_str(total : Number) : String {
		if (total / 1000 < 60 && total / 1000 >= 0) {
			var s0 : uint = total / 1000 >> 0;
			return s0 < 10 ? "0:0" + s0.toString() : "0:" + s0.toString();
		} else {
			var h : uint = (total / 3600000) >> 0;
			var m : uint = ((total - h * 3600000) / 60000) >> 0;
			var s : uint = ((total - h * 3600000 - m * 60000) / 1000) >> 0;
			var hh : String = h < 10 ? "0" + h : h.toString();
			var mm : String = m < 10 ? "0" + m : m.toString();
			var ss : String = s < 10 ? "0" + s : s.toString();
			var arr : Vector.<String> = new Vector.<String>();
			(h > 0) ? arr.push(hh) : null;
			(h > 0 || m > 0 ) ? arr.push(mm) : null;
			(h > 0 || m > 0 || s > 0 )  ? arr.push(ss) : null;
			return arr.join(":");
		}
	}

	private var _timer_i : uint = 0;
	private function timer_func(evt : TimerEvent):void{
		if(!nStream){
			pause();
			return;
		}
		_time_now = nStream.time * 1000;
		if(_time_now >= _time_all - 1000){
			_timer_i++;
			if(_timer_i > 10){
				trace("---End---");
				_time_now = _time_all;
				_slider.value = _slider.maxValue;
				_timer_i = 0;
				pause();
				showLabel("播放完成");
				if(_loop){
					play();
				}
			}
		}
		reset_lab_time();
	}

	public function set source(path : String) : void {
		_video_path = path;
		_slider.value = 0;
		_slider.maxValue = 100;
		_time_now = 0;
		if(nStream){
			nStream.dispose();
		}
		if(nProcess){
			nProcess.exit(true);
		}
		if(process0){
			process0.exit(true);
		}
		reset_lab_time();
		if (timer) {
			timer.stop();
		}
		if(_video_path == null){
			return;
		}
		if (NativeProcess.isSupported) {
			var exe:File = ffmpeg.parent.resolvePath('ffprobe.exe');

			var args:Vector.<String> = new Vector.<String>();
			args.push('-v', 'error', '-show_entries', 'format=duration', '-of', 'default=noprint_wrappers=1:nokey=1', _video_path);

			var npsi:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			try{
			npsi.executable = ffprobe;
			}catch(e:Error){
				showLabel("[ERROR:1056] 未找到编码器！");
				return;
			}
			npsi.arguments = args;

			process0 = new NativeProcess();
			process0.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, on_output_data);
			process0.start(npsi);

			function on_output_data(e:ProgressEvent):void
			{
				var duration_str : String = process0.standardOutput.readUTFBytes(process0.standardOutput.bytesAvailable);
				duration_str = duration_str.replace(/[\t\n\r ]/g, "");
				var duration : Number = Number(duration_str);
				if (!isNaN(duration) && _enabled) {
					_time_all = Math.round(duration * 1000);
					_slider.maxValue = _time_all;
					trace('[_time_all:]', duration, _time_all, time_to_str(_time_all));
					reset_lab_time();
					nConection = new NetConnection();
					nConection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
					nConection.connect(null);

					if (!timer) {
						timer = new Timer(100);
						timer.addEventListener(TimerEvent.TIMER, timer_func);
					}
					timer.reset();
				}
			}
		}else{
			showLabel("[ERROR:0056] 无法加载视频");
			trace("NativeProcess is not Supported!");
		}
	}

	private function netStatusHandler(evt : NetStatusEvent):void{
		checked_err = false;
		switch(evt.info.code){
			case "NetConnection.Connect.Success":
//				case "NetConnection.Connect.Success":
				setupAndLaunch();
				break;
		}
	}

	public function get source() : String {
		return _video_path;
	}

	public function set autoPlay(boo : Boolean) : void {
		_auto_play = boo;
	}

	public function get autoPlay() : Boolean {
		return _auto_play;
	}

	private function setupAndLaunch(boo:Boolean = true) : void {
		nStream = new NetStream(nConection);
		var client : Object = {};
		client.onMetaData = onMetaData;
		nStream.client = client;

		_video.attachNetStream(nStream);
		nStream.play(null);
		nStream.inBufferSeek = true;
		var lvl_bit_obj : Object = lvl_bit[_cbb_lvl.selection];
		trace(lvl_bit_obj["smoothing"]);
		_video.smoothing = lvl_bit_obj["smoothing"];

		var nativeProcessStartupInfo : NativeProcessStartupInfo = new NativeProcessStartupInfo();
		nativeProcessStartupInfo.executable = ffmpeg;

		var processArgs : Vector.<String> = new Vector.<String>();
		processArgs.push("-i", _video_path);
		if(boo){
			processArgs.push("-c:v", "copy");
		}
		processArgs.push("-crf", lvl_bit_obj["crf"],
			"-preset", lvl_bit_obj["preset"],
			"-c:a", "aac",
			"-b:v", lvl_bit_obj["bv"],
			"-b:a", lvl_bit_obj["ba"],
			"-ar", lvl_bit_obj["ar"],
			"-ac", "2", "-f", "flv", "-");
		try{
			nativeProcessStartupInfo.arguments = processArgs;
			nProcess = new NativeProcess();
			nProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			nProcess.start(nativeProcessStartupInfo);
			play_ok = false;
			check_timer.reset();
			check_timer.start();
		}catch(e:Error){
			showLabel("[ERROR:0007] 加载视频失败!");
		}
	}

	private function checked(evt : TimerEvent) : void {
		trace("[CHECKED:]", checked_err);
		if(checked_err){
			return;
		}
		checked_err = true;
		if(!play_ok){
			nProcess.exit(true);
			nProcess.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			setupAndLaunch(false);
		}
	}

	private function onMetaData(infoObject : Object) : void {
		_video_width = infoObject.width;
		_video_height = infoObject.height;
		size = [];
		if (!_auto_play) {
			pause();
		}else{
			_playing = true;
			_btn_play.base64 = bmp_b64_pause;
			timer.start();
		}
	}

	private function onOutputData(evt : ProgressEvent) : void {
		//trace("---onOutputData---");
		showLabel("缓冲中...");
		if(!play_ok){
			play_ok = true;
		}
		var videoStream : ByteArray = new ByteArray();
		//videoStream.writeBytes(videoStream, 0, nProcess.standardOutput.bytesAvailable);
		try{
			nProcess.standardOutput.readBytes(videoStream, 0, nProcess.standardOutput.bytesAvailable);
			nStream.appendBytes(videoStream);
		}catch(e:Error){
			stop();
			showLabel("[ERROR:0026] 缓冲错误！");
		}
		//video.smoothing = true; // 是否開啟平滑處理
		//nStream.dispose(); // 釋放資源
		//nStream.close(); // 停止播放數據
		//video.clear(); // 清除畫面上的一幀圖像
		//nStream.pause(); //暫停播放
		//nStream.togglePause(); //繼續播放
		//nStream.step(-1); //前進或後退一幀
	}
}
}
