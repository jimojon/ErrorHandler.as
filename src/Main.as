package {
	import flash.text.TextFormat;
	import com.jonas.debug.ErrorHandler;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author jonas
	 */
	public class Main extends Sprite
	{
		private var bt1:Sprite;
		private var bt2:Sprite;
		private var title:TextField;

		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var error:ErrorHandler = new ErrorHandler(this);
			addChild(error);

			bt1 = createButton("Custom Error", clickError1, 40, 80);
			bt2 = createButton("Native Error", clickError2, 40, 120);
			bt2 = createButton("Native ErrorEvent", clickError3, 40, 160);

			title = new TextField();
			title.autoSize = TextFieldAutoSize.LEFT;
			title.defaultTextFormat = new TextFormat("Arial", 15, 0x333333, true);
			title.x = title.y = 40;
			title.text = "ErrorHandler test";
			addChild(title);
		}

		private function clickError1(e:MouseEvent):void {
            throw new Error("Custom Error", "ErrorID");
		}

		private function clickError3(e:MouseEvent):void {
			var loader:Loader = new Loader();
            loader.load(new URLRequest("child.swf"));
		}

		private function clickError2(e:MouseEvent):void {
			var a:Array;
			a[33];
		}

		private function createButton(label:String, listener:Function, x:Number, y:Number):Sprite
		{
			var t:TextField = new TextField();
			t.mouseEnabled = false;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.text = label;
			t.x = 10;

			var b:Sprite = new Sprite();
			b.addEventListener(MouseEvent.CLICK, listener);
			b.buttonMode = true;
			b.graphics.beginFill(0xCCCCCC);
			b.graphics.drawRect(0, 0, t.width+20, t.height);
			b.graphics.endFill();
			b.addChild(t);
			b.x = x;
			b.y = y;
			addChild(b);

			return b;
		}
	}
}
