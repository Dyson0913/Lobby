package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
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
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	
	
	/**
	 * Canvas , loading other display swf
	 * @author ...
	 */
	public class Visual_Canvas  extends VisualHandler
	{
		[Inject]
		public var _regular:RegularSetting;
		
		public var _loader:Loader = new Loader();
		
		public var _canve1:MovieClip;
		
		public function Visual_Canvas() 
		{
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="Load_flash")]
		public function loading(gameidx:Intobject):void
		{
			utilFun.Log("game = " + gameidx.Value);
			
			startup(gameidx.Value);
			
		}
		
		private function startup(gameidx:int):void 
		{
			_canve1 = new Lobby_altas;
			_canve1.width = 500;
			_canve1.height = 500;
			_canve1.x = 10;
			_canve1.y = 10;
			
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
			if ( (_loader.content as MovieClip )["viewroot"] != null)
			{
				//var result:Object  = JSON.decode(_para);
				(_loader.content as MovieClip)["viewroot"](_canve1);				
			}
			
			add(_canve1);
			_canve1.addChild(_loader);
			//removeChild(loadingPro);		
		}
	
	}

}