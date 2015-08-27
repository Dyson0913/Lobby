package View.ViewComponent 
{
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
		
		[Inject]
		public var _regular:RegularSetting;	
		
		public function Visual_PlayerInfo() 
		{
			
		}
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "HandShake_updateCredit")]
		[MessageHandler(type = "Model.ModelEvent", selector = "update_result_Credit")]
		public function updateCredit():void
		{							
			//TODO update creatid
			//var creadit:int = _model.getValue(modelName.CREDIT);
			//var credit:MultiObject = Get(modelName.CREDIT)
			//credit.CustomizedFun = _regular.ascii_idx_setting;						
			//credit.CustomizedData = creadit.toString().split("");
			//credit.container.x = 1593 + (credit.CustomizedData.length -1) * 37 *-1;   //right -> left *-1
			//credit.container.y = 16;
			//credit.Create_by_bitmap(credit.CustomizedData.length, utilFun.Getbitmap(ResName.L_altas), 0, 0, credit.CustomizedData.length, 37, 51, "o_");
			//utilFun.scaleXY(credit.container, 1, 0.9);
			//
			//
		}		
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "update_result_Credit")]
		//public function update_result_Credit():void
		//{	
			//
			//utilFun.SetText(GetSingleItem(modelName.CREDIT)["credit"], _model.getValue(modelName.CREDIT).toString());
		//}
		
	}

}