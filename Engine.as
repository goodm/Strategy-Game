package com.asgamer
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Engine extends MovieClip
	{
		private var startButton:StartGame;
		public static var round:Round;
		public static var score:Score;		
		public static var _menu:MainMenu;
		public static var oMenu:ObjectMenu;
		private var leftArrow:MoveArrows;
		private var rightArrow:MoveArrows;
		private var topArrow:MoveArrows;
		private var bottomArrow:MoveArrows;
		private var conMenu:ConMenu;
		private var lMenu:LabMenu;
		public static var constructionMenu:Boolean = false;
		public static var enemies:Array = new Array();
		public static var buildings:Array = new Array();
		public static var golds:Array = new Array();
		public static var troops:Array = new Array();
		public static var maskSquares:Array = new Array();
		public static var oMenuOn:Boolean = false;
		private var moving:int = 0;
		private var labolatoryMenu:Boolean = false;

		public static var currentLevel:int = 1;
		
		public function Engine()
		{
			startButton = new StartGame(stage);
			
			finnished();	
			
			addEventListener("level2", displayLevel2);
			addEventListener("level3", displayLevel3);
			addEventListener("level4", displayLevel4);
			addEventListener("level5", displayLevel5);
		}
		
		private function displayLevel5(e:Event):void 
		{
			var level = new Level(stage, "Level 5","More, more enemies...");
			level.x = stage.stageWidth / 2;
			level.y = stage.stageHeight / 2;
			stage.addChild(level);		
			currentLevel = 5;
			removeEventListener("level5", displayLevel5);			
		}
		
		private function displayLevel2(e:Event):void 
		{
			var level = new Level(stage, "Level 2","Prepare to protect");
			level.x = stage.stageWidth / 2;
			level.y = stage.stageHeight / 2;
			stage.addChild(level);		
			_menu.level2 = true;
			currentLevel = 2;
			removeEventListener("level2", displayLevel2);
		}
		
		private function displayLevel3(e:Event):void 
		{
			var level = new Level(stage, "Level 3","Be ready for stronger eniemies");
			level.x = stage.stageWidth / 2;
			level.y = stage.stageHeight / 2;
			stage.addChild(level);		
			currentLevel = 3;
			removeEventListener("level3", displayLevel3);
		}
		
		private function displayLevel4(e:Event):void 
		{
			var level = new Level(stage, "Level 4","They can attack from anyside");
			level.x = stage.stageWidth / 2;
			level.y = stage.stageHeight / 2;
			stage.addChild(level);		
			currentLevel = 4;
			removeEventListener("level4", displayLevel4);
		}		
		
		private function loop(e:Event)
		{			
			buildingsChecking();
			stopDrawing();				
			objectMenuOption();			
			removeConstructionMenu();
			moveRound();
			
			if (buildings.length > 5)
			{
				dispatchEvent(new Event("level2"));
			}
			
			if (score.score >= 1200 && score.score < 2800)
			{
				dispatchEvent(new Event("level3"));
			}
			else if (score.score >= 2800 && score.score < 5000)
			{
				dispatchEvent(new Event("level4"));
			}
			else if (score.score >= 5000)
			{
				dispatchEvent(new Event("level5"));
			}
		}
		
		private function progressHandler(e:ProgressEvent)
		{
			var myProgress:Number = e.target.bytesLoaded/e.target.bytesTotal;
			trace(myProgress);
			startButton.scaleX =myProgress;
		}
		
		private function finnished()
		{		
			stage.addChild(startButton);	
			oMenu = new ObjectMenu(stage);
			conMenu = new ConMenu(stage);
			lMenu = new LabMenu(stage);
			_menu = new MainMenu(stage);	
			round = new Round(stage);
			score = new Score(stage);
			leftArrow = new MoveArrows(stage);
			rightArrow = new MoveArrows(stage);
			topArrow = new MoveArrows(stage);
			bottomArrow = new MoveArrows(stage);
			
			startButton.addEventListener(MouseEvent.CLICK,begin);
			addEventListener(Event.ENTER_FRAME, loop);
			oMenu.addEventListener("Contraction Menu", connMenu);
			oMenu.addEventListener("Lab Menu",labMenu);
			round.addEventListener("Menu Off",MenuOff);			
		}		
		
		private function labMenu(e:Event):void 
		{
			trace("lab");
			lMenu.indexLab = oMenu.buildIndex;
			stage.addChild(lMenu);
			lMenu.x = 150;
			lMenu.y = 40;
			labolatoryMenu = true;			
		}
		
		private function connMenu(e:Event)
		{
			conMenu.indexCon = oMenu.buildIndex;
			stage.addChild(conMenu);
			conMenu.x = stage.stageWidth/2;
			conMenu.y = stage.stageHeight/2;
			constructionMenu = true;
		}
		
		private function MenuOff(e:Event)
		{
			constructionMenu = false;
			labolatoryMenu = false;
		}		
		
		private function removeConstructionMenu():void 
		{
			if(constructionMenu == false)
			{
				if(stage.contains(conMenu))
					stage.removeChild(conMenu)
			}	
			
			if(labolatoryMenu == false)
			{
				if(stage.contains(lMenu))
					stage.removeChild(lMenu)
			}				
			
		}		
		
		private function objectMenuOption():void 
		{
			if(round.contains(oMenu))
			{
				if(oMenuOn == true)
					oMenu.alpha = 1;
					
				else if(oMenuOn == false)
				{
					if(oMenu.alpha > 0)
						oMenu.alpha -= 0.1;
					else if(oMenu.alpha <=0)
					{
						round.removeChild(oMenu);
					}
				}	
			}			
		}
		
		private function stopDrawing():void 
		{
			if(MainMenu.buttonOn == true)
				round.drawing = false;			
		}
		
		private function buildingsChecking():void 
		{
			if(buildings[0] != null)
			{
				for(var i:int = 0; i < buildings.length; i++)
				{
					
					if(buildings[i].life <= 0)
					{
						if(oMenu.buildIndex == i)
						{
							oMenuOn = false;
							round.removeChild(oMenu);
							oMenu.buildIndex = 0;
						}
						buildings[i].removeSelf(stage);
						buildings.splice(i, 1);
						break;
					}
					
					if(buildings[i].clickOn == true)
					{
						round.drawing = false;
						round.addChild(oMenu);
						oMenu.x = buildings[i].x + buildings[i].width/2;
						oMenu.y = buildings[i].y - buildings[i].height/2;
						oMenu.buildIndex = i;
						oMenuOn = true;
						break;
					}
					else
					{
						oMenuOn = false;
						oMenu.buildIndex = 0;
					}
					
					if (buildings[0] == null)
						break;
				}
			}	
		}
		

		
		private function begin(e:MouseEvent):void
		{	
			stage.addChild(round);
			addingArrows();
			stage.addChild(_menu);
			stage.addChild(score);
			score.x = 80;
			score.y = 540;
			round.addEventListener("hitPlace", hitHere, false, 0, true);
			
			var level = new Level(stage, "Level 1","Build your base");
			level.x = stage.stageWidth / 2;
			level.y = stage.stageHeight / 2;
			stage.addChild(level);
		}
		
		private function addingArrows():void 
		{
			stage.addChild(leftArrow);
			leftArrow.x = 0;
			leftArrow.y = stage.stageHeight / 2;
			leftArrow.rotation = 180;
			
			stage.addChild(rightArrow);
			rightArrow.x = stage.stageWidth;
			rightArrow.y = stage.stageHeight / 2;
			
			stage.addChild(topArrow);
			topArrow.x = stage.stageWidth/2;
			topArrow.y = 0;
			topArrow.rotation = -90;
			
			stage.addChild(bottomArrow);
			bottomArrow.x = stage.stageWidth/2;
			bottomArrow.y = stage.stageHeight;
			bottomArrow.rotation = 90;
			
			leftArrow.addEventListener(MouseEvent.MOUSE_OVER, moveLeft);
			leftArrow.addEventListener(MouseEvent.MOUSE_OUT, moveOut);
			rightArrow.addEventListener(MouseEvent.MOUSE_OVER, moveRight);
			rightArrow.addEventListener(MouseEvent.MOUSE_OUT, moveOut);	
			topArrow.addEventListener(MouseEvent.MOUSE_OVER, moveUp);
			topArrow.addEventListener(MouseEvent.MOUSE_OUT, moveOut);
			bottomArrow.addEventListener(MouseEvent.MOUSE_OVER, moveDown);
			bottomArrow.addEventListener(MouseEvent.MOUSE_OUT, moveOut);
			
		}
		
		private function moveOut(e:MouseEvent):void 
		{
			moving = 0;
		}
		
		private function moveDown(e:MouseEvent):void 
		{
			moving = 1;
		}
		
		private function moveUp(e:MouseEvent):void 
		{
			moving = 2;
		}
		
		private function moveRight(e:MouseEvent):void 
		{
			moving = 3;
		}
		
		private function moveLeft(e:MouseEvent):void 
		{
			moving = 4;
		}
		
		private function moveRound():void 
		{
			if (moving == 1)
			{
				if(round.y + 2270 >600)
					round.y -=20;			
			}
			else if (moving == 2)
			{
				if(round.y - 380 < 0)
					round.y +=20;					
			}
			else if (moving == 3)
			{
				if(round.x + 2800 > 800)
					round.x -=20;				
			}
			else if (moving == 4)
			{
				if(round.x - 820 < 0)
					round.x +=20;				
			}
		}
				
		
		private function hitHere(e:Event):void
		{
			for(var i:int = 0;i<troops.length;i++)
				troops[i].hitPlace(stage);
		}
	}
}