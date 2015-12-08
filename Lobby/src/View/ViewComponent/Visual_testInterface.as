package View.ViewComponent 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Transform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;	
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	import View.Viewutil.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import com.adobe.serialization.json.JSON;
	/**
	 * testinterface to fun quick test
	 * @author ...
	 */
	public class Visual_testInterface  extends VisualHandler
	{
		[Inject]
		public var _MsgModel:MsgQueue;		
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _debug:Visual_debugTool;
		
		[Inject]
		public var _Version:Visual_Version;
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{
			
			_model.putValue("test_init", false);
			
			_debug.init();
			_betCommand.bet_init();			
			_model.putValue("result_Pai_list", []);
			_model.putValue("game_round", 1);
			_model.putValue("history_list",[]);
			
			//腳本
			var script_list:MultiObject = create("script_list", [ResName.TextInfo]);	
			script_list.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			script_list.stop_Propagation = true;
			script_list.mousedown = script_list_test;
			script_list.CustomizedData = [ { size:18 }, "lobby"];
			script_list.CustomizedFun = _text.textSetting;			
			script_list.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			script_list.Post_CustomizedData = [5, 100, 100];			
			script_list.Create_(script_list.CustomizedData.length -1);
			
			
			
			_model.putValue("Script_idx", 0);			
			
			
		}		
		
		public function script_list_test(e:Event, idx:int):Boolean
		{
			utilFun.Log("script_list_test=" + idx);
			_model.putValue("Script_idx", idx);
			view_init();
			dispatcher(new TestEvent(_model.getValue("Script_idx").toString()));
			
			
			return true;
		}
	
		public function view_init():void
		{
			if ( _model.getValue("test_init")) return;
			changeBG(ResName.Lobby_Scene);
			
			_Version.init();
			
			
			
			_Version.debug();
			_model.putValue("test_init",true);
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "0")]
		public function betScript():void
		{
			
		}
	}

}