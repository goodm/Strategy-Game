package com.asgamer
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class ConMenu extends MovieClip
	{
		private var stageRef:Stage;
		public var indexCon:int;
		public var tank:Tank;
		public var dTank:DoubleTank;
		public var chopper:Chopper;
		private var _numbersOfUnit:Number;
		private var air:Boolean = false;
		public function ConMenu(stageRef:Stage)
		{
			this.stageRef = stageRef;
			tank_btn.addEventListener(MouseEvent.CLICK, startCreateTank, false, 0, true);
			dTank_btn.addEventListener(MouseEvent.CLICK, startCreateDTank, false, 0, true);
			tank_btn.addEventListener(MouseEvent.MOUSE_OVER,mouseOverTank, false, 0, true);
			dTank_btn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverDTank, false, 0, true);
			tank_btn.addEventListener(MouseEvent.MOUSE_OUT,mouseOut, false, 0, true);
			dTank_btn.addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
			chopper_btn.addEventListener(MouseEvent.CLICK, startCreateChopper);
			chopper_btn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverChopper);
			chopper_btn.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			_numbersOfUnit = 1;
			qty.text = String(_numbersOfUnit);
		}
		
		private function mouseOverChopper(e:MouseEvent):void 
		{
			if (air == true)
			{
				maxQty(400, 200);				
			}
			else
			max_txt.text = "You need Air Control Tower!";				
		}
		
		private function startCreateChopper(e:MouseEvent):void 
		{
			if (chopper_btn.alpha > 0.2)
			{
				if (_numbersOfUnit > 0)
				{
					var i:int = 1;
					while ( i < _numbersOfUnit+1)
					{
						if(Engine.score.gold < 400 || Engine.score.food < 200)
							break;						
						createChooper();
						i++;
					}
				}
			}
			trace(Engine.troops.length);			
		}
				
		private function mouseOut(e:MouseEvent):void 
		{
			max_txt.text = " ";			
		}
		
		private function mouseOverDTank(e:MouseEvent):void 
		{
			maxQty(200,100);			
		}
		
		private function mouseOverTank(e:MouseEvent):void 
		{
			maxQty(100,50);			
		}
		

		
		private function loop(e:Event)
		{
			checkingButtons();		
			checkingForAir();
			_numbersOfUnit = Number(qty.text);			
		}
		
		private function checkingForAir():void 
		{
			if (Engine.buildings[0] != null)
			{
				for (var i:int = 0; i < Engine.buildings.length; i++)
				{
					if (Engine.buildings[i].what == "Air Control Tower")
					{	
						air = true;
						break;
					}
					else
						air = false;
				}
			}
		}

		private function startCreateTank(e:MouseEvent):void 
		{
			if (tank_btn.alpha > 0.2)
			{
				if (_numbersOfUnit > 0)
				{
					var i:int = 1;
					while ( i < _numbersOfUnit+1)
					{
						if(Engine.score.gold < 100 || Engine.score.food < 50)
							break;						
						createTank();
						i++;
					}
				}
			}
			trace(Engine.troops.length);
		}		
		
		private function startCreateDTank(e:MouseEvent):void 
		{
			if (dTank_btn.alpha > 0.2)
			{
				if (_numbersOfUnit > 0)
				{
					var i:int = 1;
					while ( i < _numbersOfUnit+1)
					{
						if(Engine.score.gold < 200 || Engine.score.food < 100)
							break;						
						createDTank();
						i++;
					}
				}
			}
			trace(Engine.troops.length);			
		}	
		
		private function checkingButtons():void 
		{
			if(Engine.score.gold < 100 || Engine.score.food < 50)
			{
				tank_btn.alpha = 0.2;
			}
			else
				tank_btn.alpha = 1;		
				
			if(Engine.score.gold < 200 || Engine.score.food < 100)
			{
				dTank_btn.alpha = 0.2;
			}
			else
				dTank_btn.alpha = 1;		
				
			if(Engine.score.gold < 400 || Engine.score.food < 200 || air == false)
			{
				chopper_btn.alpha = 0.2;
			}
			else
				chopper_btn.alpha = 1;	
		}
		
		private function maxQty(a:Number,b:Number):void 
		{
			var maxGold:Number = Math.floor(Engine.score.gold / a);
			var maxFood:Number = Math.floor(Engine.score.food / b);
			var mx:Number = 0;
			
			if (maxFood <= maxGold)
			{
				mx = maxFood;
			}
			else
			{
				mx = maxGold;
			}
			
			max_txt.text = "Max units: " + String(mx);
		}
		
		private function createTank()
		{
			Engine.score.updateGold( -100);
			Engine.score.updateFood( -50);
			tank = new Tank(stage);
			Engine.round.addChild(tank);
			tank.x = Engine.buildings[indexCon].x;
			tank.y = Engine.buildings[indexCon].y+15;
			Engine.troops.push(tank);
			tank.goOut(Engine.buildings[indexCon].x+Engine.buildings[indexCon].width/2,Engine.buildings[indexCon].y-Engine.buildings[indexCon].height/2);
		}
		
		private function createDTank():void 
		{
			Engine.score.updateGold( -200);
			Engine.score.updateFood( -100);
			dTank = new DoubleTank(stage);
			Engine.round.addChild(dTank);
			dTank.x = Engine.buildings[indexCon].x;
			dTank.y = Engine.buildings[indexCon].y+15;
			Engine.troops.push(dTank);
			dTank.goOut(Engine.buildings[indexCon].x+Engine.buildings[indexCon].width/2,Engine.buildings[indexCon].y-Engine.buildings[indexCon].height/2);			
		}
		
		private function createChooper():void 
		{
			Engine.score.updateGold( -400);
			Engine.score.updateFood( -200);
			chopper = new Chopper(stage);
			Engine.round.addChild(chopper);
			chopper.x = Engine.buildings[indexCon].x;
			chopper.y = Engine.buildings[indexCon].y+15;
			Engine.troops.push(chopper);
			chopper.goOut(Engine.buildings[indexCon].x+Engine.buildings[indexCon].width/2,Engine.buildings[indexCon].y-Engine.buildings[indexCon].height/2);					
		}		
	}
}