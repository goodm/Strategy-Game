 package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.SimpleButton;

	
	public class MainMenu extends MovieClip
	{
		private var stageRef:Stage;
		public static var menuUp:Boolean = false;	

		
		public static var buttonOn:Boolean = false;

		
		private var armyB:Army;
		private var mineB:Mine;
		private var fishB:FishPort;
		private var towerB:Tower;
		private var constructionB:ConstructionFactory;
		private var mTowerB:MidTower;
		private var lab:Lab;
		private var air:AirControlTower;
		private var buttons:Array = new Array();

		private var moveButtons:int = 0;

		public var level2:Boolean = false;

		
		
		public function MainMenu(stageRef:Stage)
		{
			this.stageRef = stageRef;
			x = 800;
			y = 675;
			
			buttons = [army_btn, fish_btn, mine_btn, tower_btn, construction_btn, midTower_btn, lab_btn, air_btn];
			
			addEventListener(Event.ENTER_FRAME,loop,false,0,true);
			
			
			
			//Main button
			build_btn.addEventListener(MouseEvent.CLICK,menuUpGo,false,0,true);
			//Engine.buildings buttons
			army_btn.addEventListener(MouseEvent.CLICK,armyBuild,false,0,true);
			fish_btn.addEventListener(MouseEvent.CLICK,fishBuild,false,0,true);
			mine_btn.addEventListener(MouseEvent.CLICK,mineBuild,false,0,true);
			tower_btn.addEventListener(MouseEvent.CLICK,towerBuild,false,0,true);
			construction_btn.addEventListener(MouseEvent.CLICK,constructionFactoryBuild,false,0,true);
			midTower_btn.addEventListener(MouseEvent.CLICK,midTowerBuild,false,0,true);
			lab_btn.addEventListener(MouseEvent.CLICK,labBuild,false,0,true);
			air_btn.addEventListener(MouseEvent.CLICK, airBuild);
			right_btn.addEventListener(MouseEvent.MOUSE_OVER,moveRightButtons,false,0,true);
			left_btn.addEventListener(MouseEvent.MOUSE_OVER,moveLeftButtons,false,0,true);
			right_btn.addEventListener(MouseEvent.MOUSE_OUT,moveButtonsOff,false,0,true);
			left_btn.addEventListener(MouseEvent.MOUSE_OUT,moveButtonsOff,false,0,true);		
		}		
		
		private function loop(e:Event):void
		{
			menuUporDown();
			buttonsSet();
		
		}				
		
		private function buttonsSet():void 
		{
			if(Engine.buildings[0] == null)
				army_btn.alpha = 1;
			else
				army_btn.alpha = 0.2;			
			
			if(Engine.buildings[0] != null && Engine.buildings[0] == armyB && buttonOn == false)
			{
				if(Engine.score.food >= 200 && Engine.score.gold >= 200)
					mine_btn.alpha = 1;
				else
					mine_btn.alpha = 0.2;
					
				if(Engine.score.food >= 50 && Engine.score.gold >= 200)
					fish_btn.alpha = 1;
				else
					fish_btn.alpha = 0.2;
					
				if(Engine.score.food >= 100 && Engine.score.gold >= 100)
					tower_btn.alpha = 1;
				else
					tower_btn.alpha = 0.2;
					
				if(Engine.score.food >= 500 && Engine.score.gold >= 500)
					construction_btn.alpha = 1;
				else
					construction_btn.alpha = 0.2;
					
				if(Engine.score.food >= 500 && Engine.score.gold >= 500)
					midTower_btn.alpha = 1;
				else
					midTower_btn.alpha = 0.2;
					
				if(Engine.score.food >= 800 && Engine.score.gold >= 900)
					lab_btn.alpha = 1;
				else
					lab_btn.alpha = 0.2;
					
				if(Engine.score.food >= 900 && Engine.score.gold >= 1200 && level2 == true)
					air_btn.alpha = 1;
				else
					air_btn.alpha = 0.2;

			}
			else if (Engine.buildings[0] == null && buttonOn == false)
			{
				mine_btn.alpha = 0.2;
				fish_btn.alpha = 0.2;
				tower_btn.alpha = 0.2;
				construction_btn.alpha = 0.2;
				midTower_btn.alpha = 0.2;
				lab_btn.alpha = 0.2;
				air_btn.alpha = 0.2;
			}
			
			if(moveButtons == 1)
			{
				if(air_btn.x>-375)
				{
					for (var i:int = 0; i < buttons.length; i++)
						buttons[i].x -= 5;
				}
			}
			else if(moveButtons == 2)
			{
				if(army_btn.x < -555)
				{
					for (var j:int = 0; j < buttons.length; j++)
						buttons[j].x += 5;
				}
			}			
		}
		
		private function Dropped(e:Event):void
		{
			buttonOn = false;
		}		
		private function armyBuild(e:MouseEvent):void
		{
			if(army_btn.alpha == 1)
			{
				turnOffClick()
				if(buttonOn == false)
				{
					buttonOn = true;
					armyB = new Army(stageRef);
					Engine.round.addChild(armyB);
					armyB.addEventListener("Dropped", Dropped, false, 0, true);
				}
				else if(buttonOn == true)
				{
					Engine.round.removeChild(armyB);
					buttonOn = false;
				}			
			}
			trace(Engine.buildings);
		}	
		private function fishBuild(e:MouseEvent):void
		{
			if(fish_btn.alpha == 1)
			{
				turnOffClick()
				if(buttonOn == false)
				{
					buttonOn = true;
					fishB = new FishPort(stageRef);
					Engine.round.addChild(fishB);
					fishB.addEventListener("Dropped", Dropped, false, 0, true);
					for (var i:int = 0; i < buttons.length; i++)
					{
						if(buttons[i] != fish_btn)
							buttons[i].alpha = 0.2;
					}
				}
				else if(buttonOn == true)
				{
					Engine.round.removeChild(fishB);
					buttonOn = false;
				}
			}
			
			trace(Engine.buildings);
		}		
		private function mineBuild(e:MouseEvent):void
		{
			if(mine_btn.alpha == 1)
			{
				turnOffClick()
				if(buttonOn == false)
				{
					buttonOn = true;
					mineB = new Mine(stageRef);
					Engine.round.addChild(mineB);
					mineB.addEventListener("Dropped", Dropped, false, 0, true);
					for (var i:int = 0; i < buttons.length; i++)
					{
						if(buttons[i] != mine_btn)
							buttons[i].alpha = 0.2;
					}
				}
				else if(buttonOn == true)
				{
					Engine.round.removeChild(mineB);
					buttonOn = false;
				}
			}

			trace(Engine.buildings);
		}		
		private function towerBuild(e:MouseEvent):void
		{
			if(tower_btn.alpha == 1)
			{
				turnOffClick()
				if(buttonOn == false)
				{
					buttonOn = true;
					towerB = new Tower(stageRef);
					Engine.round.addChild(towerB);
					towerB.addEventListener("Dropped", Dropped, false, 0, true);
					for (var i:int = 0; i < buttons.length; i++)
					{
						if(buttons[i] != tower_btn)
							buttons[i].alpha = 0.2;
					}
				}
				else if(buttonOn == true)
				{
					Engine.round.removeChild(towerB);
					buttonOn = false;
				}
			}

			trace(Engine.buildings);
		}
		private function constructionFactoryBuild(e:MouseEvent):void
		{
			if(construction_btn.alpha == 1)
			{
				turnOffClick()
				if(buttonOn == false)
				{
					buttonOn = true;
					constructionB = new ConstructionFactory(stageRef);
					Engine.round.addChild(constructionB);
					constructionB.addEventListener("Dropped", Dropped, false, 0, true);
					for (var i:int = 0; i < buttons.length; i++)
					{
						if(buttons[i] != construction_btn)
							buttons[i].alpha = 0.2;
					}
				}
				else if(buttonOn == true)
				{
					Engine.round.removeChild(constructionB);
					buttonOn = false;
				}
			}

			trace(Engine.buildings);
		}		
		private function midTowerBuild(e:MouseEvent):void
		{
			if(midTower_btn.alpha == 1)
			{
				turnOffClick()
				if(buttonOn == false)
				{
					buttonOn = true;
					mTowerB = new MidTower(stageRef);
					Engine.round.addChild(mTowerB);
					mTowerB.addEventListener("Dropped", Dropped, false, 0, true);
					for (var i:int = 0; i < buttons.length; i++)
					{
						if(buttons[i] != midTower_btn)
							buttons[i].alpha = 0.2;
					}
				}
				else if(buttonOn == true)
				{
					Engine.round.removeChild(mTowerB);
					buttonOn = false;
				}
			}

			trace(Engine.buildings);
		}	
		private function labBuild(e:MouseEvent):void
		{
			if(lab_btn.alpha == 1)
			{
				turnOffClick()
				if(buttonOn == false)
				{
					buttonOn = true;
					lab = new Lab(stageRef);
					Engine.round.addChild(lab);
					lab.addEventListener("Dropped", Dropped, false, 0, true);
					for (var i:int = 0; i < buttons.length; i++)
					{
						if(buttons[i] != lab_btn)
							buttons[i].alpha = 0.2;
					}
				}
				else if(buttonOn == true)
				{
					Engine.round.removeChild(lab);
					buttonOn = false;
				}
			}

			trace(Engine.buildings);
		}	
		private function airBuild(e:MouseEvent):void 
		{
			if(air_btn.alpha == 1)
			{
				turnOffClick()
				if(buttonOn == false)
				{
					buttonOn = true;
					air = new AirControlTower(stageRef);
					Engine.round.addChild(air);
					air.addEventListener("Dropped", Dropped, false, 0, true);
					for (var i:int = 0; i < buttons.length; i++)
					{
						if(buttons[i] != air_btn)
							buttons[i].alpha = 0.2;
					}
				}
				else if(buttonOn == true)
				{
					Engine.round.removeChild(air);
					buttonOn = false;
				}
			}

			trace(Engine.buildings);			
		}		
		private function turnOffClick()
		{
			for(var i:int = 0; i < Engine.buildings.length; i++)
				Engine.buildings[i].clickOn = false;
		}		
		private function menuUporDown()
		{
			if(menuUp == true)
			{
				if(y >= 575)
					y -= 15;	
			}
			else if(menuUp == false)
			{
				if(y < 675)
					y += 15;
			}
		}		
		private function moveRightButtons(e:MouseEvent)
		{
			//moveButtons = 1;
		}		
		private function moveLeftButtons(e:MouseEvent)
		{
			//moveButtons = 2;
		}		
		private function moveButtonsOff(e:MouseEvent)
		{
			moveButtons = 0;
		}	
		private function menuUpGo(e:MouseEvent)
		{				
			if(menuUp == false)
				menuUp = true;
			else if(menuUp == true)
				menuUp = false;
		}
	}
}