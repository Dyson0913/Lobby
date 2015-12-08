package View.GameView
{	
	import com.adobe.utils.DictionaryUtil;
	import Command.RegularSetting;
	import Command.ViewCommand;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import Model.valueObject.Intobject;
	import org.osflash.signals.natives.base.SignalTextField;
	import Res.ResName;
	import util.DI;
	import util.node;
	import View.ViewBase.ViewBase;
	import Command.DataOperation;
	import flash.text.TextFormat;
	import View.ViewBase.Visual_Text;
	import View.ViewComponent.*;
	import View.Viewutil.AdjustTool;	
	import View.Viewutil.MultiObject;
	import View.Viewutil.MouseBehavior;
	import View.Viewutil.Visual_Log;
	
	import Model.*;
	import util.utilFun;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	
	import flash.utils.ByteArray;	
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.net.URLLoaderDataFormat;
	import com.adobe.serialization.json.JSON
	
		import com.istrong.log.*;
		
	/**
	 * ...
	 * @author hhg
	 */

	 
	public class LoadingView extends ViewBase
	{	
		
		[Inject]
		public var _canvas:Visual_Canvas;
		
		[Inject]
		public var _popmsg:Visual_PopMsg;
		
		[Inject]
		public var _test:Visual_testInterface;
		
		[Inject]
		public var _text:Visual_Text;
		
		[Inject]
		public var _regular:RegularSetting;
		
		private var _result:Object;
		
		public var _Gameconfig:URLLoader;
		
		[Inject]
		public var _Log:Visual_Log;	
		
		public function LoadingView()  
		{
			
		}
		
			
		public function FirstLoad(result:Object,slog:MovieClip):void
		{
			//Logger.displayLevel = LogLevel.DEBUG;
			//Logger.addProvider(new ArthropodLogProvider(), "Arthropod");
			_result = result;
			
			//new log
			_Log.init();
			_Log.logTarget(slog);
			
			if ( CONFIG::debug ) 
			{
				_model.putValue("_doname", "106.186.116.216");				
				if( _result == null) _result = { "accessToken":"c9f0f895fb98ab9159f51fd0297e236d"};				
			}
			else
			{
				_model.putValue("_doname","www.mm9900.net");
			}			
			_model.putValue(modelName.LOGIN_INFO, _result);
			
			
			
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));		
			//dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;
			return;	
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.EnterView(View);
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.L_emptymc], 0, 0, 1, 0, 0, "a_");
			
			_canvas.init();			
			//_popmsg.init();
			//_test.init();			
			
			
			var jsonconfig:String;
			if ( CONFIG::debug ) 
			{
				jsonconfig = "http://" + _model.getValue("_doname") +":8000/static/gameconfig.json";
				_Gameconfig = new URLLoader();
				_Gameconfig.addEventListener(Event.COMPLETE, configload); //載入聊天禁言清單 完成後執行 儲存清單內容
				_Gameconfig.dataFormat = URLLoaderDataFormat.BINARY; 
				_Gameconfig.load(new URLRequest(jsonconfig)); 
				// http://106.186.116.216:8000/static/gameconfig.json
			}		
			else
			{
				jsonconfig = "http://" + _model.getValue("_doname") +"/swf/gameconfig.json";				
				_Gameconfig = new URLLoader();
				_Gameconfig.addEventListener(Event.COMPLETE, configload); //載入聊天禁言清單 完成後執行 儲存清單內容
				_Gameconfig.dataFormat = URLLoaderDataFormat.BINARY; 
				_Gameconfig.load(new URLRequest(jsonconfig)); 
			}
			_Log.Log("config : "+jsonconfig);
		}
		
		public function configload(e:Event):void
		{
			var ba:ByteArray = ByteArray(URLLoader(e.target).data); //把載入文字 丟入Byte陣列裡面
		   var utf8Str:String = ba.readMultiByte(ba.length, 'utf8'); //把Byte陣列 轉 UTF8 格式		    
		  var result:Object  = JSON.decode(utf8Str);
		  
		  if ( CONFIG::debug ) 
		  {
			  _model.putValue("lobby_ws", result.development.DomainName[0].lobby_ws);		   
		  }
		  else
		  {
			_model.putValue("lobby_ws", result.online.DomainName[0].lobby_ws);			
		  }
		  _Log.Log("DomainName = " + _model.getValue("lobby_ws"));
		  
		  
		   utilFun.SetTime(connet, 0.1);
		   //_test.init();
		}
		
		private function connet():void
		{	
			var object:Object = _model.getValue(modelName.LOGIN_INFO);		
				var loading_text:MultiObject = prepare("loading_text", new MultiObject(),  GetSingleItem("_view").parent.parent);
			loading_text.CustomizedFun = _text.textSetting;
			loading_text.CustomizedData = [{size:22,color:0xCCCCCC}, "connect to\n"+_model.getValue("lobby_ws")+ ":8001/gamesocket/token/" + object.accessToken+"\n"];
			loading_text.Create_by_list(1, [ResName.TextInfo], 0 , 0, 3, 0 , 0, "Bet_");		
			loading_text.container.x = 1920/2;
			loading_text.container.y = 1082/2;
			
			//update_msg();
			
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CONNECT));
			
		}
		
		public function update_msg():void
		{			
			_regular.strdotloop(GetSingleItem("loading_text", 0).getChildByName("Dy_Text"), 10, 50);			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "socket_open")]
		public function open():void
		{
			Tweener.pauseTweens(GetSingleItem("loading_text", 0).getChildByName("Dy_Text"));
			GetSingleItem("loading_text", 0).getChildByName("Dy_Text").appendText("socket open\n");
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "socket_close")]
		public function close():void
		{
			Tweener.pauseTweens(GetSingleItem("loading_text", 0).getChildByName("Dy_Text"));
			GetSingleItem("loading_text", 0).getChildByName("Dy_Text").appendText("socket close\n")
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "socket_fali")]
		public function fail():void
		{
			Tweener.pauseTweens(GetSingleItem("loading_text", 0).getChildByName("Dy_Text"));
			var str:String = _model.getValue("connectState");		
			GetSingleItem("loading_text", 0).getChildByName("Dy_Text").appendText("socket connect fail\n");
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.ExitView(View);			
		}
		
		
	}

}