package com.jonas.utils {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	/**
	 * @author jonas
	 * @date 15 juin 2011
	 */
	public class Timeout
	{
		private static var _stack:Vector.<Object> = new Vector.<Object>();
		private static var _running:Boolean = false;
		private static var _sprite:Sprite = new Sprite();

		public static function execute(closure:Function, delay:Number, ...args:Array):void {
			_stack.push({closure:closure, delay:delay, args:args, start:getTimer()});
			if(!_running){
				_sprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		private static function onEnterFrame(event : Event) : void {
			event.stopImmediatePropagation();
			var i:int = 0;
			var b:Boolean = _stack.length>0;
			while(b){
				if(getTimer() - _stack[i]["start"] >= _stack[i]["delay"]){
					(_stack[i]["closure"] as Function).apply(null, _stack[i]["args"]);
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
				_stack = new Vector.<Object>();
				_running = false;
			}
		}
	}
}
