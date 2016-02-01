package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_PopMsg  extends VisualHandler
	{	
		//msg type
		public static const Ok_Style:String = "Ok";
		public static const Ok_Cancel_style:String = "Ok_Cancel";		
		
		//msg handle
		public static const POP_MSG_HANDLE:String = "Pop_msg_handle";
		
		
		
		public function Visual_PopMsg()
		{
			
		}
		
		public function init():void
		{
			//var wid:int =  (GetSingleItem("_view").parent.parent.stage.width / 2 );
			//var height:int =  (GetSingleItem("_view").parent.parent.stage.height / 2 );
			//var _msg:MultiObject = prepare("popmsg", new MultiObject(),  GetSingleItem("_view").parent.parent);			
			//_msg.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			//_msg.Post_CustomizedData = [[0, 0], [ -208.5, 47.35] , [74.5, 46.35] ];
			//_msg.Create_by_list(3, [ResName.PopMsg,ResName.PopBtn,ResName.PopBtn], 0 , 0, 3, 0 , 0, "Bet_");			
			//_msg.container.x =  wid;
			//_msg.container.y = height;
			//
			//_tool.SetControlMc(_msg.ItemList[1]);
			//_tool.y = 200;
			//add(_tool);
			//return;
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="Pop_msg_handle")]
		public function msg_handle(msginfo:Intobject):void
		{
			utilFun.Log("var = "+msginfo.Value);
			if ( msginfo.Value == 1)
			{				
				var text:TextField = GetSingleItem("popmsg")["_Text"];
				var _NickName:TextField = new TextField();
				_NickName.width = 626.95;
				_NickName.height = 134;
				_NickName.textColor = 0xCCFF66;
				_NickName.selectable = false;		
				_NickName.autoSize = TextFieldAutoSize.CENTER;				
				_NickName.wordWrap = true; //auto change line
				_NickName.multiline = true; //multi line
				_NickName.maxChars = 300;
				//"微軟正黑體"
				var myFormat:TextFormat = new TextFormat();
				myFormat.size = 42;
				myFormat.align = TextFormatAlign.CENTER;
				myFormat.font = "Microsoft JhengHei";			
				
				_NickName.defaultTextFormat = myFormat;				
				_NickName.text = "我的中文顥示abcdeft098098";;
				_NickName.x = -316.85;
				_NickName.y = -80;
				text.setTextFormat(_NickName.defaultTextFormat);
				GetSingleItem("popmsg").addChild(_NickName)								
				
				//GetSingleItem("popmsg").
				
				//_tool.SetControlMc(_NickName);
				//_tool.y = 200;
				//add(_tool);
				
			}
			
			
		}	
		
	}

}