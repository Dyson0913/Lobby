package View.ViewComponent 
{
	import flash.display.MovieClip;		
	import View.ViewBase.*
	import Model.valueObject.*;
	import Model.*;
	import util.*;	
	import Command.*;
	import flash.utils.setInterval;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;	
	
	
	
	/**
	 * version present way
	 * @author Dyson0913
	 */
	public class Visual_Version  extends VisualHandler
	{	
		//res		
		public const version_text:String = "Lobby_emptymc";		
		
		//tag
		private const version_texts:int = 0;	
		
		public function Visual_Version() 
		{
			
		}
		
		public function init():void
		{
			var version_container:MultiObject = create("version_container", [ResName.L_emptymc]);			
			version_container.CustomizedFun = version_init;			
			version_container.container.x = 1790;
			version_container.container.y = 1040;
			version_container.Create_(1);
			
			put_to_lsit(version_container);
		}
		
		public function version_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "version_";
			var component:Array =  [version_text];
			
			var font:Array = [{size:24,align:_text.align_left,color:0xFFFFFF},"v1.0"];
			//font = font.concat(mylist);
			var ob_cotainer:MultiObject = create(name + idx, component , mc);			
			ob_cotainer.CustomizedFun =  _text.textSetting;
			ob_cotainer.CustomizedData = font;
			//ob_cotainer.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			//ob_cotainer.Post_CustomizedData = [[0, 0], [650, 630],[860, 630], [1340, 120]];			
			ob_cotainer.Create_(component.length);
		
			//default setting
		
			//specialize setting
			//var mc:MovieClip = GetSingleItem(name + idx, version_texts);			
			
			put_to_lsit(ob_cotainer);	
		}		
		
		public function appear():void
		{
		
		}
		
		public function disappear():void
		{
			
		}
		
	}

}