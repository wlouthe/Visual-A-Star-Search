package com {
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class drawing extends MovieClip {

		var path:Shape = new Shape();
		var myStageWidth:Number;
		var myStageHeight:Number;
		public function drawing(myW:Number, myH:Number) {
			// constructor code
			myStageWidth = myW;
			myStageHeight = myH;
			path = new Shape();
			path.graphics.lineStyle(10, 0x00CCFF);
			addChild(path);
			
		}
		public function clearDrawing()
		{
			removeChild(path);
			path = new Shape();
			path.graphics.lineStyle(10, 0x00CCFF);
			addChild(path);
		}
		public function startDrawing()
		{
			path.graphics.moveTo(mouseX,mouseY);
			addEventListener(Event.ENTER_FRAME,drawLoop,false,0,true);
		}
		public function stopDrawing()
		{
			removeEventListener(Event.ENTER_FRAME,drawLoop);
		}
		public function drawLoop(e:Event)
		{
			var myX:Number = mouseX;
			var myY:Number = mouseY;
			if(myX < 5)
			{
				myX = 5;
			}
			if(myX > myStageWidth-5)
			{
				myX = myStageWidth-5;
			}
			if(myY < 5)
			{
				myY = 5;
			}
			if(myY > myStageHeight-5)
			{
				myY = myStageHeight-5;
			}
			trace("x:"+myX+" y:"+myY);
			path.graphics.lineTo(myX, myY);
		}

	}
	
}
