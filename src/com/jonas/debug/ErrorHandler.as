package com.jonas.debug {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * @author jonas
	 */
	public class ErrorHandler extends Sprite
	{
		private var _target:DisplayObject;
		private var _container:Sprite;
		private var _buildMode:String = isDebugBuild() ? "debug" : "release";
		private var _playerMode:String = Capabilities.isDebugger ? "debug" : "release";

		private var _onWithPlayerType:Array = [PlayerType.ACTIVEX, PlayerType.DESKTOP, PlayerType.EXTERNAL, PlayerType.PLUGIN, PlayerType.STANDALONE];
		private var _onWithPlayerMode:Array = [PlayerMode.DEBUG, PlayerMode.RELEASE];
		private var _onWithBuildMode:Array = [PlayerMode.DEBUG, PlayerMode.RELEASE];

		private var _button : Sprite;
		private var _buttonSize : uint = 15;
		private var _buttonBackgroundColor : Number = 0xFF0000;
		private var _buttonTextColor : Number = 0xFFFFFF;
		private var _buttonTextField : TextField;

		private var _window:Sprite;
		private var _windowWidth : Number = 500;
		private var _windowHeight : Number = 300;
		private var _windowBackgroundColor : Number = 0x333333;
		//private var _windowTextColor :Number = 0xFFFFFF;
		private var _windowTextField : TextField;

		private var _errorCount:uint = 0;

		public function ErrorHandler(display : DisplayObject)
		{
			_target = display;
			if(isOn())
				_init();
		}

		// GETTER / SETTERS

		public function get onWithPlayerType() : Array {
			return _onWithPlayerType;
		}

		public function set onWithPlayerType(onWithPlayerType : Array) : void {
			_onWithPlayerType = onWithPlayerType;
		}

		public function get onWithPlayerMode() : Array {
			return _onWithPlayerMode;
		}

		public function set onWithPlayerMode(onWithPlayerMode : Array) : void {
			_onWithPlayerMode = onWithPlayerMode;
		}

		public function get onWithBuildMode() : Array {
			return _onWithBuildMode;
		}

		public function set onWithBuildMode(onWithBuildMode : Array) : void {
			_onWithBuildMode = onWithBuildMode;
		}

		// PUBLIC

		public function isOn():Boolean
		{
			if(!inArray(_onWithPlayerType, Capabilities.playerType))
				return false;
			if(!inArray(_onWithBuildMode, _buildMode))
				return false;
			if(!inArray(_onWithPlayerMode, _playerMode))
				return false;
			return true;
		}

		// PRIVATE

		private function _init():void {
			_container = new Sprite();

			if(_target.stage.stageWidth<_windowWidth)
				_windowWidth  = _target.stage.stageWidth;
			if(_target.stage.stageWidth<_windowHeight)
				_windowHeight  = _target.stage.stageHeight;

			_target.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
		}

		private function uncaughtErrorHandler(event : UncaughtErrorEvent) : void {
			event.preventDefault();
			event.stopImmediatePropagation();
			var message : String = "<font size='11' color='#FFFFFF'>";

			if (event.error is Error){
				var error : Error = event.error as Error;
				message += "<b>"+error.message+"</b>";
				if(error.getStackTrace() != null)
					message += "\n" + error.getStackTrace();
			}
			else if (event.error is ErrorEvent) {
				var errorEvent : ErrorEvent = event.error as ErrorEvent;
				message += "<b>"+errorEvent.text+"</b>";
				message += "\n" + errorEvent;
			}
			else {
				message += "<b>Error</b>";
				message += "A non-Error, non-ErrorEvent type was thrown and uncaught";
			}
			message += "</font>";


			if(_container.stage == null){
				DisplayObjectContainer(_target.stage.getChildAt(0)).addChild(_container);
				createWindow();
				createButton();
			}else{
				DisplayObjectContainer(_target.stage.getChildAt(0)).removeChild(_container);
				DisplayObjectContainer(_target.stage.getChildAt(0)).addChild(_container);
			}

			_buttonTextField.text = (_errorCount++).toString();
			_windowTextField.htmlText = message;


			_button.x = 0;
			_button.y = 0;
			_button.visible = true;
		}

		private function createWindow():void
		{
			_windowTextField = new TextField();
			_windowTextField.selectable = true;
			_windowTextField.multiline = true;
			_windowTextField.wordWrap = true;
			_windowTextField.width = _windowWidth;
			_windowTextField.height = _windowHeight;
			_windowTextField.type = TextFieldType.DYNAMIC;
			_windowTextField.x = _windowTextField.y = 10;
			_windowTextField.width = _windowWidth -20;
			_windowTextField.height = _windowHeight -20;

			var infos:String = "<font size='11' color='#FFFFFF'>";
			infos += Capabilities.version+" "+Capabilities.playerType;
			infos += "<br/>Debug player : "+Capabilities.isDebugger;
			if(Capabilities.isDebugger)
				infos += "<br/>Debug build : "+isDebugBuild();

			infos += "<br/>ErrorHandler 0.1";
			infos += "</font>";

			var _infoTextField:TextField = new TextField();
			_infoTextField.width = _windowWidth-20;
			_infoTextField.autoSize = TextFieldAutoSize.LEFT;
			_infoTextField.wordWrap = true;
			_infoTextField.multiline = true;
			_infoTextField.htmlText = infos;
			_infoTextField.x = 10;
			_infoTextField.y = _windowHeight-_infoTextField.height-10;

			_window = new Sprite();
			_window.visible = false;
			_window.graphics.beginFill(_windowBackgroundColor);
			_window.graphics.drawRect(0, 0, _windowWidth, _windowHeight);
			_window.graphics.endFill();
			_window.graphics.beginFill(0x666666);
			_window.graphics.drawRect(0, _infoTextField.y-10, _windowWidth, _infoTextField.height+20);
			_window.graphics.endFill();
			_window.x = -_windowWidth;
			_window.addChild(_windowTextField);
			_window.addChild(_infoTextField);
			_container.addChild(_window);
		}

		private function createButton():void
		{
			_buttonTextField = new TextField();
			_buttonTextField.mouseEnabled = false;
			_buttonTextField.autoSize = TextFieldAutoSize.LEFT;
			_buttonTextField.text = "0";
			_buttonTextField.defaultTextFormat = new TextFormat(null, 11, _buttonTextColor, false, false, false, null, null, "center");
			_buttonTextField.y = (_buttonSize-_buttonTextField.height)/2;
			_buttonTextField.autoSize = TextFieldAutoSize.NONE;
			_buttonTextField.width = _buttonSize;

			_button = new Sprite();
			_button.x = -100;
			_button.visible = false;
			_button.addEventListener(MouseEvent.CLICK, onClick);
			_button.buttonMode = true;
			_button.graphics.beginFill(_buttonBackgroundColor);
			_button.graphics.drawRect(0, 0, _buttonSize, _buttonSize);
			_button.graphics.endFill();
			_button.addChild(_buttonTextField);
			_container.addChild(_button);
		}

		private function onClick(event : MouseEvent) : void
		{
			if(_window.visible){
				_window.visible = false;
				_window.x = -_windowWidth;
			}else{
				_window.x = 0;
				_window.y = _buttonSize;
				_window.visible = true;
			}
		}

		private function isDebugBuild():Boolean {
			var s:String = new Error().getStackTrace();
			if(s == null)
				return false; // undefined status
			return s.indexOf('[') != -1;
		}

		private function inArray(array:Array, value:String):Boolean {
			var n:uint = array.length;
			for(var i:uint=0; i<n; i++){
				if(array[i] == value)
					return true;
			}
			return false;
		}


	}
}
