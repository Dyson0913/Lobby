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
		
		public var _Gameconfig:URLLoader;
		
		[Inject]
		public var _Log:Visual_Log;	
		
		[Inject]
		public var _HudView:HudView;
		
		public function LoadingView()  
		{
			
		}
		
			
		public function FirstLoad(result:Object,slog:MovieClip):void
		{
			//Logger.displayLevel = LogLevel.DEBUG;
			//Logger.addProvider(new ArthropodLogProvider(), "Arthropod");
						
			
			
			//new log
			_Log.init();
			_Log.logTarget(slog);
			
			
			
			if ( CONFIG::debug ) 
			{
				//local 載入
				if ( result == null) 
				{				
					result = { "accessToken":"c9f0f895fb98ab9159f51fd0297e236d","loading_path":"http://106.186.116.216:8000/static/","domain":"106.186.116.216" };
				}
			}
			
			_model.putValue("lobby_ws", result.domain);
			_model.putValue("loading_path", result.loading_path);
			_Log.Log("lobby_ws = "+ result.domain)
			_Log.Log("loading_path = "+ result.loading_path)
			
			_model.putValue(modelName.LOGIN_INFO, result);	
			
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
			_HudView.hud_pre_init();
			//_popmsg.init();
			//dispatcher(new Intobject(1,"Pop_msg_handle"));
			//_test.init();			
			
			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			tf.bold = false;
			//tf.font = "Adobe 繁黑體 Std";
			tf.color = 0xffc634;
			
			var loading_txt:MovieClip = new Text_Info() as MovieClip
			var txt:TextField =  loading_txt["_Text"] as TextField;
			txt.text = "Loading";
			txt.defaultTextFormat = tf;
			var _view:MultiObject = Get("_view") as MultiObject;
			txt.x = 930;
			txt.y = 500;
			_view.container.addChild(txt);
			
			this._regular.strdotloop(txt, 1000 , 4000);
			
			utilFun.SetTime(connet, 0.1);
		   //_test.init();
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
		}
		
		
	}

}