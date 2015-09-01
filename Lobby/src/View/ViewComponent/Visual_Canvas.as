package View.ViewComponent 
{
	import flash.display.LoaderInfo;
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
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _opration:DataOperation;
		
		
		[Inject]
		public var _btn:Visual_BtnHandle;		
		
		public function Visual_Canvas() 
		{
			
		}
		
		public function init():void
		{
			_model.putValue("canvas_Serial", 0);
			_model.putValue("Topgameicon_blind", new DI());
			_model.putValue("cavasid_btnid", new DI());
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="Load_flash")]
		public function loading(gameidx:Intobject):void
		{
			
			//gameidx.Value = 4;
			utilFun.Log("game = " + gameidx.Value);	
			var serial:int = _model.getValue("canvas_Serial");
			var newcanvas:Object = { "Serial": serial, 
			                                        "canvas_container":  new Sprite(),
										            "canvas_loader":new Loader(),
													"call_back":null
			                                      };
												  
			_model.putValue("newcanvas" + serial, newcanvas);
			_opration.operator("canvas_Serial", DataOperation.add);
			
			startup(serial,gameidx.Value);
				
		}
		
		
		private function ScrollDrag(e:Event):void
		{
			utilFun.Log("e.cur =" + e.type);			
			//utilFun.Log("e =" + e.currentTarget.name);
			switch (e.type)
			{
				case "mouseDown":
					utilFun.Log("e.cur =  + mouseDown ");
					var serial:int = _model.getValue("canvas_Current_Serial");	
					var newcanvas:Object  = _model.getValue("newcanvas" + serial);
					var _canve:Sprite =  newcanvas.canvas_container; //_model.getValue("canvas_container").getValue(serial.toString());
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
					var newcanvas:Object  = _model.getValue("newcanvas" + serial);
					var _canve:Sprite =  newcanvas.canvas_container; //_model.getValue("canvas_container").getValue(serial.toString());
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
			var newcanvas:Object  = _model.getValue("newcanvas" + serial);
			
			var _loader:Loader =  newcanvas.canvas_loader;
			
			newcanvas.canvas_container = utilFun.GetClassByString(ResName.L_emptymc);
			newcanvas.canvas_container.opaqueBackground = "#000000";
			add(newcanvas.canvas_container);			
			newcanvas.canvas_container.width = 1920;
			newcanvas.canvas_container.height = 1080;		
			newcanvas.canvas_container.addChild( utilFun.GetClassByString(ResName.Loading_Scene));
			newcanvas.canvas_container.name = newcanvas.Serial;
			
			
			//移除完才觸發scroll事件,idx 會錯亂目前不用 (用name 解)
			//_canve.addEventListener(MouseEvent.MOUSE_DOWN, ScrollDrag);
			//_model.getValue("canvas_container").putValue(_model.getValue("canvas_Serial").toString(), _canve);
			_model.putValue("newcanvas" + serial,newcanvas);
			
			
			//_canve1.doubleClickEnabled = true;
			//_canve.mouseChildren = false;
			//_canve.addEventListener(MouseEvent.DOUBLE_CLICK, ScrollDrag);
			
			_loader.name = "canvas_" + serial;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadend);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, gameprogress);
			
			
			var rul:String = _model.getValue("gameweb")[gameidx];
			if ( CONFIG::debug ) 
			{
				rul = utilFun.Regex_CutPatten(rul , RegExp("http://\.*/"));
			}
			utilFun.Log("rul = " + rul);			
			var url:URLRequest = new URLRequest(rul);
			
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
			
			var loader:LoaderInfo = e.currentTarget as LoaderInfo;
			var s:String = utilFun.Regex_CutPatten(loader.loader.name, new RegExp("canvas_", "i"));
			var idx:int = parseInt( s);
			
			var canvas:Object  = _model.getValue("newcanvas" + idx);		
			canvas.canvas_container.getChildByName(ResName.Loading_Scene)["_percent"].text = percent.toString() + "%";
			//var y:int = canvas.canvas_container.getChildByName(ResName.Loading_Scene)["_mask"].y;			
			//var shift_amount:Number = utilFun.NPointInterpolateDistance( 101-percent, y,458 );						
			//canvas.canvas_container.getChildByName(ResName.Loading_Scene)["_mask"].y = shift_amount;
			canvas.canvas_container.getChildByName(ResName.Loading_Scene)["_mask"].y =  622 -  ( 164 *  (percent / 100));
			
			//utilFun.Log("percent "+canvas.canvas_container.getChildByName(ResName.Loading_Scene)["_percent"].text );
