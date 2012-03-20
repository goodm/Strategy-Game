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
	public class DoubleTank extends Unit
	{
		private var stageRef:Stage;
		public const what:String = "Double Tank";
		
		public function DoubleTank(stageRef:Stage) 
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
		}
		
		override protected function loop(e:Event):void
		{
			targetPoint = new Point(this.x, this.y);	
			movingIt(speed+5);
			missingBuildings(square);
			anotherTroops();
			unitsLife(square,lifeBar,lifeBar.green,35);
			
			if (ready == true)
				checkingEnemies(speed+5);
				
			unitRotation(tank);
		}	
		
		override protected function checkingEnemies(speed:Number)
		{
			if(Engine.enemies[0] != null)
			{
				var realNumber:int = Engine.enemies.length;
				
				enemyPoint.x = Engine.enemies[0].x;
				enemyPoint.y = Engine.enemies[0].y;						
				
				for(var c:int = 0; c < realNumber; c++)
				{
					if ( Point.distance( targetPoint , enemyPoint ) > Point.distance( targetPoint , new Point( Engine.enemies[c].x , Engine.enemies[c].y )))
					{
						enemyPoint.x = Engine.enemies[c].x;
						enemyPoint.y = Engine.enemies[c].y;
					}
					
					if (realNumber != Engine.enemies.length)
					{
						break;
					}
				}				
				
				if(Point.distance(targetPoint, enemyPoint) < 400)
				{	
					if(myMove == false)
					{
						if(Point.distance(targetPoint, enemyPoint) > 200)
						{
							mX = enemyPoint.x ;
							mY = enemyPoint.y;
							angle = Math.atan2(x-mX,y-mY);
							y -= Math.cos(angle)*(180/Math.PI)/speed;
							x -= Math.sin(angle) * (180 / Math.PI) /speed;
							rotation = -(angle*180/Math.PI);
						}
						else if(Point.distance(targetPoint, enemyPoint) < 100)
						{
							mX = enemyPoint.x ;
							mY = enemyPoint.y;
							angle = Math.atan2(x-mX,y-mY);
							y += Math.cos(angle)*(180/Math.PI)/speed;
							x += Math.sin(angle) * (180 / Math.PI) /speed;
							rotation = -(angle*180/Math.PI);
						}
					}
				}
				
				if(Point.distance(targetPoint, enemyPoint) < 250)
				{
					if(canFire == true && Engine.round.contains(this))
					{
						Engine.round.addChild(new Fire(stage, enemyPoint.x, enemyPoint.y, x + Math.cos(rotation) * 10, y + Math.sin(rotation) * 10, 300));
						Engine.round.addChild(new Fire(stage, enemyPoint.x, enemyPoint.y, x - Math.cos(rotation) * 10, y - Math.sin(rotation) * 10, 300));
						canFire = false;
						fireTimer.start();
					}
				}	
			}		
		}
		
		public function takeHit(j)
		{
			myIndex = j;
			life -= 2;
		}
		
	}

}