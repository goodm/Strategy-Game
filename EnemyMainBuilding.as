package com.asgamer
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	
	public class EnemyMainBuilding extends MovieClip
	{
		private var stageRef:Stage
		private var myPoint, targetPoint:Point;
		private var unitPoint:Point;
		private var buildPoint:Point;
		private var distance:Number;
		private var mX,mY,angle,xDist,yDist,dist,ale:Number;
		private var fireTimer:Timer;
		private var canFire:Boolean = true;
		private var shootSpeed:Number = 50;
		private var life:Number = 100;
		private var moving:Boolean = true;	
		private var tY,tX:Boolean = false;
		
		public function EnemyMainBuilding(stageRef:Stage)
		{
			this.stageRef = stageRef;
			
			fireTimer = new Timer(shootSpeed, 1);
			fireTimer.addEventListener(TimerEvent.TIMER, fireHandler, false, 0, true);			
			addEventListener(MouseEvent.MOUSE_OVER, mOver, false, 0, true);
			myPoint = new Point(x, y);
			targetPoint = new Point();
			unitPoint = new Point;
			buildPoint = new Point;
			addEventListener(Event.ENTER_FRAME,loop,false,0,true);		
		}
		
		private function loop(e:Event):void
		{		
			myPoint.x = x;
			myPoint.y = y;
			
			if(Engine.buildings[0] != null)
			{
				buildPoint.x = Engine.buildings[0].x;
				buildPoint.y = Engine.buildings[0].y;
				
				for (var c:int = 0; c < Engine.buildings.length; c++) 
				{
					if ( Point.distance( myPoint , buildPoint ) > Point.distance( myPoint , new Point( Engine.buildings[c].x , Engine.buildings[c].y ) ) )
					{
						buildPoint.x = Engine.buildings[c].x;
						buildPoint.y = Engine.buildings[c].y;
					}
				}
				
				targetPoint.x = buildPoint.x;
				targetPoint.y = buildPoint.y;
				
				if(Engine.troops[0] != null)
				{
					unitPoint.x = Engine.troops[0].x;
					unitPoint.y = Engine.troops[0].y;
					
					for (var d:int = 0; d < Engine.troops.length; d++) 
					{
						if ( Point.distance( myPoint , unitPoint ) > Point.distance( myPoint , new Point( Engine.troops[d].x , Engine.troops[d].y ) ) )
						{
							unitPoint.x = Engine.troops[d].x;
							unitPoint.y = Engine.troops[d].y;
						}
					}
					
					if(Point.distance(unitPoint,myPoint) <= Point.distance(buildPoint,myPoint))
					{
						targetPoint.x = unitPoint.x;
						targetPoint.y = unitPoint.y;
					}
				}
				
				if(Point.distance( myPoint , targetPoint ) < 800)
				{
					if(canFire == true && Engine.round.contains(this))
					{
						Engine.round.addChild(new Bullet(stage,targetPoint.x,targetPoint.y,x-60,y+20,850));
						canFire = false;
						fireTimer.start();
					}
				}
			}
			
			
			
			
			if (Engine.currentLevel == 2 || Engine.currentLevel == 3 || Engine.currentLevel == 5)
			{
				if(Math.floor(Math.random()*250) == 5)
				{
					var enemy:Enemy = new Enemy(stage);
					Engine.enemies.push(enemy);
					Engine.round.addChild(enemy);
					enemy.x = this.x-200;
					enemy.y = this.y;
				}	
				
				if (Engine.currentLevel == 3)
				{
					if(Math.floor(Math.random()*350) == 5)
					{
						var enemybig:EnemyBig = new EnemyBig(stage);
						Engine.enemies.push(enemybig);
						Engine.round.addChild(enemybig);
						enemybig.x = this.x-200;
						enemybig.y = this.y;
					}
				}
			}
			
			if (Engine.currentLevel == 4 || Engine.currentLevel == 5)
			{
				if(Math.floor(Math.random()*200) == 5)
				{
					var tel:TelEnemy = new TelEnemy(stage);
					Engine.enemies.push(tel);
					Engine.round.addChild(tel);
					tel.x = this.x-200;
					tel.y = this.y;
				}
			}
			
			lifeBar.width = 25/10 * life;
			if(lifeBar.alpha>0)
				lifeBar.alpha -= 0.1;
					
			if(life <=0)
				removeSelf();
		}

		private function mOver(e:MouseEvent)
		{
			lifeBar.alpha = 1;
		}

//Remove enemy from the stage and from balls.array
		private function removeSelf():void
		{
			if(Engine.round.contains(this))
			{
				Engine.round.addChild(new Explosion(stageRef, x, y,width,height));
				Engine.round.removeChild(this);
				Engine.enemies.splice(Engine.enemies.indexOf(this),1);
				trace(Engine.enemies);
			}
		}
//Stop shooting
		private function fireHandler(e:TimerEvent):void
		{
			canFire = true;
		}		
//Take a hit by fire
		public function takeHit()
		{
			lifeBar.alpha = 1;
			life -=0.05;
		}		
		
	}
}