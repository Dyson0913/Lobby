package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.spicefactory.parsley.core.context.Context;
	import org.spicefactory.parsley.asconfig.*;
	
	
	import util.utilFun;
	import View.GameView.*;
	import com.adobe.serialization.json.JSON;
	import flash.events.KeyboardEvent;

	import Res.ShareManager;
	/**
	 * ...
	 * @author hhg
	 */
	[SWF(backgroundColor = "#000000")]
	public class Main extends MovieClip 
	{
		private var _context:Context;
		public var result:Object ;	
		
		//slog
		private var _slog:MovieClip;
		private var _scode:Array = [];
		private var checkList:Array = [];
		
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
			
			//Debug.monitor(stage);
			//utilFun.Log("welcome to alcon");
			
			_slog = utilFun.GetClassByString("s_log");
			_slog.visible = false;
			
			_slog._Text.backgroundColor = 0x999999;
			_slog._Text.text = "i am secret";
			_slog._Text.wordWrap = true; //auto change line
			_slog._Text.multiline = true; //multi line
			_slog._Text.maxChars = 300;
			
			_context  = ActionScriptContextBuilder.build(appConfig, stage);
			
			addChild(_context.getObjectByType(LoadingView) as LoadingView);			
			addChild(_context.getObjectByType(LobbyView) as LobbyView);
			addChild(_context.getObjectByType(HudView) as HudView);			
			addChild(_slog);
			
			
			
			_scode = [83, 72, 79, 87, 77, 69, 76, 79, 71];
			checkList = checkList.concat(_scode);		
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyUpHandler);   
			EnterLoadingView();
			//ShareManager.loadSahreSwf( "http://106.186.116.216:8000/static/share.swf", EnterLoadingView);
		}
		
		public function EnterLoadingView() {
				var Enter:LoadingView = _context.getObject("Enter") as LoadingView;			
				Enter.FirstLoad(result,_slog);
		}
		
		public function keyUpHandler(event:KeyboardEvent):void 
		{
			utilFun.Log("event.keyCode = "+event.keyCode);
			if ( event.keyCode == checkList[0])
			{
				checkList.shift();				
				if (checkList.length == 0) _slog.visible = true;	
			}
			else if (checkList.length == 0)
			{
				_slog.visible = true;
			}
			else
			{
				checkList.length = 0;
				checkList = checkList.concat(_scode);
			}
			
		}  
	}
	
}