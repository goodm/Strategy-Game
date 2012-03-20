package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	public class StartGame extends MovieClip
	{
		private var stageRef:Stage;
		
		public function StartGame(stageRef:Stage)
		{
			this.stageRef = stageRef;
			x = 400;
			y = 300;
			addEventListener(MouseEvent.CLICK,del,false,0,true);
		}
		
		public function del(e:MouseEvent):void
		{
			if(stageRef.contains(this))
				stageRef.removeChild(this);
		}
	}
}