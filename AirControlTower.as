package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class AirControlTower extends MainBuild
	{
		private var stageRef:Stage;
		public const what:String = "Air Control Tower";
		
		public function AirControlTower(stageRef:Stage)
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
			lifeStatus(lifeBar,lifeBar.green,14,square);
			upgradStart(upBar,upBar.blue,14);
			repairStart();
		}	
		
		private function dropArmy(e:MouseEvent)
		{
			mainDrop(-1200,-900);
		}
		
		public function takeHit()
		{
			life -=0.5-level*0.01;
		}
	}
}