package  
{
	import com.hexagonstar.util.debug.Debug;
	import Command.*;
	import flash.display.MovieClip;
	import Model.*;
	import org.spicefactory.parsley.asconfig.processor.ActionScriptConfigurationProcessor;
	import org.spicefactory.parsley.core.registry.ObjectDefinition;
	import util.utilFun;
	import View.ViewBase.ViewBase;
	import ConnectModule.websocket.WebSoketComponent;
	import View.ViewBase.Visual_Text;
	import View.ViewComponent.*;
	import View.Viewutil.Visual_Log;
	
	import View.GameView.*;
	/**
	 * ...
	 * @author hhg
	 */
	public class appConfig 
	{
		//要unit test 就切enter來達成
		
		//singleton="false"
		[ObjectDefinition(id="Enter")]
		public var _LoadingView:LoadingView = new LoadingView();		
		public var _LobbyView:LobbyView = new LobbyView();
		public var _HudView:HudView = new HudView();		
		
		//model		
		public var _Model:Model = new Model();
		public var _MsgModel:MsgQueue = new MsgQueue();
		public var _Actionmodel:ActionQueue = new ActionQueue();
		
		
		//connect module
		public var _socket:WebSoketComponent = new WebSoketComponent();
		
		//util
		public var _text:Visual_Text = new Visual_Text();		
		public var _Log:Visual_Log = new Visual_Log();
		
		//command 
		public var _viewcom:ViewCommand = new ViewCommand();
		public var _state:StateCommand = new StateCommand();
		public var _dataoperation:DataOperation = new DataOperation();
		public var _betcom:BetCommand = new BetCommand();
		public var _regular:RegularSetting = new RegularSetting();
		
		//visual		
		public var _hint:Visual_Hintmsg = new Visual_Hintmsg();
		public var _playerinfo:Visual_PlayerInfo = new Visual_PlayerInfo();		
		public var _btn:Visual_BtnHandle = new Visual_BtnHandle();
		public var _canvas:Visual_Canvas = new Visual_Canvas();				
		public var _popmsg:Visual_PopMsg = new Visual_PopMsg();		
		public var _test:Visual_testInterface = new Visual_testInterface();	
		
		
		public function appConfig() 
		{
			Debug.trace("Lobby init");
		}
	
	}

}