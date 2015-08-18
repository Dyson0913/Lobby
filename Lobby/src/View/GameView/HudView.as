package View.GameView
{
	import Command.BetCommand;
	import Command.RegularSetting;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import Model.valueObject.Intobject;
	import util.DI;
	import View.ViewBase.ViewBase;
	import View.ViewComponent.*;
	import View.Viewutil.*;
	import Model.*;
	import util.utilFun;
	import Res.ResName;
	
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
		
		[Inject]
		public var _activelist:Visual_ActiveList;	
		
		
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
			barback.Create_by_list(1920, [ResName.Lobby_topbar], 0 , 0, 1920, 1, 0, "Bet_");			
			utilFun.scaleXY(barback.container, 1, 0.9);
			
			//var Mascot:MultiObject = prepare("Mascot", new MultiObject(), this);
			//Mascot.Create_by_list(1, [ResName.L_Mascot], 0 , 0, 1, 0, 0, "Bet_");
			//utilFun.scaleXY(Mascot.container, 1, 0.9);
			
			
			
			//var topGameState:MultiObject = prepare("top_icon", new MultiObject(), this);
			//topGameState.MouseFrame = utilFun.Frametype(MouseBehavior.SencetiveBtn);			
			//topGameState.rollover = _btn.test_reaction;
			//topGameState.mousedown = _btn.test_reaction;
			//topGameState.Create_by_list(5, [ResName.L_top_icon], 0 , 0, 5, 114, 0, "Bet_");
			//topGameState.container.x = 108;			
			//topGameState.container.y = 5;			
			
			var playerinfo:MultiObject = prepare("playinfo", new MultiObject(), this);
			playerinfo.Create_by_list(2, [ResName.L_name,ResName.L_credit], 0 , 0, 2, 360, 0, "Bet_");
			playerinfo.container.x = 940;
			playerinfo.container.y = 10;
			utilFun.scaleXY(playerinfo.container,1, 0.9);
			
			//name
			var name:MultiObject = prepare("name", new MultiObject() , this);
			name.CustomizedFun = _regular.ascii_idx_setting;			
			name.CustomizedData =  _model.getValue(modelName.NICKNAME).split("");
			name.container.x = 1212  + (name.CustomizedData.length -1) * 37 * -1; //mid *-.05
			name.container.y = 14;
			name.Create_by_bitmap(name.CustomizedData.length, utilFun.Getbitmap(ResName.L_altas), 0, 0, name.CustomizedData.length, 37, 51, "o_");			
			utilFun.scaleXY(name.container, 1, 0.9);
			
			var creadit:int = _model.getValue(modelName.CREDIT);
			var credit:MultiObject = prepare(modelName.CREDIT, new MultiObject() , this);
			credit.CustomizedFun = _regular.ascii_idx_setting;						
			credit.CustomizedData = creadit.toString().split("");
			credit.container.x = 1593 + (credit.CustomizedData.length -1) * 37 *-1;   //right -> left *-1
			credit.container.y = 16;
			credit.Create_by_bitmap(credit.CustomizedData.length, utilFun.Getbitmap(ResName.L_altas), 0, 0, credit.CustomizedData.length, 37, 51, "o_");
			utilFun.scaleXY(credit.container,1, 0.9);
			
			var topicon:MultiObject = prepare("topicon", new MultiObject(), this);
			topicon.Posi_CustzmiedFun = _regular.Posi_x_Setting;
			topicon.Post_CustomizedData = [0, 160, 230,230];
			topicon.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);			
			topicon.rollover = _btn.BtnHint;
			topicon.rollout = _btn.test_reaction;
			topicon.mousedown = _btn.gonewpage;
			topicon.Create_by_list(4, [ResName.L_icon_1, ResName.L_icon_2 ,ResName.L_icon_3,ResName.L_icon_4], 0 , 0, 4, 0 , 0, "Bet_");
			topicon.container.x = 1624;
			topicon.container.y = 10;
			utilFun.scaleXY(topicon.container, 1, 0.9);
		
			// TODO hud di
			var gamestate:Array  =_model.getValue("gamestat");
			utilFun.Log("gamestate ="+gamestate);			
			
			var avalibe:Array =  get_avalible(gamestate);
			utilFun.Log("avalibe ="+avalibe);			
			var avtivelist:MultiObject = prepare("avtivelist", new MultiObject() , this);				
			avtivelist.container.x = 120;
			//avtivelist.container.x = 120;
			avtivelist.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			avtivelist.mousedown = test_reaction;
			avtivelist.CustomizedFun = gameframe;
			avtivelist.CustomizedData = avalibe;
			avtivelist.Create_by_list(avalibe.length, [ResName.L_top_icon], 0, 0, avalibe.length, 102, 51, "o_");			
			
			_tool = new AdjustTool();
			_tool.SetControlMc(avtivelist.container);
			addChild(_tool);
			
			//_activelist.init();
			//_tool.SetControlMc(credit.container);
			//_tool.SetControlMc(topicon.ItemList[2]);
			//addChild(_tool);
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
			
		
		public function gameframe(mc:MovieClip, idx:int, data:Array):void
		{		
			mc["_game_name"].gotoAndStop(data[idx]+1);
			mc["_game_state"].gotoAndStop(5);
		}
		
		public function test_reaction(e:Event, idx:int):Boolean
		{
			utilFun.Log("e.u" + e.currentTarget.currentFrame);
			utilFun.Log("idx" + idx);
			
			if ( e.currentTarget.currentFrame == 1)  dispatcher(new Intobject(idx, "Load_flash") );
			else ;
			return true;
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Hud) return;
			
		}
		
		
	}

}