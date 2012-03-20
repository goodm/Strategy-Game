package com.asgamer
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Fire extends MovieClip
	{
		private var stageRef:Stage;
		private var angle:Number;
		private var mX,mY:Number;
		private var distance:Number;
		
		private var beginPoint,thisPoint:Point;
		
		public function Fire(stageRef:Stage,tX:Number,tY:Number,x:Number,y:Number,distance:Number)
		{
			this.stageRef = stageRef;
			this.x = x;
			this.y = y;
			this.distance = distance;
			beginPoint = new Point(x,y);
			thisPoint = new Point(x,y);
			
			angle = Math.atan2(tX-x,tY-y);		
			mX = Math.cos(angle)*(180/Math.PI)/5;
			mY = Math.sin(angle)*(180/Math.PI)/5;
	
			addEventListener(Event.ENTER_FRAME,loop,false,0,true);
		}
		
		private function loop(e:Event):void
		{			
			thisPoint.x = x;
			thisPoint.y = y;
			y += mX;
			x += mY;
			
			if(stageRef.contains(this))
			{
				for(var j:int = 0; j < Engine.enemies.length; j++)
				{
					if(hitTestObject(Engine.enemies[j]))
					{
						Engine.round.addChild(new Implosion(stageRef, x, y));
						removeSelf();
						Engine.enemies[j].takeHit();
					}
				}
			}
			
//Checking if it steal on stage		
			if(Point.distance(thisPoint,beginPoint) > distance)
				alpha -= 0.1;
				
			if(alpha <= 0)
				removeSelf();
				
		}
//Remove function	
		private function removeSelf():void
		{
			if (Engine.round.contains(this))
			{
				Engine.round.removeChild(this);
				removeEventListener(Event.ENTER_FRAME, loop);
				delete(this);
			}
		}
	}
}