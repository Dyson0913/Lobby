package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.ID3Info;
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
			page.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);			
			page.mousedown = _btn.test_reaction;
			page.mouseup = _btn.test_reaction;		
			page.rollover = _btn.test_reaction;		
			page.rollout = _btn.test_reaction;		
			page.CustomizedFun = arror_turn;
			page.Create_by_list(2, [ResName.L_arrow_l, ResName.L_arrow_r], 0 , 0, 2, 1880 , 0, "Bet_");
			page.container.x = 10;
			page.container.y = 502;
			
			
			//TODO fun -->map 
			var icon_mapping:DI = new DI();
			icon_mapping.putValue("BigWin", 0);
			icon_mapping.putValue("PerfectAngel", 1);
			icon_mapping.putValue("Bingo", 2);
			icon_mapping.putValue("Finance", 3);
			var gameIconlist:Array = [ResName.L_game_3,ResName.L_game_2, ResName.L_game_4, ResName.L_game_5];
			var arr:Array = _model.getValue(modelName.OPEN_STATE);
			
			var gameweb:Array = [];
			var gametype:Array = [];
			var game_online:Array = [];
			for ( var i:int = 0; i < arr.length ; i++)
			{				
				//{"game_website": "http://106.186.116.216:8000/static/perfectangel.swf",
				   //"game_description": "Perfect Angel",
				   //"game_online": 1,
				   //"game_type": "PerfectAngel", 
				   //"game_id": "PerfectAngel-1", 
				   //"game_avaliable": 1}
				var gameinfo:Object = { "game_online": arr[i].game_online, 
														"game_website":  arr[i].game_website,
														"game_type":arr[i].game_type
														
			                                      };
								
				gameweb.push(arr[i].game_website);
				gametype.push(arr[i].game_type);
				game_online.push(arr[i].game_online);
				//game_description
			
			}			
			
			utilFun.Log("gameweb = "+gameweb);
			utilFun.Log("game_online = "+game_online);
			_model.putValue("gameweb", gameweb);			
			_model.putValue("gametype", gametype);
			_model.putValue("gameonline", game_online);
			
			var gameIcon:MultiObject = prepare("gameIcon", new MultiObject(), this);
			gameIcon.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 1]);
			gameIcon.rollover = _btn.Game_iconhandle;
			gameIcon.rollout = _btn.Game_iconhandle;
			gameIcon.mousedown = _btn.Game_iconclick_down;
			gameIcon.mouseup = _btn.Game_iconclick_up;
			gameIcon.CustomizedFun = FrameSetting
			gameIcon.CustomizedData = game_online;
			gameIcon.Create_by_list(game_online.length,gameIconlist, 0 , 0, 3, 400 , 330, "Bet_");
			gameIcon.container.x = 380;
			gameIcon.container.y = 242;
			
			//_tool.SetControlMc(gameIcon.container);
			//_tool.SetControlMc(gameIcon.ItemList[3]);
			//_tool.y = 200;
			//addChild(_tool);
			//return;
			
			//coin_ani.ItemList[0];
			
		}			 
		
		public function FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{
			if( data[idx] ==0) mc.gotoAndStop(4);
			else mc.gotoAndStop(data[idx]);
		}
		
		public function arror_turn(mc:MovieClip, idx:int, data:Array):void
		{
			if ( idx == 1) mc.rotationY = 180;
			
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