//		utilFun.Log("y "+canvas.canvas_container.getChildByName(ResName.Loading_Scene)["_mask"].y);
		}
		
		private function loadend(event:Event):void
		{			
			var loader:LoaderInfo = event.currentTarget as LoaderInfo;
			var s:String = utilFun.Regex_CutPatten(loader.loader.name, new RegExp("canvas_", "i"));
			var idx:int = parseInt( s);
			
			var newcanvas:Object  = _model.getValue("newcanvas" + idx);
			
			var serial:int = newcanvas.Serial ; 
			var _loader:Loader = newcanvas.canvas_loader; 
			var _canve:Sprite =    newcanvas.canvas_container;
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadend);
			utilFun.Log("load down");
			//接口
			if ( (_loader.content as MovieClip )["handshake"] != null)
			{
				//var result:Object  = JSON.decode(_para);
				var idx:int = serial;
				//(_loader.content as MovieClip)["handshake"](_model.getValue(modelName.CREDIT),idx,handshake,_model.getValue(modelName.LOGIN_INFO));
				(_loader.content as MovieClip)["handshake"](_model.getValue(modelName.CREDIT), idx, handshake, _model.getValue(modelName.UUID));
				
				//if  ((_loader.content as MovieClip )["call_back"] != null)
				//{
					//utilFun.Log("call_back != null");
					//newcanvas.call_back = (_loader.content as MovieClip )["call_back"];
					//utilFun.Log("newcanvas.call_back ="+newcanvas.call_back);
				//}
			}			
			_canve.addChild(_loader);
			
			var topicon:MultiObject = prepare("gameicon_" + serial, new MultiObject(), _canve);			
			topicon.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);			
			topicon.rollover = this.BtnHint;
			topicon.rollout = _btn.test_reaction;
			topicon.mousedown = swfcommand;
			topicon.Create_by_list(1, [ResName.L_icon_exit_game], 0 , 0, 1, 50 , 0, "game_"+serial+"_");
			topicon.container.x = 1854;
			topicon.container.y = 80;						
			utilFun.Log("add leave");
			_model.putValue("newcanvas" + serial, newcanvas);
			
			//removeChild(loadingPro);		
		}
		
		public function BtnHint(e:Event, idx:int):Boolean
		{			
			e.currentTarget.gotoAndStop(2);
			e.currentTarget["_hintText"].gotoAndStop(5);
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
			var s:Array = utilFun.Regex_Match(e.currentTarget.name, new RegExp("game_(.)_.","i"));		
			var idx:int = parseInt(s[1]);
			var newcanvas:Object  = _model.getValue("newcanvas" + idx);			
			var serial:int = newcanvas.Serial;
			
			
			var _loader:Loader = newcanvas.canvas_loader;
			var _canve:Sprite =  newcanvas.canvas_container; 
			if ( _canve ) 
			{			
				_loader.unloadAndStop(true);
				Del("gameicon_" + serial.toString() );
				removie(_canve);				
			}
			
			var cavasid_btn:DI = _model.getValue("cavasid_btnid");
			var btn_cavasid:DI =  _model.getValue("Topgameicon_blind");
			var cancel_btn_id:int =  cavasid_btn.getValue(serial)
			
			btn_cavasid.Del(cancel_btn_id); 
			cavasid_btn.Del(serial);
			//find first avtive canvas		
			
			var pass:int = -1;
			var first_live_cavas_btn:* = cavasid_btn.firstitem();
			if ( first_live_cavas_btn != undefined) pass = first_live_cavas_btn; 
			dispatcher(new Intobject(pass, "close_cavas"));		
			
			return true;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "update_result_Credit")]
		public function updateCredit():void
		{
			//TODO new credit pass to game
			//var allcanvas:int = _model.getValue("canvas_Serial");
			//for ( var i:int = 0; i < allcanvas ; i++)
			//{
				//var newcanvas:Object  = _model.getValue("newcanvas" + i);
				//utilFun.Log("ca =" + i);
					//utilFun.Log("newcanvas.call_back ="+newcanvas.call_back);
				//utilFun.Log("newcanvas.credit =" + _model.getValue(modelName.CREDIT));
				//utilFun.Log("newcanvas.credit =" + typeof( _model.getValue(modelName.CREDIT) ));
				//
				//newcanvas.call_back(_model.getValue(modelName.CREDIT));
			//
			//}
		}
		
	}

}