package com {
	
	public class myPos {
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var g:Number = 0;
		public var h:Number = 0;
		public var f:Number = 0;
		public var lastX:Number = 0;
		public var lastY:Number = 0;
		public var myStatus:Number = 0;
		
		//public function myPos(myX:Number, myY:Number)
		//{
		//	x=myX;
		//	y=myY;
		//}
		public function myPos(myX:Number, myY:Number, myG:Number, myH:Number)
		{
			x=myX;
			y=myY;
			g=myG;
			h=myH;
			f=g+h;
		}
	}
	
}
