package com.asgamer
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class MaskSquare extends MovieClip
	{
		private var stageRef:Stage;
		private var timer:Timer;
		private var blocker:Boolean = false;
		private var deleteStart:Boolean = false;;
		public function MaskSquare(stageRef:Stage)
		{
			this.stageRef = stageRef;
			
			timer = new Timer(250, 1);
			timer.addEventListener(TimerEvent.TIMER, unBlock);
			addEventListener(MouseEvent.CLICK, moveUnit);
			addEventListener(MouseEvent.MOUSE_DOWN, drawing);
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function unBlock(e:TimerEvent):void 
		{
			blocker = false;
		}
		
		private function loop(e:Event):void 
		{
			if (blocker == false)
			{
				checking(Engine.buildings);
				checking(Engine.troops);
				blocker = true;
				timer.start();
			}
			
			if (deleteStart == true)
			{
				blocker = true;
				alpha -= 0.2;
			}
			
			if (alpha <= 0)
				removeSelf();
		}
		
		private function checking(someArray:Array):void 
		{
			if (someArray[0] != null)
			{
				for (var i:int = 0; i < someArray.length; i++)
				{
					if (hitTestObject(someArray[i]))
					{
						deleteStart = true;
						break;
					}
				}
			}
		}
		
		private function drawing(e:MouseEvent):void 
		{
			dispatchEvent(new Event("startDrawing"));
		}
		
		private function moveUnit(e:MouseEvent):void 
		{
			if(Round.stopClick == false)
				dispatchEvent(new Event("hitPlace"));
		}
		
		public function removeSelf()
		{
			if (Engine.round.contains(this))
			{
				Engine.round.removeChild(this);
				removeEventListener(MouseEvent.CLICK, moveUnit);
				removeEventListener(MouseEvent.MOUSE_DOWN, drawing);
				removeEventListener(Event.ENTER_FRAME, loop);
				delete(this);
			}
		}
	}
}