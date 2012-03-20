package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class Army extends MainBuild
	{
		private var stageRef:Stage;
		public const what:String = "Main building";
		
		public function Army(stageRef:Stage)
		{
			this.stageRef = stageRef;
			addEventListener(Event.ENTER_FRAME,loop,false,0,true);
			addEventListener(MouseEvent.CLICK,dropArmy,false,0,true);
		}
		
		override protected function loop(e:Event):void
		{
			dropper(stageRef);
			blocker();
			clicker(square,lifeBar,upBar);
			lifeStatus(lifeBar,lifeBar.green,25,square);
			upgradStart(upBar,upBar.blue,25);
			repairStart();
		}	
		private function dropArmy(e:MouseEvent)
		{
			mainDrop(-150,-100);
		}
		
		public function takeHit()
		{
			life -=0.1-level*0.01;
		}
	}
}