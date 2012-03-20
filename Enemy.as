﻿package com.asgamer
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.senocular.utils.KeyObject;	
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	
	public class Enemy extends MovieClip
	{
		private var stageRef:Stage
		private var myPoint,targetPoint:Point;
		private var unitPoint:Point;
		private var buildPoint:Point;
		private var distance:Number;
		private var mX,mY,angle,xDist,yDist,dist,ale:Number;
		private var fireTimer:Timer;
		private var canFire:Boolean = true;
		private var shootSpeed:Number = 500;
		private var life:Number = 100;
		private var moving:Boolean = true;
		private var key:KeyObject;			
		private var tY,tX:Boolean = false;
		
		public function Enemy(stageRef:Stage)
		{
			this.stageRef = stageRef;
			
			fireTimer = new Timer(shootSpeed, 1);
			fireTimer.addEventListener(TimerEvent.TIMER, fireHandler, false, 0, true);			
			
			myPoint = new Point(x,y);
			targetPoint = new Point();
			unitPoint = new Point();
			buildPoint = new Point();
			addEventListener(MouseEvent.MOUSE_OVER, mOver, false, 0, true);
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
				
				if(Engine.troops[0] != null)
				{
					var realNumber:int = Engine.troops.length;
					
					unitPoint.x = Engine.troops[0].x;
					unitPoint.y = Engine.troops[0].y;
					
					for (var d:int = 0; d < realNumber; d++) 
					{
						if ( Point.distance( myPoint , unitPoint ) > Point.distance( myPoint , new Point( Engine.troops[d].x , Engine.troops[d].y ) ) )
						{
							unitPoint.x = Engine.troops[d].x;
							unitPoint.y = Engine.troops[d].y;
						}
						
						if (Engine.troops.length != realNumber)
						{
							break;
						}						
					}
					
					if(Point.distance(unitPoint,myPoint) <= Point.distance(buildPoint,myPoint))
					{
						targetPoint.x = unitPoint.x;
						targetPoint.y = unitPoint.y;
					}
					else
					{
						targetPoint.x = buildPoint.x;
						targetPoint.y = buildPoint.y;						
					}
				}
				else
				{
					targetPoint.x = buildPoint.x;
					targetPoint.y = buildPoint.y;
				}
				
				
				
			}
			else
			{
				targetPoint.x = 2000 + Math.random()*200;
				targetPoint.y = 2000 + Math.random()*200;
			}
			
			mX = targetPoint.x;
			mY = targetPoint.y;
				
		

			if(Point.distance( myPoint , targetPoint ) > 200)
			{
				angle = Math.atan2(x-mX,y-mY);
				y -= Math.cos(angle)*(180/Math.PI)/30;
				x -= Math.sin(angle)*(180/Math.PI)/30;
			}
			else if(Point.distance( myPoint , targetPoint ) < 110)
			{
				angle = Math.atan2(x-mX,y-mY);
				y += Math.cos(angle)*(180/Math.PI)/30;
				x += Math.sin(angle)*(180/Math.PI)/30;
			}


			
			if(Engine.buildings[0] != null)
			{
				if(Point.distance( myPoint , targetPoint ) < 300)
				{
					if(canFire == true && Engine.round.contains(this))
					{
						Engine.round.addChild(new Bullet(stage,targetPoint.x,targetPoint.y,x,y,350));
						canFire = false;
						fireTimer.start();
					}
				}
			}

//Checking for anothers enemies
			
			var real2:int = Engine.enemies.length;

			for(var b:int = 1; b < real2; b++)
			{
				if(Engine.enemies[b] != this)
				{
					xDist = x - Engine.enemies[b].x;
					yDist =	y - Engine.enemies[b].y;
					dist = Math.sqrt(xDist * xDist + yDist * yDist);
					ale = Math.atan2(yDist,xDist);
						
					if(dist < Engine.enemies[b].width)
					{
						x = Engine.enemies[b].x + (Engine.enemies[b].width * Math.cos(ale));
						y = Engine.enemies[b].y + (Engine.enemies[b].width * Math.sin(ale));
					}
				}
				
				if (real2 != Engine.enemies.length)
				{
					break;
				}
			}
			
			lifeBar.width = 3/10 * life;
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
				Engine.round.addChild(new Explosion(stageRef, x, y, width, height));
				Engine.round.addChild(new KillScore(stageRef, x, y, 50, 50));
				Engine.score.updateFood(50);
				Engine.score.updateGold(50);
				Engine.score.updateScore(80);
				Engine.round.removeChild(this);
				Engine.enemies.splice(Engine.enemies.indexOf(this), 1);
				removeEventListener(Event.ENTER_FRAME, loop);
				delete(this);
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
			life -=5;
		}		
		
	}
}