package com.asgamer
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	public class Gold extends MovieClip
	{
		private var stageRef:Stage;
		
		public function Gold(stageRef:Stage)
		{
			this.stageRef = stageRef;
		}
		public function removeSelf()
		{
			if(Engine.round.contains(this))
			{
				Engine.round.removeChild(this);
				Engine.golds.splice(Engine.golds.indexOf(this),1);
			}
		}
	}
}