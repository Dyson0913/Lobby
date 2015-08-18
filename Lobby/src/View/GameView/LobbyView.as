package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import Model.valueObject.*
	import Res.ResName;
	import util.DI;
	import Model.*
	import util.node;
	import View.ViewComponent.Visual_BtnHandle;
	import View.Viewutil.*;
	import View.ViewBase.ViewBase;
	import util.*;
	import View.ViewComponent.Visual_Coin;
	
	import Command.*;
	
	import caurina.transitions.Tweener;	
	import caurina.transitions.properties.CurveModifiers;
	/**
	 * ...
	 * @author hhg
	 */
	public class LobbyView extends ViewBase
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _regular:RegularSetting;	
		
		[Inject]
		public var _visual_coin:Visual_Coin;
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		public function LobbyView()  
		{
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.lobby) return;
			super.EnterView(View);
			//清除前一畫面
			utilFun.Log("in to EnterBetview=");			
			
			
			
			
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Lobby_Scene], 0, 0, 1, 0, 0, "a_");			
			
			var page:MultiObject = prepare("pagearr", new MultiObject(), this);
			page.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			page.mousedown = _btn.test_reaction;		
			page.mouseup = _btn.test_reaction;		
			page.Create_by_list(2, [ResName.L_arrow_l, ResName.L_arrow_r], 0 , 0, 2, 1820 , 0, "Bet_");
			page.container.x = 10;
			page.container.y = 502;
			
			//TODO fun -->map 
			var gameIconlist:Array = [ResName.L_game_3,ResName.L_game_2, ResName.L_game_4, ResName.L_game_5];
			var arr:Array = _model.getValue(modelName.OPEN_STATE);
			//
			var gamestat:Array = [];
			var gameweb:Array = [];
			var gametype:Array = [];
			var game_online:Array = [];
			for ( var i:int = 0; i < arr.length ; i++)
			{
				//	var resultinfo:Array = arr[i].split("|");
				if ( arr[i].game_type == "BigWin")
				{
					gamestat.push( arr[i].game_online);
				}
				if ( arr[i].game_type == "PerfectAngel")
				{
					gamestat.push(arr[i].game_online);
				}
			
				if ( arr[i].game_type == "Bingo")
				{
					gamestat.push( arr[i].game_online);
				}
				if ( arr[i].game_type == "Finance")
				{
					gamestat.push( arr[i].game_online);
				}
				
				gameweb.push(arr[i].game_website);
				gametype.push(arr[i].game_type);
				game_online.push(arr[i].game_online);
				//game_description
			
			}			
			
			utilFun.Log("gameweb = "+gameweb);
			utilFun.Log("game_online = "+game_online);
			_model.putValue("gameweb", gameweb);
			_model.putValue("gamestat", gamestat);
			_model.putValue("gametype", gametype);
			var gameIcon:MultiObject = prepare("gameIcon", new MultiObject(), this);
			gameIcon.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 1]);
			gameIcon.rollover = _btn.Game_iconhandle;
			gameIcon.rollout = _btn.Game_iconhandle;
			gameIcon.mousedown = _btn.Game_iconclick_down;
			gameIcon.mouseup = _btn.Game_iconclick_up;
			gameIcon.CustomizedFun = FrameSetting
			gameIcon.CustomizedData = gamestat;
			gameIcon.Create_by_list(gamestat.length,gameIconlist, 0 , 0, 3, 550 , 400, "Bet_");
			gameIcon.container.x = 210;
			gameIcon.container.y = 192;
			
		}			 
		
		public function FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{
			if( data[idx] ==0) mc.gotoAndStop(3);
			else mc.gotoAndStop(data[idx]);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_result():void
		{		

		}
		
		
		
		private function clearn():void
		{			
			dispatcher(new ModelEvent("clearn"));			
		  
		
				
			//dispatcher(new BoolObject(false, "Msgqueue"));
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.lobby) return;
			super.ExitView(View);
		}		
	}

}