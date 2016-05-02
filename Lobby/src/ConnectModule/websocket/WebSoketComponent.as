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
	import util.DI;
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
				utilFun.Log("before" + event.message.utf8Data)
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
						
							//TODO find name dynamic
							var bingo:Object = result.game_list["Bingo-1"];
							var binary:Object = result.game_list["Binary-1"];
							var pa:Object = result.game_list["PerfectAngel-1"];
							var super7:Object = result.game_list["Super7PK-1"];
							var bigwin:Object = result.game_list["BigWin-1"];
							
							var gamelist:Array = [];
							gamelist.push(pa);
							gamelist.push(bigwin);
							gamelist.push(bingo);
							gamelist.push(super7);
							gamelist.push(binary);
							
							dispatcher(new ValueObject( gamelist, modelName.OPEN_STATE) );
							
							dispatcher(new Intobject(modelName.lobby, ViewCommand.SWITCH));		
							dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;				
							
						}
					}
					break
					
					//new archi
					case Message.MSG_TYPE_GAME_OPEN_INFO:
					case Message.MSG_TYPE_BET_INFO:
					case Message.MSG_TYPE_STATE_INFO:
					case Message.MSG_TYPE_ROUND_INFO:
					case Message.MSG_TYPE_ENTER_GAME:
					{
						_model.putValue("pass_to_game_pagcage", result);
						dispatcher(new ModelEvent("update_package"));
					}				
					
					break;
				}
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="GameJoin")]
		public function game_join():void
		{
			var game_info:DI = _model.getValue("game_info");
			var join_game_info:Object = game_info.getValue(_model.getValue("join_game_type"));
			var join_info:Object = { "id": "11111",
											"timestamp":2222,
											"message_type":Message.MSG_TYPE_ENTER_GAME, 
			                                "game_type": _model.getValue("join_game_type"),
											"game_id":join_game_info.game_id
			};			
			
			SendMsg(join_info);
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="game_credit_update")]
		public function update_bet_from_game():void
		{
			var bet:Object = _model.getValue("game_bet");			
			SendMsg(bet);
		}
		
		public function SendMsg(msg:Object):void 
		{
			var jsonString:String = JSON.encode(msg);
			//_Log.Log("lobby send jsonString = "+ jsonString);
			websocket.sendUTF(jsonString);
		}
		
	}
}