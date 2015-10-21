package View.Viewutil 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import View.ViewBase.VisualHandler;
	
	
	import com.hexagonstar.util.debug.Debug;
	import com.istrong.log.*;
	
	/**
	 * log present way
	 * @author Dyson0913
	 */
	public class Visual_Log  extends VisualHandler
	{			
		private var scret_log:Array = [];
		
		private var _logob:DisplayObjectContainer;
		
		public function Visual_Log() 
		{
			
		}
		
		public function init():void
		{
			
			//Debug.monitor(stage);
			
			Logger.displayLevel = LogLevel.DEBUG;
			Logger.addProvider(new ArthropodLogProvider(), "Arthropod");
			
		}
	
		public function logTarget(logob:DisplayObjectContainer):void
		{
			_logob = logob;
		}
		
		public  function Log(msg:String):void
		{			
			Logger.log("lobby " + msg, 0, 0, false);
			
			//Debug.trace(msg);			
			addlog(msg);
			
			//diff item to diff handle						
			_logob["_Text"].text = scret_log.join("\n");
		}
		
		public function addlog(log:String): void
		{
			scret_log.unshift(log);
			if ( scret_log.length > 100) 
			{
				scret_log = scret_log.slice(1);
			}
		}
	}

}