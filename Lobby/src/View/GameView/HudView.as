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
		
		public function HudView()  
		{
			utilFun.Log("HudView");
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Hud) return;			
			_tool = new AdjustTool();
			
			var barback:MultiObject = prepare("TopBar", new MultiObject(), this);
			barback.Create_by_list(1920, [ResName.Lobby_topbar], 0 , 0, 1920, 1, 0, "Bet_");			
			
			var Mascot:MultiObject = prepare("Mascot", new MultiObject(), this);
			Mascot.Create_by_list(1, [ResName.L_Mascot], 0 , 0, 1, 0, 0, "Bet_");
			
			var topGameState:MultiObject = prepare("top_icon", new MultiObject(), this);
			topGameState.MouseFrame = utilFun.Frametype(MouseBehavior.SencetiveBtn);			
			topGameState.rollover = _betCommand.test_reaction;
			topGameState.mousedown = _betCommand.test_reaction;
			topGameState.Create_by_list(5, [ResName.L_top_icon], 0 , 0, 5, 114, 0, "Bet_");
			topGameState.container.x = 108;			
			topGameState.container.y = 5;			
			
			var playerinfo:MultiObject = prepare("playinfo", new MultiObject(), this);
			playerinfo.Create_by_list(2, [ResName.L_name,ResName.L_credit], 0 , 0, 2, 360, 0, "Bet_");
			playerinfo.container.x = 940;
			playerinfo.container.y = 10;
			
			var topicon:MultiObject = prepare("topicon", new MultiObject(), this);
			topicon.Posi_CustzmiedFun = _regular.Posi_x_Setting;
			topicon.Post_CustomizedData = [0, 160, 230];
			topicon.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);			
			topicon.rollover = _betCommand.test_reaction;			
			topicon.Create_by_list(3, [ResName.L_icon_1, ResName.L_icon_2, ResName.L_icon_4], 0 , 0, 3, 0 , 0, "Bet_");
			topicon.container.x = 1624;
			topicon.container.y = 10;
			
		
			
			_tool.SetControlMc(topGameState.container);
			//_tool.SetControlMc(topicon.ItemList[2]);
			addChild(_tool);
		}
		
		private function LeaveGame(e:Event):Boolean 
		{
			Get("leavehint").visible = true;
			return true;
		}
		
		private function backGame(e:Event):Boolean 
		{
			Get("leavehint").visible = false;
			return true;
		}
		
		private function backLobby(e:Event):Boolean 
		{
			
			return true;
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Hud) return;
			
		}
		
		
	}

}