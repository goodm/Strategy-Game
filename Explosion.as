package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class Explosion extends MovieClip
	{
		private var stageRef:Stage;
		
		public function Explosion(stageRef:Stage, x:Number, y:Number,w:Number,h:Number)
		{
			this.stageRef = stageRef;
			this.x = x;
			this.y = y;
			this.width = w;
			this.height = h;
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		
		private function loop(e:Event)
		{
			if (currentFrame == totalFrames)
			{
				removeSelf();
			}
		}
		
		private function removeSelf():void
		{
			removeEventListener(Event.ENTER_FRAME, loop);
			
			if(Engine.round.contains(this))
				Engine.round.removeChild(this);
		}
	}
}