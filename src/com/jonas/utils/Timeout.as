package com.jonas.utils {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * @author @jonasmonnier @Seraf_NSS
	 */
	public class Timeout {
		private static var _stack : Vector.<Object> = new Vector.<Object>();
		private static var _running : Boolean = false;
		private static var _e : Shape = new Shape();
		private static var _id : int = -1;

		public static function create(closure : Function, delay : Number, ...args : Array) : int {
			_id++;
			_stack.push({closure:closure, delay:delay, args:args, start:getTimer(), id:_id});
			if (!_running){
				_running = true;
				_e.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			return _id;
		}

		private static function onEnterFrame(event : Event) : void {
			event.stopImmediatePropagation();
			var i : int = 0;
			var b : Boolean = _stack.length > 0;
			while (b) {
				if (getTimer() - _stack[i]["start"] >= _stack[i]["delay"]) {
					(_stack[i]["closure"] as Function).apply(null, _stack[i]["args"]);
					_stack.splice(i, 1);
				} else {
					i++;
				}
				b = _stack.length > i;
			}
			if (_stack.length == 0) {
				_e.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_running = false;
			}
		}

		public static function get running() : Boolean {
			return _running;
		}

		public static function clear(id : int) : Boolean {
			var l : int = _stack.length ;
			while (l--) {
				if ( _stack[l]["id"] == id ) {
					_stack.splice(l, 1);
					return true;
				}
			}
			return false;
		}

		public static function clearAll() : void {
			if (_running) {
				_e.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_stack = new Vector.<Object>();
				_running = false;
			}
		}
	}
}