package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class ConstructionFactory extends MainBuild
	{
		private var stageRef:Stage;
		public const what:String = "Construction factory";
		
		public function ConstructionFactory(stageRef:Stage)
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
			mainDrop(-500,-500);
		}
		
		public function takeHit()
		{
			life -=0.5;
		}
		
		override public function removeSelf(stageRef:Stage)
		{
			if(Engine.round.contains(this))
			{
				Engine.constructionMenu = false;
				startWorking = false;
				clickOn = false;
				Engine.round.addChild(new Explosion(stageBuild, x, y,width,height));
				Engine.round.removeChild(this);
			}			
		}
	}
}