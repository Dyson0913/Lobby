package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.spicefactory.parsley.core.context.Context;
	import org.spicefactory.parsley.asconfig.*;
	
	import com.hexagonstar.util.debug.Debug;
	import util.utilFun;
	import View.GameView.*;
	import com.adobe.serialization.json.JSON;
		
	/**
	 * ...
	 * @author hhg
	 */
	[SWF(backgroundColor = "#0000")]
	public class Main extends MovieClip 
	{
		private var _context:Context;
		
		//[ObjectDefinition(id="Enter")]
		//public var _LoadingView:LoadingView
		public var result:Object ;
		
		private var _appconfig:appConfig = new appConfig();
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function pass(pass:Object):void
		{
			result = pass;
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			Debug.monitor(stage);
			utilFun.Log("welcome to alcon");
			
			_context  = ActionScriptContextBuilder.build(appConfig, stage);
			
			addChild(_context.getObjectByType(LoadingView) as LoadingView);			
			addChild(_context.getObjectByType(LobbyView) as LobbyView);
			addChild(_context.getObjectByType(HudView) as HudView);			
			
			var Enter:LoadingView = _context.getObject("Enter") as LoadingView;
			utilFun.Log("Enter = "+Enter);
			Enter.FirstLoad(result);
			
			
		}
		
	}
	
}