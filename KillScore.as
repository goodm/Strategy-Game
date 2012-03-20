package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class KillScore extends MovieClip
	{
		private var stageRef:Stage;
		private var gold:Number;
		private var food:Number;
		
		
		public function KillScore(stageRef:Stage, x:Number, y:Number,gold:Number,food:Number)
		{
			this.stageRef = stageRef;
			this.gold = gold;
			this.food = food;
			this.x = x;
			this.y = y;
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		
		private function loop(e:Event)
		{
			kill_txt.text = "Gold +" + String(gold) + "\nFood +" + String(food);
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