package ConnectModule
{
	/**
	 * Error handle
	 * @author dyson0913
	 */
	public class Error_Msg 
	{
		public static const NET_DISCONNECT:String = "NET_DISCONNECT";
		
		[Selector]
		public var selector:String
		
		public var Value:*;
		
		public function Error_Msg(select:String, ...agrs) 
		{
			selector = select;
			Value = agrs;
		}
		
	
		
	}

}