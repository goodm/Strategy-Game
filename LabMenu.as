package com.asgamer
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class LabMenu extends MovieClip
	{
		private var stageRef:Stage;
		public var indexLab:int;
		private var buttonOn:Boolean = false;
		private var upgr:Boolean = false;
		private var tankB:Boolean = false;
		private var dtank:Boolean = false;
		private var midd:Boolean = false;
		private var startUpgr:Boolean = false;
		private var tankUpgr:Boolean = false;
		private var midUpgr:Boolean = false;
		private var doubleUpgr:Boolean = false;
		private var loadLevel:Number = 0;
		private var buttons:Array;
		
		public function LabMenu(stageRef:Stage)
		{
			this.stageRef = stageRef;
			loading.width = 0;
			buttons = [upgr_mc, tank, double, mid];
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			upgr_mc.stop();
			upgr_mc.addEventListener(MouseEvent.MOUSE_OVER, upgrMouseOver);
			upgr_mc.addEventListener(MouseEvent.CLICK, upgrOn);
			upgr_mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			tank.stop();
			tank.addEventListener(MouseEvent.MOUSE_OVER, tankMouseOver);
			tank.addEventListener(MouseEvent.CLICK, tankOn);			
			tank.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			double.stop();
			double.addEventListener(MouseEvent.MOUSE_OVER, doubleMouseOver);
			double.addEventListener(MouseEvent.CLICK, doubleOn);
			double.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			mid.stop();
			mid.addEventListener(MouseEvent.MOUSE_OVER, midMouseOver);
			mid.addEventListener(MouseEvent.CLICK, midOn);
			mid.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);	
		}
		
		private function midOn(e:MouseEvent):void 
		{
			if (buttonOn == false)
			{
				Engine.score.updateGold( -300);
				Engine.score.updateFood( -200);
				buttonOn = true;
				midUpgr = true;
			}	
		}
		
		private function doubleOn(e:MouseEvent):void 
		{
			if (buttonOn == false)
			{
				Engine.score.updateGold( -300);
				Engine.score.updateFood( -200);
				buttonOn = true;
				doubleUpgr = true;
			}			
		}
		
		private function tankOn(e:MouseEvent):void 
		{
			if (buttonOn == false)
			{
				Engine.score.updateGold( -250);
				Engine.score.updateFood( -150);
				buttonOn = true;
				tankUpgr = true;
			}			
		}
		
		private function upgrOn(e:MouseEvent):void 
		{
			if (buttonOn == false)
			{
				Engine.score.updateGold( -150);
				Engine.score.updateFood( -150);
				buttonOn = true;
				startUpgr = true;
			}
		}
		
		private function upgrMouseOver(e:MouseEvent):void 
		{
			upgr = true;
		}
		
		private function midMouseOver(e:MouseEvent):void 
		{
			midd = true;
		}
		
		private function doubleMouseOver(e:MouseEvent):void 
		{
			dtank = true;
		}
		
		private function tankMouseOver(e:MouseEvent):void 
		{
			tankB = true;
		}
		
		private function mouseOut(e:MouseEvent):void 
		{
			upgr = false;
			tankB = false;
			dtank = false;
			midd = false;
		}

		
		private function loop(e:Event)
		{
			//all.text = "Current tank speed: " + String(100 - Unit.speed) + " , double tank speed: " + String(100 - (Unit.speed + 10)) + "\nShooting speed: " + String(1000-Unit.shootSpeed);
			
			if (upgr == true)
			{
				upgr_mc.nextFrame();
				if (double.x < 280)
					double.x += 30;
			}
			else
			{
				upgr_mc.prevFrame();
				if (double.x > 110)
					double.x -= 30;
			}
				
			if (tankB == true)
			{
				tank.nextFrame();
				if (mid.x < 280)
					mid.x += 30;
			}
			else
			{
				tank.prevFrame();
				if (mid.x > 110)
					mid.x -= 30;
			}
				
			if (dtank == true)
				double.nextFrame();
			else
				double.prevFrame();
				
			if (midd == true)
				mid.nextFrame();
			else
				mid.prevFrame();
				
			if (buttonOn == true)
			{
				for (var i:int = 0; i < buttons.length; i++)
				{
					buttons[i].alpha = 0.2;
				}
			}
			else
			{
				for (var j:int = 0; j < buttons.length; j++)
				{
					buttons[j].alpha = 1;
				}				
			}
				
			if (startUpgr == true)
			{
				loading.width = loadLevel*4.8;
				loadLevel += 0.1;
				status_txt.text = "Faster upgrading: " + String(Math.floor(loadLevel)) + "%";
				if (loadLevel >= 100)
				{
					loadLevel = 0;
					startUpgr = false;
					buttonOn = false;
					loading.width = 0;
					MainBuild.upgrTime += 0.002;
					status_txt.text = " ";
				}
			}
			if (tankUpgr == true)
			{
				loading.width = loadLevel*4.8;
				loadLevel += 0.1;
				status_txt.text ="Improve units speed: " +  String(Math.floor(loadLevel)) + "%";
				if (loadLevel >= 100)
				{
					loadLevel = 0;
					tankUpgr = false;
					buttonOn = false;
					loading.width = 0;
					Unit.speed -= 1;
					status_txt.text = " ";
				}
			}
			if (doubleUpgr == true)
			{
				loading.width = loadLevel*4.8;
				loadLevel += 0.1;
				status_txt.text ="Improve units shooting time: " +  String(Math.floor(loadLevel)) + "%";
				if (loadLevel >= 100)
				{
					loadLevel = 0;
					doubleUpgr = false;
					buttonOn = false;
					loading.width = 0;
					Unit.shootSpeed -= 25;
					status_txt.text = " ";
				}
			}
			if (midUpgr == true)
			{
				loading.width = loadLevel*4.8;
				loadLevel += 0.1;
				status_txt.text = String(Math.floor(loadLevel)) + "%";
				if (loadLevel >= 100)
				{
					loadLevel = 0;
					midUpgr = false;
					buttonOn = false;
					loading.width = 0;
					MainBuild.upgrTime += 0.002;
					status_txt.text = " ";
				}
			}
		}
		
	}
}