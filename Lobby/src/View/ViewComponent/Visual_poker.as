package View.ViewComponent 
{
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;	
	import caurina.transitions.properties.CurveModifiers;
	
	/**
	 * poker present way
	 * @author ...
	 */
	public class Visual_poker  extends VisualHandler
	{
		//TODO pagckage to a class
		private var fwd:Array = [];
		
		private var dynamicpoker:Array = [];
		
		public function Visual_poker() 
		{
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{
			if ( Get(modelName.PLAYER_POKER) != null) Get(modelName.PLAYER_POKER).CleanList();
			if ( Get(modelName.BANKER_POKER) != null) Get(modelName.BANKER_POKER).CleanList();			
			
			for ( var i:int = 0; i <  dynamicpoker.length ; i++)
		  {
			   removie(dynamicpoker[i])			
			}
		   dynamicpoker.length = 0;
		   
		   	var BPresult:MultiObject = Get("zone");
			BPresult.container.visible = false;
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="pokerupdate")]
		public function playerpokerupdate(type:Intobject):void
		{
			var Mypoker:Array =   _model.getValue(type.Value);
			var pokerlist:MultiObject = Get(type.Value)
			pokerlist.CleanList();
			pokerlist.CustomizedFun = pokerUtil.showPoker;
			pokerlist.CustomizedData = Mypoker;
			pokerlist.Create_by_list(Mypoker.length, [ResName.Poker], 0 , 0, Mypoker.length, 30, 123, "Bet_");
		}
		
		[MessageHandler(type= "Model.ModelEvent",selector = "playerpokerAni")]
		public function playerpokerani():void
		{			
			var playerpoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			//取得第n 張牌路徑
			paipathinit(modelName.PLAYER_POKER,playerpoker.length-1);
			
			var pokerid:int = pokerUtil.pokerTrans(playerpoker[playerpoker.length - 1])
			paideal(pokerid,modelName.PLAYER_POKER);
		}
		
		[MessageHandler(type= "Model.ModelEvent",selector = "playerpokerAni2")]
		public function playerpokerani2():void
		{			
			var bank:Array =   _model.getValue(modelName.BANKER_POKER);
			//取得第n 張牌路徑
			paipathinit(modelName.BANKER_POKER,bank.length-1);
			
			var pokerid:int = pokerUtil.pokerTrans(bank[bank.length - 1])		
			paideal(pokerid,modelName.BANKER_POKER);
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_effect():void
		{
			//var playerpoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			//var best3:Array = pokerUtil.newnew_judge( playerpoker);
			//utilFun.Log("best 3 = "+best3);
			//var pokerlist:MultiObject = Get(modelName.PLAYER_POKER)
			//pokerUtil.poer_shift(pokerlist.ItemList.concat(), best3);
			//
			//var banker:Array =   _model.getValue(modelName.BANKER_POKER);
			//var best2:Array = pokerUtil.newnew_judge( banker);
			//var bpokerlist:MultiObject = Get(modelName.BANKER_POKER)
			//pokerUtil.poer_shift(bpokerlist.ItemList.concat(), best2);
		}
		
		public function paideal(pokerid:int,cardtype:int):void
	   {
		   	var mypoker:MovieClip = utilFun.GetClassByString(ResName.Poker);
			mypoker.rotationY = -180
			mypoker.visible = false;
			mypoker.gotoAndStop(pokerid);
			var pokerbac:MovieClip = utilFun.GetClassByString("pokerback");
			mypoker.x = 83;
			mypoker.y = -126;	
			pokerbac.addChild(mypoker)
			
			pokerbac.rotation = -65;
			pokerbac.scaleX = 0.48;
			pokerbac.scaleY = 0.48;
			
			add(pokerbac);
			dynamicpoker.push(pokerbac);
			
			//位移 by path
			pokerbac.x = fwd [0].x;
            pokerbac.y = fwd [0].y;
            Tweener.addTween(pokerbac, {
                x:fwd [fwd.length -1].x,
                y:fwd [fwd.length -1].y,
                _bezier:makeBesierArray (fwd),
                time:0.5, onComplete:ok, onCompleteParams:[pokerbac,mypoker,cardtype], transition:"linear"});
        
			Tweener.addTween(pokerbac, { scaleX:0.8,scaleY:0.8, rotation: 0,time:0.5, transition:"easeInOutCubic" } )
	   }
		
	   public function ok(pokerbac:MovieClip,mypoker:MovieClip,cardtype:int):void
		{		
			//翻牌
			Tweener.addTween(pokerbac, { rotationY:-180, time:0.5, transition:"linear",onUpdate:this.show,onUpdateParams:[pokerbac,mypoker] } )
		}
		
		public function show(pokerbac:MovieClip,mypoker:MovieClip):void
		{			
			if ( pokerbac.rotationY <= -100)
			{
				mypoker.visible = true;
			}
		}
	   
	   public function makeBesierArray (p:Array):Array
        {
            var bezier:Array = [];
            // convert all points between p[0] and p[last]
            for (var i:int = 1; i < p.length -2; i++)
            {
                var b1:Object = {}, b2:Object = {};
                // use p[0] properties to fill bezier array
                for (var prop:String in p[0])
                {
                    b1[prop] = -p[i -1][prop]/6 +p[i][prop] +p[i +1][prop]/6;
                    b2[prop] = +p[i][prop]/6 +p[i +1][prop] -p[i +2][prop]/6;
                }
                bezier.push (b1); bezier.push (b2);
            }
            return bezier;
        }
	   
		public function paipathinit(cardtype:int ,npoker:int):void
		{
			//add path
			fwd.length = 0;
			
			var i:int;
            for (i = 0; i < 3; i++) {
                var mc:MovieClip = new MovieClip();				
				if ( i == 0 )
				{
                   mc.x = 1458.45
				   mc.y = 154.15
			    }				
				else if (i == 1)
				{
					mc.x = 1097.2
					mc.y =  429.45
				}
				else if (i == 2)
				{
					if ( cardtype == modelName.PLAYER_POKER)
					{					    
						mc.x = 766.25 + npoker * 30;
					    mc.y = 301.75
					}
					else	if ( cardtype == modelName.BANKER_POKER)
					{					    
						mc.x = 1077.25 + npoker * 30;
					    mc.y = 301.75
					}
				}				
                var obj:Object = { x: mc.x, y: mc.y };
                fwd.push (obj);               
            }
            fwd.unshift (fwd [0]); fwd.push (fwd [fwd.length -1]);
		}
	}

}