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
		
		public function Visual_Canvas() 
		{
			
		}
		
		public function init():void
		{
			_model.putValue("canvas_Serial",0);
			_model.putValue("canvas_Current_Serial",0);
			_model.putValue("canvas_Open_Serial",[]);
			_model.putValue("canvas_container", new DI());
			_model.putValue("canvas_loader", new DI());			
			//_model.putValue("canvas_swfname", new DI());			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="Load_flash")]
		public function loading(gameidx:Intobject):void
		{
			
			//gameidx.Value = 4;
			utilFun.Log("game = " + gameidx.Value);	
			
			_model.getValue("canvas_container").putValue(_model.getValue("canvas_Serial").toString(), new Sprite());
			_model.getValue("canvas_loader").putValue(_model.getValue("canvas_Serial").toString(), new Loader());
			//_model.getValue("canvas_swfname").putValue(_model.getValue("canvas_Serial").toString(), _model.getValue("swf_"+gameidx.Value.toString()) );
				
			//serial 產生
			startup(_model.getValue("canvas_Serial"),gameidx.Value);
			
		}
		
		
		private function ScrollDrag(e:Event):void
		{
			//utilFun.Log("e.cur =" + e.type);
			switch (e.type)
			{
				case "mouseDown":
					utilFun.Log("e.cur =  + mouseDown ");
					var serial:int = _model.getValue("canvas_Current_Serial");				
					var _canve:Sprite =  _model.getValue("canvas_container").getValue(serial.toString());
					//限制拖曳的範圍
					var sRect:Rectangle = new Rectangle(0,0,1920,1080);
					_canve.startDrag(false,sRect);
					_canve.addEventListener(MouseEvent.MOUSE_MOVE, ScrollDrag);
					_canve.addEventListener(MouseEvent.MOUSE_UP, ScrollDrag);
				break;
				case "mouseMove":
					//utilFun.Log("move  x= "+_canve1.x + " y= " + _canve1.y);
					
				break;
				case "mouseUp":
					//utilFun.Log("e.cur =  + up ");
					var serial:int = _model.getValue("canvas_Current_Serial");		
					var _canve:Sprite =  _model.getValue("canvas_container").getValue(serial.toString());
					_canve.stopDrag();
					_canve.removeEventListener(MouseEvent.MOUSE_MOVE, ScrollDrag);
					_canve.removeEventListener(MouseEvent.MOUSE_UP, ScrollDrag);
				break;
				
			case "doubleClick":
				
				//if ( _canve1.scaleX == 1) 
				//{
					//_canve1.x = 500;
					//_canve1.y =  266;
					//utilFun.scaleXY( _canve1, 0.5, 0.5);
				//}
				//else  
				//{
					//_canve1.x = 0;
					//_canve1.y =  0;
					//utilFun.scaleXY( _canve1, 1, 1);
				//}
				break;
			}
		}
		
		private function startup(serial:int,gameidx:int):void 
		{
			var _canve:Sprite =  _model.getValue("canvas_container").getValue(serial.toString());
			var _loader:Loader =  _model.getValue("canvas_loader").getValue(serial.toString());
			//var swfname:String =  _model.getValue("canvas_swfname").getValue(serial.toString());
			_canve = utilFun.GetClassByString(ResName.L_emptymc);
			_canve.width = 1920;
			_canve.height = 1080;			
			
			//移除完才觸發scroll事件,idx 會錯亂目前不用
			//_canve.addEventListener(MouseEvent.MOUSE_DOWN, ScrollDrag);
			_model.getValue("canvas_container").putValue(_model.getValue("canvas_Serial").toString(), _canve);
			
			//_canve1.doubleClickEnabled = true;
			//_canve1.mouseChildren = false;
			//_canve1.addEventListener(MouseEvent.DOUBLE_CLICK, ScrollDrag);
			//_model.putValue("gamename", gameName);
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadend);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, gameprogress);
			
			
			//var gameswf:String = "";			
			var rul:String = _model.getValue("gameweb")[gameidx];
			utilFun.Log("rul = " + rul);
			//return
			//var rul:String = "http://106.186.116.216:7000/static/" + rul;			
			var url:URLRequest = new URLRequest("perfectangel.swf");
			
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
			//TODO current serial
			var serial:int = _model.getValue("canvas_Serial")
			var _loader:Loader =  _model.getValue("canvas_loader").getValue(serial.toString());
			var _canve:Sprite =  _model.getValue("canvas_container").getValue(serial.toString());
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadend);
			utilFun.Log("loadn");
			//接口
			if ( (_loader.content as MovieClip )["handshake"] != null)
			{
				//var result:Object  = JSON.decode(_para);
				var idx:int = serial;
				//(_loader.content as MovieClip)["handshake"](_model.getValue(modelName.CREDIT),idx,handshake,_model.getValue(modelName.LOGIN_INFO));
				(_loader.content as MovieClip)["handshake"](_model.getValue(modelName.CREDIT),idx,handshake,_model.getValue(modelName.UUID));
			}
			
			add(_canve);			
			_canve.addChild(_loader);
			
			var topicon:MultiObject = prepare("gameicon_" + serial.toString(), new MultiObject(), _canve);
			topicon.Posi_CustzmiedFun = _regular.Posi_x_Setting;
			topicon.Post_CustomizedData = [0, 160, 230];
			topicon.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);			
			topicon.rollover = this.BtnHint;
			topicon.rollout = _btn.test_reaction;
			topicon.mousedown = swfcommand;
			topicon.Create_by_list(1, [ResName.L_icon_3], 0 , 0, 1, 50 , 0, "game_");
			topicon.container.x = 1854;
			topicon.container.y = 80;
			//utilFun.scaleXY(topicon.container, 1, 0.9);
			_model.getValue("canvas_container").putValue(serial.toString(), _canve);
			
			_model.putValue("canvas_Current_Serial", serial);
			_model.putValue("canvas_Serial", ++serial);			
			
			
			//_tool.SetControlMc(topicon.container);
			//_canve1.addChild(_tool);
			
			//removeChild(loadingPro);		
		}
		
		public function BtnHint(e:Event, idx:int):Boolean
		{
			e.currentTarget.gotoAndStop(2);
			e.currentTarget["_hintText"].gotoAndStop(3);
			return true;
		}
		
		public function handshake(Client_serial:int , data:Array):void
		{
			utilFun.Log("handshake response " + Client_serial + " date = " + data);
			
			if (data[0] == "HandShake_updateCredit")
			{
				dispatcher(new ValueObject( data[1],modelName.CREDIT) );
				dispatcher(new ModelEvent("HandShake_updateCredit"));
			}
			
		}
		
		public function swfcommand(e:Event, idx:int):Boolean
		{
			//TODO how to know which cave click
			
			var serial:int = _model.getValue("canvas_Current_Serial");			
			var _loader:Loader =  _model.getValue("canvas_loader").getValue(serial.toString());
			var _canve:Sprite =  _model.getValue("canvas_container").getValue(serial.toString());
			if ( _canve ) 
			{			
				_loader.unloadAndStop(true);
				Del("gameicon_" + serial.toString() );
				removie(_canve);
				_model.putValue("canvas_Current_Serial",--serial);				
			}
			return true;
		}
	}

}