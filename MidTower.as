package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;	
	
	
	public class MidTower extends MainBuild
	{
		private var stageRef:Stage;
		public const what:String = "Medium Tower";

		private var targetPoint,enemyPoint:Point;

		private var fireTimer:Timer;
		private var canFire:Boolean = true;
		private var shootSpeed:Number = 150;
		
		public function MidTower(stageRef:Stage)
		{
			this.stageRef = stageRef;
			addEventListener(Event.ENTER_FRAME,loop,false,0,true);
			addEventListener(MouseEvent.CLICK,dropTower,false,0,true);
			enemyPoint = new Point();
//Timers settings			
			fireTimer = new Timer(shootSpeed, 1);
//Timers functions
			fireTimer.addEventListener(TimerEvent.TIMER, fireHandler, false, 0, true);		
		}
		
		override protected function loop(e:Event):void
		{
			if(shootSpeed > 50)
				shootSpeed = 350 - 50*level;
			else
				shootSpeed = 50;
				
			dropper(stageRef);
			blocker();
			clicker(square,lifeBar,upBar);
			lifeStatus(lifeBar,lifeBar.green,7,square);
			upgradStart(upBar,upBar.blue,7);
			repairStart();
			
			targetPoint = new Point(this.x,this.y);		
			
			if(Engine.enemies[0] != null && startWorking == true)
			{
				for(var b:int = 0; b < Engine.enemies.length; b++)
				{
					enemyPoint.x = Engine.enemies[b].x;
					enemyPoint.y = Engine.enemies[b].y;
					
					if(Point.distance(targetPoint, enemyPoint) < 400)
					{
						if(canFire == true && stageRef.contains(this))
						{
							Engine.round.addChild(new Fire(stage,Engine.enemies[b].x,Engine.enemies[b].y,x,y,450));
							canFire = false;
							fireTimer.start();
						}
					}
				}
			}
		}	
		private function dropTower(e:MouseEvent)
		{
			mainDrop(-500,-500);
			startWorking = true;
		}
		
//Stop shooting
		private function fireHandler(e:TimerEvent):void
		{
			canFire = true;
		}
		
		public function takeHit()
		{
			life -=0.5;
		}
	}
}