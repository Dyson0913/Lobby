package View.GameView
{	
	import com.adobe.utils.DictionaryUtil;
	import Command.RegularSetting;
	import Command.ViewCommand;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.text.TextField;
	import Model.valueObject.Intobject;
	import Res.ResName;
	import util.DI;
	import util.node;
	import View.ViewBase.ViewBase;
	import Command.DataOperation;
	import flash.text.TextFormat;
	import View.ViewComponent.*;
	import View.Viewutil.AdjustTool;
	import View.Viewutil.LinkList;
	import View.Viewutil.MultiObject;
	import View.Viewutil.MouseBehavior;
	
	import Model.*;
	import util.utilFun;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	
	/**
	 * ...
	 * @author hhg
	 */

	 
	public class LoadingView extends ViewBase
	{	
		[Inject]
		public var _regular:RegularSetting;	
		
		[Inject]
		public var _canvas:Visual_Canvas;
		
		[Inject]
		public var _popmsg:Visual_PopMsg;
		
		[Inject]
		public var _test:Visual_testInterface;
		
		private var _result:Object;
		
		public function LoadingView()  
		{
			
		}
		
			
		public function FirstLoad(result:Object):void
		{
			_result = result;
			utilFun.Log("_result = "+_result);
			_model.putValue(modelName.LOGIN_INFO, _result);
			
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));		
			//dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;
			return;
			
			//local test
			//dispatcher(new Intobject(modelName.lobby, ViewCommand.SWITCH));		
			//dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.EnterView(View);
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.L_emptymc], 0, 0, 1, 0, 0, "a_");			
			//_tool = new AdjustTool();
					
			_canvas.init();			
			//_popmsg.init();
			//_test.init();			
			
			//Tweener.addTween(view.ItemList[0]["_mask"], { y:view.ItemList[0]["_mask"].y-164, time:3,onComplete:test,transition:"easeInOutQuart"} );			
			utilFun.SetTime(connet,0.1);
		}
		
		public function test():void
		{			
			
		}
		
		private function connet():void
		{	
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CONNECT));
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.ExitView(View);
			utilFun.Log("LoadingView ExitView");
		}
		
		
	}

}