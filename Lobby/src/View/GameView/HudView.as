package View.GameView
{
	import Command.BetCommand;
	import Command.RegularSetting;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import Interface.CollectionsInterface;
	import Model.valueObject.Intobject;
	import util.DI;
	import View.ViewBase.ViewBase;
	import View.ViewComponent.*;
	import View.Viewutil.*;
	import Model.*;
	import util.utilFun;
	import Res.ResName;
	import ConnectModule.Error_Msg;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class HudView extends ViewBase
	{
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _btn:Visual_BtnHandle;		
		
		//[Inject]
		//public var _activelist:Visual_ActiveList;	
		
		
		public function HudView()  
		{
			utilFun.Log("HudView");
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Hud) return;			
			
			
			//var view:MultiObject = prepare("_hudview", new MultiObject() , this);
			//view.Create_by_list(1, [ResName.L_emptymc], 0, 0, 1, 0, 0, "a_");			
			
			var barback:MultiObject = prepare("TopBar", new MultiObject(), this);
			barback.Create_by_list(1, [ResName.Lobby_topbar], 0 , 0, 1, 1, 0, "Bet_");			
			
			
			var Mascot:MultiObject = prepare("Mascot", new MultiObject(), this);
			Mascot.Create_by_list(1, [ResName.L_Mascot], 0 , 0, 1, 0, 0, "Bet_");
			Mascot.container.x = -42;
			Mascot.container.y = -25;
			
			//utilFun.Log("name= "+_model.getValue(modelName.NICKNAME));
			//utilFun.Log("credit= " + _model.getValue(modelName.CREDIT));
			var credit:int = _model.getValue(modelName.CREDIT);
			var playerinfo:MultiObject = prepare("playinfo", new MultiObject(), this);
			playerinfo.CustomizedFun = _regular.textSetting;
			playerinfo.CustomizedData = [_model.getValue(modelName.NICKNAME),credit]
			playerinfo.Create_by_list(2, [ResName.L_name,ResName.L_credit], 0 , 0, 2, 290, 0, "Bet_");
			playerinfo.container.x = 90;
			playerinfo.container.y = 1020;
			
			//_tool.SetControlMc(Mascot.container);
			//_tool.y = 200;
			//addChild(_tool);	
			
			var coin_ani:MultiObject = prepare("update_coin", new MultiObject(), this);								
			coin_ani.Create_by_list(1, [ResName.coin_In_pack], 0 , 0, 1, 0 , 0, "Bet_");
			coin_ani.container.x = 510;
			coin_ani.container.y = 980;
			//coin_ani.ItemList[0].gotoAndStop(2);
			
			//_tool.SetControlMc(coin_ani.container);
			//_tool.y = 200;
			//addChild(_tool);	
			
			var topicon:MultiObject = prepare("topicon", new MultiObject(), this);
			//topicon.CustomizedFun =  _btn.Btn_setting;
			topicon.CustomizedData = [6];
			//topicon.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			//topicon.Post_CustomizedData = [[0, 0], [80, 0], [157, -2], [230, 0]];
			topicon.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,0]);			
			topicon.rollover = _btn.BtnHint;
			topicon.rollout = _btn.Btn_roout;
			topicon.mousedown = _btn.gonewpage;
			topicon.Create_by_list(1, [ ResName.L_icon_Full_Screen], 0 , 0,2 , 50 , 0, "Bet_");
			topicon.container.x = 1790;
			topicon.container.y = 2;
			
			
		
		
			// TODO hud di
			var gamestate:Array  =_model.getValue("gameonline");
			utilFun.Log("gameonline ="+gamestate);			
			
			var avalibe:Array =  get_avalible(gamestate);
			//拿掉二元期權
			//avalibe.pop();
			utilFun.Log("avalibe ="+avalibe);			
			var avtivelist:MultiObject = prepare("avtivelist", new MultiObject() , this);				
			avtivelist.container.x = 180;
			avtivelist.container.y= 4;
			avtivelist.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,0]);
			avtivelist.mousedown = myreaction;
			avtivelist.Create_by_list(avalibe.length, [ResName.pa_icons,ResName.dk_icons,ResName.bg_icons,ResName.s7pk_icons,ResName.biany_icons], 0, 0, avalibe.length, 50, 0, "o_");			
			//拿掉二元期權
			//avtivelist.Create_by_list(avalibe.length, [ResName.pa_icons,ResName.dk_icons,ResName.bg_icons,ResName.s7pk_icons], 0, 0, avalibe.length, 50, 0, "o_");		
			
			hud_pre_init();
			//_activelist.init();
			//_tool.SetControlMc(pop_msg.container);			
			//_tool.y = 200;
			//addChild(_tool);
		}
		
		public function hud_pre_init():void
		{
		
			//退出確定鈕
			//0 = bg 1 = cancel 2 = confirm
			var pop_msg:MultiObject = prepare("popmst", new MultiObject() , this);			
			pop_msg.container.x = 1590;
			pop_msg.container.y = 130;
			pop_msg.CustomizedData = [[0, 0] ,[60,90],[170,90]]
			pop_msg.CustomizedFun = _regular.Posi_xy_Setting;
			//pop_msg.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);
			pop_msg.Create_by_list(3, [ResName.PopMsg, ResName.PopBtn, ResName.PopBtn], 0, 0, 1, 50, 0, "o_");			
			pop_msg.rollout = pop_msg_rollout;
			pop_msg.rollover = pop_msg_rollover;
			//pop_msg.mousedown = cliek;
			pop_msg.container.visible = false;
			pop_msg.ItemList[1]["_btn_context"].gotoAndStop(2);
			pop_msg.ItemList[2]["_btn_context"].gotoAndStop(1);
		}
		
		public function pop_msg_rollout(e:Event, idx:int):Boolean
		{			
			if(e.currentTarget["_btn_context"] != undefined){
			
				if (e.currentTarget["_btn_context"].currentFrame == 2) {
					Get("popmst").ItemList[1].gotoAndStop(1);
					Get("popmst").ItemList[1]["_btn_context"].visible = true;
				}else if (e.currentTarget["_btn_context"].currentFrame == 1) {
					Get("popmst").ItemList[2].gotoAndStop(1);
					Get("popmst").ItemList[2]["_btn_context"].visible = true;
				}
			
			}
			
			return true;
		}
		
		public function pop_msg_rollover(e:Event, idx:int):Boolean
		{			
			if (e.currentTarget["_btn_context"] != undefined) {
				
				if (e.currentTarget["_btn_context"].currentFrame == 2) {
					Get("popmst").ItemList[1].gotoAndStop(2);
					Get("popmst").ItemList[1]["_btn_context"].visible = false;
				}else if (e.currentTarget["_btn_context"].currentFrame == 1) {
					Get("popmst").ItemList[2].gotoAndStop(3);
					Get("popmst").ItemList[2]["_btn_context"].visible = false;
				}
			
			}
			
			return true;
		}
		
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "msgbox")]
		public function pop_handle(msg:ModelEvent):void
		{			
			var popmsg:MultiObject = Get("popmst");			
			popmsg.container.visible = true;
			
			if ( msg.Value == Error_Msg.NET_DISCONNECT)
			{
				popmsg.CustomizedData = [[0, 0] , [ 115, 90], [ 115, 90]];
				popmsg.CustomizedFun = _regular.Posi_xy_Setting;
				popmsg.FlushObject();
				popmsg.mousedown = handle_;
				popmsg.ItemList[0]["_content"].gotoAndStop(3);
			}
			
		}
		
		public function handle_(e:Event, idx:int):Boolean
		{			
			var popmsg:MultiObject = Get("popmst");			
			popmsg.container.visible = false;
			
			//斷線後處理
			//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CONNECT));
			return true;
		}
		
		public function get_avalible(arr:Array):Array
		{
			var ava:Array = [];
			var gametype:Array  = _model.getValue("gametype");
			utilFun.Log("gametype ="+gametype);		
			for (var i:int = 0; i < arr.length ; i++)
			{
				if (arr[i] == "1") 
				{
					ava.push(i);
				}
			}
			
			return ava;
		}
		
		public function myreaction(e:Event, idx:int):Boolean
		{
			var popmsg:MultiObject = Get("popmst");
			if ( popmsg.container.visible )
			{
				utilFun.Log("promet not repley");
				return false;
			}
			
			//utilFun.Log("e.u" + e.currentTarget.currentFrame);			
			if ( e.currentTarget.currentFrame == 1) 
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
						if ( i == cav_id) 
						{
							newcanvas.canvas_container.visible = true;
							newcanvas.call_back(["RESUME"]);
						}
						else if(newcanvas != null)
						{
							newcanvas.canvas_container.visible = false;
							newcanvas.call_back(["MUTE"]);
						}
					}
					
				}
				// e.currentTarget["_game_name"].gotoAndStop(idx);
				 
			}
			else 
			{
				//show current game
				utilFun.Log("show current game");				
			};
			
			var activelist:MultiObject = Get("avtivelist");			
			activelist.exclusive(idx, 1);
			utilFun.Log("click ok ");				
			return true;
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="close_cavas")]
		public function change(clickbtn:Intobject):void
		{			
			utilFun.Log("clickbtn.Value " + clickbtn.Value );
			if ( clickbtn.Value == -1) 
			{
				var activelist:MultiObject = Get("avtivelist");			
				activelist.anti_exclusive( clickbtn.Value,2,1);
				return;
			}
			
			
			
			var btn_cavasid:DI =  _model.getValue("Topgameicon_blind");
			var cav_id:int = btn_cavasid.getValue(clickbtn.Value);		
			
			//swith visible for all  newcanvas
			var allcanvas:int = _model.getValue("canvas_Serial");
			for ( var i:int = 0; i < allcanvas ; i++)
			{
				var newcanvas:Object  = _model.getValue("newcanvas" + i);
				if ( i == cav_id) newcanvas.canvas_container.visible = true;
				else newcanvas.canvas_container.visible = false;
			}
			
			
			
			var activelist:MultiObject = Get("avtivelist");			
			activelist.anti_exclusive( clickbtn.Value,2,1);
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Hud) return;
			
		}
		
		
	}

}