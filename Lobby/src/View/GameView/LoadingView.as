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
		private var _mainroad:MultiObject = new MultiObject();
		private var _localDI:DI = new DI();
		
		private var but:MultiObject = new MultiObject();
		
		public var _mainTable:LinkList = new LinkList();
		public var _bigroadTable:LinkList = new LinkList();
		
		private var _too:AdjustTool = new AdjustTool();
		
		private var _result:Object;
		
		private var fwd:Array = [];
		private var mclist:Array = [];
        private var bwd:Array = [];
		
		[Inject]
		public var _regular:RegularSetting;	
		
		[Inject]
		public var _canvas:Visual_Canvas;	
		
		[Inject]
		public var _activelist:Visual_ActiveList;	
		
		
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
			view.Create_by_list(1, [ResName.Loading_Scene], 0, 0, 1, 0, 0, "a_");			
			//_tool = new AdjustTool();
					
			_canvas.init();			
			//_tool.SetControlMc(Mascot.container);
			//addChild(_tool);
			Tweener.addTween(view.ItemList[0]["_mask"], { y:view.ItemList[0]["_mask"].y-164, time:3,onComplete:test,transition:"easeInOutQuart"} );		
			
			//_activelist.ini
			
			
		}
		
		public function test():void
		{
			utilFun.Log("ok");
			//dispatcher(new Intobject(modelName.lobby, ViewCommand.SWITCH) );		
			utilFun.SetTime(connet,1);
			
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