package View.ViewComponent 
{
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * playerinfo present way
	 * @author ...
	 */
	public class Visual_PlayerInfo  extends VisualHandler
	{	
		public function Visual_PlayerInfo() 
		{
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "update_result_Credit")]
		public function updateCredit():void
		{			
			var new_credit:int = _model.getValue(modelName.CREDIT);
			var old_credit:int = _model.getValue(modelName.NEW_CREDIT_UPDATE);
			
			utilFun.Log("new_credit n= "+ new_credit);
			utilFun.Log("old_credit c= "+ old_credit);
			
			if ( new_credit < old_credit) 
			{
				_model.putValue(modelName.NEW_CREDIT_UPDATE, new_credit);
				//utilFun.Log("put oldcreid = "+ new_credit);
				//utilFun.Log("new oldcreid = "+ _model.getValue(modelName.NEW_CREDIT_UPDATE));
			}
			else
			{
				_model.putValue(modelName.NEW_CREDIT_UPDATE, new_credit);
				GetSingleItem("update_coin").gotoAndPlay(2);
			}
		
			var credit:int = _model.getValue(modelName.CREDIT);
			utilFun.SetText(GetSingleItem("playinfo", 1)["_Text"], credit.toString());
			
			
			
			
		}				
		
	}

}