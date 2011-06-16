package test {
	import com.jonas.utils.Timeout;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * @author jonas
	 * @date 16 juin 2011
	 */
	[SWF(width = "320", height = "480", frameRate = "60")]
	public class TimeoutTest extends Sprite
	{
		private var message1:TextField;
		private var message2:TextField;
		private var start1:int;
		private var start2:int;
		private var iteration:int = 30;
		private var delay:int = 100;
		public function TimeoutTest()
		{
			message1 = new TextField();
			message1.width = 160;
			message1.height = 480;
			message1.htmlText = "setTimeout()\n";
			addChild(message1);

			message2 = new TextField();
			message2.x = 160;
			message2.width = 160;
			message2.height = 480;
			message2.htmlText = "Timeout.execute()\n";
			addChild(message2);

			startTest1();
		}

		public function startTest1():void {
			var i:uint;
			var n:uint = 0;
			start1 = getTimer();
			for(i=1; i<=iteration; i++){
				n = i*delay;
				setTimeout(test1, n, "A "+n+" ms delay - ");
			}
		}

		public function startTest2():void {
			var i:uint;
			var n:uint = 0;
			start2 = getTimer();
			for(i=1; i<=iteration; i++){
				n = i*delay;
				Timeout.execute(test2, n, "A "+n+" ms delay - ");
			}
		}

		public function test1(s:String):void {
			var m:String = s+(getTimer()-start1)+"\n";
			message1.appendText(m);
		}

		public function test2(s:String):void {
			var m:String = s+(getTimer()-start2)+"\n";
			message2.appendText(m);
		}
	}
}
