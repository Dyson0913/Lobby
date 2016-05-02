package Command 
{
	import flash.events.Event;
	import Model.*;
	
	import util.*;
	import View.GameView.*;
	/**
	 * state event
	 * @author hhg4092
	 */
	public class StateCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		public static const INITIAL:int = 0;
		public static const NEW_ROUND:int = 1;
		public static const END_BET:int = 2;
		public static const START_OPEN:int = 3;
		public static const END_ROUND:int = 4;
		
		public function StateCommand() 
		{
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "update_state")]
		public function state_update():void
		{
			var state:int = _model.getValue(modelName.GAMES_STATE);		
			if ( state  == NEW_ROUND)
			{
				dispatcher(new ModelEvent("clearn"));
				dispatcher(new ModelEvent("display"));
				//clearn();
			}
			else if ( state == END_BET) dispatcher(new ModelEvent("hide"));
			else if ( state == START_OPEN) { }
			else if ( state == END_ROUND) { }
		}
	}

}