package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import Model.valueObject.*
	import Res.ResName;
	import util.DI;
	import Model.*
	import util.node;
	import View.Viewutil.*;
	import View.ViewBase.ViewBase;
	import util.*;
	import View.ViewComponent.Visual_Coin;
	
	import Command.*;
	
	import caurina.transitions.Tweener;	
	import caurina.transitions.properties.CurveModifiers;
	/**
	 * ...
	 * @author hhg
	 */
	public class LobbyView extends ViewBase
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _regular:RegularSetting;	
		
		[Inject]
		public var _visual_coin:Visual_Coin;
		
		private var _mainroad:MultiObject = new MultiObject();
				
		public var _mainTable:LinkList = new LinkList();
		public var _bigroadTable:LinkList = new LinkList();
		
		//private var fwd:Array = [];
		private var dynamicpoker:Array = [];
		
		public function LobbyView()  
		{
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.lobby) return;
			super.EnterView(View);
			//清除前一畫面
			utilFun.Log("in to EnterBetview=");			
			
			_tool = new AdjustTool();
			
			
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Lobby_Scene], 0, 0, 1, 0, 0, "a_");			
			
			var page:MultiObject = prepare("pagearr", new MultiObject(), this);
			page.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			page.CustomizedFun = this.roation;			
			page.mousedown = _betCommand.test_reaction;
			page.Create_by_list(2, [ResName.L_arrow, ResName.L_arrow], 0 , 0, 2, 1880 , 0, "Bet_");
			page.container.x = 10;
			page.container.y = 502;
			
			var gameIcon:MultiObject = prepare("gameIcon", new MultiObject(), this);
			gameIcon.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			gameIcon.mousedown = _betCommand.test_reaction;
			gameIcon.Create_by_list(6, [ResName.L_game_2, ResName.L_game_3, ResName.L_game_4, ResName.L_game_5], 0 , 0, 3, 550 , 400, "Bet_");
			gameIcon.container.x = 210;
			gameIcon.container.y = 192;
			//
			//_tool.SetControlMc(gameIcon.container);
			_tool.SetControlMc(page.ItemList[1]);
			addChild(_tool);
