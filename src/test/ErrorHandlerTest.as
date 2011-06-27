package test{
	import com.jonas.debug.ErrorHandler;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author jonas
	 */
	[SWF(width="550", height="400", backgroundColor="#f2f2f2")]
	public class ErrorHandlerTest extends Sprite
	{
		public function ErrorHandlerTest(){
			if(stage == null){
				addEventListener(Event.ADDED_TO_STAGE, ready);
			}else{
				ready();
			}
		}

		private function ready(event : Event = null) : void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			ErrorHandler.getIntance().init(this);

			var title:TextField = new TextField();
			title.autoSize = TextFieldAutoSize.LEFT;
			title.width = stage.stageWidth-80;
			title.multiline = true;
			title.wordWrap = true;
			title.defaultTextFormat = new TextFormat("Arial", 15, 0x333333, true);
			title.x = title.y = 40;

			var infos:String = "<font size='15'><b>ErrorHandler "+ErrorHandler.VERSION+"</b></font>";
			infos+="<br/><font size='11'>Active with player types : "+ErrorHandler.getIntance().activeWithPlayerType;
			infos+="<br/>Active with player modes : "+ErrorHandler.getIntance().activeWithPlayerMode;
			infos+="<br/>Active with build modes : "+ErrorHandler.getIntance().activeWithBuildMode+'</font>';

			title.htmlText = infos;
			addChild(title);

			var bt1:Sprite = createButton("Custom Error", clickError1, 40, title.y+title.height+20);
			var bt2:Sprite = createButton("Native Error", clickError2, 40, bt1.y+bt1.height+20);
			createButton("Native ErrorEvent", clickError3, 40, bt2.y+bt2.height+20);
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
