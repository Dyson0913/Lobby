package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import View.Viewutil.*;
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
		
		//res
		public static const hintmsg:String = "hint_msg";
		public static const hintmsg_btn:String = "hint_msg_btn";
		
		
		public function Visual_PopMsg()
		{
			
		}
		
		public function init():void
		{
			var wid:int =  (GetSingleItem("_view").parent.parent.stage.width / 2 );
			var height:int =  (GetSingleItem("_view").parent.parent.stage.height / 2 );
			
			//0 = bg, 1 = cancel 2 = comfirm
			var _msg:MultiObject = create("popmsg", [hintmsg, hintmsg_btn, hintmsg_btn]);
			_msg.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);
			_msg.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			_msg.Post_CustomizedData = [[0, 0], [ -208.5, 47.35] , [74.5, 46.35] ];
			_msg.Create_(3);
			_msg.container.x =  wid;
			_msg.container.y = height;
			_msg.rollout = empty_reaction;
			_msg.rollover = empty_reaction;
			_msg.mousedown = mouse_down;
			
			_text.textSetting_s(GetSingleItem("popmsg",1), [ { size:24, color:0x000000,align:_text.align_left,bold:true,x:20,y:10 }, "cancel"]);
			_text.textSetting_s(GetSingleItem("popmsg",2), [ { size:24, color:0x000000,align:_text.align_left,bold:true,x:45,y:10 }, "ok"]);
			//_tool.SetControlMc(_msg.ItemList[1]);
			//_tool.y = 200;
			//add(_tool);
			//return;
		}
		
		public function mouse_down(e:Event, idx:int):Boolean
		{			
			utilFun.Log("idx = "+idx);
			return true;
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="Pop_msg_handle")]
		public function msg_handle(msginfo:Intobject):void
		{
			utilFun.Log("var = " + msginfo.Value);
			
			//_text.textSetting_s(GetSingleItem("popmsg"), [ { size:22, color:0xCCCCCC,align:_text.align_center }, "我的中文顥示abcdeft098098:"]);
			//return;
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
				_NickName.text = "我的中文顥示字串的長度有限不知道是幾個字多打幾個字試試看";
				_NickName.x = -316.85;
				_NickName.y = -80;
				text.setTextFormat(_NickName.defaultTextFormat);
				GetSingleItem("popmsg").addChild(_NickName)			
				
				//_tool.SetControlMc(_NickName);
				//_tool.y = 200;
				//add(_tool);				
			}
			
			
		}	
			
		private function hint_font_type():void
		{
			
		}
	}

}