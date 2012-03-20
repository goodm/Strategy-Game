package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class MainBuild extends MovieClip
	{
		protected var stageBuild:Stage;
		protected var drop:Boolean = false;
		public var block:Boolean = false;
		public var clickOn:Boolean = false;
		public var life:Number = 100;
		public var level:int = 0;
		public var index:int;
		public var upgrading:Boolean = false;
		public var repair:Boolean = false;
		private var repairing:Number = 0;
		public static var upgrTime:Number = 0.001;
		public var couting:Number = 0;
		protected var startWorking:Boolean = false;		
		
		protected function dropper(stageBuild:Stage)
		{
			if(drop == false)
			{
				x = stageBuild.mouseX - Engine.round.x;
				y = stageBuild.mouseY - Engine.round.y;
				
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
				
				if (Engine.troops[0] != null && block == false)
				{
					for(var j:int = 0; j < Engine.troops.length; j++)
					{	
						if(hitTestObject(Engine.troops[j].square))
						{
							block = true;
							break;
						}
						else
						{
							block = false;
						}
					}
				}
			}
		}		
		
		protected function clicker(squ:MovieClip,bar:MovieClip,up:MovieClip)
		{
			if(clickOn == true)
			{
				squ.alpha = 1;
				bar.alpha = 1;
				up.alpha = 1;
			}
		}
		
		protected function loop(e:Event):void
		{

		}	
		
		protected function lifeStatus(bar:MovieClip,gr:MovieClip,barLength:Number,squ:MovieClip)
		{
			bar.width = barLength/10 * life;
			gr.alpha = life/100-0.2;		
			bar.height = 4;

			if(bar.alpha>0)
				bar.alpha -= 0.1;
				
			if(squ.alpha>0)
				squ.alpha -= 0.1;			
		}
		
		protected function blocker()
		{
			if(block == true)
			{
				alpha = 0.2;
			}
			else
			{
				alpha = 1;
			}
		}	
		
		protected function mainDrop(gold:Number,food:Number):void
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
					Engine.score.updateGold(gold);
					Engine.score.updateFood(food);
				}
			}
			else
			{
				Engine.round.removeChild(this);
				MainMenu.buttonOn = false;
			}			
		}
		
		protected function upgradStart(up:MovieClip,blu:MovieClip,barLength:Number)
		{
			if(upgrading == true)
			{
				if(couting < 1)
				{
					couting += upgrTime;
					up.width = barLength/10 * couting * 100;
					blu.alpha = (couting*100)/100-0.2;		
					up.height = 4;		
				}
				else if(couting >=1)
				{
					level +=1;
					couting = 0;
					upgrading = false;
					if(up.alpha>0)
						up.alpha -= 0.1;
				}			
			}
			
			if(up.alpha>0)
				up.alpha -= 0.1;
			up.width = barLength/10 * couting * 100;
			blu.alpha = (couting*100)/100-0.2;		
			up.height = 4;		
		}
		
		protected function repairStart()
		{
			if(repair == true)
			{
				if(repairing < 26 && life < 101)
				{
					repairing += 0.1
					life += 0.1;
				}
				else
				{
					repair = false
					repairing = 0;
				}
			}
		}
		
		public function removeSelf(stageBuild:Stage)
		{
			if(Engine.round.contains(this))
			{
				startWorking = false;
				clickOn = false;
				Engine.round.addChild(new Explosion(stageBuild, x, y, width, height));
				Engine.round.removeChild(this);
				removeEventListener(Event.ENTER_FRAME, loop);
				delete(this);
			}
		}
	}
}