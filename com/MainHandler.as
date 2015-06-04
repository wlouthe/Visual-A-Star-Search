package com {
	
	import flash.display.MovieClip;
	
	public class MainHandler extends MovieClip {

		var bg:MyBackground = new MyBackground();
		
		public function MainHandler() {
			// constructor code
			bg.scaleX = stage.width/100;
			bg.scaleY = stage.height/100;
			
		}
		
		stage.addChild(bg);

	}
	
}
