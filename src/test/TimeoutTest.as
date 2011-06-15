package test {
	import com.jonas.utils.Timeout;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer;

	/**
	 * @author jonas
	 * @date 16 juin 2011
	 */
	[SWF(width = "320", height = "480", frameRate = "60")]
	public class TimeoutTest extends Sprite
	{
		private var message:TextField;
		private var start:int;
		public function TimeoutTest()
		{
			message = new TextField();
			message.width = 320;
			message.height = 480;
			addChild(message);

			var n:uint = 0;
			start = getTimer();
			for(var i:int=1; i<=50; i++){
				n = i*100;
				Timeout.execute(test, n, "Hello with a "+n+" ms delay - ");
			}
		}

		public function test(s:String):void {
			var m:String = s+(getTimer()-start)+"\n";
			message.appendText(m);
		}
	}
}
