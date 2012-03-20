package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.senocular.utils.KeyObject;
	import flash.ui.Keyboard;
	import flash.display.Shape;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Round extends MovieClip
	{
		private var stageRef:Stage;
		private var key:KeyObject;		
		private var enemyB:EnemyMainBuilding;
		private var myShape:Shape;
		public var drawing:Boolean = false;
		private var mX,mY:Number;
		private var stopper:Timer;
		public static var stopClick:Boolean = false;	
		private var roundIndex:int;
		
		public function Round(stageRef:Stage)
		{	
			this.stageRef = stageRef;
			key = new KeyObject(stageRef);	
			
			addMainEnemy();			
			addGoldToRound();
			
			background.addEventListener(MouseEvent.CLICK, setOut, false, 0 , true);
			addEventListener(Event.ENTER_FRAME,loop,false,0,true);
			background.addEventListener(MouseEvent.MOUSE_DOWN,startDraw,false,0,true);
			background.addEventListener(MouseEvent.MOUSE_UP, stopDraw, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, stopDraw, false, 0, true);
			stageRef.addEventListener(Event.MOUSE_LEAVE, stopDrawing,false,0,true);
			
			myShape = new Shape();		
			stopper = new Timer(300, 1);
			stopper.addEventListener(TimerEvent.TIMER, comeBack, false, 0, true);
			
			maskCover();	
		}
		
		private function addMainEnemy():void 
		{
			var random:Number = Math.random() * 10;
			if (random <= 3)
			{
				enemyB = new EnemyMainBuilding(stage);
				enemyB.x = 2630;
				enemyB.y = 2135;
				this.addChild(enemyB);
				Engine.enemies.push(enemyB);						
			}
			else if (random > 3 && random <= 6)
			{
				enemyB = new EnemyMainBuilding(stage);
				enemyB.x = 2630;
				enemyB.y = -235;
				this.addChild(enemyB);
				Engine.enemies.push(enemyB);				
			}
			else
			{
				enemyB = new EnemyMainBuilding(stage);
				enemyB.x = -640;
				enemyB.y = 2157;
				this.addChild(enemyB);
				Engine.enemies.push(enemyB);				
			}
		}
		
		private function addGoldToRound():void 
		{
			for(var i:int = 0; i < 10; i++)
			{
				var gold:Gold = new Gold(stage);
				this.addChild(gold);
				gold.x = Math.random()*2000;
				gold.y = Math.random()*2000;
				Engine.golds.push(gold);
			}			
		}
		
		private function stopDrawing(e:Event):void 
		{
			drawing = false;
		}
		
		private function loop(e:Event)
		{
			moveRound();			
			drawingSquare();	
			roundIndex = getMaxRoundIndex();
		}
		
		private function moveRound():void 
		{
			if(key.isDown(Keyboard.DOWN))
			{
				if(y + 2270 >600)
					y -=20;
			}
			else if(key.isDown(Keyboard.UP))
			{
				if(y - 380 < 0)
					y +=20;
			}
			if(key.isDown(Keyboard.LEFT))
			{
				if(x - 820 < 0)
					x +=20;
			}
			else if(key.isDown(Keyboard.RIGHT))
			{
				if(x + 2800 > 800)
					x -=20;
			}					
		}
		
		private function maskCover()
		{
			for(var i:int = 1;i < 14; i++)
			{
				for(var j:int = 1;j < 14;j++)
				{
					var maskSquare:MaskSquare = new MaskSquare(stage);
					this.addChild(maskSquare);
					maskSquare.x = -1089+288*i;
					maskSquare.y = -584 + 208 * j;
					maskSquare.addEventListener("hitPlace", hitHere);
					maskSquare.addEventListener("startDrawing", startDrawing);
					Engine.maskSquares.push(maskSquare);
				}
			}
		}
		
		private function startDrawing(e:Event):void 
		{
			mX = stageRef.mouseX;
			mY = stageRef.mouseY;
			drawing = true;			
		}
		
		private function hitHere(e:Event):void 
		{
			stageClick();		
		}
		
		private function setOut(e:MouseEvent)
		{
			stageClick();
		}
		
		private function stageClick():void 
		{
			for(var i:int = 0; i < Engine.buildings.length; i++)
			{	
				Engine.buildings[i].clickOn = false;
			}
			
			MainMenu.menuUp = false;	
			dispatchEvent(new Event("Menu Off"));
			
			if(stopClick == false)
				dispatchEvent(new Event("hitPlace"));				
		}
		
		private function comeBack(e:TimerEvent):void
		{
			stopClick = false;
		}
		
		private function drawingSquare()
		{
			if(drawing == true)
			{
				myShape.graphics.clear();
				myShape.graphics.lineStyle(0.01,0x010101,0.5);
				myShape.graphics.beginFill(0x010101, 0.2);
				myShape.graphics.moveTo(mX,mY);
				myShape.graphics.lineTo(mX,stageRef.mouseY);
				myShape.graphics.lineTo(stageRef.mouseX,stageRef.mouseY);
				myShape.graphics.lineTo(stageRef.mouseX,mY);
				myShape.graphics.lineTo(mX,mY);
				myShape.graphics.endFill();
				stageRef.addChild(myShape);
			}
			else
			{
				if(stageRef.contains(myShape))
					{
						stageRef.removeChild(myShape);
						myShape.graphics.clear();
					}
			}
		}
		
		private function startDraw(e:MouseEvent):void
		{
			mX = stageRef.mouseX;
			mY = stageRef.mouseY;
			drawing = true;
		}	
		
		private function stopDraw(e:MouseEvent):void
		{
			drawing = false;
			
			if (Engine.troops[0] != null)
			{
				for(var i:int = 0;i < Engine.troops.length; i++)
				{
					if(myShape.hitTestObject(Engine.troops[i]))
					{
						Engine.troops[i].startMoving = true;
						stopClick = true;
					}
					
					if (Engine.troops[i].what == "Chopper")
					{
						setChildIndex(Engine.troops[i], roundIndex);
					}
				}
			}	
			stopper.start();
		}
		
		private function getMaxRoundIndex():int
		{
			if (Engine.buildings[0] != null)
			{
				var max:int = Engine.buildings[0];
				
				for (var j:int = 0; j < Engine.buildings.length; j++)
				{
					if( max < getChildIndex(Engine.buildings[i]))
						max = getChildIndex(Engine.buildings[i]);				
				}
				if (Engine.troops[0] != null)
				{
					for (var i:int = 0; i < Engine.troops.length; i++)
					{
						if( max < getChildIndex(Engine.troops[i]))
							max = getChildIndex(Engine.troops[i]);
					}				
				}
				return max;
			}
			else
				return 0;
		}
	}
}