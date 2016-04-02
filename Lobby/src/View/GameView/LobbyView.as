package View.GameView
{
	import com.adobe.webapis.events.ServiceEvent;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.ID3Info;
	import flash.text.TextField;
	import Model.valueObject.*
	import Res.ResName;
	import util.DI;
	import Model.*
	import util.node;
	import View.ViewComponent.*;
	import View.Viewutil.*;
	import View.ViewBase.ViewBase;
	import util.*;
	import flash.text.TextFormat;
	
	import Command.*;
	
	import caurina.transitions.Tweener;	
	/**
	 * ...
	 * @author hhg
	 */
	public class LobbyView extends ViewBase
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		[Inject]
		public var _Version:Visual_Version;
		
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
			
			//arrow
			//var page:MultiObject = prepare("pagearr", new MultiObject(), this);
			//page.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);			
			//page.mousedown = _btn.test_reaction;
			//page.mouseup = _btn.test_reaction;		
			//page.rollover = _btn.test_reaction;		
			//page.rollout = _btn.test_reaction;		
			//page.CustomizedFun = arror_turn;
			//page.Create_by_list(2, [ResName.L_arrow_l, ResName.L_arrow_r], 0 , 0, 2, 1880 , 0, "Bet_");
			//page.container.x = 10;
			//page.container.y = 502;
			
			
			//TODO fun -->map 
			var icon_mapping:DI = new DI();
			icon_mapping.putValue("BigWin", 0);
			icon_mapping.putValue("PerfectAngel", 1);
			icon_mapping.putValue("Bingo", 2);
			icon_mapping.putValue("Finance", 3);
			icon_mapping.putValue("7pk", 4);
			var gameIconlist:Array = [ResName.L_game_pa,ResName.L_game_dk, ResName.L_game_bingo, ResName.L_game_7pk,ResName.L_game_financial];
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
			gameIcon.Create_by_list(game_online.length,gameIconlist, 0 , 0, 3, 300 , 280, "Bet_");
			gameIcon.container.x = 550;
			gameIcon.container.y = 420;
			
			var sport:MultiObject = prepare("sport", new MultiObject() , this);
			sport.container.x = 1160;
			sport.container.y = 700;
			sport.Create_by_list(1, [ResName.L_game_sport], 0, 0, 1, 0, 0, "a_");			
			utilFun.scaleXY(GetSingleItem("sport", 0), 0.95, 0.95);
			
			//_tool.SetControlMc(sport.container);			
			//_tool.y = 200;
			//addChild(_tool);
			//return;
			
			//coin_ani.ItemList[0];
			_Version.init();
				
			var ad_mask:MultiObject = prepare("ad_mask", new MultiObject() , this);
			ad_mask.container.x = 0;
			ad_mask.container.y = 50;
			ad_mask.Create_by_list(1, ["ad_mask"], 0, 0, 1, 0, 0, "ad_mask_");			
			
			//廣告
			var ad_arr:Array = [];
			var ad_pa:MovieClip = utilFun.GetClassByString("ad_pa");
			var ad_dk:MovieClip = utilFun.GetClassByString("ad_dk");
			var ad_bingo:MovieClip = utilFun.GetClassByString("ad_bingo");
			var ad_7pk:MovieClip = utilFun.GetClassByString("ad_7pk");
			ad_pa.name = "ad_pa";
			ad_dk.name = "ad_dk";
			ad_bingo.name = "ad_bingo";
			ad_7pk.name = "ad_7pk";
			ad_arr.push(ad_pa);
			ad_arr.push(ad_dk);
			ad_arr.push(ad_bingo);
			ad_arr.push(ad_7pk);
			var lobbyAdMc:MovieClip = new LobbyAd(ad_arr);
			lobbyAdMc.x = 0;
			lobbyAdMc.y = 50;
			lobbyAdMc.mask = ad_mask.container;
			
			var _view:MultiObject = Get("_view") as MultiObject;
			_view.container.addChild(lobbyAdMc);
			lobbyAdMc.buttonMode = true;
			lobbyAdMc.addEventListener(MouseEvent.CLICK, ad_click_handler);
			
		}			 
		
		private function ad_click_handler(e:MouseEvent):void {
			var game_idx:int = 0;
			var ad_name = e.target.name;
			switch(ad_name) {
				case "ad_pa":
					game_idx = 0;
				break;
				case "ad_dk":
					game_idx = 1;
				break;
				case "ad_bingo":
					game_idx = 2;
				break;
				case "ad_7pk":
					game_idx = 3;
				break;
			}
			
			var obj:MultiObject = Get("gameIcon");
			var pa_icon:MovieClip = obj.ItemList[game_idx] as MovieClip;
			pa_icon.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			pa_icon.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
		}
		
		public function FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{
			if( data[idx] ==0) mc.gotoAndStop(4);
			else mc.gotoAndStop(data[idx]);
			
			utilFun.scaleXY(mc, 0.95, 0.95);
		}
		
		public function arror_turn(mc:MovieClip, idx:int, data:Array):void
		{
			if ( idx == 1) mc.rotationY = 180;
			
		}	
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.lobby) return;
			super.ExitView(View);
		}		
	}

}