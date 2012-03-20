package com.asgamer 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author goodm
	 */
	public class MoveArrows extends MovieClip
	{
		private var stageRef:Stage;
		private var appearIt:Boolean = false;
		
		public function MoveArrows(stageRef:Stage) 
		{
			this.stageRef = stageRef;
			addEventListener(MouseEvent.MOUSE_OVER, showIt);
			addEventListener(MouseEvent.MOUSE_OUT, hideIt);
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(e:Event):void 
		{
			if (appearIt == true)
				gotoAndStop(2);
			else
				gotoAndStop(1);
		}
		
		private function hideIt(e:MouseEvent):void 
		{
			appearIt = false;
		}
		
		private function showIt(e:MouseEvent):void 
		{
			appearIt = true;
		}
		
	}

}