package com.jonas.utils {
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author jonas
	 * @date 15 juin 2011
	 */
	public class Timeout2
	{
		private static var _stack:Vector.<TimeoutData> = new Vector.<TimeoutData>();
		private static var _running:Boolean = false;
		private static var _sprite:Sprite = new Sprite();

		public static function execute(closure:Function, delay:Number, ...args:Array):void {
			_stack.push(new TimeoutData(closure, delay, args));
			if(!_running){
				_sprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		private static function onEnterFrame(event : Event) : void {
			event.stopImmediatePropagation();
			var i:int = 0;
			var b:Boolean = true;
			while(b){
				if(_stack[i]["expire"]()){
					_stack[i]["execute"]();
					_stack.splice(i, 1);
				}else{
					i++;
				}
				b = _stack.length<i-1;
			}
			if(_stack.length==0){
				_sprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_running = false;
			}


		}

		public static function get running() : Boolean {
			return _running;
		}

		public static function clear():void {
			if(_running){
				_sprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_stack = new Vector.<TimeoutData>();
				_running = false;
			}
		}
	}
}
