package View.ViewComponent 
{
	import com.adobe.webapis.events.ServiceEvent;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import util.utilFun;
	import caurina.transitions.Tweener;
	/**
	 * ...
	 * @author divia
	 */
	public class LobbyAd extends MovieClip
	{
		
		private var _mc_arr:Array;

		private var _index:int = 0;
		private var _next_idx:int = 1;
		
		public function LobbyAd(mc_arr:Array)  
		{
			_mc_arr = mc_arr;
			
			recursive();
		}
		
		private function recursive():void {
			indexSet();
			Tweener.addTween(this, {  time:5 ,  onComplete:fadeOut,  transition:"linear" } );
		}
		
		private function fadeOut():void {
			var mc:MovieClip = this.getChildAt(1) as MovieClip;
			Tweener.addTween(mc, {alpha:0, time:1, onComplete: fadeComplete});
		}
		
		private function fadeComplete():void {
			this.removeChildAt(1);
			
			recursive();
		}
		
		private function indexSet():void {
			
			this.addChild(_mc_arr[_next_idx]);
			this.addChild(_mc_arr[_index]);
			this.getChildAt(0).alpha = 1;
			
			if (_index == _mc_arr.length - 1) {
				_index = 0;
			}else{
				_index++;
			}
			
			if (_next_idx == _mc_arr.length - 1) {
				_next_idx = 0;
			}else {
				_next_idx++;
			}
			
		}
	}

}