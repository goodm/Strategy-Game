package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class FishPort extends MainBuild
	{
		private var stageRef:Stage;
		private var fishTimer:Timer;
		public const what:String = "Food factory";
	
		
		public function FishPort(stageRef:Stage)
		{
			this.stageRef = stageRef;
			addEventListener(Event.ENTER_FRAME,loop,false,0,true);
			addEventListener(MouseEvent.CLICK,dropFish,false,0,true);
		}
		override protected function loop(e:Event):void
		{
			dropper(stageRef);
			blocker();
			clicker(square,lifeBar,upBar);
			lifeStatus(lifeBar,lifeBar.green,13,square);
			upgradStart(upBar,upBar.blue,13);
			repairStart();

			if(startWorking == true)
				Engine.score.updateFood(0.05+(level/40));
		}
		
		private function dropFish(e:MouseEvent)
		{
			mainDrop(-200,-50);
			startWorking = true;
		}
		
		public function takeHit()
		{
			life -=0.5;
		}
	}
}