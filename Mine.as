package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class Mine extends MainBuild
	{
		private var stageRef:Stage;
		public const what:String = "Mine";
		
		public function Mine(stageRef:Stage)
		{
			this.stageRef = stageRef;
			addEventListener(Event.ENTER_FRAME,loop,false,0,true);
			addEventListener(MouseEvent.CLICK,dropMine,false,0,true);
		}
		
		override protected function loop(e:Event):void
		{
			dropperMine();
			blocker();
			clicker(square,lifeBar,upBar);
			lifeStatus(lifeBar,lifeBar.green,8,square);
			upgradStart(upBar,upBar.blue,8);
			repairStart();
			
			if(startWorking == true)		
				Engine.score.updateGold(0.05+(level/40));
		}	
		
		private function dropperMine()
		{
			if(drop == false)
			{
				x = stageRef.mouseX - Engine.round.x;
				y = stageRef.mouseY - Engine.round.y;			
				
				for(var j:int = 0; j < Engine.golds.length; j ++)
				{
					if(hitTestObject( Engine.golds[j]))
					{
						for(var i:int = 0; i < Engine.buildings.length; i++)
						{	
							if(hitTestObject( Engine.buildings[i]))
							{
								block = true;
								break;
							}
							else
							{
								block = false;
							}
						}
						break;
					}
					else
					{
						block = true;
					}					
				}
			}
		}	
		
		private function dropMine(e:MouseEvent)
		{
			if(block == false)
			{
				if(drop == true)
				{
					if(clickOn == false)
					{
						for(var i:int = 0; i < Engine.buildings.length; i++)
						{	
							Engine.buildings[i].clickOn = false;
						}
						
						clickOn = true;
					}
					else
						clickOn = false;
				}
					
				if(drop == false)
				{
					for(var a:int = 0; a < Engine.golds.length; a++)
					{
						if(hitTestObject( Engine.golds[a]))
							Engine.golds[a].removeSelf();										
					}		
					
					drop = true;
					dispatchEvent(new Event("Dropped"));
					Engine.buildings.push(this);
					Engine.score.updateGold(-200);
					Engine.score.updateFood(-200);
					startWorking = true;
				}
			}
			else
			{
				Engine.round.removeChild(this);
				MainMenu.buttonOn = false;
			}
		}
		
		public function takeHit()
		{
			life -=0.5;
		}
	}
}