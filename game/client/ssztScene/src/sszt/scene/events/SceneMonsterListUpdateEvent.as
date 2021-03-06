package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneMonsterListUpdateEvent extends Event
	{
		public static const ADD_MONSTER:String = "addMonster";
		public static const REMOVE_MONSTER:String = "removeMonster";
		
		public var data:Object;
		
		public function SceneMonsterListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}