//
			//var info:MultiObject = prepare(modelName.CREDIT, new MultiObject() , this);
			//info.container.x = 11.3;
			//info.container.y = 910.5;
			//info.Create_by_list(1, [ResName.playerInfo], 0, 0, 1, 0, 0, "info_");			
			//utilFun.SetText(info.ItemList[0]["_Account"], _model.getValue(modelName.UUID) );
			//utilFun.SetText(info.ItemList[0]["nickname"], _model.getValue(modelName.NICKNAME) );			
			//utilFun.SetText(info.ItemList[0]["credit"], _model.getValue(modelName.CREDIT).toString());
			//
			//var countDown:MultiObject = prepare(modelName.REMAIN_TIME,new MultiObject()  , this);
		   //countDown.Create_by_list(1, [ResName.Timer], 0, 0, 1, 0, 0, "time_");
		   //countDown.container.x = 350;
		   //countDown.container.y = 280;
		   //countDown.container.visible = false;
		   //
			//var hintmsg:MultiObject = prepare(modelName.HINT_MSG, new MultiObject()  , this);
			//hintmsg.Create_by_list(1, [ResName.Hint], 0, 0, 1, 0, 0, "time_");
			//hintmsg.container.x = 627.3;			
			//hintmsg.container.y = 459.3;			
			//
			//
			//bet區容器
			//coin
			//var coinob:MultiObject = prepare("CoinOb", new MultiObject(), this);
			//coinob.container.x = 640;
			//coinob.container.y = 800;
			//coinob.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,3,0]);
			//coinob.CustomizedFun = _regular.FrameSetting;
			//coinob.CustomizedData = [3, 2, 2, 2, 2];
			//coinob.Posi_CustzmiedFun = _regular.Posi_y_Setting;
			//coinob.Post_CustomizedData = [0,10,20,10,0];
			//coinob.Create_by_list(5,  [ResName.coin1,ResName.coin2,ResName.coin3,ResName.coin4,ResName.coin5], 0 , 0, 5, 130, 0, "Coin_");
			//coinob.mousedown = _visual_coin.betSelect;			
			//
			//下注區容器
			//var playerzone:MultiObject = prepare("betzone", new MultiObject() , this);			
			//playerzone.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			//playerzone.mousedown = _betCommand.betTypeMain;
			//playerzone.container.x = 196;
			//playerzone.container.y = 502;
			//playerzone.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			//playerzone.Post_CustomizedData = [[760,0],[0,0],[575,-33]];
			//playerzone.Create_by_list(3, [ResName.betzone_banker, ResName.betzone_player, ResName.betzone_tie], 0, 0, 3, 0, 0, "time_");
			//
			//stick cotainer  
			//var coinstack:MultiObject = prepare("coinstakeZone", new MultiObject(), playerzone.container);	
			//coinstack.autoClean = true;
			//coinstack.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			//coinstack.Post_CustomizedData = [[830,200],[180,100],[615,57]];
			//coinstack.Create_by_list(3, [ResName.emptymc], 0, 0, 3, 0, 0, "time_");
			//_tool.SetControlMc(coinstack.ItemList[0]);
			//addChild(_tool);
			//
			//
			//CurveModifiers.init();
			
			//_tool.SetControlMc(hintmsg);
			//addChild(_tool);
			//return
		
		}
		
	   public function roation(mc:MovieClip, idx:int, data:Array):void
		{
			if ( idx == 1) mc.rotationY= -180;
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_result():void
		{		
			var a:String = _model.getValue(modelName.ROUND_RESULT);
			var result:Array = a.split(_model.getValue(modelName.SPLIT_SYMBOL));
			result.pop();
			var betresult:int = parseInt( result[0])			
			if ( betresult== CardType.PLAYER) 
			{			 
			    _regular.Twinkle(GetSingleItem("betzone",1), 3, 10,2);
			  
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone"));	
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",2));
		    }
			else if (betresult == CardType.BANKER) 
			{				
				_regular.Twinkle(GetSingleItem("betzone"), 3, 10,2);
			   
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",1));	
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",2));
			}
			else
			{
				_regular.Twinkle(GetSingleItem("betzone",2), 3, 10,2);			
			   
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",0));	
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",1));			
			}	
				
			//點數顥示			
			var BPresult:MultiObject = Get("zone");
			BPresult.container.visible = true;
			var playerpoint:Array = utilFun.arrFormat(countPoint(_model.getValue(modelName.BANKER_POKER)), 2);
			if ( playerpoint[0] == 0 ) playerpoint[0] = 10;
			if ( playerpoint[1] == 0 ) playerpoint[1] = 10;			
			BPresult.ItemList[0]["_num0"].gotoAndStop(playerpoint[0]);
			BPresult.ItemList[0]["_num1"].gotoAndStop(playerpoint[1]);
			var bpoint:Array = utilFun.arrFormat(countPoint(_model.getValue(modelName.PLAYER_POKER)), 2);
			if ( bpoint[0] == 0 ) bpoint[0] = 10;
			if ( bpoint[1] == 0 ) bpoint[1] = 10;		
			BPresult.ItemList[1]["_num0"].gotoAndStop(bpoint[0]);
			BPresult.ItemList[1]["_num1"].gotoAndStop(bpoint[1]);
			
			//主路單更新
			//var idx:int = _mainTable.current.data.getValue("current_idx");				
			//addBall(betresult,_model.getValue("Position")[idx] , _mainTable.current.Item,"mainball");
			//idx = (idx + 1) % 6;
			//if ( idx == 0) 
			//{
				//_mainTable.Next();
			//}
			//_mainTable.current.data.putValue("current_idx",idx);
			//
			//大路單更新
			//bigRoadupdate();		
									
		}
		
		public function addBall(balltype:int,y:int,contain:MovieClip,objectName:String):void
		{
			var ball:MovieClip = utilFun.GetClassByString(objectName);
			ball.x = 17;
			ball.y = y;			
			ball.gotoAndStop(balltype);
			contain.addChild(ball)			
		}	
		
		public function bigRoadupdate():void
		{
			var result:int = _model.getValue(modelName.ROUND_RESULT);			
			if ( result != CardType.Tie )
			{					
				_model.putValue("PreResult",   _model.getValue("currntResult"));		
				_model.putValue("currntResult",  result);
				
				//與上次不同
			    if (  _model.getValue("PreResult") != -1 )					
				{
					if ( _model.getValue("PreResult") !=  _model.getValue("currntResult") )
					{
						//未超過的換行
						_bigroadTable.Next_empty();
						_bigroadTable.current.data.putValue("current_idx",0);
					}						
				}					
			}
				
				var idx:int = _bigroadTable.current.data.getValue("current_idx");				
				if ( _bigroadTable.current.data.getValue("result_row")[idx] == -1)
				{
				
					//檢查前一列和前一格結果 (第一格不用檢查)
					if ( _bigroadTable.current.pre != null)
					{
						if ( idx !=0 )
						{					  
						   var pre_resutl:int = _bigroadTable.current.pre.data.getValue("result_row")[idx];
						    if ( _bigroadTable.current.data.getValue("result_row")[idx - 1] == pre_resutl && pre_resutl != 3) 
							{
								_bigroadTable.Next();
								idx -=1;
							}
					   }
					  
					}
					
					
					// 前後二格是一樣的 (第五格不用檢查)
					if ( idx != 5 )
					{
						var up_result:int = _bigroadTable.current.data.getValue("result_row")[idx - 1] ;
						if ( up_result != -1 ) 
						{ 
							if (up_result == _bigroadTable.current.data.getValue("result_row")[idx + 1] )
							{
								_bigroadTable.Next();
								idx -= 1;
							}
						}
					}
					
					
					addBall(result, _model.getValue("Position")[idx] , _bigroadTable.current.Item,"bigRoadBall");
				   _bigroadTable.current.data.getValue("result_row")[idx] = result;
					
					idx += 1;
					
					//1.到底 
					//2下一格不是-1,己經有放東西
					if ( idx == 6)
					{
						_bigroadTable.Next();
						idx = 5;
					}
					else if ( _bigroadTable.current.data.getValue("result_row")[idx] != -1) 
					{
					  	_bigroadTable.Next();
						idx -=1;
					}
					
					_bigroadTable.current.data.putValue("current_idx", idx );
				}
		}
		
		private function countPoint(poke:Array):int
		{
			var total:int = 0;
			for (var i:int = 0; i < poke.length ; i++)
			{
				var strin:String =  poke[i];
				var arr:Array = strin.match((/(\w|d)+(\w)+/));					
				var numb:String = arr[1];				
				
				var point:int = 0;
				if ( numb == "i" || numb == "j" || numb == "q" || numb == "k" ) 				
				{
					point = 10;
				}				
				else 	point = parseInt(numb);
				
				total += point;
			}	
			
			return total %= 10;
		}
			
		
		
		private function clearn():void
		{			
			dispatcher(new ModelEvent("clearn"));			
		  
		
				
			//dispatcher(new BoolObject(false, "Msgqueue"));
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.lobby) return;
			super.ExitView(View);
		}		
	}

}