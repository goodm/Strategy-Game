package com.asgamer
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class ObjectMenu extends MovieClip
	{
		private var stageRef:Stage;
		public var buildIndex:int;
		private var otherStatus:Boolean = false;
		
		public function ObjectMenu(stageRef:Stage)
		{
			this.stageRef = stageRef;
			del_btn.alpha = 1;
			repair_btn.alpha = 0.2;
			upgrade_btn.alpha = 0.2;
			create_btn.alpha = 0.2;
			
			addEventListener(Event.ENTER_FRAME,loop,false,0,true);
			
			repair_btn.addEventListener(MouseEvent.MOUSE_OVER,repairStatus,false,0,true);
			repair_btn.addEventListener(MouseEvent.MOUSE_OUT,statusOff,false,0,true);
			repair_btn.addEventListener(MouseEvent.CLICK,repairBuild,false,0,true);
			
			del_btn.addEventListener(MouseEvent.MOUSE_OVER,deleteStatus,false,0,true);
			del_btn.addEventListener(MouseEvent.MOUSE_OUT,statusOff,false,0,true);
			del_btn.addEventListener(MouseEvent.CLICK,deleteBuild,false,0,true);	
			
			upgrade_btn.addEventListener(MouseEvent.MOUSE_OVER,upgradeStatus,false,0,true);
			upgrade_btn.addEventListener(MouseEvent.MOUSE_OUT,statusOff,false,0,true);
			upgrade_btn.addEventListener(MouseEvent.CLICK,upgrade,false,0,true);
			
			create_btn.addEventListener(MouseEvent.MOUSE_OVER,createStatus,false,0,true);
			create_btn.addEventListener(MouseEvent.MOUSE_OUT,statusOff,false,0,true);
			create_btn.addEventListener(MouseEvent.CLICK,createUnit,false,0,true);		
		}
		
		public function loop(e:Event)
		{
			if(Engine.score.gold<49 || Engine.score.food<49)
				repair_btn.alpha = 0.2;
					
			if(Engine.score.gold<149 || Engine.score.food<149)
				upgrade_btn.alpha = 0.2;	
					
			if(Engine.score.gold>50 && Engine.score.food>50)
				repair_btn.alpha = 1;
			if(Engine.score.gold>150 && Engine.score.food>150)
				upgrade_btn.alpha = 1;
				
			create_btn.alpha = 0.2;		
			
			if(buildIndex > 0 )
			{
				if(Engine.buildings[buildIndex].what == "Construction factory" || Engine.buildings[buildIndex].what == "Lab")
					create_btn.alpha = 1;					
					
				if(Engine.buildings[buildIndex].couting>0)
				{
					upgrade_btn.alpha = 0.2;
					repair_btn.alpha = 0.2;
				}
			}
			if(Engine.buildings[0] != null && otherStatus == false)
			{
				if(Engine.buildings[buildIndex].couting > 0)
				infoBar.text = Engine.buildings[buildIndex].what + "\nUpg. " + String(Math.floor(Engine.buildings[buildIndex].couting * 100)) + "%" +  " Life: " + String(Math.floor(Engine.buildings[buildIndex].life));
				else
				infoBar.text = Engine.buildings[buildIndex].what +  "\nLife: " + String(Math.floor(Engine.buildings[buildIndex].life)) + "   Level: " + Engine.buildings[buildIndex].level;			
			}
		}
		private function createStatus(e:MouseEvent)
		{
			if(create_btn.alpha == 1)
			{
				if (Engine.buildings[buildIndex].what == "Construction factory")
				{
					otherStatus = true;
					infoBar.text = Engine.buildings[buildIndex].what + "\nCreate an army Unit";
				}
				else if (Engine.buildings[buildIndex].what == "Lab")
				{
					otherStatus = true;
					infoBar.text = Engine.buildings[buildIndex].what + "\nSearch & improve";
				}
			}
		}
		private function createUnit(e:MouseEvent)
		{
			if(create_btn.alpha == 1)
			{
				Engine.buildings[buildIndex].clickOn = false;
				Engine.round.removeChild(this);
				if(Engine.buildings[buildIndex].what == "Construction factory")
					dispatchEvent(new Event("Contraction Menu"));
				else if (Engine.buildings[buildIndex].what == "Lab")
				{
					trace("poszlo");
					dispatchEvent(new Event("Lab Menu"));
				}
			}
		}
		private function upgradeStatus(e:MouseEvent)
		{
			if(Engine.buildings[buildIndex].couting==0)
			{
				otherStatus = true;
				infoBar.text = Engine.buildings[buildIndex].what + "\ngold -150 food -150";
			}
		}		
		
		private function upgrade(e:MouseEvent)
		{
			if(Engine.buildings[buildIndex].couting == 0 && Engine.score.gold >= 150 && Engine.score.food >= 150 )
			{
				Engine.buildings[buildIndex].upgrading = true;
				Engine.buildings[buildIndex].couting = 0;
				Engine.score.gold -= 150;
				Engine.score.food -= 150;
			}
		}		
		
		private function deleteBuild(e:MouseEvent)
		{
			Engine.buildings[buildIndex].removeSelf(stage);
			Engine.buildings.splice(buildIndex,1);
			Engine.score.gold +=50;
			Engine.score.food +=50;
			trace(Engine.buildings);
			buildIndex = 0;
			Engine.round.removeChild(this);
		}		
		
		private function deleteStatus(e:MouseEvent)
		{
			otherStatus = true;
			infoBar.text = Engine.buildings[buildIndex].what + "\ngold +50 food +50";
		}		
		
		private function repairStatus(e:MouseEvent)
		{
			if(Engine.buildings[buildIndex].couting == 0)
			{
				otherStatus = true;
				if(Engine.buildings[buildIndex].life < 100)
					infoBar.text = Engine.buildings[buildIndex].what + "\ngold -50 food -50";
				else
					infoBar.text = Engine.buildings[buildIndex].what + "\nDon`t need it";
			}
		}		
		
		private function statusOff(e:MouseEvent)
		{
			otherStatus = false;
		}		
		
		private function repairBuild(e:MouseEvent)
		{
			if(Engine.buildings[buildIndex].life < 100 && Engine.score.gold >= 50 && Engine.score.food >= 50 && Engine.buildings[buildIndex].couting == 0)
			{
				Engine.buildings[buildIndex].repair = true;					
				Engine.score.gold -= 50;
				Engine.score.food -= 50;
			}
		}
	}
}