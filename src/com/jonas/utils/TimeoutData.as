package com.jonas.utils {
	import flash.utils.getTimer;
	/**
	 * @author jonas
	 * @date 16 juin 2011
	 */
	public class TimeoutData {
		private var _closure:Function;
		private var _delay:Number;
		private var _args:Array;
		private var _start:int;

		public function TimeoutData(closure:Function, delay:Number, args:Array):void{
			_closure = closure;
			_delay = delay;
			_args = args;
			_start = getTimer();
		}

		public function expire():Boolean {
			return getTimer() - _start >= _delay;
		}

		public function execute():void {
			_closure.apply(null, _args);
		}
	}
}
