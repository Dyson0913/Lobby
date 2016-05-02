package ConnectModule.websocket 
{
	/**
	 * ...
	 * @author hhg4092
	 */
	public final class Message
	{
		
		//S->C
		public static const MSG_TYPE_GAME_OPEN_INFO:String =  "MsgBPOpenCard";			
		public static const MSG_TYPE_BET_INFO:String = "MsgPlayerBet";
		public static const MSG_TYPE_ROUND_INFO:String = "MsgBPEndRound";
		public static const MSG_TYPE_STATE_INFO:String = "MsgBPState"
		
		//Game
		//C->S
		public static const MSG_TYPE_ENTER_GAME:String = "MsgPlayerEnterGame";
			
	}

}