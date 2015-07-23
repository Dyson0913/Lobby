package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.events.Event;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * Canvas , loading other display swf
	 * @author ...
	 */
	public class Visual_Canvas  extends VisualHandler
	{
		[Inject]
		public var _regular:RegularSetting;
	
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		public var _loader:Loader = new Loader();
		
		public var _canve1:MovieClip = null;
		
		public function Visual_Canvas() 
		{
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="Load_flash")]
		public function loading(gameidx:Intobject):void
		{
			utilFun.Log("game = " + gameidx.Value);
			
			startup(gameidx.Value);
			
		}
		
		
		private function ScrollDrag(e:Event):void
		{
			//utilFun.Log("e.cur =" + e.type);
			switch (e.type)
			{
				case "mouseDown":
					//utilFun.Log("e.cur =  + mouseDown ");
					
					//限制拖曳的範圍
					var sRect:Rectangle = new Rectangle(0,0,1920,1080);
					_canve1.startDrag(false,sRect);
					_canve1.addEventListener(MouseEvent.MOUSE_MOVE, ScrollDrag);
					_canve1.addEventListener(MouseEvent.MOUSE_UP, ScrollDrag);
				break;
				case "mouseMove":
					//utilFun.Log("move  x= "+_canve1.x + " y= " + _canve1.y);
					
				break;
				case "mouseUp":
					//utilFun.Log("e.cur =  + up ");
					_canve1.stopDrag();
					_canve1.removeEventListener(MouseEvent.MOUSE_MOVE, ScrollDrag);
					_canve1.removeEventListener(MouseEvent.MOUSE_UP, ScrollDrag);
				break;
				
			case "doubleClick":
				
				if ( _canve1.scaleX == 1) 
				{
					_canve1.x = 500;
					_canve1.y =  266;
					utilFun.scaleXY( _canve1, 0.5, 0.5);
				}
				else  
				{
					_canve1.x = 0;
					_canve1.y =  0;
					utilFun.scaleXY( _canve1, 1, 1);
				}
				break;
			}
		}
		
		private function startup(gameidx:int):void 
		{
			_canve1 = utilFun.GetClassByString(ResName.L_emptymc);
			_canve1.width = 1024;
			_canve1.height = 576;
			//_canve1.width = 1920;
			//_canve1.height = 1080;
			
			_canve1.addEventListener(MouseEvent.MOUSE_DOWN, ScrollDrag);
			//_canve1.doubleClickEnabled = true;
			//_canve1.mouseChildren = false;
			//_canve1.addEventListener(MouseEvent.DOUBLE_CLICK, ScrollDrag);
	
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadend);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, gameprogress);
			
			
			//var url:URLRequest = new URLRequest(result.game + "?para=" + result);
			var game:String = "perfectangel.swf";
			//var url:URLRequest = new URLRequest(game + "?para=" + result);
			var url:URLRequest = new URLRequest(game);
			
			//var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var loaderContext:LoaderContext = new LoaderContext(false, new ApplicationDomain());
				
			_loader.load( url, loaderContext);
		}
		
		private function gameprogress(e:ProgressEvent):void 
		{
			// TODO update loader
			var total:Number = Math.round( e.bytesTotal/ 1024);
			var loaded:Number = Math.round(e.bytesLoaded / 1024);
			var percent:Number = Math.round(loaded / total * 100);
			
			//loadingPro._Progress.gotoAndStop(percent);
			//loadingPro._Progress._Percent._TextFild.text = percent.toString()+"%";
		}
		
		private function loadend(event:Event):void
		{			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadend);
			utilFun.Log("loadn");
			//接口
			if ( (_loader.content as MovieClip )["handshake"] != null)
			{
				//var result:Object  = JSON.decode(_para);
				var idx:int = 1;
				(_loader.content as MovieClip)["handshake"](_model.getValue(modelName.CREDIT),idx,handshake,_model.getValue(modelName.LOGIN_INFO));
			}
			
			add(_canve1);
			_loader.name = "perfectangel";
			_canve1.addChild(_loader);		
			
			
			var topicon:MultiObject = prepare("gameicon", new MultiObject(), _canve1);
			topicon.Posi_CustzmiedFun = _regular.Posi_x_Setting;
			topicon.Post_CustomizedData = [0, 160, 230];
			topicon.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);			
			topicon.rollover = _btn.BtnHint;
			topicon.rollout = _btn.test_reaction;
			topicon.mousedown = swfcommand;
			topicon.Create_by_list(1, [ResName.L_icon_3], 0 , 0, 1, 50 , 0, "game_");
			topicon.container.x = 1844;
			topicon.container.y = 10;
			//utilFun.scaleXY(topicon.container, 1, 0.9);
			
			//_tool.SetControlMc(topicon.container);
			//_canve1.addChild(_tool);
			
			//removeChild(loadingPro);		
		}
	
		public function handshake(Client_idx:int , data:Array):void
		{
			utilFun.Log("handshake response " + Client_idx + " date = " + data);
			
			if (data[0] == "HandShake_updateCredit")
			{
				dispatcher(new ValueObject( data[1],modelName.CREDIT) );
				dispatcher(new ModelEvent("HandShake_updateCredit"));
			}
			
		}
		
		public function swfcommand(e:Event, idx:int):Boolean
		{
			if ( _canve1 ) 
			{			
				_loader.unloadAndStop(true);
				Del("gameicon");
				removie(_canve1);			
			}
			return true;
		}
	}

}