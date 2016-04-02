package ConnectModule.websocket 
{	
	import com.worlize.websocket.WebSocket
	import com.worlize.websocket.WebSocketEvent
	import com.worlize.websocket.WebSocketMessage
	import com.worlize.websocket.WebSocketErrorEvent
	import com.adobe.serialization.json.JSON	
	import Command.ViewCommand;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.system.Security;
	import Model.*;	
	import View.Viewutil.Visual_Log;
	
	import Model.valueObject.*;	
	
	import util.utilFun;	
	import ConnectModule.Error_Msg;

	
	/**
	 * socket 連線元件
	 * @author hhg4092
	 */
	public class WebSoketComponent 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _MsgModel:MsgQueue;		
		
		[Inject]
		public var _actionqueue:ActionQueue;
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _Log:Visual_Log;
		
		private var websocket:WebSocket;
		
		public function WebSoketComponent() 
		{
			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="connect")]
		public function Connect():void
		{
			var object:Object = _model.getValue(modelName.LOGIN_INFO);			
			_Log.Log("connect to " + "ws:// "+ _model.getValue("lobby_ws") + ":8001/gamesocket/token/" + object.accessToken);
			websocket = new WebSocket("ws://"+ _model.getValue("lobby_ws")+ ":8001/gamesocket/token/" + object.accessToken, "");			
			websocket.addEventListener(WebSocketEvent.OPEN, handleWebSocket);
			websocket.addEventListener(WebSocketEvent.CLOSED, handleWebSocket);
			websocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, handleConnectionFail);
			websocket.addEventListener(WebSocketEvent.MESSAGE, handleWebSocketMessage);
			websocket.connect();
		}
		
		private function handleWebSocket(event:WebSocketEvent):void 
		{			
			if ( event.type == WebSocketEvent.OPEN)
			{
				utilFun.Log("Connected open=" + event.type );
				_Log.Log("socket open");
				
			}
			else if ( event.type == WebSocketEvent.CLOSED)
			{
				utilFun.Log("Connected close lobby=" + event.type );
				_Log.Log("socket socket_close");
				dispatcher(new ModelEvent("msgbox",Error_Msg.NET_DISCONNECT));
			}
		}
		
		private function handleConnectionFail(event:WebSocketErrorEvent):void 
		{
			utilFun.Log("Connected= fale" + event.type);
			_Log.Log("socket ConnectionFail = "+ event.type);
		}
		
		
		private function handleWebSocketMessage(event:WebSocketEvent):void 
		{
			var result:Object ;
			if (event.message.type === WebSocketMessage.TYPE_UTF8) 
			{
				utilFun.Log("lobby before" + event.message.utf8Data)
				//_Log.Log("lobby pack ConnectionFail = "+ event.message.utf8Data);
				result = JSON.decode(event.message.utf8Data);			
			}
			
			_MsgModel.push(result);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "popmsg")]
		public function msghandler():void
		{
			   var result:Object  = _MsgModel.getMsg();			   
				switch(result.message_type)
				{
					case "MsgLogin":
					{
						if ( result.game_type == "Lobby")
						{
							dispatcher(new ValueObject( result.player_info.player_account, modelName.NICKNAME) );							
							dispatcher(new ValueObject( result.player_info.player_uuid,modelName.UUID) );
							//player_id
							//player_currency
							dispatcher(new ValueObject( result.player_info.player_credit, modelName.CREDIT) );
							dispatcher(new ValueObject( result.player_info.player_credit, modelName.NEW_CREDIT_UPDATE) );
							//
							
						
							dispatcher(new ValueObject( result.game_list, modelName.OPEN_STATE) );
							
							dispatcher(new Intobject(modelName.lobby, ViewCommand.SWITCH));		
							dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;				
							
						}
					}
					break
					
					case "MsgPlayerCreditUpdate":
					{
						if ( result.game_type == "Lobby")
						{
							dispatcher(new ValueObject( result.player_credit, modelName.CREDIT) );
							//dispatcher(new ValueObject( result.player_info.player_credit, modelName.NEW_CREDIT_UPDATE) );
							//
							dispatcher(new ModelEvent("update_result_Credit"));
						}
					}
					break;
				}
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="Bet")]
		public function SendBet():void
		{
			
		}
		
		public function SendMsg(msg:Object):void 
		{
			var jsonString:String = JSON.encode(msg);
			_Log.Log("lobby send jsonString = "+ jsonString);
			websocket.sendUTF(jsonString);
		}
		
	}
}