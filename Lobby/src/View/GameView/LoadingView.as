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
	import Res.ResName;
	import util.DI;
	import util.node;
	import View.ViewBase.ViewBase;
	import Command.DataOperation;
	import flash.text.TextFormat;
	import View.ViewComponent.*;
	import View.Viewutil.AdjustTool;
	import View.Viewutil.LinkList;
	import View.Viewutil.MultiObject;
	import View.Viewutil.MouseBehavior;
	
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
		public var _regular:RegularSetting;	
		
		[Inject]
		public var _canvas:Visual_Canvas;
		
		[Inject]
		public var _popmsg:Visual_PopMsg;
		
		[Inject]
		public var _test:Visual_testInterface;
		
		private var _result:Object;
		
		public var _Gameconfig:URLLoader;
		
		public function LoadingView()  
		{
			
		}
		
			
		public function FirstLoad(result:Object):void
		{
			Logger.displayLevel = LogLevel.DEBUG;
			Logger.addProvider(new ArthropodLogProvider(), "Arthropod");
			_result = result;
			utilFun.Log("_result = "+_result);
			_model.putValue(modelName.LOGIN_INFO, _result);
			
			if ( CONFIG::debug ) 
			{
				_model.putValue("_doname","106.186.116.216");
			}
			else
			{
				_model.putValue("_doname","sqoo.t28.net");
			}
			_model.putValue(modelName.UUID, "c9f0f895fb98ab9159f51fd0297e236d");
			
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));		
			//dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;
			return;
			
			//local test
			//dispatcher(new Intobject(modelName.lobby, ViewCommand.SWITCH));		
			//dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.EnterView(View);
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.L_emptymc], 0, 0, 1, 0, 0, "a_");			
			//_tool = new AdjustTool();				
			_canvas.init();			
			//_popmsg.init();
			//_test.init();			
			
			if ( CONFIG::debug ) 
			{
				//Debug.monitor(stage);
				//utilFun.Log("welcome to perfect alcon");
				_Gameconfig = new URLLoader();
				_Gameconfig.addEventListener(Event.COMPLETE, configload); //載入聊天禁言清單 完成後執行 儲存清單內容
				_Gameconfig.dataFormat = URLLoaderDataFormat.BINARY; 
				_Gameconfig.load(new URLRequest("http://" + _model.getValue("_doname") +":8000/static/gameconfig.json")); 
				// http://106.186.116.216:8000/static/gameconfig.json
			}		
			else
			{
				_Gameconfig = new URLLoader();
				_Gameconfig.addEventListener(Event.COMPLETE, configload); //載入聊天禁言清單 完成後執行 儲存清單內容
				_Gameconfig.dataFormat = URLLoaderDataFormat.BINARY; 
				_Gameconfig.load(new URLRequest("http://"+ _model.getValue("_doname") +"/swf/gameconfig.json")); 
			}		
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
		   utilFun.SetTime(connet,0.1);
		}
		
		private function connet():void
		{	
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CONNECT));
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.ExitView(View);
			utilFun.Log("LoadingView ExitView");
		}
		
		
	}

}