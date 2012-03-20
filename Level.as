package com.asgamer 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author goodm
	 */
	public class Level extends MovieClip
	{
		private var stageRef:Stage;
		private var onOff:Boolean = false;;
		
		public function Level(stageRef:Stage, main:String,sub:String) 
		{
			this.stageRef = stageRef;
			main_txt.text = main;
			sub_txt.text = sub;
			
			alpha = 0;
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function removeSelf():void 
		{
			if (stageRef.contains(this))
				stageRef.removeChild(this);
		}
		
		private function loop(e:Event):void 
		{
			if (onOff == false)
			{
				if (alpha < 1)
				{
					alpha += 0.02;
				}
				else
				{
					onOff = true;
				}
			}
			else if (onOff == true)
			{
				if (alpha > 0)
				{
					alpha -= 0.02;
				}
				else
				{
					removeSelf();
				}
			}
		}
		
	}

}