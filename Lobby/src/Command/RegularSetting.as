package Command 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import util.utilFun;
	import caurina.transitions.Tweener;
	
	/**
	 * regular setting fun
	 * @author hhg4092
	 */
	public class RegularSetting 
	{
		
		public function RegularSetting() 
		{
			
		}		
		
		//relative position adjust
		public function Posi_x_Setting(mc:MovieClip, idx:int, data:Array):void
		{		
			mc.x += data[idx];
		}
		
		public function Posi_y_Setting(mc:MovieClip, idx:int, data:Array):void
		{			
			mc.y += data[idx];
		}
		
		public function Posi_xy_Setting(mc:MovieClip, idx:int, data:Array):void
		{
			var po:Array = data[idx]
			mc.x = po[0];
			mc.y = po[1];
		}
		
		public function FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{
			mc.gotoAndStop(data[idx]);
		}
		
		public function textSetting(mc:MovieClip, idx:int, data:Array):void
		{			
			text_setting_single(mc, data[idx]);
			//utilFun.SetText(mc["_Text"],data[idx])
		}
		
		public function text_setting_single(mc:MovieClip, str:String):void
		{			
			utilFun.SetText(mc["_Text"],str)
		}
		
		
		public function FadeIn(mc:MovieClip,  in_t:int , out_t:int, onComF:Function):void
		{
			Tweener.addTween(mc, { alpha:1, time:in_t, onCompleteParams:[mc,0,out_t],onComplete:onComF } );
		}
		
		public function Fadeout(mc:MovieClip, a:int, t:int):void
		{
			Tweener.addTween(mc, {alpha:a, time:t});
		}		
		
		public function Twinkle(mc:MovieClip, t:int, cnt:int,frameNum:int):void
		{
			Tweener.addCaller(mc, { time:3 , count: 10 , transition:"linear", onUpdateParams:[mc,frameNum], onUpdate: this.flash } );
		}
		
		private function flash(mc:MovieClip,frameNum:int):void
		{			
			mc.gotoAndStop( utilFun.cycleFrame(mc.currentFrame,frameNum) )	
		}	
		
		public function strdotloop(s:TextField,Mytime:int ,Mycount:int):void
		{
			Tweener.addCaller( s.text, { time:Mytime , count: Mycount , transition:"linear", onUpdateParams:[ s,s.length,4], onUpdate: this.dotloop } );
		}
		
		public function dotloop(s:TextField, orlength:int, limit:int):void
		{
			var str:String = s.text;
			var len:int = str.length;
			str = str.substr(0, len) + ".";
			if ( str.length > orlength + limit) str = str.substr(0, len - limit) + ".";			
			s.text = str;
		}	
			
		public function sliding(mc:MovieClip,t:Number, x:Number =0, y:Number = 0):void
		{
			Tweener.addTween(mc, { x:x ,y:y,time:t, transition:"easeOutCubic"} );
		}
		
		public function ascii_idx_setting(mc:*, idx:int, data:Array):void
		{
			var code:int  = data[idx].toString().charCodeAt(0) -32;
			mc.drawTile(code);
		}
		
	}

}