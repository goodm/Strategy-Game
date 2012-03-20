package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Score extends MovieClip
	{
		private var stageRef:Stage;
		private var goodm:Boolean = false;
		private var unitName:String;
		public var gold:Number = 13000;
		public var food:Number = 13000;
		public var score:Number = 0;
		
		public function Score(stageRef:Stage)
		{
			this.stageRef = stageRef;
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);	
			goodm_btn.addEventListener(MouseEvent.MOUSE_OVER, goodmOn);
			goodm_btn.addEventListener(MouseEvent.MOUSE_OUT, goodmOff);
		}
		
		private function goodmOff(e:MouseEvent):void 
		{
			goodm = false;
		}
		
		private function goodmOn(e:MouseEvent):void 
		{
			goodm = true;
		}
		
		private function loop(e:Event)
		{
			gold_txt.text = String(Math.floor(gold));
			food_txt.text = String(Math.floor(food));
			score_txt.text = String(Math.floor(score)) +" points";
			if (Engine.troops[0] != null)
			{
				var counter:int = 0;
				var unitLife:Number = 0;
				
				for (var i:int = 0; i < Engine.troops.length; i++)
				{
					if (Engine.troops[i].startMoving == true)
					{
						counter ++;
						unitName = Engine.troops[i].what;
						unitLife = Engine.troops[i].life;
					}
				}
				
				if (goodm == false)
				{
					if (counter == 1)
						units_txt.text = unitName + "\nLife: " + String(unitLife) + "%";
					else if (counter > 1)
						units_txt.text = String(counter) + " units selected";
					else if (counter == 0)
						units_txt.text = " " ;
				}
				else if (goodm == true)
				{
					units_txt.text = "Goodm@vp.pl\nwww.goodm.co.uk";
				}
			}
			else
			{
			if (goodm == true)
				units_txt.text = "Goodm@vp.pl\nwww.goodm.co.uk";
			else
				units_txt.text = " " ;
			}
		}
		
		public function updateFood(value:Number):void
		{
			food +=value;
		}
		
		public function updateGold(value:Number):void
		{
			gold +=value;
		}	
		
		public function updateScore(value:Number):void
		{
			score += value;
		}
	}
}