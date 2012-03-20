package com.asgamer 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author goodm
	 */

	public class Tank extends Unit
	{
		private var stageRef:Stage;
		public const what:String = "Tank";
		
		public function Tank(stageRef:Stage) 
		{
			stop();
			this.stageRef = stageRef;
			enemyPoint = new Point();
			mousePoint = new Point();
			movePoint = new Point();
			addEventListener(MouseEvent.CLICK,moveIt,false,0,true);
			addEventListener(Event.ENTER_FRAME,loop,false,0,true);

			fireTimer = new Timer(shootSpeed, 1);
			fireTimer.addEventListener(TimerEvent.TIMER, fireHandler, false, 0, true);			
			
			functionTimer = new Timer(50, 1);
			functionTimer.addEventListener(TimerEvent.TIMER, releaseFunction);
		}	
		
		override protected function loop(e:Event):void
		{
			targetPoint = new Point(this.x, this.y);	
			unitRotation(tank);
			movingIt(speed);
			
			if (ready == true)
				checkingEnemies(speed);
					
			if (functionRelease == true)
			{
				missingBuildings(square);
				anotherTroops();
				unitsLife(square, lifeBar, lifeBar.green, 25);		
				functionRelease = false;
				functionTimer.start();
			}	
		}
		
		public function takeHit(j)
		{
			myIndex = j;
			life -= 5;
		}
		
	}

}