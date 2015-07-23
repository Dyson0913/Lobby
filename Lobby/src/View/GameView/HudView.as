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
	import View.ViewComponent.Visual_BtnHandle;
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
			utilFun.scaleXY(barback.container, 1, 0.9);
			
			var Mascot:MultiObject = prepare("Mascot", new MultiObject(), this);
			Mascot.Create_by_list(1, [ResName.L_Mascot], 0 , 0, 1, 0, 0, "Bet_");
			utilFun.scaleXY(Mascot.container, 1, 0.9);
			
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
			
			var credit:MultiObject = prepare(modelName.CREDIT, new MultiObject() , this);
			credit.CustomizedFun = _regular.ascii_idx_setting;						
			credit.CustomizedData = _model.getValue(modelName.CREDIT).toString().split("");
			credit.container.x = 1593 + (credit.CustomizedData.length -1) * 37 *-1;   //right -> left *-1
			credit.container.y = 16;
			credit.Create_by_bitmap(credit.CustomizedData.length, utilFun.Getbitmap(ResName.L_altas), 0, 0, credit.CustomizedData.length, 37, 51, "o_");
			utilFun.scaleXY(credit.container,1, 0.9);
			
			var topicon:MultiObject = prepare("topicon", new MultiObject(), this);
			topicon.Posi_CustzmiedFun = _regular.Posi_x_Setting;
			topicon.Post_CustomizedData = [0, 160, 230];
			topicon.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);			
			topicon.rollover = _btn.BtnHint;
			topicon.rollout = _btn.test_reaction;
			topicon.mousedown = _btn.gonewpage;
			topicon.Create_by_list(3, [ResName.L_icon_1, ResName.L_icon_2, ResName.L_icon_4], 0 , 0, 3, 0 , 0, "Bet_");
			topicon.container.x = 1624;
			topicon.container.y = 10;
			utilFun.scaleXY(topicon.container, 1, 0.9);
		
			
			//_tool.SetControlMc(credit.container);
			//_tool.SetControlMc(topicon.ItemList[2]);
			//addChild(_tool);
		}
		
		
			
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Hud) return;
			
		}
		
		
	}

}