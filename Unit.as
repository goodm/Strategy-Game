package com.asgamer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	
	public class Unit extends MovieClip
	{
		protected var stageUnit:Stage;
		public var startMoving:Boolean = false;
		protected var tX:Boolean = false;
		protected var tY:Boolean = false;
		public var moving:Boolean = false;
		protected var mX,hX:Number;
		protected var mY,hY:Number;
		protected var angle:Number = 0;
		protected var mousePoint,targetPoint,enemyPoint:Point;
		protected var movePoint:Point;
		public var distance:Number;
		protected var xDist,yDist,dist,ale:Number;
		public var life:Number = 100;
		protected var ready:Boolean = false;
		protected var fireTimer:Timer;
		protected var canFire:Boolean = true;
		public static var shootSpeed:Number = 300;
		public static var speed:Number = 20;
		
		protected var myIndex:int;
		
		protected var myMove:Boolean = false;
			
		protected var functionRelease:Boolean = true;
		protected var functionTimer:Timer;
		
		
		protected function unitRotation(unitTank:MovieClip):void 
		{
			if(0 < rotation && rotation <= 90)
				unitTank.gotoAndStop("druga");
			else if(90 < rotation && rotation <= 180)
				unitTank.gotoAndStop("trzecia");
			else if(-90 < rotation && rotation <= 0)
				unitTank.gotoAndStop("pierwsza");
			else 
				unitTank.gotoAndStop("czwarta");			
		}
		
		protected function releaseFunction(e:TimerEvent):void 
		{
			functionRelease = true;
		}	
		
		public function goOut(startX:Number,startY:Number)
		{
			mX = startX;
			mY = startY;
			movePoint.x = mX;
			movePoint.y = mY;
			tX = true;
		}
		
		protected function movingIt(speed:Number)
		{
			if(moving == true)
			{
				if(tX == false )
				{
					angle = Math.atan2(x-mX,y-mY);
					y -= Math.cos(angle)*(180/Math.PI)/speed;
					x -= Math.sin(angle)*(180/Math.PI)/speed;
					rotation = -(angle*180/Math.PI);
				}
				else if(tX == true )
				{
					angle = Math.atan2(x-movePoint.x,y-movePoint.y);
					y -= Math.cos(angle)*(180/Math.PI)/speed;
					x -= Math.sin(angle)*(180/Math.PI)/speed;
					rotation = -(angle*180/Math.PI);
					
					if(Point.distance(targetPoint,movePoint)<20||Point.distance(targetPoint,mousePoint)<=100)
					{
						tX = false;
					}
				}
				
				if(Point.distance(mousePoint,targetPoint)<10)
				{
					moving = false;
					myMove = false;
					tX = false;
				}
			}
			else if (moving == false)
			{
				if (tX == true)
				{
					angle = Math.atan2(x-movePoint.x,y-movePoint.y);
					y -= Math.cos(angle)*(180/Math.PI)/speed;
					x -= Math.sin(angle)*(180/Math.PI)/speed;
					rotation = -(angle*180/Math.PI);
					
					if (Point.distance(targetPoint, movePoint) < 20)
					{
						tX = false;
						ready = true;
					}	
				}
			}
		}
		
		protected function anotherTroops()
		{
			var realNumber:int = Engine.troops.length;
			
			for(var i:int = 0; i < realNumber; i++)
			{
				if(Engine.troops[i] != this)
				{
					if(moving == false && tX == false)
					{
						xDist = x - Engine.troops[i].x;
						yDist =	y - Engine.troops[i].y;
						dist = Math.sqrt(xDist * xDist + yDist * yDist);
						ale = Math.atan2(yDist,xDist);
						
						if(dist < Engine.troops[i].square.height)
						{
							if (Engine.troops[i].what != "Chopper")
							{
								x = Engine.troops[i].x + (Engine.troops[i].square.height * Math.cos(ale));
								y = Engine.troops[i].y + (Engine.troops[i].square.height * Math.sin(ale));
							}
						}
					}
				}
				
				if (Engine.troops.length != realNumber)
				{
					break;
				}
			}
		}		
		
		protected function checkingEnemies(speed:Number)
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
							x -= Math.sin(angle) * (180 / Math.PI) / speed;
							rotation = -(angle*180/Math.PI);
						}
						else if(Point.distance(targetPoint, enemyPoint) < 100)
						{
							mX = enemyPoint.x ;
							mY = enemyPoint.y;
							angle = Math.atan2(x-mX,y-mY);
							y += Math.cos(angle)*(180/Math.PI)/speed;
							x += Math.sin(angle) * (180 / Math.PI) / speed;
							rotation = -(angle*180/Math.PI);
						}
					}
				}
				
				if(Point.distance(targetPoint, enemyPoint) < 250)
				{
					if(canFire == true && Engine.round.contains(this))
					{
						Engine.round.addChild(new Fire(stage,enemyPoint.x,enemyPoint.y,x,y,300));
						canFire = false;
						fireTimer.start();
					}
				}	
			}
		}
		
		protected function unitsLife(sq:MovieClip,lBar:MovieClip,gB:MovieClip,lev:Number)
		{
			if(startMoving)
			{
				sq.alpha = 1;
				lBar.alpha = 1;
			}
			else
			{

				if(lBar.alpha>0)
				{
					lBar.alpha -= 0.1;
					sq.alpha -= 0.1;
				}
			}	
			
			lBar.width = lev/100 * life;
			gB.alpha = life/100-0.2;
			
			if(life <= 0)
			{
				removeSelf();
			}
		}
		
		protected function missingBuildings(sq:MovieClip)
		{
			if(Engine.buildings[0] != null)
			{
				for(var d:int = 0;d<Engine.buildings.length;d++)
				{
					if(sq.hitTestObject(Engine.buildings[d].tb))
					{
						if(tX==false)
						{
							movePoint.y = Engine.buildings[d].y - Engine.buildings[d].height/2-20;
							if(Math.abs(mX-(Engine.buildings[d].x- Engine.buildings[d].width/2)) < Math.abs(mX-(Engine.buildings[d].x+Engine.buildings[d].width/2)))
								movePoint.x = Engine.buildings[d].x - Engine.buildings[d].width/2-20;
							else if(Math.abs(mX-(Engine.buildings[d].x- Engine.buildings[d].width/2)) > Math.abs(mX-(Engine.buildings[d].x+Engine.buildings[d].width/2)))
								movePoint.x = Engine.buildings[d].x + Engine.buildings[d].width/2+20;
							tX = true;
							break;
						}
					}
					else if(sq.hitTestObject(Engine.buildings[d].bb))
					{
						if(tX==false)
						{
							movePoint.y = Engine.buildings[d].y + Engine.buildings[d].height/2+20;
							if(Math.abs(mX-(Engine.buildings[d].x- Engine.buildings[d].width/2)) < Math.abs(mX-(Engine.buildings[d].x+Engine.buildings[d].width/2)))
								movePoint.x = Engine.buildings[d].x - Engine.buildings[d].width/2-20;
							else if(Math.abs(mX-(Engine.buildings[d].x- Engine.buildings[d].width/2)) > Math.abs(mX-(Engine.buildings[d].x+Engine.buildings[d].width/2)))
								movePoint.x = Engine.buildings[d].x + Engine.buildings[d].width/2+20;
							tX = true;
							break;
						}
					}
					else if(sq.hitTestObject(Engine.buildings[d].lb))
					{
						if(tX==false)
						{
							movePoint.x = Engine.buildings[d].x - Engine.buildings[d].width/2-20;
							if(Math.abs(mY-(Engine.buildings[d].y- Engine.buildings[d].height/2)) < Math.abs(mY-(Engine.buildings[d].y+Engine.buildings[d].height/2)))
								movePoint.y = Engine.buildings[d].y - Engine.buildings[d].height/2-20;
							else if(Math.abs(mY-(Engine.buildings[d].y- Engine.buildings[d].height/2)) > Math.abs(mY-(Engine.buildings[d].y+Engine.buildings[d].height/2)))
								movePoint.y = Engine.buildings[d].y + Engine.buildings[d].height/2+20;
							tX = true;
							break;
						}
					}
					else if(sq.hitTestObject(Engine.buildings[d].rb))
					{
						if(tX==false)
						{
							movePoint.x = Engine.buildings[d].x + Engine.buildings[d].width/2+20;					
							if(Math.abs(mY-(Engine.buildings[d].y- Engine.buildings[d].height/2)) < Math.abs(mY-(Engine.buildings[d].y+Engine.buildings[d].height/2)))
								movePoint.y = Engine.buildings[d].y - Engine.buildings[d].height/2-20;
							else if(Math.abs(mY-(Engine.buildings[d].y- Engine.buildings[d].height/2)) > Math.abs(mY-(Engine.buildings[d].y+Engine.buildings[d].height/2)))
								movePoint.y = Engine.buildings[d].y + Engine.buildings[d].height/2+20;
							tX = true;
							break;
						}
					}
				}
			}
		}
		
		protected function removeSelf():void
		{
			if(Engine.round.contains(this))
			{
				Engine.round.removeChild(this);
				Engine.round.addChild(new Explosion(stageUnit, x, y, width, width));
				Engine.troops.splice(myIndex, 1);
				removeEventListener(Event.ENTER_FRAME, loop);
				delete(this);
			}
		}
		
		protected function loop(e:Event):void
		{

		}	
		
		protected function moveIt(e:MouseEvent):void
		{
			if(!startMoving)
			startMoving = true;
			else
			startMoving = false;
		}
		
		public function hitPlace(stageRef:Stage):void
		{				
			if(startMoving == true)
			{
				moving = true;
				mX = stageRef.mouseX - Engine.round.x;
				mY = stageRef.mouseY - Engine.round.y;
				mousePoint.x = mX;
				mousePoint.y = mY;
				angle = Math.atan2(x-mX,y-mY);
				startMoving = false;
				myMove = true;
			}
		}
		
		protected function fireHandler(e:TimerEvent):void
		{
			canFire = true;
		}
	}
}	