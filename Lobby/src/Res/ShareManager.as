package Res 
{
	/**
	 * ...
	 * @author david
	 */
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class ShareManager 
	{
		public static var shareApp:ApplicationDomain;
		
		private static var _callback:Function;
		public function ShareManager() 
		{
			
		}
		
		public static function loadSahreSwf(url:String, callback:Function):void {
			_callback = callback;
			
			 var share_loader:Loader =  new Loader();
			share_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, shareloadend);
			 var share_url:URLRequest = new URLRequest(url);
			var loaderContext:LoaderContext = new LoaderContext(false, new ApplicationDomain());				
			share_loader.load( share_url, loaderContext);
		}
		
		private static function shareloadend(e:Event):void {
			shareApp = e.target.applicationDomain;
			
			_callback();
		}
		
	}

}