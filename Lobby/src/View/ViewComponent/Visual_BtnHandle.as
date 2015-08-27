package View.ViewComponent 
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.display.StageDisplayState;
	
	/**
	 * btn handle present way
	 * @author ...
	 */
	public class Visual_BtnHandle  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		
		public function Visual_BtnHandle() 
		{
			
		}
		
		public function test_reaction(e:Event, idx:int):Boolean
		{
			return true;
		}
		
		public function Game_iconhandle(e:Event, idx:int):Boolean
		{			
			if ( e.currentTarget.currentFrame == 3 || e.currentTarget.currentFrame == 4) return false;
			else
			{
				e.currentTarget.gotoAndStop(2);
			}
			return true;
		}
		
		public function Game_iconclick_down(e:Event, idx:int):Boolean
		{
			if ( e.currentTarget.currentFrame == 3 || e.currentTarget.currentFrame == 4) return false;
			else
			{
				var btn_cavasid:DI =  _model.getValue("Topgameicon_blind");					
				if (btn_cavasid.getValue(idx)== null)
				{						
					var cav_id:int = _model.getValue("canvas_Serial");
					utilFun.Log("no find");									
					btn_cavasid.putValue(idx, cav_id);
					
					var cavasid_btn:DI = _model.getValue("cavasid_btnid");
					cavasid_btn.putValue(cav_id, idx);
					dispatcher(new Intobject(idx, "Load_flash") );						
				}
				else
				{
					var cav_id:int = btn_cavasid.getValue(idx);
					utilFun.Log("find " +cav_id);
					
					//swith visible for all  newcanvas
					var allcanvas:int = _model.getValue("canvas_Serial");
					for ( var i:int = 0; i < allcanvas ; i++)
					{
						var newcanvas:Object  = _model.getValue("newcanvas" + i);
						if ( i == cav_id) newcanvas.canvas_container.visible = true;
						else newcanvas.canvas_container.visible = false;
					}
					
				}
				
				var activelist:MultiObject = Get("avtivelist");			
				activelist.anti_exclusive( idx,2,1);
				
				
				//e.currentTarget.y += 10;
			}
			return true;
		}
		
		public function Game_iconclick_up(e:Event, idx:int):Boolean
		{
			if ( e.currentTarget.currentFrame == 3 || e.currentTarget.currentFrame == 4) return false;
			else
			{
				//loading game
				//e.currentTarget.y -= 10;
			}
			return true;
		}
		
		public function Btn_setting(mc:MovieClip, idx:int, data:Array):void
		{			
			mc.gotoAndStop(2);
			mc["_hintText"].gotoAndStop(data[idx]);			
		}
		
		
		public function BtnHint(e:Event, idx:int):Boolean
		{
			var data:Array  = Get("topicon").CustomizedData;
			if ( e.currentTarget.currentFrame == 4 )			
			{
				e.currentTarget.gotoAndStop(5);
				e.currentTarget["_hintText"].gotoAndStop(data[idx]);
				return false;
			}
			
			if (  e.currentTarget.currentFrame == 5)
			{
				e.currentTarget.gotoAndStop(4);
				//e.currentTarget["_hintText"].gotoAndStop(data[idx]);
				return false;
			}
			
			e.currentTarget.gotoAndStop(2);
			e.currentTarget["_hintText"].gotoAndStop(data[idx]);
			return true;
		}
		
		public function Btn_roout(e:Event, idx:int):Boolean
		{
			var data:Array  = Get("topicon").CustomizedData;
			utilFun.Log("idx =" + idx);
			if ( e.currentTarget.currentFrame == 4)
			{
				return false;
			}
			if ( e.currentTarget.currentFrame == 5)
			{
				e.currentTarget.gotoAndStop(4);
				return false;
			}
			
			e.currentTarget.gotoAndStop(2);
			e.currentTarget["_hintText"].gotoAndStop(data[idx]);
			return true;
		}
		
		
		public function gonewpage(e:Event, idx:int):Boolean
		{
			//TODO button mapping to multiob ?
			if ( idx == 1)
			{
				//GetSingleItem("_view").parent.parent.stage
				if ( GetSingleItem("_view").parent.parent.stage.displayState == StageDisplayState.NORMAL)
				{
					GetSingleItem("_view").parent.parent.stage.displayState = StageDisplayState.FULL_SCREEN; 
					
					e.currentTarget.gotoAndStop(4);
				}
				else
				{
					GetSingleItem("_view").parent.parent.stage.displayState = StageDisplayState.NORMAL; 
					e.currentTarget.gotoAndStop(1);
				}
				return false;
			}
			else
			{
				var request:URLRequest = new URLRequest("https://www.google.com.tw/");			
				navigateToURL( request, "_blank" );
				return true;
			}
			
			return true;
		}
	}

}